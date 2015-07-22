From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4 v2] e2fsprogs: Support for orphan file feature
Date: Wed, 22 Jul 2015 11:18:35 +0200
Message-ID: <20150722091835.GD17243@quack.suse.cz>
References: <1432626669-6643-1-git-send-email-jack@suse.cz>
 <CAP9B-Qnk1UGSvmaMQdixwNLZRN7L4xW2xWYY6vX877t5uHSr-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
To: Shilong Wang <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539AbbGVJSl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2015 05:18:41 -0400
Content-Disposition: inline
In-Reply-To: <CAP9B-Qnk1UGSvmaMQdixwNLZRN7L4xW2xWYY6vX877t5uHSr-Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Wed 22-07-15 17:05:28, Shilong Wang wrote:
> 2015-05-26 15:51 GMT+08:00 Jan Kara <jack@suse.cz>:
> 
> >   Hello,
> >
> >   this is the second version of support for orphan file feature in
> > e2fsprogs.
> > Since v1, I have finished and debugged e2fsck support, fixed a couple of
> > issues
> > in mke2fs and tune2fs and also incorporated changes resulting from the
> > review.
> > The only unresolved issue I'm aware of is which reserved inode will we use
> > for
> > this feature.
> >
> > If nobody speaks up, I will pick up patches from Konstantin to support
> > increasing number of reserved inodes (he implemented it in resize2fs, I
> > will
> > move it to tune2fs by moving some resize2fs functionality to libext2fs).
> > That
> > will practically remove the current limitation of the number of reserved
> 
> inodes.
> >
> 
> 
> Any progress about this?  More reserved inodes are also needed  by project
> quota.
> BTW, i noticed if i extend s_first_ino, many e2fsprogs tests will fail
> because
> tests results reiled on previous confirmed system inodes, any idea about
> this?

Yes, I'm working on this on-and-off for some time. I already have separated
functionality to move blocks and to move inodes from resize2fs into
libext2fs. So the hardest part is hopefully done. But it needs testing and
I need to figure out whether some group accounting parts also don't need to
be moved into libext2fs as they may be needed in more places. So overall
it's about one or two days of work to finish this but I get preempted by
other stuff...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
