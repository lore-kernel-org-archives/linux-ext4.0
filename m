From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/7] ext4: fsync should wait for DIO writers
Date: Thu, 13 Sep 2012 15:01:25 +0400
Message-ID: <874nn25gqi.fsf@openvz.org>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org> <1347211634-11509-5-git-send-email-dmonakhov@openvz.org> <20120913104621.GC11330@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41219 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406Ab2IMLB2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 07:01:28 -0400
Received: by lbbgj3 with SMTP id gj3so1852333lbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 04:01:26 -0700 (PDT)
In-Reply-To: <20120913104621.GC11330@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 13 Sep 2012 18:46:21 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Sun, Sep 09, 2012 at 09:27:11PM +0400, Dmitry Monakhov wrote:
> > fsync and punch_hole are the places where we have to wait for all
> > existing writers (writeback, aio, dio), but currently we simply
> > flush pended end_io request which is not sufficient.
> > Even more i_mutex is not holded while punch_hole which obviously
> > result in dangerous data corruption due to write-after-free.
> 
> Hi Dmitry,
> 
> Lukas already has a patch to take i_mutex locking before punching a
> hole.  Just a reminding. :-)
Yes, i've found it after patch was submitted, but this bug make me
nervous a bit because we have broken punch_hole implementation
long time ago, it allow to destroy data easily, user are able to
call it if has WR permission for a file.
So if you ask be i'll vote for hide it under CAP_SYS_RESOURCE until
proper implementation appears.
Same it true for EXT4_IO_MOVE_EXT because it allow to kernel panic
since v2.6.30-6558-g748de67, so all primary distros (RH6,Deb6) are
affected :( 

> 
> https://patchwork.kernel.org/patch/1247271/
> 
> Regards,
> Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
