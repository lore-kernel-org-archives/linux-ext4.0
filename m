From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 4/7] ext4: fsync should wait for DIO writers
Date: Wed, 12 Sep 2012 13:40:01 +0800
Message-ID: <20120912054001.GA3149@gmail.com>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-5-git-send-email-dmonakhov@openvz.org>
 <20120910095135.GF22903@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, wenqing.lz@taobao.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36876 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2ILF3m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2012 01:29:42 -0400
Received: by dady13 with SMTP id y13so742996dad.19
        for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2012 22:29:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120910095135.GF22903@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 10, 2012 at 11:51:35AM +0200, Jan Kara wrote:
> On Sun 09-09-12 21:27:11, Dmitry Monakhov wrote:
> > fsync and punch_hole are the places where we have to wait for all
> > existing writers (writeback, aio, dio), but currently we simply
> > flush pended end_io request which is not sufficient.
>   Why not? I guess you mean the fact that there can be DIO in flight for
> which end_io() was not called so it is not queued in the queue? But that is
> OK - we have not yet called aio_complete() for that IO so for userspace the
> write has not happened yet. Thus there's no need to flush it to disk -
> fsync() does not say anything about writes in progress while fsync is
> called.
> 
> > Even more i_mutex is not holded while punch_hole which obviously
> > result in dangerous data corruption due to write-after-free.
>   Yes, that's a bug. I also noticed that but didn't get to fixing it (I'm
> actually working on a more long term fix using range locking but that's
> more of a research project so having somehow fixed at least the most
> blatant locking problems is good).

Hi Jan,

Could you please share more detailed information about range locking
with me?  Actually, the goal of extent status tree is to implement a
range locking in ext4 [1], and I am working on it.  So I think that
you have some good ideas to share with me. :-)

1. http://www.spinics.net/lists/linux-ext4/msg32661.html

If you have some problems, please let me know.  Thanks!

Regards,
Zheng
