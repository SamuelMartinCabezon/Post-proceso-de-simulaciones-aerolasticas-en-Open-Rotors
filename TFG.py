import numpy as np
import matplotlib.pyplot as plt
import math

puntos = int (input ("Numero de puntos a pintar:"))
armonicos = int (input ("Numero de armonicos a representar:"))

x_1 = np.linspace(0, 2 * np.pi, 100)
y_1 = np.sin(x_1)
x_2 = []; y_2 = []; x_2_ultimo = []; y_2_ultimo = []
for i in range (0, puntos):
    x = np.pi * i / (4 * ((puntos - 1) / 8))
    if i == (puntos - 1):
        x_2_ultimo.append(x); x_2.append(x)
        y_2_ultimo.append(np.sin(x)); y_2.append(np.sin(x))
    else:
        x_2.append(x)
        y_2.append(np.sin(x))

n_armonicos = []
for i in range (1, armonicos + 1):
    n_armonicos.append(i)
armonicos_desplazamiento = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
armonicos_desplazamiento = armonicos_desplazamiento[:armonicos]   
armonicos_presion = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
armonicos_presion = armonicos_presion[:armonicos]

#-------------------------------------------------------------------------------------
theta = np.linspace(0, 2*np.pi, 250)

z_1 = np.exp(1j * theta) / 2
z_2 = np.exp(-1j * theta) / 2
suma = (z_1 + z_2)
resta = (z_1 - z_2)

fig4, axs = plt.subplots(4, 1, num = 4, figsize = (10, 10), sharex=True)

axs[0].plot(theta, z_1.real, label=r'Re($e^{i\theta}$)', color='blue')
axs[0].plot(theta, z_2.real, '--', label=r'Re($e^{-i\theta}$)', color='red')
axs[0].set_title('Partes reales')
axs[0].set_ylabel('Parte real')
axs[0].legend()
axs[0].grid(True)


axs[1].plot(theta, z_1.imag, label=r'Im($e^{i\theta}$)', color='blue')
axs[1].plot(theta, z_2.imag, '--', label=r'Im($e^{-i\theta}$)', color='red')
axs[1].set_title('Partes imaginarias')
axs[1].set_ylabel('Parte imaginaria')
axs[1].legend()
axs[1].grid(True)


axs[2].plot(theta, suma.real, color='black', label=r'$(e^{i\theta}+e^{-i\theta}) / 2=cos(\theta)$')
axs[2].set_title('Suma de las exponenciales')
axs[2].set_xlabel(r'$\theta$ (rad)')
axs[2].set_ylabel('Valor')
axs[2].legend()
axs[2].grid(True)
axs[2].set_xticks([0, np.pi/2, np.pi, 3*np.pi/2, 2*np.pi], [r'$0$', r'$\pi/2$', r'$\pi$', r'$3\pi/2$', r'$2\pi$'])


axs[3].plot(theta, resta.imag, color='purple', label=r'$(e^{i\theta}-e^{-i\theta}) / 2=sen(\theta)$')
axs[3].set_title('Resta de las exponenciales')
axs[3].set_xlabel(r'$\theta$ (rad)')
axs[3].set_ylabel('Valor')
axs[3].legend()
axs[3].grid(True)
axs[3].set_xticks([0, np.pi/2, np.pi, 3*np.pi/2, 2*np.pi], [r'$0$', r'$\pi/2$', r'$\pi$', r'$3\pi/2$', r'$2\pi$'])

plt.tight_layout()
plt.show()

#-------------------------------------------------------------------------------------

fig1 = plt.figure(1)               
plt.plot(x_1, y_1, color="blue", linewidth=2, label = "seno")
plt.scatter(x_2, y_2, color="red", marker='o', s=50, label = "seno por N = " + str(puntos) + " puntos")
plt.scatter(x_2_ultimo, y_2_ultimo, color="yellow", marker='o', s=25, label = "punto excluido")                  
#plt.title("Calculo de la serie de Fourier de manera numerica")
#plt.grid(True)                            
plt.legend()
plt.show()

fig2 = plt.figure(2)
plt.plot(n_armonicos, armonicos_desplazamiento, color='blue', linewidth=2)
plt.scatter(n_armonicos, armonicos_desplazamiento, color="red", marker='o')
plt.title("Modulo del armonico del desplazamiento total")
plt.ylabel("[m]")  
plt.show()

fig3 = plt.figure(3)
plt.plot(n_armonicos, armonicos_presion, color='blue', linewidth=2)
plt.scatter(n_armonicos, armonicos_presion, color="red", marker='o')
plt.title("Modulo del armonico de la presion")
plt.ylabel("[Pa]") 
plt.show()


fig1.savefig(rf'C:\UNI\Asignaturas carrera\TFG\Fotos powerpoint\seno python/seno_python_{puntos}_puntos.svg')
