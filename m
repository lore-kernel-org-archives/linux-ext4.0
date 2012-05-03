From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] implement uid and gid mount options for ext2, ext3 and
 ext4
Date: Thu, 3 May 2012 13:51:44 -0400
Message-ID: <20120503175144.GH18002@thunk.org>
References: <1336036248-12980-1-git-send-email-ludwig.nussel@suse.de>
 <4FA2B0C1.4030206@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	linux-kernel@vger.kernel.org,
	"Jan Kara (maintainer:EXT2 FILE SYSTEM)" <jack@suse.cz>,
	"Andrew Morton (maintainer:EXT3 FILE SYSTEM)"
	<akpm@linux-foundation.org>,
	"Andreas Dilger (maintainer:EXT3 FILE SYSTEM)"
	<adilger.kernel@dilger.ca>,
	"open list:EXT2 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
To: Rob Landley <rob@landley.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58121 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab2ECRv7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 May 2012 13:51:59 -0400
Content-Disposition: inline
In-Reply-To: <4FA2B0C1.4030206@landley.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 03, 2012 at 11:22:25AM -0500, Rob Landley wrote:
> > When using 'real' file systems on removable storage devices such as
> > hard disks or usb sticks people quickly face the problem that their
> > Linux users have different uids on different machines.
> 
> I still think this belongs at the VFS level, not in individual filesystems.

I agree with Rob; as much as possible, this should be done at the VFS
level.  The problem is that there will need to be at least some
support in the individual file system, since there isn't a good place
for the VFS to intercept the internal file system iget() function to
patch in the override uid/gid values.

So the question at this point is whether it's cleaner to have the
functionality split between the VFS and the file system layers (i.e.,
with the options parsing and storing the override uid/gid values in
the super_block structure) or keeping it all in the file system layer,
and accepting the duplication of code across multiple file systems.

My preference leans towards the former (pushing as much as we can into
the VFS layer), but I can see the other point of view.

Regards,

					- Ted
