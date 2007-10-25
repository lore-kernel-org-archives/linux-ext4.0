From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: compilebench numbers for ext4
Date: Thu, 25 Oct 2007 17:40:25 -0500
Message-ID: <20071025174025.1c042424@gara>
References: <20071022193104.0beafeca@think.oraclecorp.com>
	<20071025103449.2e358220@gara>
	<20071025144355.583a8f88@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/mRZk15SN8iEie=o9.Q9+KzH"
Cc: linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36357 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbXJYWj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 18:39:27 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9PMdQZR022976
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 18:39:26 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9PMdQJi134710
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 18:39:26 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9PMdQOU013048
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 18:39:26 -0400
In-Reply-To: <20071025144355.583a8f88@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--MP_/mRZk15SN8iEie=o9.Q9+KzH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 25 Oct 2007 14:43:55 -0400
Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > 2) You mentioned that one of the goals of the benchmark is to measure
> > locality during directory aging, but the workloads seems too well
> > order to truly age the filesystem.  At least that's what I can gather
> > from the output the benchmark spits out.  It may be that Im not
> > understanding the relationship between INITIAL_DIRS and RUNS, but the
> > workload seem to been localized to do operations on a single dir at a
> > time.  Just wondering is this is truly stressing allocation algorithms
> > in a significant or realistic way.
> 
> A good question.  compilebench has two modes, and the default is better
> at aging then the run I graphed on ext4.  compilebench isn't trying to
> fragment individual files, but it is instead trying to fragment
> locality, and lower the overall performance of a directory tree.
> 
> In the default run, the patch, clean, and compile operations end up
> changing around groups of files in a somewhat random fashion (at least
> from the FS point of view).  But, it is still a workload where a good
> FS should be able to maintain locality and provide consistent results
> over time.
> 
> The ext4 numbers I sent here are from compilebench --makej, which is a
> shorter and less complex run.  It has a few simple phases:
> 
> * create some number of kernel trees sequentially
> * write new files into those trees in random order
> * read a three of the trees
> * delete all the trees
> 
> It is a very basic test that can give you a picture of directory
> layout, writeback performance and overall locality.

Thanks.  This clear a couple of things and I think I now follow the
direction you're heading into with this workload. 

> > 
> > I really want to use seekwatcher to test some of the stuff that I'm
> > doing for flex_bg feature but it barfs on me in my test machine.
> > 
> > running :sleep 10:
> > done running sleep 10
> > Device: /dev/sdh
> >   Total:                     0 events (dropped 0),     1368 KiB data
> > blktrace done
> > Traceback (most recent call last):
> >   File "/usr/bin/seekwatcher", line 534, in ?
> >     add_range(hist, step, start, size)
> >   File "/usr/bin/seekwatcher", line 522, in add_range
> >     val = hist[slot]
> > IndexError: list index out of range
> 
> I don't think you have any events in the trace.  Try this instead:
> 
> echo 3 > /proc/sys/vm/drop_caches
> seekwatcher -t find-trace -d /dev/xxxx -p 'find /usr/local -type f'

Nope, get the same error.  There does seem to be data recorded in the
trace files and iostat does show activity on the disk.

toolssf2 ~ # echo 3 > /proc/sys/vm/drop_caches
toolssf2 ~ # seekwatcher -t find-trace -d /dev/sdb3 -p 'find /root -type f >/dev/null'
running :find /root -type f >/dev/null:
done running find /root -type f >/dev/null
Device: /dev/sdb3
  CPU  0:                    0 events,      303 KiB data
  CPU  1:                    0 events,      262 KiB data
  CPU  2:                    0 events,      205 KiB data
  CPU  3:                    0 events,      302 KiB data
  CPU  4:                    0 events,      240 KiB data
  CPU  5:                    0 events,      281 KiB data
  CPU  6:                    0 events,      191 KiB data
  CPU  7:                    0 events,      281 KiB data
  Total:                     0 events (dropped 0),     2061 KiB data
blktrace done
Traceback (most recent call last):
  File "/usr/bin/seekwatcher", line 534, in ?
    add_range(hist, step, start, size)
  File "/usr/bin/seekwatcher", line 522, in add_range
    val = hist[slot]
IndexError: list index out of range

> > This is running on a PPC64/gentoo combination.  Dont know if this
> > means anything to you.  I have a very basic algorithm for to take
> > advantage block group metadata grouping and want be able to better
> > visualize how different IO patterns take advantage or are hurt by the
> > feature.
> 
> I wanted to benchmark flexbg too, but couldn't quite figure out the
> correct patch combination ;)

Ill attach e2progfs and Kernel patches but do realize that these are
experimental patches that Im using to test what layout would work
best.  Don't take them too seriously as it is largely incomplete.

Currently trying to come up with workloads to test this and other
changes with.  Im am warming up to yours :)

To create a filesystem with the feature just do:
	mke2fs -j -I 256 -O flex_bg /dev/xxx

Curently the number of block group meta data that are group together
is EXT4_DESC_PER_BLOCK() which matches the meta_bg feature. This turns
out to be 128 block groups.  This may(probably will) change in the
future but it give a general idea of what benefits can be had with
large grouping of metadata.

On compilebench it seems to show a 10x improvement on "create dir"
since Im currently testing on a SCSI disk with write cache disable.  I
would think the improvements would be a lot less noticeable on a SATA
drive since those usually ship with write caching enable.  All other
test from the --makej runs where measurably better.  Would love to see
seekwatche working to tune a bit better though.


-JRS

--MP_/mRZk15SN8iEie=o9.Q9+KzH
Content-Type: application/x-bzip; name=flex_bg_test.tar.bz2
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=flex_bg_test.tar.bz2

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

--MP_/mRZk15SN8iEie=o9.Q9+KzH--
