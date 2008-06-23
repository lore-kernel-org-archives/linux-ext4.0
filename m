From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re:
Date: Mon, 23 Jun 2008 10:02:42 -0500
Message-ID: <20080623100242.44780b60@rx8>
References: <3.0.6.32.20080616134710.01b18a90@pop.west.cox.net>
	<19376.1213652644@alphaville.zko.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Gary Hawco <ghawco@cox.net>, linux-ext4@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46271 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbYFWPCp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2008 11:02:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5NF2iEf021625
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 11:02:44 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5NF2ipw237758
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 11:02:44 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5NF2hEi027014
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 11:02:44 -0400
In-Reply-To: <19376.1213652644@alphaville.zko.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 16 Jun 2008 17:44:04 -0400
Nick Dokos <nicholas.dokos@hp.com> wrote:

> Gary Hawco <ghawco@cox.net> wrote:
> 
> > Had a couple of questions as to what flex_bg & meta_bg features
> > involve.  I think flex_bg has to do with areas of metadata skipped
> > during e2fsck, but I am not sure about meta_bg.  And is meta_bg a
> > mount option or a feature specified during mkfs.ext4dev?  And if
> > so, I guess you would use mkfs.ext4dev -t meta_bg?
> > 
> > Any insight would be most appreciated.
> 
> From http://www.ussg.iu.edu/hypermail/linux/kernel/0709.2/2408.html
> 
> ext4: FLEX_BG Kernel support v2.
> 
>     This feature relaxes check restrictions on where each block groups
>     meta data is located within the storage media. This allows for the
>     allocation of bitmaps or inode tables outside the block group
>     boundaries in cases where bad blocks forces us to look for new
>     blocks which the owning block group can not satisfy. This will
> also allow for new meta-data allocation schemes to improve performance
>     and scalability.
> 
> 
> It's set with `mkfs.ext4dev -O flex_bg ...' or `tune2fs -O
> flex_bg ...'

As the description says, FLEX_BG just removes restrictions on where
each block groups meta data can be located.  There is a option
currently in e2fsprogs (-G) that allow the grouping of meta data of
multiple block groups in a contiguous fashion.  There is also a
experimental inode allocator in the patch queue that is FLEX_BG
grouping aware and changes inode allocation better fit the new
meta data allocation and improve performance on heavy meta data
workloads.  Aneesh's OLS paper will have a section on this new
allocator as well as more details on FLEX_BG.
 
> meta_bg is described in last year's OLS ext4 paper:
> 
>     The solution to this problem [having enough bits for only a 256TB
>     filesystem] is to use the metablock group feature (META_BG), which
>     is already in ext3 for all 2.6 releases. With the META_BG feature,
>     ext4 filesystems are partitioned into many metablock groups.  Each
>     metablock group is a cluster of block groups whose group
> descriptor structures can be stored in a single disk block. For ext4
>     filesystems with 4 KB block size, a single metablock group
> partition includes 64 block groups, or 8 GB of disk space. The
> metablock group feature moves the location of the group descriptors
> from the congested first block group of the whole filesystem into the
> first group of each metablock group itself. The backups are in the
> second and last group of each metablock group. This increases the 2^21
>     maximum block groups limit to 2^32, allowing support for the full
>     1EB filesystem.
> 
> meta_bg is incompatible with resize_inode and afaik cannot be set
> through tune2fs, so you got to do it at mkfs time:
> 
>     mkfs.ext4dev -O flex_bg,meta_bg,^resize_inode ...

I believe that you no longer need to add the ^resize_inode option
since current e2fsprogs removes the option if meta_bg is specified.
 
> Hope this helps (and that it is correct, although if it isn't I'm
> sure somebody will correct it!).
> 
> Nick
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
