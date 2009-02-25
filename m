From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4-fs: group descriptors corrupted!
Date: Wed, 25 Feb 2009 16:30:46 -0500
Message-ID: <20090225213046.GF1363@mit.edu>
References: <49A5AC83.1020009@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux-Ext4 <linux-ext4@vger.kernel.org>
To: Ron Johnson <ron.l.johnson@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52781 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759750AbZBYVav (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2009 16:30:51 -0500
Content-Disposition: inline
In-Reply-To: <49A5AC83.1020009@cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 02:39:31PM -0600, Ron Johnson wrote:
> These are the relevant Debian Sid package versions:
> e2fsprogs                1.41.3-1
> linux-source-2.6.28      2.6.28-2~snapshot.12850
>
> Since I built the fs with extents enabled, I am hesitant to run fsck on 
> it because I've read that it doesn't yet support extents.
>
> As you can see from the dmesg snippets, one of my ext4 file systems  
> mounted perfectly.  The one that didn't is an lvm2 "array", which seems 
> to be consistent.

E2fsck 1.41.3 does actually have extent support, but let's not be too
hasty to run e2fsck just yet.

Can you send me the output of "dumpe2fs -o superblock=32768
/dev/main_huge_vg/main_huge_lv" and see how it compares to the
dumpe2fs of your primary superblock?

It looks like your block group descriptors were totally scribbled
upon.  How and why it happened, I'm not sure.  But before we do
anything else, let's check out the backup descriptors and make sure
they are sane.

						- Ted
