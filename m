From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: remove misleading argument from
	ext2fs_bg_flags_clear
Date: Wed, 2 Sep 2009 19:42:43 -0400
Message-ID: <20090902234243.GC30497@mit.edu>
References: <4A9EE6E4.2000307@redhat.com> <20090902232811.GG4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40346 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbZIBXmo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 19:42:44 -0400
Content-Disposition: inline
In-Reply-To: <20090902232811.GG4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 05:28:11PM -0600, Andreas Dilger wrote:
> On Sep 02, 2009  16:43 -0500, Eric Sandeen wrote:
> > ext2fs_bg_flags_clear shouldn't take an unused bg_flags argument
> > if its purpose is to clear -all- flags.  That just makes people
> > like me call it for the wrong purpose ;)
> 
> I'd pointed this out when the code was originally submitted.
> That said, I'd prefer a function which allows clearing
> individual flags, rather than all of them.  It is possible to
> call it with ~0 to clear all of the flags.

Agreed; if we want to have a function which clears all of the flags,
it should be named something like ext2fs_bg_flags_zap(), or some such.
It would be confusing for ext2fs_bg_flags_clear() and
ext2fs_bg_flags_set() not to be symmetric.

						- Ted
