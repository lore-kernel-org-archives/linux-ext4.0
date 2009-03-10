From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Wed, 11 Mar 2009 07:29:44 +1030
Message-ID: <1236718784.16191.2.camel@kulgan.wumi.org.au>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
	 <49B5D71D.1030802@redhat.com>
	 <1236687347.30280.42.camel@kulgan.wumi.org.au>
	 <20090310204418.GW3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:53632 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbZCJU7s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 16:59:48 -0400
In-Reply-To: <20090310204418.GW3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-03-10 at 14:44 -0600, Andreas Dilger wrote:
> On Mar 10, 2009  22:45 +1030, Kevin Shanahan wrote:
> > Pass 3: Checking directory connectivity
> > Pass 3A: Optimizing directories
> > Error reading block 2705859237 (Invalid argument).  Ignore error<y>? yes
> > 
> > Force rewrite<y>? yes
> > 
> > Error writing block 2705859237 (Invalid argument).  Ignore error<y>? yes
> 
> Hmm, is this read beyond EOF?  The block pointers should be fixed by this
> time, so there may be a hole in e2fsck at this point.  I assume you do
> not have a 10TB filesystem here.

Yeah, this is a 1TB filesystem.

hermes:~# tune2fs -l /dev/dm-0
tune2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          3db511f5-97fe-4a35-b327-ea58dd498414
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file huge_file
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              67108864
Block count:              268435456
Reserved block count:     13421772
Free blocks:              227859007
Free inodes:              66820121
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      192
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Feb 27 01:58:46 2009
Last mount time:          Tue Mar 10 22:39:18 2009
Last write time:          Tue Mar 10 22:39:18 2009
Mount count:              1
Maximum mount count:      22
Last checked:             Tue Mar 10 22:36:30 2009
Check interval:           15552000 (6 months)
Next check after:         Sun Sep  6 21:36:30 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      14c2ef0e-3417-45b2-8327-07dfb3603af1
Journal backup:           inode blocks

Cheers,
Kevin.


