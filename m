From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: don't re-try to remove the entry from es tree when
 we encounter a ENOMEM in ext4_ext_truncate
Date: Tue, 30 Jul 2013 07:50:34 +0800
Message-ID: <20130729235034.GC3648@gmail.com>
References: <1374753397-26432-1-git-send-email-wenqing.lz@taobao.com>
 <20130729154239.GD11816@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47284 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3G2Xuk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 19:50:40 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so1538075pbb.5
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 16:50:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130729154239.GD11816@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 11:42:39AM -0400, Theodore Ts'o wrote:
> On Thu, Jul 25, 2013 at 07:56:37PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > ext4_es_remove_extent returns ENOMEM only if we need to split an entry
> > and insert a part into es tree.  After applied this commit (e15f742c),
> > we have retried to do this.  So we don't need to do this again in
> > ext4_ext_truncate().
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> 
> Actually, we still need to do this, since the retry loop in
> __es_remove_extent() tries to shrink the extent status tree for the
> inode in question, and only retries if we were able to free up some
> memory.  (We only do it for the inode we're working on, since we have
> it locked already.)  So __es_remove_extent() can still return ENOMEM,
> and so callers of ext4_es_insert_extent() and ext4_es_remove_extent()
> still need to check for ENOMEM and try to do something sane if
> possible.
> 
> The problem with truncate is that the VFS assumes truncate() will
> always succeed (the method function is returns a void, so there isn't
> even a way to propagate an error code back p to the VFS), so we really
> do need to do a retry in ext4's truncate code.
> 
> For other code paths, like for example fallocate(), it's completely
> fair game for it to return ENOMEM, although we need to make sure that
> we've gotten the error handling correct.  
> 
> For the writeback paths, where the application which performed the
> write may have exited already and we have dirty pages in the page
> cache, retrying an ENOMEM after calling congestion_wait() is something
> that *does* make sense.
> 
> This is why I didn't add an unconditional retry loop to the low-level
> extent_status tree code, since where we can return ENOMEM, it's better
> to do that, since that way applications can start failing fast in OOM
> conditions.  Whether or not we want do that is going to depend on the
> higher level code paths.

Got it, thanks for your explanation.

                                                - Zheng
