From: Sean McCauliff <Sean.D.McCauliff@nasa.gov>
Subject: Re: High CPU Utilization When Copying to Ext4
Date: Wed, 29 Jun 2011 17:01:45 -0700
Message-ID: <4E0BBCE9.9020600@nasa.gov>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>,<20110627030539.GF3064@thunk.org> <341DAA96EE3A8444B6E4657BE8A846EA4B3DA12708@NDJSSCC06.ndc.nasa.gov>,<F673734C-4ECE-40B2-B283-959027C34B06@mit.edu> <341DAA96EE3A8444B6E4657BE8A846EA4B3DA1270A@NDJSSCC06.ndc.nasa.gov> <50F503A1-6A16-41C4-9C27-0662063C7817@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ndmsnpf02.ndc.nasa.gov ([198.117.0.122]:35674 "EHLO
	ndmsnpf02.ndc.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1F3ABr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jun 2011 20:01:47 -0400
In-Reply-To: <50F503A1-6A16-41C4-9C27-0662063C7817@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/29/2011 06:08 AM, Theodore Tso wrote:
>
> On Jun 28, 2011, at 4:20 PM, Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS] wrote:
>
>> Last time I benchmarked cp and tar with the respective sparse file options they where extremely slow as they (claim) to identify sparseness by contiguous regions of zeros.  This was quite sometime ago so perhaps cp and tar have changed.
>
> How many of your files are sparse?   If the source file is not sparse (which you can check by looking at st_blocks and comparing it to the st_size value), and skip calling fiemap in that case.
I already know most of the files are not sparse and can identify them by 
the directory name they reside in.  So the copy program just does a 
straight copy for the non-sparse files without the fiemap trickery. 
I've already mentioned that I have about 2M sparse files.

>
> Also, how many times are you calling fiemap per file?   Are you calling once per block, or something silly like this?

Twice.  Once to get the number of struct fiemap_extent and another time 
with the correct number of struct fiemap_extent.

>
> (This is all of the details that should have been in your initial question, by the way....  we're not mind readers, you know.   Can you just send a copy of the key parts of your Java code?)
Sorry, I didn't mean to bother you.  I did try and email ext3-users so 
as to not take up any developer time with my question.  Portions of the 
source are below.  It might also be useful to know the source and 
destination file systems live on a 3par SAN, RAID 1+0 stripped across 
240 7200 rpm disks.  The source file system uses LVM to combine several 
3par volumes into a single volume.  The destination file system does not 
use LVM.  There are two FC HBAs, they are load balanced using 
multipathd.  My original question:

 > I'm copying terabytes of data from an ext3 file system to a new ext4 
 > file system.  I'm seeing high CPU usage from the processes  flush- 
 >253:2, kworker-3:0, kworker-2:2, kworker-1:1, and kworker-0:0.   Does 
 > anyone on the list have any idea what these processes do, why they 
 >are consuming so much cpu time and if there is something that can be 
 >done about it?  This is using Fedora 15.

Thanks,
Sean



///This is a snipped from extentmap.cpp, I thought I would spare you
//the madness of looking the JNI portion.
static void initFiemap(struct fiemap* fiemap, __u32 nExtents) {
   if (fiemap == 0) {
     throw FiemapException("Bad fiemap pointer.");
   }

   memset(fiemap, 0, sizeof(struct fiemap));

   //Start mapping the file from user space length 0.
   fiemap->fm_start = 0;
   //Start mapping to the last possible byte of user space.
   fiemap->fm_length = ~0ULL;
   //In the current code this is now FIEMAP_FLAG_SYNC
   fiemap->fm_flags = 0;
   fiemap->fm_extent_count = nExtents;
   fiemap->fm_mapped_extents = 0;

   memset(fiemap->fm_extents, 0, sizeof(struct fiemap_extent) * nExtents);
}




static struct fiemap *readFiemap(int fd) throw (FiemapException) {
   struct fiemap* extentMap =
     reinterpret_cast<struct fiemap*>(malloc(sizeof(struct fiemap)));
   if (extentMap == 0) {
     throw FiemapException("Failed to allocate fiemap struct.");
   }

   FiemapDeallocator fiemapDeallocator(extentMap);

   initFiemap(extentMap, 0);

   // Find out how many extents there are
   if (ioctl(fd, FS_IOC_FIEMAP, extentMap) < 0) {
     char errbuf[128];
     strerror_r(errno, errbuf, 127);
     throw FiemapException(errbuf);
   }

   __u32 nExtents = extentMap->fm_mapped_extents;
   __u32 extents_size = sizeof(struct fiemap_extent) * nExtents;
   fiemapDeallocator.noDeallocate();

   // Resize fiemap to allow us to read in the extents.
   extentMap = reinterpret_cast<struct 
fiemap*>(realloc(extentMap,sizeof(struct fiemap) + extents_size));
   if (extentMap == 0) {
     throw FiemapException("Out of memory allocating fiemap.");
   }

   initFiemap(extentMap, nExtents);
   FiemapDeallocator reallocDeallocator(extentMap);

   if (ioctl(fd, FS_IOC_FIEMAP, extentMap) < 0) {
     char errbuf[128];
     strerror_r(errno, errbuf, 127);
     throw FiemapException(errbuf);
   }
   reallocDeallocator.noDeallocate();
   return extentMap;
}

////This is from the Java code SparseFileUtil.java
public List<SimpleInterval> extents(File file) throws IOException {

    //A SimpleInterval is just a 64bit start and end pair
    SimpleInterval[] extents = null;
    try {	
        extents = extentsForFile(file.getAbsolutePath());
     } catch (IllegalArgumentException iae) {
         throw new IllegalArgumentException("For file \"" + file + 
"\".", iae);
     }
     if (extents.length == 0) {
         return Collections.emptyList();
     }

     Arrays.sort(extents, comp);
     List<SimpleInterval> mergedExtents = new ArrayList<SimpleInterval>();
     SimpleInterval current = extents[0];

    //merge adjacent extents
    for (int i=1; i < extents.length; i++) {
        SimpleInterval sortedExtent = extents[i];
        if (current.end() < sortedExtent.start()) {
            mergedExtents.add(current);
            current = sortedExtent;
        } else {
            current = new SimpleInterval(Math.min(sortedExtent.start(), 
current.start()),
                     Math.max(current.end(), sortedExtent.end()));
        }
     }
     mergedExtents.add(current);
     return mergedExtents;
}

public void copySparseFile(File src, File dest) throws IOException {
     if (!src.exists()) {
         throw new FileNotFoundException(src.getAbsolutePath());
     }
     if (src.isDirectory()) {
         throw new IllegalArgumentException("Src must be a file.");
     }
     List<SimpleInterval> extents = extents(src);
     if (extents.size() == 1 && extents.get(0).start() == 0) {
         FileUtils.copyFile(src, dest);
         return;
     }

     byte[] buf = new byte[1024*1024];
     RandomAccessFile srcRaf = new RandomAccessFile(src, "r");
     try {
        RandomAccessFile destRaf = new RandomAccessFile(dest, "rw");
        try {
            for (SimpleInterval extent : extents) {
                long extentSize = extent.end() - extent.start() + 1;
                srcRaf.seek(extent.start());
                destRaf.seek(extent.start());
                while (extentSize > 0) {
                    int readLen = (int) Math.min(buf.length, extentSize);
                    int nread = srcRaf.read(buf,0, readLen);
                    if (nread == -1) {
                        break; //file ends before extent ends.
                    }
                    extentSize -= nread;
                    destRaf.write(buf, 0, nread);
                }
           }
        } finally {
            FileUtil.close(destRaf);
        }
      } finally {
          FileUtil.close(srcRaf);
      }
}

     private native SimpleInterval[] extentsForFile(String fname) throws 
IOException;



