From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 3/5] ext4: fix wrong m_len value after unwritten
 extent conversion
Date: Wed, 13 Mar 2013 16:53:02 +0800
Message-ID: <20130313085302.GB11553@gmail.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <1362579435-6333-4-git-send-email-wenqing.lz@taobao.com>
 <20130311010718.GC10090@thunk.org>
 <20130311054707.GA3867@gmail.com>
 <20130313015741.GA16919@thunk.org>
 <20130313021420.GB16919@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61042 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3CMIhm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Mar 2013 04:37:42 -0400
Received: by mail-pb0-f52.google.com with SMTP id ma3so793914pbc.11
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 01:37:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130313021420.GB16919@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 12, 2013 at 10:14:20PM -0400, Theodore Ts'o wrote:
> Oh, now I see my confusion.  You're talking about retval being
> different from the output of map->m_len.  I was talking about retval
> being often different from the *input* value of map->m_len.

Ah, sorry for my bad expression. :-(

> 
> I agree that the output of ext4_ext_map_blocks() and
> ext4_ind_map_blocks() should be the same as map->m_len, and having a
> BUG_ON there would make sense.  But we can save those changes for
> after -rc3 as a cleanup....

Actually, in my tree I use a WARN_ON() because I don't want to throw a
kernel panic for user.  I think it is too unfriendly.  I will send a
patch to change it after -rc3.

Regards,
                                                - Zheng
