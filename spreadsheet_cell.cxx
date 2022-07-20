module;

#include <iostream>

export module spreadsheet_cell;

export class SpreadsheetCell{
    public:
        void setValue(double value);
        double getValue() const;
    private:
        double m_value;
};


module :private;


void SpreadsheetCell::setValue(double value) {
  std::cout << "SetValue:" << value << std::endl;
  m_value = value;
}
double SpreadsheetCell::getValue() const {
  std::cout << "GetValue" << m_value << std::endl;
  return m_value;
}