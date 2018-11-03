function I = ReadNEF(file)

t = Tiff(file, 'r');
offsets = getTag(t, 'SubIFD');
setSubDirectory(t, offsets(1));
I = read(t);
close(t);

I = demosaic(I, 'rggb');
I = TrimRaw(I);