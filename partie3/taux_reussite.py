#import des modules nécessaires
import numpy as np 
import pandas as pd
import matplotlib.pyplot as plt
import math
import numpy.linalg as la

from sklearn.linear_model import LinearRegression

#création du dataframe �  partir du fichier CSV
collegesDF = pd.read_csv("/media/santoine/ANTOINE_1B2/BUT INFO/BUT 1/S2/Sae/S2.04/partie3/colleges.csv", sep=";")

#print(collegesDF)

#création d'un np.array �  partir du dataframe
collegesAR0 = collegesDF.to_numpy()

#on enlève l'uai et le nom de l'établissement de notre array
collegesAR = collegesAR0[:,[2,3,4,5,6,7]]

#print(collegesAR)

#fonction pour centrer réduire collegesAR
def centreduit(t):
    t = np.array(t, dtype=np.float64)
    lig, col = t.shape 
    temp = np.zeros((lig, col))
    for i in range(0, lig):
        for j in range(0, col):
            temp[i][j] = (t[i][j] - np.mean(t[:,j], axis = 0)) / np.std(t[:,j], axis = 0)
    return temp

#création du np.array centré-réduit
collegesAR_CR = centreduit(collegesAR)

#fonction pour créer le diagramme en batons 
def DiagBatons(Colonne):
    m = min(Colonne) # m contient la valeur minimale de la colonne
    M = max(Colonne) # M contient la valeur maximale de la colonne
    inter=[] # liste de valeurs allant de m a M
    inter = np.linspace(m, M, 30)
    plt.figure()
    # trace du diagramme pour les intervalles inter
    plt.hist(Colonne, inter, histtype='bar',align='left',rwidth=0.8)
    plt.title("Diagramme en batons")
    plt.show() 

#diagramme pour le nombre de candidats
#DiagBatons(collegesAR[:,0])

#diagramme pour le taux de reussite
#DiagBatons(collegesAR[:,1])
    
#diagramme pour le taux d'accès
#DiagBatons(collegesAR[:,2])

#diagramme pour le nombre de mentions total
#DiagBatons(collegesAR[:,3])
    
#diagramme pour l'ips
#DiagBatons(collegesAR[:,4])
    
#diagramme pour l'écart type de l'ips
#DiagBatons(collegesAR[:,5])

#création de la matrice de covariance
matr_cov = np.cov(collegesAR_CR, rowvar=False)

print(matr_cov)

#variable endogène de la régression linéaire
Y = np.array(collegesAR_CR[:,1])

#print(Y)

#variables explicatives de la régression linéaire
X = np.array(collegesAR_CR[:, [3,4]])

#print(X)

#calcul du coefficient de corrélation multiple
linear_regression = LinearRegression()
linear_regression.fit(X, Y)
coeff = linear_regression.coef_

#print(coeff)

#régression linéaire multiple matriciellement

ones = np.ones((X.shape[0], 1)) #création d'une matrice d'une colonne remplie de 1 et dont le nombre de ligne est celui du np.array X
X1 = np.hstack((ones, X))  #création d'une autre matrice �  laquelle on vient ajouter une colonne : la colonne temp

tX1 = X1.T  #on transpose la matrice X1
tX1_X1 = np.dot(tX1, X1)    #on multiplie les deux matrices : X1 par sa transposée
inv_tX1_X1 = la.inv(tX1_X1) #on calcule l'inverse du résultat de la multiplication 
tX1_Y = np.dot(tX1, Y)  #on multiplie la transposé de X1 par Y

a = np.dot(inv_tX1_X1, tX1_Y) # enfin on calcule le résultat de la régression linéaire multiple matriciellement en multipliant l'inverse de la multiplication de la transposée de X1 par X1, par la multiplication de la transposé de X1 par Y : inv(X1.T * X1) * (X1.T * Y) 

# print("La matrice X1 est :")
# print(X1)
# print("Le résultat a est :")
# print(a)

#vérification de la corrélation (au carré avec score donc on fait la racine carrée du résultat avec math.sqrt)
correlation = math.sqrt(linear_regression.score(X,Y))

#print(correlation)