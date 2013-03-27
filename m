From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: take i_mutex in ext4_symlink to eliminate a
 warning from ext4_truncate
Date: Wed, 27 Mar 2013 23:07:35 +0800
Message-ID: <20130327150735.GA4395@gmail.com>
References: <1364390347-4360-1-git-send-email-wenqing.lz@taobao.com>
 <20130327134110.GI5861@thunk.org>
 <20130327140250.GA4316@gmail.com>
 <20130327135155.GK5861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44972 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3C0Ovz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Mar 2013 10:51:55 -0400
Received: by mail-pd0-f179.google.com with SMTP id x11so673741pdj.10
        for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 07:51:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130327135155.GK5861@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 09:51:55AM -0400, Theodore Ts'o wrote:
> Ah, now I see.  Thanks for sending the stack trace.  On the failure
> path, we're calling the inline function ext4_truncate_filaed_write()
> and this is calling ext4_truncate().
> 
> But I'm now wondering if we need to take the i_data_sem mutex in
> ext4_truncate_failed_write().
> 
> Otherwise, couldn't we end up with problems where a failed write calls
> ext4_truncate() without i_data_sem(), and that races with something
> else --- say, a punch or truncate call to that same inode?

I don't think we need to take i_mutex lock honestly.  In ext4_symlink
when we call __page_symlink() the new inode doesn't access yet.  So no
one can do a punching hole or truncation to this inode.  But I also
think we need to add WARN_ON in ext4_truncate because i_mutex lock is
used to serialize truncate/punch hole and buffered io.

Regards,
                                                - Zheng
