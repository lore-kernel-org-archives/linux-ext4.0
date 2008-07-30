From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Porting Zfs features to ext2/3
Date: Tue, 29 Jul 2008 21:29:09 -0400
Message-ID: <20080730012909.GC29748@mit.edu>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto> <20080727233855.GB9378@mit.edu> <loom.20080729T222131-137@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:36212 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYG3B3r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 21:29:47 -0400
Content-Disposition: inline
In-Reply-To: <loom.20080729T222131-137@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 29, 2008 at 10:52:26PM +0000, Szabolcs Szakacsits wrote:
> I did also an in memory test on a T9300@2.5, with disk I/O completely 
> eliminated. Results:
> 
> tmpfs:    975 MB/sec
> ntfs-3g:  889 MB/sec  (note, this FUSE driver is not optimized yet)
> ext3:     675 MB/sec

Again, I agree that you can optimize bulk data transfer.  It'll be
metadata operations where I'm really not convinced FUSE will be able
to be acceptable for many workloads.  If you are doing a sequential
I/O in huge chunks, sure you can amortize the overhead of the
userspace context switches.

The test you did above looks bad because ext3 does lots of small I/O
to the loop device.  The CPU overhead is not a big deal for real
disks, but when you do a pure memory test, it definitely becomes an
issue.  Try doing an in-memory test with ext2, and you'll see much
better results, much closer to tmpfs.  The reason?  Blktrace tells the
tale.  Ext2 looks like this:

254,4    1        1     0.000000000 23109  Q   W 180224 + 96 [pdflush]
254,4    1        2     0.000030032 23109  Q   W 180320 + 8 [pdflush]
254,4    1        3     0.000328538 23109  Q   W 180328 + 1024 [pdflush]
254,4    1        4     0.000628162 23109  Q   W 181352 + 1024 [pdflush]
254,4    1        5     0.000925550 23109  Q   W 182376 + 1024 [pdflush]
254,4    1        6     0.001317715 23109  Q   W 183400 + 1024 [pdflush]
254,4    1        7     0.001619783 23109  Q   W 184424 + 1024 [pdflush]
254,4    1        8     0.001913400 23109  Q   W 185448 + 1024 [pdflush]
254,4    1        9     0.002206738 23109  Q   W 186472 + 1024 [pdflush]

Ext3 looks like this:

254,4    0        1     0.000000000 23109  Q   W 131072 + 8 [pdflush]
254,4    0        2     0.000040578 23109  Q   W 131080 + 8 [pdflush]
254,4    0        3     0.000059575 23109  Q   W 131088 + 8 [pdflush]
254,4    0        4     0.000076617 23109  Q   W 131096 + 8 [pdflush]
254,4    0        5     0.000093728 23109  Q   W 131104 + 8 [pdflush]
254,4    0        6     0.000110211 23109  Q   W 131112 + 8 [pdflush]
254,4    0        7     0.000127253 23109  Q   W 131120 + 8 [pdflush]
254,4    0        8     0.000143735 23109  Q   W 131128 + 8 [pdflush]

So it's issueing lots of 4k writes, one page at a time, because it
needs to track the completion of each block.  This creates a
significant CPU overhead, which dominates in an all-memory test.
Although this is not an issue in real-life today, it will likely
become an issue in real-life solid state disks (SSD's).

Fortunately, ext4's blktrace when copying a large file looks like
this:

254,4    1        1     0.000000000 24574  Q   R 648 + 8 [cp]
254,4    1        2     0.000059855 24574  U   N [cp] 0
254,4    0        1     0.000427435     0  C   R 648 + 8 [0]
254,4    1        3     0.385530672 24313  Q   R 520 + 8 [pdflush]
254,4    1        4     0.385558400 24313  U   N [pdflush] 0
254,4    1        5     0.385969143     0  C   R 520 + 8 [0]
254,4    1        6     0.387101706 24313  Q   W 114688 + 1024 [pdflush]
254,4    1        7     0.387269327 24313  Q   W 115712 + 1024 [pdflush]
254,4    1        8     0.387434854 24313  Q   W 116736 + 1024 [pdflush]
254,4    1        9     0.387598425 24313  Q   W 117760 + 1024 [pdflush]
254,4    1       10     0.387831698 24313  Q   W 118784 + 1024 [pdflush]
254,4    1       11     0.387996037 24313  Q   W 119808 + 1024 [pdflush]
254,4    1       12     0.388162890 24313  Q   W 120832 + 1024 [pdflush]
254,4    1       13     0.388325204 24313  Q   W 121856 + 1024 [pdflush]

*Much* better.  :-)

						- Ted
