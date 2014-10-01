From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Journal under-reservation bug on first >2G file
Date: Wed, 1 Oct 2014 07:53:20 -0400
Message-ID: <20141001115320.GA2903@thunk.org>
References: <542B1C38.9010409@redhat.com>
 <542B1EFC.4050500@redhat.com>
 <C355A8E9-1799-43AB-9F57-4EFE1BBE3767@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58603 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaJALxY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 07:53:24 -0400
Content-Disposition: inline
In-Reply-To: <C355A8E9-1799-43AB-9F57-4EFE1BBE3767@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 30, 2014 at 03:36:17PM -0600, Andreas Dilger wrote:
> > 
> >  1.5a) Always set the large_file feature with a fresh mkfs, insteadl
> >        of relying on the accident of the resize inode being > 2G!
> 
> I think that 1.5a is definitely the way to go for new mke2fs, I'm a
> bit surprised that we didn't do this for "-t ext4" a long time ago
> given that we've enabled lots of other features automatically.

Yes, I agree that would be a good thing to do.  I'll make the change
to mke2fs.conf.

> There shouldn't be any problem to do this retroactively in e2fsck
> and potentially at mount time for filesystems that already have some
> features enabled that are post-large_file (e.g. extents, flex_bg, etc.)
> This definitely would not impose any compatibility issues, because any
> kernel that supports those features already understands large_file.

That sounds like a plan.  If we only enable it automatically at mount
time (iff we mounted the file system read/write) if any of the ext3 or
ext4 specific features are enabled, that should be completely safe.

In fact the only reason why we shouldn't turn it on unconditionally is
because there are other implementations of ext2 (most notably, GNU
Hurd and *BSD) which might not support large_file.

						- Ted
