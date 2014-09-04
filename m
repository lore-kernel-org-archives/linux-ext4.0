From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user
 specific flag
Date: Thu, 4 Sep 2014 15:16:12 -0700
Message-ID: <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
	peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
	js1304@gmail.com, gunho.lee@lge.com
To: Gioh Kim <gioh.kim@lge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbaIDWQO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Sep 2014 18:16:14 -0400
In-Reply-To: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu,  4 Sep 2014 16:29:38 +0900 Gioh Kim <gioh.kim@lge.com> wrote:

> This patch try to solve problem that a long-lasting page caches of
> ext4 superblock and journaling of superblock disturb page migration.
> 
> I've been testing CMA feature on my ARM-based platform
> and found that two page caches cannot be migrated.
> They are page caches of superblock of ext4 filesystem and its journaling data.
> 
> Current ext4 reads superblock with sb_bread() that allocates page
> from movable area. But the problem is that ext4 hold the page until
> it is unmounted. If root filesystem is ext4 the page cannot be migrated
> forever.
> And also the journaling data for the superblock cannot be migreated.
> 
> I introduce new APIs that allocates page cache with specific flag passed by an
> argument.
> *_gfp APIs are for user want to set page allocation flag for page cache
> allocation.
> And *_unmovable APIs are for the user wants to allocate page cache from
> non-movable area.
> 
> It is useful for ext4/ext3 and others that want to hold page cache for a long
> time.

Could we please have some detailed information about the real-world
effect of this patchset?

You earlier said "My test platform is currently selling item in the
market.  And also I test my patch when my platform is working as if
real user uses it.".

But what were the problems which were observed in standard kernels and
what effect did this patchset have upon them?  Some quantitative
measurements will really help here.

I'm trying to get an understanding of how effective and important the
change is, whether others will see similar benefits.  I'd also like to
understand how *complete* the fix is - were the problems which you
observed completely fixed, or do outstanding problems remain?

Thanks.
