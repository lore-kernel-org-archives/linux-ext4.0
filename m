From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] debugfs: open with EXT2_FLAG_64BITS
Date: Sat, 12 Sep 2009 22:29:19 +0200
Message-ID: <20090912202919.GY9372@webber.adilger.int>
References: <4AAA6A44.90902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:40425 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZILU3W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Sep 2009 16:29:22 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8CKTPAX025276
	for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2009 13:29:26 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPV00K00KV17P00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Sat,
 12 Sep 2009 13:29:25 -0700 (PDT)
In-reply-to: <4AAA6A44.90902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 11, 2009  10:18 -0500, Eric Sandeen wrote:
> Pointing debugfs from the pu branch at a large filesystem is
> still failing with:
>
> Filesystem too large to use legacy bitmaps while reading block bitmap
>
> We need to open with EXT2_FLAG_64BITS; I'm not sure if this
> should be a switch based on the size of the fs or not?

The one thing that is already VERY painful is the time it takes for
debugfs to read the bitmaps from disk at startup.  Running with
"-c" allows that step to be skipped, but tha means it isn't possible
to modify the filesystem at all.

The time for 8TB filesystems is already in the multi-minute range, so
I can't imagine how long it will take on huge filesystems.  The only
saving grace might be flex_bg avoiding seeks between every pair of
bitmaps.

Has any attention been given to the ext2fs_load_bitmaps() function for
flex_bg filesystems?  This would need to be tuned to read groups_per_flex
block bitmaps first, then groups_per_flex inode bitmaps before skipping
to the next flex group.  Otherwise we may still be reading each pair of
block+inode bitmaps at a time, and only by virtue of disk track caching
are we avoiding a seek between each one (which would eventually break
down once the groups_per_flex exceeds the track cache size).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

