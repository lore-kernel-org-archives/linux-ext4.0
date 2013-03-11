From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 3/5] ext4: fix wrong m_len value after unwritten
 extent conversion
Date: Mon, 11 Mar 2013 13:47:07 +0800
Message-ID: <20130311054707.GA3867@gmail.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <1362579435-6333-4-git-send-email-wenqing.lz@taobao.com>
 <20130311010718.GC10090@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:59697 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3CKFbv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Mar 2013 01:31:51 -0400
Received: by mail-pb0-f45.google.com with SMTP id ro8so3312079pbb.32
        for <linux-ext4@vger.kernel.org>; Sun, 10 Mar 2013 22:31:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130311010718.GC10090@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 10, 2013 at 09:07:18PM -0400, Theodore Ts'o wrote:
> On Wed, Mar 06, 2013 at 10:17:13PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > We always assume that the return value of ext4_ext_map_blocks is equal
> > to map->m_len
> 
> Note that in general, this is _never_ safe to assume.  There are a
> number of times when the number of blocks mapped is less than what the
> caller originally requested, both when allocating blocks (and there
> isn't the requestd number of contiguous blocks available), and when
> EXT4_GET_BLOCKS_CREATE is not set.

Yes, When EXT4_GET_BLOCKS_CREATE is not set, it could be 0 because there
is no block mapping, and we don't create it.  Meanwhile when we want to
allocate some blocks, it could be less than the number of block we
requested.  But IMHO at least when we try to allocate some blocks, m_len
should be changed according to the number of allocated blocks in order
to make them equal if the number of allocated blocks is less than the
number of blocks we requested.  Namely, when the return value (retval)
is greater than 0, this assumption will be right.  Because we will use
m_len value after map_blocks function returns.  We need to let upper
level know it, such as write_begin, DIO, etc...  Am I miss something?

Regards,
                                                - Zheng
