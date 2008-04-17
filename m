From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ininitial e2fsprogs TODO list (please expand)
Date: Wed, 16 Apr 2008 23:36:16 -0400
Message-ID: <20080417033616.GA2850@mit.edu>
References: <20080415115216.1f6868de@gara.konoha.net> <20080416033002.GZ3106@webber.adilger.int> <20080415115216.1f6868de@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47984 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750822AbYDQDgY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2008 23:36:24 -0400
Content-Disposition: inline
In-Reply-To: <20080416033002.GZ3106@webber.adilger.int> <20080415115216.1f6868de@gara.konoha.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2008 at 11:52:16AM -0500, Jose R. Santos wrote:
> As discuss on the call yesterday, some folks (my self included) really
> want a TODO list to help them keep track of what things are left undone
> in e2fsprogs as we try to get ext4 out the door.  Here is my initial
> list of items that still need addressing.  Hopefully we can expand this
> list and document it somewhere like the ext4 wiki or the SourceForge
> bug tracker.
> 
> - Rename uninit_groups to uninit_bg to be consistent with other
> defined features.  Retain the old name for historical purpose.

Yes.  Although until we actually don't do lazy initialization of the
inode table, I still think the name is a bit of a misnomer.  It really
is more about checksuming the block group descriptors and a faster
fsck, but whether or not we initialize the block groups or not is
pretty much a non-issue.

> - The return value of ext2fs_super_and_bgd_loc() is not to be trusted.
> Document this in the source code.
> 
> - Make sure ext2fs_super_and_bgd_loc() does not get used anywhere where
> the return value is expected to be accurate (aside from mke2fs).
> 
> - Remove lazy_bg feature from being set in mke2fs.  Feature has been
> declare a dangerous hack by its creator, remove it to avoid people
> building on top of it.

.... and to replace it, add a configuration parameter to
/etc/e2fsck.conf which controls whether or not the inode table and
bitmap blocks should be uninitialized when using uninit groups.  It
will default to off for now, until the kernel support can be
implemented.

> - Add flex_bg meta-data grouping support.

Once it is demonstrated to work correctly in all circumstances.  :-)

     	   		   		     - Ted
