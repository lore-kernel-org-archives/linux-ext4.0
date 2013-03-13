From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG][dioread_nolock] blocked for more than 120s when we run
 xfstests #269
Date: Wed, 13 Mar 2013 18:52:33 +0800
Message-ID: <20130313105233.GB12012@gmail.com>
References: <20130307124054.GE2800@gmail.com>
 <20130307151140.GF6723@quack.suse.cz>
 <20130308135222.GA2768@gmail.com>
 <20130311163041.GL29799@quack.suse.cz>
 <20130313091511.GB29730@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63692 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3CMKhM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Mar 2013 06:37:12 -0400
Received: by mail-pb0-f45.google.com with SMTP id ro8so883748pbb.32
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 03:37:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130313091511.GB29730@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 13, 2013 at 10:15:11AM +0100, Jan Kara wrote:
[snip]
> > > I post the sysrq-w output here.  But IMHO it is not very useful.  So I
> > > also post the sysrq-t output.
> >   Heh, curious. Thanks for the data. So worker thinks there's nothing to do
> > but inode has elevated i_ioend_count... Maybe we leaked ioend somewhere.
> > I'll check the code when I have time.
>   Ah, I think I see what's going on.
> a) Code in ext4_ext_direct_IO() is racy wrt iocb->private handling (that
>    can get cleared concurrently from ext4_end_io_dio()).

Thanks for tracing this problem.  But I am still confused that iocb is
allocated on stack in do_sync_write(), and is allocated from slab in
ioctx_alloc().  You mean iocb in ext4_ext_direct_IO and ext4_end_io_dio
is the same one?  Then this iocb could be changed concurrently, and we
are blocked for more than 120s.  I must miss something.

> b) ext4_end_io_dio() forgets to free the io_end if size == 0 (but this
>    shouldn't really happen looking into fs/direct_io.c).

Yes, we will return directly from do_blockdev_direct_IO().

Regards,
                                                - Zheng
