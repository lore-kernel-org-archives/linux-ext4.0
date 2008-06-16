From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re:
Date: Mon, 16 Jun 2008 17:44:04 -0400
Message-ID: <19376.1213652644@alphaville.zko.hp.com>
References: <3.0.6.32.20080616134710.01b18a90@pop.west.cox.net>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:37424 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYFPVoI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 17:44:08 -0400
In-Reply-To: Your message of "Mon, 16 Jun 2008 13:47:10."
             <3.0.6.32.20080616134710.01b18a90@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Gary Hawco <ghawco@cox.net> wrote:

> Had a couple of questions as to what flex_bg & meta_bg features involve.  I
> think flex_bg has to do with areas of metadata skipped during e2fsck, but I
> am not sure about meta_bg.  And is meta_bg a mount option or a feature
> specified during mkfs.ext4dev?  And if so, I guess you would use
> mkfs.ext4dev -t meta_bg?
> 
> Any insight would be most appreciated.

>From http://www.ussg.iu.edu/hypermail/linux/kernel/0709.2/2408.html

ext4: FLEX_BG Kernel support v2.

    This feature relaxes check restrictions on where each block groups
    meta data is located within the storage media. This allows for the
    allocation of bitmaps or inode tables outside the block group
    boundaries in cases where bad blocks forces us to look for new
    blocks which the owning block group can not satisfy. This will also
    allow for new meta-data allocation schemes to improve performance
    and scalability.


It's set with `mkfs.ext4dev -O flex_bg ...' or `tune2fs -O flex_bg ...'

meta_bg is described in last year's OLS ext4 paper:

    The solution to this problem [having enough bits for only a 256TB
    filesystem] is to use the metablock group feature (META_BG), which
    is already in ext3 for all 2.6 releases. With the META_BG feature,
    ext4 filesystems are partitioned into many metablock groups.  Each
    metablock group is a cluster of block groups whose group descriptor
    structures can be stored in a single disk block. For ext4
    filesystems with 4 KB block size, a single metablock group partition
    includes 64 block groups, or 8 GB of disk space. The metablock group
    feature moves the location of the group descriptors from the
    congested first block group of the whole filesystem into the first
    group of each metablock group itself. The backups are in the second
    and last group of each metablock group. This increases the 2^21
    maximum block groups limit to 2^32, allowing support for the full
    1EB filesystem.

meta_bg is incompatible with resize_inode and afaik cannot be set through
tune2fs, so you got to do it at mkfs time:

    mkfs.ext4dev -O flex_bg,meta_bg,^resize_inode ...

Hope this helps (and that it is correct, although if it isn't I'm sure somebody
will correct it!).

Nick

