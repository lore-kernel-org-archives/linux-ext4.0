From: Chris Mason <chris.mason@oracle.com>
Subject: Re: compilebench numbers for ext4
Date: Thu, 25 Oct 2007 14:43:55 -0400
Message-ID: <20071025144355.583a8f88@think.oraclecorp.com>
References: <20071022193104.0beafeca@think.oraclecorp.com>
	<20071025103449.2e358220@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:58476 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbXJYSpf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 14:45:35 -0400
In-Reply-To: <20071025103449.2e358220@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 25 Oct 2007 10:34:49 -0500
"Jose R. Santos" <jrs@us.ibm.com> wrote:

> On Mon, 22 Oct 2007 19:31:04 -0400
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > Hello everyone,
> > 
> > I recently posted some performance numbers for Btrfs with different
> > blocksizes, and to help establish a baseline I did comparisons with
> > Ext3.
> > 
> > The graphs, numbers and a basic description of compilebench are
> > here:
> > 
> > http://oss.oracle.com/~mason/blocksizes/
> 
> I've been playing a bit with the workload and I have a couple of
> comments.
> 
> 1) I find the averaging of results at the end of the run misleading
> unless you run a high number of directories.  A single very good
> result due to page caching effects seems to skew the final results
> output. Have you considered providing output of the standard
> deviation of the data points as well in order to show how widely the
> results are spread. 

This is the main reason I keep the output from each run.  Stdev would
definitely help as well, I'll put it on the todo list.

> 
> 2) You mentioned that one of the goals of the benchmark is to measure
> locality during directory aging, but the workloads seems too well
> order to truly age the filesystem.  At least that's what I can gather
> from the output the benchmark spits out.  It may be that Im not
> understanding the relationship between INITIAL_DIRS and RUNS, but the
> workload seem to been localized to do operations on a single dir at a
> time.  Just wondering is this is truly stressing allocation algorithms
> in a significant or realistic way.

A good question.  compilebench has two modes, and the default is better
at aging then the run I graphed on ext4.  compilebench isn't trying to
fragment individual files, but it is instead trying to fragment
locality, and lower the overall performance of a directory tree.

In the default run, the patch, clean, and compile operations end up
changing around groups of files in a somewhat random fashion (at least
from the FS point of view).  But, it is still a workload where a good
FS should be able to maintain locality and provide consistent results
over time.

The ext4 numbers I sent here are from compilebench --makej, which is a
shorter and less complex run.  It has a few simple phases:

* create some number of kernel trees sequentially
* write new files into those trees in random order
* read a three of the trees
* delete all the trees

It is a very basic test that can give you a picture of directory
layout, writeback performance and overall locality.

> 
> If I understand how compilebench works, directories would be allocated
> with in one or two block group boundaries so the data and meta data
> would be in very close proximity.  I assume that doing random lookup
> through the entire file set would show some weakness in the ext3 meta
> data layout.

Probably.

> 
> I really want to use seekwatcher to test some of the stuff that I'm
> doing for flex_bg feature but it barfs on me in my test machine.
> 
> running :sleep 10:
> done running sleep 10
> Device: /dev/sdh
>   Total:                     0 events (dropped 0),     1368 KiB data
> blktrace done
> Traceback (most recent call last):
>   File "/usr/bin/seekwatcher", line 534, in ?
>     add_range(hist, step, start, size)
>   File "/usr/bin/seekwatcher", line 522, in add_range
>     val = hist[slot]
> IndexError: list index out of range

I don't think you have any events in the trace.  Try this instead:

echo 3 > /proc/sys/vm/drop_caches
seekwatcher -t find-trace -d /dev/xxxx -p 'find /usr/local -type f'

> 
> This is running on a PPC64/gentoo combination.  Dont know if this
> means anything to you.  I have a very basic algorithm for to take
> advantage block group metadata grouping and want be able to better
> visualize how different IO patterns take advantage or are hurt by the
> feature.

I wanted to benchmark flexbg too, but couldn't quite figure out the
correct patch combination ;)

> 
> > To match the ext4 numbers with Btrfs, I'd probably have to turn off
> > data checksumming...
> > 
> > But oddly enough I saw very bad ext4 read throughput even when
> > reading a single kernel tree (outside of compilebench).  The time
> > to read the tree was almost 2x ext3.  Have others seen similar
> > problems?
> > 
> > I think the ext4 delete times are so much better than ext3 because
> > this is a single threaded test.  delayed allocation is able to get
> > everything into a few extents, and these all end up in the inode.
> > So, the delete phase only needs to seek around in small directories
> > and seek to well grouped inodes.  ext3 probably had to seek all
> > over for the direct/indirect blocks.
> > 
> > So, tomorrow I'll run a few tests with delalloc and mballoc
> > independently, but if there are other numbers people are interested
> > in, please let me know.
> > 
> > (test box was a desktop machine with single sata drive, barriers
> > were not used).
> 
> More details please....
> 
> 1. CPU info (type, count, speed)

Dual core 3ghz x86-64

> 2. Memory info (mostly amount)

2GB

> 3. Disk info (partition size, disk rpms, interface, internal cache

SAMSUNG HD160JJ (sataII w/ncq), the FS was on a 40GB lvm volume.
Single spindle.

> size) 4. Benchmark cmdline parameters.

mkdir ext4
compilebench --makej -D /mnt -d /dev/mapper/xxxx -t ext4/trace -i 20 >&
ext4/out

-chris
