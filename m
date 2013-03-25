From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: add WARN_ON to check the length of allocated blocks
Date: Mon, 25 Mar 2013 10:50:23 +0800
Message-ID: <20130325025023.GA14550@gmail.com>
References: <1364118173-12354-1-git-send-email-wenqing.lz@taobao.com>
 <20130324182318.GA26792@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f51.google.com ([209.85.210.51]:62741 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3CYCep (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Mar 2013 22:34:45 -0400
Received: by mail-da0-f51.google.com with SMTP id g27so2907532dan.10
        for <linux-ext4@vger.kernel.org>; Sun, 24 Mar 2013 19:34:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130324182318.GA26792@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 24, 2013 at 02:23:18PM -0400, Theodore Ts'o wrote:
> On Sun, Mar 24, 2013 at 05:42:53PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > In this commit (921f266b) a sanity check is added in map_blocks to make
> > sure 'retval == map->m_len'.  But we need to define a macro to enable
> > it.  This commit uses a WARN_ON to do the same thing.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> You and Dmitry were the ones who using originally these these checks
> to fix the bugs here;

Yes, I use this check to fix bug.

> if we think the code is clean enough that we
> don't need the debugging information with the inode number, length,
> etc., then sure, we could use the unconditionally defined WARN_ON().
> 
> If we wanted to be really paranoid and give ourselves the maximal
> amount of debugging information, we could of course do something like
> this:
> 
> 		if (retval != map->m_len) {
> 			ext4_warning(inode->i_sb, "ES len assertation failed for inode: %lu retval %d != map->m_len %d\n", inode->i_ino, retval,
> 			       map->m_len);
> 			 WARN_ON(1);
> 		}

I think this is better.

> 
> This way, we get the stack dump, the file system device, and all of
> the debugging information.  The tradeoff is we're bloating the code
> size a bit.
> 
> The question is really how confident are we that we've found all of
> the potential bugs here.  If we think that there's a chance we might
> trip this check in the future, sometimes it's good to print as much
> information as possible, especially if it's hard to create a
> reproduction on demand.
> 
> What do you think?

In my sand box, after fixed the bug, I never see this warning again.
But I do believe we'd better leave it here to give us an opportunity to
fix some potential bugs.

Thanks,
                                                - Zheng
