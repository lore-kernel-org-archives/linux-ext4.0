From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Fix incorrect interior node logical start values
Date: Thu, 29 Nov 2012 08:22:53 -0500
Message-ID: <20121129132253.GB20413@thunk.org>
References: <50A546D8.3020500@redhat.com>
 <20121129044609.GC8029@thunk.org>
 <20121129045230.GD8029@thunk.org>
 <50B6F75C.8070903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35730 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab2K2NW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2012 08:22:57 -0500
Content-Disposition: inline
In-Reply-To: <50B6F75C.8070903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2012 at 11:49:16PM -0600, Eric Sandeen wrote:
> > 
> > Wow, that was unnecessarily large.  Here's a smaller one...
> > 
>
> Was that by hand-hackery or did you figure out how to hit
> it at runtime?

Via hand-hackery.  The tst_extents command allow you to do things like
this:

% ./build/lib/ext2fs/tst_extents  -w /tmp/test_case.img
tst_extents 1.42.6 (21-Sep-2012)
tst_extents:  inode <16>
header: magic=f30a entries=3 max=4 depth=1 generation=0
Loaded inode 16
tst_extents:  root
extent: lblk 0--83, len 84, pblk 1731, flags: (none)
tst_extents:  next_sibling
extent: lblk 84--4021, len 3938, pblk 1899, flags: (none)
tst_extents:  replace_node 80 0 1899
extent replace: 16 extent: lblk 80--79, len 0, pblk 1899, flags: (none)
extent: lblk 80--4021, len 3942, pblk 1899, flags: (none)
tst_extents:  prev_sibling
extent: lblk 0--79, len 80, pblk 1731, flags: 2ND_VISIT 
tst_extents:  q

						- Ted
