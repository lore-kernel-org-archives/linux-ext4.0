From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Mon, 2 May 2011 12:56:29 +0200
Message-ID: <20110502105629.GA4556@quack.suse.cz>
References: <20110216145627.GB5592@quack.suse.cz>
 <4D5C9B1B.2050304@jp.fujitsu.com>
 <20110217104552.GD4947@quack.suse.cz>
 <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
 <20110331234050.GD2904@dastard>
 <20110401140856.GA5311@quack.suse.cz>
 <20110406054005.GD31057@dastard>
 <20110406061856.GC23285@quack.suse.cz>
 <20110406112135.GE31057@dastard>
 <4DBE746F.3090707@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Surbhi Palande <surbhi.palande@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52722 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757817Ab1EBK4d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 06:56:33 -0400
Content-Disposition: inline
In-Reply-To: <4DBE746F.3090707@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-05-11 12:07:59, Surbhi Palande wrote:
> On 04/06/2011 02:21 PM, Dave Chinner wrote:
> >On Wed, Apr 06, 2011 at 08:18:56AM +0200, Jan Kara wrote:
> >>On Wed 06-04-11 15:40:05, Dave Chinner wrote:
> >>>On Fri, Apr 01, 2011 at 04:08:56PM +0200, Jan Kara wrote:
> >>>>On Fri 01-04-11 10:40:50, Dave Chinner wrote:
> >>>>>If you don't allow the page to be dirtied in the fist place, then
> >>>>>nothing needs to be done to the writeback path because there is
> >>>>>nothing dirty for it to write back.
> >>>>   Sure but that's only the problem he was able to hit. But generally,
> >>>>there's a problem with needing s_umount for unfreezing because it isn't
> >>>>clear there aren't other code paths which can block with s_umount held
> >>>>waiting for fs to get unfrozen. And these code paths would cause the same
> >>>>deadlock. That's why I chose to get rid of s_umount during thawing.
> >>>
> >>>Holding the s_umount lock while checking if frozen and sleeping
> >>>is essentially an ABBA lock inversion bug that can bite in many more
> >>>places that just thawing the filesystem.  Any where this is done should
> >>>be fixed, so I don't think just removing the s_umount lock from the thaw
> >>>path is sufficient to avoid problems.
> >>   That's easily said but hard to do - any transaction start in ext3/4 may
> >>block on filesystem being frozen (this seems to be similar for XFS as I'm
> >>looking into the code) and transaction start traditionally nests inside
> >>s_umount (and basically there's no way around that since sync() calls your
> >>fs code with s_umount held).
> >
> >Sure, but the question must be asked - why is ext3/4 even starting a
> >transaction on a clean filesystem during sync? A frozen filesystem,
> >by definition, is a clean filesytem, and therefore sync calls of any
> >kind should not be trying to write to the FS or start transactions.
> >XFS does this just fine, so I'd consider such behaviour on a frozen
> >filesystem a bug in ext3/4...
> 
> I had a look at the xfs code for seeing how this is done.
> xfs_file_aio_write()
>   xfs_wait_for_freeze()
>     vfs_check_frozen()
> So xfs_file_aio_write() writes to buffers when the FS is not frozen.
> 
> Now, I want to know what stops the following scenario from happening:
> --------------------
> xfs_file_aio_write()
>   xfs_wait_for_freeze()
>     vfs_check_frozen()
> At this point F.S was not frozen, so the next instruction in the
> xfs_file_aio_write() will be executed next.
> However at this point (i.e after checking if F.S is frozen) the
> write process gets pre-empted and say the _freeze_ process gets
> control.
> 
> Now the F.S freezes and the write process gets the control back. And
> so we end up writing to the page cache when the F.S is frozen.
> --------------------
> 
> Can anyone please enlighten me on how & why this premption is _not_
> possible?
  XFS works similarly as ext4 in this regard I believe. They have the log
frozen in xfs_freeze() so if the race you describe above happens, either
the writing process gets caught waiting for log to unfreeze or it manages
to start a transaction and then freezing process waits for transaction to
finish before it can proceed with freezing. I'm not sure why is there the
check in xfs_file_aio_write()...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
