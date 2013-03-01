From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 3/6] ext4: add self-testing infrastructure to do a sanity
 check
Date: Fri, 1 Mar 2013 11:23:26 +0800
Message-ID: <20130301032326.GA2765@gmail.com>
References: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
 <1362076004-10087-4-git-send-email-wenqing.lz@taobao.com>
 <8738wgxnso.fsf@openvz.org>
 <20130301022816.GA10692@gmail.com>
 <20130301022946.GB10692@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:37451 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3CADIb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 22:08:31 -0500
Received: by mail-da0-f49.google.com with SMTP id t11so1167538daj.36
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2013 19:08:31 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130301022946.GB10692@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 01, 2013 at 10:29:46AM +0800, Zheng Liu wrote:
[snip]
> > > > +	if (!ext4_es_is_written(es) && !ext4_es_is_unwritten(es))
> > > > +		return;
> > > > +
> > > > +	/*
> > > > +	 * We don't need to worry about the race condition because
> > > > +	 * caller takes i_data_sem locking.
> > >          Yes, and it is good place to assertion that we hold it.
> > 
> > A BUG_ON(mutex_is_locked(&inode->i_mutex) will be added.
>            ^^^^^^^
>            !mutex_is_locked(&inode->i_mutex)

Sigh, it should be !rwsem_is_locked(&EXT4_I(inode)->i_data_sem).  Sorry
for the noisy.

Regards,
                                                - Zheng
