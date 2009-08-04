From: Andreas Dilger <adilger@sun.com>
Subject: Re: spatch for 64-bit e2fsprogs (was Re: Fix device too big bug in
	mainline?)
Date: Tue, 04 Aug 2009 13:24:08 -0600
Message-ID: <20090804192408.GE3340@webber.adilger.int>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu>
 <20090802022209.GC8680@mit.edu> <20090803202740.GE10853@shell>
 <20090804144846.GE28678@mit.edu> <20090804181850.GF9324@shell>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, Julia Lawall <julia@diku.dk>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Jesper Andersen <jespera@diku.dk>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42248 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322AbZHDTYk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Aug 2009 15:24:40 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n74JObS1011960
	for <linux-ext4@vger.kernel.org>; Tue, 4 Aug 2009 12:24:38 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KNV00M009PV4O00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 04 Aug 2009 12:24:37 -0700 (PDT)
In-reply-to: <20090804181850.GF9324@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Semantic patches...  a very interesting idea.

On Aug 04, 2009  14:18 -0400, Valerie Aurora wrote:
> // Free blocks
> -fs->group_desc[group].bg_free_blocks_count++
> +ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)+1)
> |
> -fs->group_desc[group].bg_free_blocks_count--
> +ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)-1)
> |
> -fs->group_desc[group].bg_free_blocks_count += i
> +ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)+i)
> |
> -fs->group_desc[group].bg_free_blocks_count -= i
> +ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)-i)

I wonder if it makes more sense for ext2fs to export functions like
ext2fs_bg_free_blocks_count_add() and ext2fs_bg_free_blocks_count_sub()?

> -fs->group_desc[group].bg_flags & flag
> +ext2fs_bg_flag_test(fs, group, flag)
> |
> -fs->group_desc[group].bg_flags &= ~flag
> +ext2fs_bg_flag_clear(fs, group, flag)
> |
> -fs->group_desc[group].bg_flags |= flag
> +ext2fs_bg_flag_set(fs, group, flag)
> |
> -fs->group_desc[group].bg_flags = 0
> +ext2fs_bg_flags_clear(fs, group, 0)

This last one looks like an error.  To clear the flags you should
use ext2fs_bg_flags_set(fs, group, 0), otherwise you are "clearing
no flags".


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

