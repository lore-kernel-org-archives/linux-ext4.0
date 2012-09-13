From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 4/7] ext4: fsync should wait for DIO writers
Date: Thu, 13 Sep 2012 20:36:32 +0800
Message-ID: <20120913123632.GA13319@gmail.com>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-5-git-send-email-dmonakhov@openvz.org>
 <20120913104621.GC11330@gmail.com>
 <874nn25gqi.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55013 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab2IMM0J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 08:26:09 -0400
Received: by pbbrr13 with SMTP id rr13so3869335pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 05:26:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <874nn25gqi.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 13, 2012 at 03:01:25PM +0400, Dmitry Monakhov wrote:
> On Thu, 13 Sep 2012 18:46:21 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > On Sun, Sep 09, 2012 at 09:27:11PM +0400, Dmitry Monakhov wrote:
> > > fsync and punch_hole are the places where we have to wait for all
> > > existing writers (writeback, aio, dio), but currently we simply
> > > flush pended end_io request which is not sufficient.
> > > Even more i_mutex is not holded while punch_hole which obviously
> > > result in dangerous data corruption due to write-after-free.
> > 
> > Hi Dmitry,
> > 
> > Lukas already has a patch to take i_mutex locking before punching a
> > hole.  Just a reminding. :-)
> Yes, i've found it after patch was submitted, but this bug make me
> nervous a bit because we have broken punch_hole implementation
> long time ago, it allow to destroy data easily, user are able to
> call it if has WR permission for a file.
> So if you ask be i'll vote for hide it under CAP_SYS_RESOURCE until
> proper implementation appears.
> Same it true for EXT4_IO_MOVE_EXT because it allow to kernel panic
> since v2.6.30-6558-g748de67, so all primary distros (RH6,Deb6) are
> affected :( 

IMHO, it will be better when this patch is applied, and I prefer to fix
the problem rather than hidding it using CAP_SYS_RESOURCE. ;-)

Regards,
Zheng
