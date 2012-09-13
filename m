From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 4/7] ext4: fsync should wait for DIO writers
Date: Thu, 13 Sep 2012 18:46:21 +0800
Message-ID: <20120913104621.GC11330@gmail.com>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab2IMKf5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 06:35:57 -0400
Received: by pbbrr13 with SMTP id rr13so3741805pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 03:35:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1347211634-11509-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 09, 2012 at 09:27:11PM +0400, Dmitry Monakhov wrote:
> fsync and punch_hole are the places where we have to wait for all
> existing writers (writeback, aio, dio), but currently we simply
> flush pended end_io request which is not sufficient.
> Even more i_mutex is not holded while punch_hole which obviously
> result in dangerous data corruption due to write-after-free.

Hi Dmitry,

Lukas already has a patch to take i_mutex locking before punching a
hole.  Just a reminding. :-)

https://patchwork.kernel.org/patch/1247271/

Regards,
Zheng
