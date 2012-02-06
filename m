From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] filemap: don't call generic_write_sync for
 -EIOCBQUEUED
Date: Mon, 6 Feb 2012 14:55:47 -0500
Message-ID: <20120206195546.GA22640@infradead.org>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
 <1327698949-12616-4-git-send-email-jmoyer@redhat.com>
 <20120202175219.GB6640@quack.suse.cz>
 <x497gzzrkfa.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56863
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab2BFTzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Feb 2012 14:55:49 -0500
Content-Disposition: inline
In-Reply-To: <x497gzzrkfa.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 06, 2012 at 11:33:29AM -0500, Jeff Moyer wrote:
> > code, right? Before that we'd drain the IO queue when cache flush is issued
> > and thus effectively wait for IO completion...
> 
> Right, though hch seems to think even then the problem existed.

I was wrong, using -o barrier it didn't.  That was however not something
people using O_SYNC heavy production loads would do, they'd use disabled
caches and nobarrier.

> > Also I was thinking whether we couldn't implement the fix in VFS. Basically
> > it would be the same like the fix for ext4. Like having a per-sb workqueue
> > and queue work calling generic_write_sync() from end_io handler when the
> > file is O_SYNC? That would solve the issue for all filesystems...
> 
> Well, that would require buy-in from the other file system developers.
> What do the XFS folks think?

I don't think using that code for XFS makes sene.  But just like
generic_write_sync there's no reason it can't be added to generic code,
just make sure only generic_file_aio_write/__generic_file_aio_write use
it, but generic_file_buffered_write and generic_file_direct_write stay
clear of it.

