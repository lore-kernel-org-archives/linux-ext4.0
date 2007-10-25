From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: compilebench numbers for ext4
Date: Thu, 25 Oct 2007 10:54:29 -0500
Message-ID: <20071025105429.68626981@gara>
References: <20071022193104.0beafeca@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42340 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbXJYSBT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 14:01:19 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9PI1JAl007583
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:01:19 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9PI1Ja0139362
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:01:19 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9PI1Hxk013339
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 14:01:18 -0400
In-Reply-To: <20071022193104.0beafeca@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 22 Oct 2007 19:31:04 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> Hello everyone,
> 
> I recently posted some performance numbers for Btrfs with different
> blocksizes, and to help establish a baseline I did comparisons with
> Ext3.
> 
> The graphs, numbers and a basic description of compilebench are here:
> 
> http://oss.oracle.com/~mason/blocksizes/

I've been playing a bit with the workload and I have a couple of
comments.

1) I find the averaging of results at the end of the run misleading
unless you run a high number of directories.  A single very good result
due to page caching effects seems to skew the final results output.
Have you considered providing output of the standard deviation of the
data points as well in order to show how widely the results are spread. 

2) You mentioned that one of the goals of the benchmark is to measure
locality during directory aging, but the workloads seems too well order
to truly age the filesystem.  At least that's what I can gather from
the output the benchmark spits out.  It may be that Im not
understanding the relationship between INITIAL_DIRS and RUNS, but the
workload seem to been localized to do operations on a single dir at a
time.  Just wondering is this is truly stressing allocation algorithms
in a significant or realistic way.

Still playing and reading the code so I hope to have a clearer
understating of how it stresses the filesystem.  This would be a hard
one to simulate in ffsb (my favorite workload) due to the locality in
the way the dataset is access.  Would be interesting to let ffsb age
the filesystem and run then run compilebench to see how it does on an
unclean filesystem with lots of holes.

> Ext3 easily wins the read phase, but scores poorly while creating files
> and deleting them.  Since ext3 is winning the read phase, we can assume
> the file layout is fairly good.  I think most of the problems during the
> write phase are caused by pdflush doing metadata writeback.  The file
> data and metadata are written separately, and so we end up seeking
> between things that are actually close together.

If I understand how compilebench works, directories would be allocated
with in one or two block group boundaries so the data and meta data
would be in very close proximity.  I assume that doing random lookup
through the entire file set would show some weakness in the ext3 meta
data layout.

> Andreas asked me to give ext4 a try, so I grabbed the patch queue from
> Friday along with the latest Linus kernel.  The FS was created with:
> 
> mkfs.ext3 -I 256 /dev/xxxx
> mount -o delalloc,mballoc,data=ordered -t ext4dev /dev/xxxx
> 
> I did expect delayed allocation to help the write phases of
> compilebench, especially the parts where it writes out .o files in
> random order (basically writing medium sized files all over the
> directory tree).  But, every phase except reads showed huge
> improvements.
> 
> http://oss.oracle.com/~mason/compilebench/ext4/ext-create-compare.png
> http://oss.oracle.com/~mason/compilebench/ext4/ext-compile-compare.png
> http://oss.oracle.com/~mason/compilebench/ext4/ext-read-compare.png
> http://oss.oracle.com/~mason/compilebench/ext4/ext-rm-compare.png

I really want to use seekwatcher to test some of the stuff that I'm
doing for flex_bg feature but it barfs on me in my test machine.

running :sleep 10:
done running sleep 10
Device: /dev/sdh
  CPU  0:                    0 events,      121 KiB data
  CPU  1:                    0 events,      231 KiB data
  CPU  2:                    0 events,      121 KiB data
  CPU  3:                    0 events,      208 KiB data
  CPU  4:                    0 events,      137 KiB data
  CPU  5:                    0 events,      213 KiB data
  CPU  6:                    0 events,      120 KiB data
  CPU  7:                    0 events,      220 KiB data
  Total:                     0 events (dropped 0),     1368 KiB data
blktrace done
Traceback (most recent call last):
  File "/usr/bin/seekwatcher", line 534, in ?
    add_range(hist, step, start, size)
  File "/usr/bin/seekwatcher", line 522, in add_range
    val = hist[slot]
IndexError: list index out of range

This is running on a PPC64/gentoo combination.  Dont know if this means
anything to you.  I have a very basic algorithm for to take advantage
block group metadata grouping and want be able to better visualize how
different IO patterns take advantage or are hurt by the feature.

> To match the ext4 numbers with Btrfs, I'd probably have to turn off data
> checksumming...
> 
> But oddly enough I saw very bad ext4 read throughput even when reading
> a single kernel tree (outside of compilebench).  The time to read the
> tree was almost 2x ext3.  Have others seen similar problems?
> 
> I think the ext4 delete times are so much better than ext3 because this
> is a single threaded test.  delayed allocation is able to get
> everything into a few extents, and these all end up in the inode.  So,
> the delete phase only needs to seek around in small directories and
> seek to well grouped inodes.  ext3 probably had to seek all over for
> the direct/indirect blocks.
> 
> So, tomorrow I'll run a few tests with delalloc and mballoc
> independently, but if there are other numbers people are interested in,
> please let me know.
> 
> (test box was a desktop machine with single sata drive, barriers were
> not used).

More details please....

1. CPU info (type, count, speed)
2. Memory info (mostly amount)
3. Disk info (partition size, disk rpms, interface, internal cache size)
4. Benchmark cmdline parameters.

All good info when trying to explain and reproduce results since some
of the components of the workload are very sensitive to the hw
configuration.  For example with the algorithms for flex_bg grouping
of meta-data, the speed improvement on is about 10 time greater than
with the standard allocation in ext4.  This is cause by the fact that
Im running on a SCSI subsystem which has write caching disable on the
disk (like in most servers).  Testing on a desktop sata drive with
write caching enable would probably yeild much different results, so I
find the detail of the system under test important when looking at the
performance characteristics of different solutions.

> -chris

-JRS
