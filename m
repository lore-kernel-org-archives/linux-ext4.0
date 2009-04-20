From: Theodore Tso <tytso@mit.edu>
Subject: Re: PATCH: Making mb_history length a dynamic tunable
Date: Mon, 20 Apr 2009 15:26:12 -0400
Message-ID: <20090420192612.GX19186@mit.edu>
References: <6601abe90904071020gdce65d2madc6df30c182c5cd@mail.gmail.com> <20090420032252.GA3209@webber.adilger.int> <6601abe90904201153q5e66cb30na22a49767245e53f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59910 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbZDTT0U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 15:26:20 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90904201153q5e66cb30na22a49767245e53f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 20, 2009 at 11:53:12AM -0700, Curt Wohlgemuth wrote:
> 
> > Since the s_mb_history buffers are allocated at mount time only,
> > and later writing to mb_hist_size does not affect their size,
> > it means that mb_hist_size must be set before the filesystems are
> > mounted.  However, that makes it impossible to tune the root
> > filesystem history size, and at best it is difficult to tune the
> > other filesystems because the value has to be set by an init
> > script after root mounts but before other filesystems mount.

If it's only going to be allocated at mount-time (as opposed doing it
at run-time --- where for simplicities sake I would just simply flush
the existing history when resizing the mb_history buffers), I would
make this a mount option.  This would allow it to be set for the root
filesystem via a boot option (rootfsflags).

> Right, I thought about this.  But avoiding the race when the tunable is
> being changed at the same time that history is being updated just didn't
> seem worth it to me.

Fixing this wouldn't be that hard; I would use read-copy-update (RCU)
and just free the old history when changing the size of the
mb_history.  But setting it as a mount option would also be fine, I
think.

							- Ted
