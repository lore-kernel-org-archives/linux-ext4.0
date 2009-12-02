From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Use slab allocator for sub-page sized
	allocations
Date: Wed, 2 Dec 2009 11:48:08 -0500
Message-ID: <20091202164807.GA26175@localhost.localdomain>
References: <1259716451-26901-1-git-send-email-tytso@mit.edu> <1259716451-26901-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbZLBQsD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Dec 2009 11:48:03 -0500
Content-Disposition: inline
In-Reply-To: <1259716451-26901-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 01, 2009 at 08:14:11PM -0500, Theodore Ts'o wrote:
> Now that the SLUB seems to be fixed so that it respects the requested
> alignment, use kmem_cache_alloc() to allocator if the block size of
> the buffer heads to be allocated is less than the page size.
> Previously, we were using 16k page on a Power system for each buffer,
> even when the file system was using 1k or 4k block size.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Heh funny you should bring this up, we just fixed a problem in RHEL5 related to
using slabs.  If you have a non-jbd based root filesystem and then mount a bunch
of jbd-based fs's at the same time you will race with the cache creation stuff
and end up getting errors about creating the same slab cache multiple times.
The way this was fixed in RHEL5 was to put a mutex around the slabcache creation
and deletion so this sort of race.  It seems that this patch has the same issue
as the 2.6.18 jbd had.  Thanks,

Josef
