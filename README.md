# WESTPA 2.0 on a dimer of dimers system

## Step 1. clone repo

```
git clone git@github.com:razvanmarinescu/twodimers2.git
cd twodimers2
```

## Step 2. Setup conda environment

```
conda create -n myenv python=3.9
conda activate myenv
```

## Step 3. Install dependencies

```
conda env update --file environment.yml
```

or

```
pip install MDAnalysis mdanalysistests
conda install -c conda-forge openmm
```

## Step 4. Install WESTPA 2.0

```
wget https://github.com/westpa/westpa/archive/refs/tags/v2022.01.zip
unzip v2022.01.zip
cd westpa-2022.01
python -m pip install -e .
```

## Step5. Run WESTPA
```
./init.sh
```

```
./run.sh
```

