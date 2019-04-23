# led-matrix-104x16
Serially interfaced led matrix driver for 104x16 pixels.

# Serial-Data Format (16 bits)
<table rules="none">
  <tr>
    <td>D15</td>
    <td>D14</td>
    <td>D13</td>
    <td>D12</td>
    <td>D11</td>
    <td>D10</td>
    <td>D9</td>
    <td>D8</td>
    <td>D7</td>
    <td>D6</td>
    <td>D5</td>
    <td>D4</td>
    <td>D3</td>
    <td>D2</td>
    <td>D1</td>
    <td>D0</td>
  </tr>
  <tr>
    <td colspan="8" align="center">ADDRESS</td>
    <td colspan="8" align="center">DATA</td>
  </tr>
</table>
