From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] e2fslibs: fix llseek on i386
Date: Fri, 25 Jan 2013 10:48:08 +0800
Message-ID: <20130125024808.GA11093@gmail.com>
References: <1359044517-18243-1-git-send-email-psusi@ubuntu.com>
 <20130124195158.GC9477@thunk.org>
 <5101980D.30904@ubuntu.com>
 <20130124203230.GA20776@thunk.org>
 <20130125022514.GA10883@gmail.com>
 <20130125021604.GB28908@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:40920 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab3AYCeN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 21:34:13 -0500
Received: by mail-pb0-f44.google.com with SMTP id uo1so5819644pbc.17
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2013 18:34:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130125021604.GB28908@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 24, 2013 at 09:16:05PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 25, 2013 at 10:25:14AM +0800, Zheng Liu wrote:
> > 
> > This patch makes me consider my patches that dump a sparse file in
> > debugfs.  In my patch [1] llseek64(2) is called to seek to the next
> > data in target file.  So I believe ext2fs_llseek() is a better choice.
> > I am happy to send a newer patch to fix it.  What do you think?
> > 
> > 1. http://www.spinics.net/lists/linux-ext4/msg36134.html
> 
> You're right, we should use ext2fs_llseek() for better portability.
> Thanks,

Yep, the next version will be sent out soon.

Regards,
                                                - Zheng
