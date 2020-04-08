import 'package:covital_dataset_builder/user_data_container.dart';
import 'package:flutter_material_color_picker/src/circle_color.dart';
import 'package:flutter_material_color_picker/src/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

class CovitalColorPicker extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChange;
  final ValueChanged<ColorSwatch> onMainColorChange;
  final List<ColorSwatch> colors;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final bool allowShades;
  final bool onlyShadeSelection;
  final double circleSize;
  final double spacing;
  final IconData iconSelected;
  final VoidCallback onBack;
  final double elevation;

  const CovitalColorPicker({
    Key key,
    this.selectedColor,
    this.onColorChange,
    this.onMainColorChange,
    this.colors,
    this.shrinkWrap = false,
    this.physics,
    this.allowShades = true,
    this.onlyShadeSelection = false,
    this.iconSelected = Icons.check,
    this.circleSize = 45.0,
    this.spacing = 9.0,
    this.onBack,
    this.elevation,
  }) : super(key: key);

  @override
  _CovitalColorPickerState createState() => _CovitalColorPickerState();
}

class _CovitalColorPickerState extends State<CovitalColorPicker> {
  final _defaultValue = materialColors[0];

  List<ColorSwatch> _colors = materialColors;
  bool is_init = false;
  ColorSwatch _mainColor;
  Color _shadeColor;
  bool _isMainSelection;

  @override
  void initState() {
    super.initState();
//    _initSelectedValue();
    SchedulerBinding.instance.addPostFrameCallback((_){
      _initSelectedValue();
    });
  }

  @protected
  void didUpdateWidget(covariant CovitalColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initSelectedValue();
  }

  void _initSelectedValue() {
    bool has_value = (UserDataContainer.of(context).data.current_survey.skinColor != null);
    if (widget.colors != null) _colors = widget.colors;

    Color shadeColor = widget.selectedColor ?? _defaultValue;
    ColorSwatch mainColor = _findMainColor(shadeColor);

    if(has_value == false){
      mainColor = null;
      shadeColor = null;
    }
//    print(mainColor.value);
//    if (mainColor == null) {
////      mainColor = _colors[0];
////      shadeColor = mainColor[500] ?? mainColor[400];
//    }

    setState(() {
      _mainColor = mainColor;
      _shadeColor = shadeColor;
      _isMainSelection = true;
      is_init = true;
    });

  }

  ColorSwatch _findMainColor(Color shadeColor) {
    for (final mainColor in _colors)
      if (_isShadeOfMain(mainColor, shadeColor)) return mainColor;

    return (shadeColor is ColorSwatch && _colors.contains(shadeColor))
        ? shadeColor
        : null;
  }

  bool _isShadeOfMain(ColorSwatch mainColor, Color shadeColor) {
    for (final shade in _getMaterialColorShades(mainColor)) {
      if (shade == shadeColor) return true;
    }
    return false;
  }

  void _onMainColorSelected(ColorSwatch color) {
    var isShadeOfMain = _isShadeOfMain(color, _shadeColor);
    final shadeColor = isShadeOfMain ? _shadeColor : (color[500] ?? color[400]);

    setState(() {
      _mainColor = color;
      _shadeColor = shadeColor;
      _isMainSelection = false;
    });
    if (widget.onMainColorChange != null) widget.onMainColorChange(color);
    if (widget.onlyShadeSelection && !_isMainSelection) {
      return;
    }
    if (widget.allowShades && widget.onColorChange != null)
      widget.onColorChange(shadeColor);
  }

  void _onShadeColorSelected(Color color) {
    setState(() => _shadeColor = color);
    if (widget.onColorChange != null) widget.onColorChange(color);
  }

  void _onBack() {
    setState(() => _isMainSelection = true);
    if (widget.onBack != null) widget.onBack();
  }

  List<Widget> _buildListMainColor(List<ColorSwatch> colors) {
   List<Widget> colors_list = [
      for (final color in colors)
        CircleColor(
          color: color,
          circleSize: widget.circleSize,
          onColorChoose: () => _onMainColorSelected(color),
          isSelected: _mainColor == color,
          iconSelected: widget.iconSelected,
          elevation: widget.elevation,
        )
    ];

   var survey = UserDataContainer.of(context).data.current_survey;

   colors_list.insert(0, IconButton(icon: Icon(Icons.cancel, color: survey.skinColor != null ? Theme.of(context).accentColor: null), onPressed:  survey.skinColor == null ? null : (){
     print("Chrosen");
     setState(() {
       survey.skinColor = null;
       _mainColor = null;
//       shadeColor = null;
     });
   },
//     isSelected: survey.skinColor == null ? true : false,
//     iconSelected: Icons.check,
   ),);

   return colors_list;
  }

  List<Color> _getMaterialColorShades(ColorSwatch color) {
    return <Color>[
      if (color[50] != null) color[50],
      if (color[100] != null) color[100],
      if (color[200] != null) color[200],
      if (color[300] != null) color[300],
      if (color[400] != null) color[400],
      if (color[500] != null) color[500],
      if (color[600] != null) color[600],
      if (color[700] != null) color[700],
      if (color[800] != null) color[800],
      if (color[900] != null) color[900],
    ];
  }

  List<Widget> _buildListShadesColor(ColorSwatch color) {
    return [
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _onBack,
        padding: const EdgeInsets.only(right: 2.0),
      ),
      for (final color in _getMaterialColorShades(color))
        CircleColor(
          color: color,
          circleSize: widget.circleSize,
          onColorChoose: () => _onShadeColorSelected(color),
          isSelected: _shadeColor == color,
          iconSelected: widget.iconSelected,
          elevation: widget.elevation,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (is_init == true) {
      final listChildren = _isMainSelection || !widget.allowShades
          ? _buildListMainColor(_colors)
          : _buildListShadesColor(_mainColor);

      // Size of dialog
      final double width = MediaQuery
          .of(context)
          .size
          .width ;
      // Number of circle per line, depend on width and circleSize
      final int nbrCircleLine = width ~/ (widget.circleSize + widget.spacing);

      return Container(
        width: width,
        child: GridView.count(
          shrinkWrap: widget.shrinkWrap,
          physics: widget.physics,
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: widget.spacing,
          mainAxisSpacing: widget.spacing,
          crossAxisCount: nbrCircleLine,
          children: listChildren,
        ),
      );
    }
    else{
      return CircularProgressIndicator();
    }
  }

}
