From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Fri, 02 Mar 2007 11:19:15 -0600
Message-ID: <45E85C93.7080509@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>	 <20070225022326.137b4875.akpm@linux-foundation.org>	 <20070301183445.GA7911@amitarora.in.ibm.com> <45E7BE4B.5070602@us.ibm.com>	 <45E83FCE.4040008@redhat.com> <1172851980.9213.13.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992644AbXCBRU6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2007 12:20:58 -0500
In-Reply-To: <1172851980.9213.13.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Badari Pulavarty wrote:

> BTW, what is the interface for finding out what is the size of the
> pre-allocated file ? 

With XFS at least, "du," "stat," etc tell you a little:

[root@magnesium test]# touch resvsp
[root@magnesium test]# xfs_io resvsp
xfs_io> resvsp 0 10g

The file is 0 length, but is using 10g of blocks:
(with posix_fallocate this would move the size out to 10g as well)

[root@magnesium test]# ls -lh resvsp
-rw-r--r--  1 root root 0 Nov 28 14:11 resvsp
[root@magnesium test]# du -hc resvsp
10G     resvsp
10G     total
[root@magnesium test]# stat resvsp
   File: `resvsp'
   Size: 0               Blocks: 20971520   IO Block: 4096   regular 
empty file
Device: 81eh/2078d      Inode: 186         Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)

xfs also has an interface to find out what allocations are where:

if you reserve some ranges not starting at 0...

[root@magnesium test]# xfs_io resvsp
xfs_io> resvsp 1g 1g
xfs_io> resvsp 3g 1g
xfs_io> resvsp 5g 1g
xfs_io> quit

[root@magnesium test]# xfs_bmap -v resvsp
resvsp:
  EXT: FILE-OFFSET           BLOCK-RANGE       AG AG-OFFSET 
TOTAL FLAGS
    0: [0..2097151]:         hole 
2097152
    1: [2097152..4194303]:   42392..2139543     0 (42392..2139543) 
2097152 10000
    2: [4194304..6291455]:   hole 
2097152
    3: [6291456..8388607]:   4236696..6333847   0 (4236696..6333847) 
2097152 10000
    4: [8388608..10485759]:  hole 
2097152
    5: [10485760..12582911]: 8431000..10528151  0 (8431000..10528151) 
2097152 10000

The flags of 10000 mean that these extents is preallocated/unwritten.

I suppose outside of XFS, FIBMAP is your best bet, but that won't tell 
you what is preallocated vs. allocated/written....

-Eric
