from setuptools import setup, find_packages

setup(
    name="python-app",
    packages=find_packages(),
    package_dir={"python_app": "python_app"},
    version="0.0.1",
    entry_points={"console_scripts": ["python-app=python_app.main:main"]},
)
