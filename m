From: tytso@mit.edu
Subject: Re: [PATCH] ext3: make "norecovery" an alias for "noload"
Date: Thu, 19 Nov 2009 14:33:58 -0500
Message-ID: <20091119193358.GE2099@thunk.org>
References: <4B01D749.3030601@redhat.com>
 <20091119151233.GE24836@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37218 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZKSUc5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Nov 2009 15:32:57 -0500
Content-Disposition: inline
In-Reply-To: <20091119151233.GE24836@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 19, 2009 at 04:12:33PM +0100, Jan Kara wrote:
> On Mon 16-11-09 16:50:49, Eric Sandeen wrote:
> > Users on the list recently complained about differences across
> > filesystems w.r.t. how to mount without a journal replay.
> > 
> > In the discussion it was noted that xfs's "norecovery" option is
> > perhaps more descriptively accurate than "noload," so let's make
> > that an alias for ext3.
> > 
> > Also show this status in /proc/mounts
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>   OK, provided ext4 will have the same change, I'm fine with the patch.
> So how is it with ext4?

Queued for the next merge window.  I did slightly change the
documentation in Documentation/filesystems/ext4.txt to make
"norecovery" be the canonnical option name, since that's what Eric had
show up in /proc/mounts.  That seems fair, we might as well try to add
consistency between different Linux filesystems.

							- Ted
