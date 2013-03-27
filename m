From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: take i_mutex in ext4_symlink to eliminate a
 warning from ext4_truncate
Date: Wed, 27 Mar 2013 23:19:22 +0800
Message-ID: <20130327151922.GA4487@gmail.com>
References: <1364390347-4360-1-git-send-email-wenqing.lz@taobao.com>
 <20130327134110.GI5861@thunk.org>
 <20130327140250.GA4316@gmail.com>
 <20130327135155.GK5861@thunk.org>
 <20130327150735.GA4395@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50959 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3C0PDj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Mar 2013 11:03:39 -0400
Received: by mail-pb0-f45.google.com with SMTP id ro8so5301731pbb.32
        for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 08:03:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130327150735.GA4395@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 11:07:35PM +0800, Zheng Liu wrote:
> On Wed, Mar 27, 2013 at 09:51:55AM -0400, Theodore Ts'o wrote:
> > Ah, now I see.  Thanks for sending the stack trace.  On the failure
> > path, we're calling the inline function ext4_truncate_filaed_write()
> > and this is calling ext4_truncate().
> > 
> > But I'm now wondering if we need to take the i_data_sem mutex in
                                                 ^^^
Sigh, I misread i_data_sem and i_mutex.  Really sorry about that. :-/

> > ext4_truncate_failed_write().
> > 
> > Otherwise, couldn't we end up with problems where a failed write calls
> > ext4_truncate() without i_data_sem(), and that races with something
> > else --- say, a punch or truncate call to that same inode?

Let me think about it.  I need to take a close look at it.

Regards,
                                                - Zheng
