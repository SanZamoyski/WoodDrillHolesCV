(Metric Mode)
G20
(Absolute Coordinates)
G90
G0 Z0.78 ;~20 mm 
G0 X0.000000 Y0.000000 
G0 Z0.039 ;~1mm
M3
(start delay)
G4 P3

;G1 Z-0.4 F2.0 ;~10 mm
;G1 Z-0.3 F2.0 ;~7.6 mm
;G1 Z-0.14 F2.0 ;~3.5 mm
;G1 Z-0.16 F2.0 ;~4 mm
;G1 Z-0.26 F2.0 ;~6.6 mm
;G1 Z-0.078 F2 ;~-2 mm

(col 2)
G0 X0.50 Y0.30

G0 Y0.50
G1 Z-0.078 F2 ;~-2mm
G0 Z0.039

G0 Y1.50
G1 Z-0.078 F2 ;~-2mm
G0 Z0.039

(col 5)
G0 X1.50 Y0.30

G0 Y0.50
G1 Z-0.078 F2 ;~-2mm
G0 Z0.039

G0 Y1.50
G1 Z-0.078 F2 ;~-2mm
G0 Z0.039

G0 Z0.1 ;~2.5 mm 
M5
G0 X0.000000 Y0.000000 Z0.78 ; ~20mm
