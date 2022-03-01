# BrainVision Analyzer

BrainVision Analyzer (BVA) is a complex program with a lot to offer. Therefore, we will not go over everything here. However, we will give an overview of the important concepts for working in BVA.

## New Workspace

Creating a new workspace (i.e. Project) can be done be selecting `New` at the start screen. A window will pop up allowing you specify three folders:

1. Raw files

   - Folder where your BVA data files are stored (see `bva_data` in \ref{Acq2Bva}). This data will only ever be read, and never changed

2. History Files

   - Empty folder where history files of each raw file is stored. When you do transformations on the raw files in BVA, the result (and pipeline) is stored in special history files here.

3. Export Files

   - Empty folder where any export files from BVA will be saved in

After a new workspace has been started, any data file BVA finds in the "Raw Files" folder you specified will be displayed in the left-side file viewer. Expanding any file will expose it's raw file, which can be opened and viewed.

## History Nodes

When you have opened a new raw file, BVA allows you to perform certain transformations and actions on that data (e.g. filtering, baseline correction, segmentation, average, etc.). Any function performed will act on the data that is currently opened. When you execute the function you have selected, a new node will appear in the left-side file viewer under the node you performed the action on.

What results is a tree-like structure of nodes, each of which performs some action on the parent node and stores the result. This tree is the pipeline that you will be constructing to transform the raw data into something you can analyze. No data is actually changed; you can still review the original data by selecting the top-most parent. The only thing that is saved are the actions performed on that data. You can move nodes around, delete any branch or the whole pipeline. Therefore, you can rest assured you are not destroying anything irreversibly.

There are many functions available within the BVA program under `Transformations`. However, you can also use `Macros` (see below).

## History templates

When you have created a satisfying pipeline on one of the files, you actually save that pipeline to, what is called, a history template. This template is a separate file that specifies the nodes and actions that can be applied on raw data files. This history file can then be applied on each data file sequentially.

You do this by selecting `History Template` > `Apply to History File(s)`. The window that opens up allows you to select what history template to apply, and what data files to apply _to_.

## Macros

Macros are a user-written program that can act just like a normal history node. You can write a new macro under `Macros` > `New`. Macros are written in SAX Basic.

To run a macro, either press the green arrow on a script open in the editor or under `Macros` > `Run`.

With the power of macros, you are able to do almost anything you can imagine with the EMG data.
