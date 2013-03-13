From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 3/5] ext4: fix wrong m_len value after unwritten
 extent conversion
Date: Tue, 12 Mar 2013 21:57:41 -0400
Message-ID: <20130313015741.GA16919@thunk.org>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <1362579435-6333-4-git-send-email-wenqing.lz@taobao.com>
 <20130311010718.GC10090@thunk.org>
 <20130311054707.GA3867@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52993 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932439Ab3CMB5s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 21:57:48 -0400
Content-Disposition: inline
In-Reply-To: <20130311054707.GA3867@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 11, 2013 at 01:47:07PM +0800, Zheng Liu wrote:
> On Sun, Mar 10, 2013 at 09:07:18PM -0400, Theodore Ts'o wrote:
> > On Wed, Mar 06, 2013 at 10:17:13PM +0800, Zheng Liu wrote:
> > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > 
> > > We always assume that the return value of ext4_ext_map_blocks is equal
> > > to map->m_len
> > 
> > Note that in general, this is _never_ safe to assume.  There are a
> > number of times when the number of blocks mapped is less than what the
> > caller originally requested, both when allocating blocks (and there
> > isn't the requestd number of contiguous blocks available), and when
> > EXT4_GET_BLOCKS_CREATE is not set.
> 
> Yes, When EXT4_GET_BLOCKS_CREATE is not set, it could be 0 because there
> is no block mapping, and we don't create it.  Meanwhile when we want to
> allocate some blocks, it could be less than the number of block we
> requested.  But IMHO at least when we try to allocate some blocks, m_len
> should be changed according to the number of allocated blocks in order
> to make them equal if the number of allocated blocks is less than the
> number of blocks we requested.  Namely, when the return value (retval)
> is greater than 0, this assumption will be right.  Because we will use
> m_len value after map_blocks function returns.  We need to let upper
> level know it, such as write_begin, DIO, etc...  Am I miss something?

No, you didn't miss anything.  I just wanted to say point out that any
assumption that ext4_ext_map_blocks() is equial to map->m_len was
always wrong, and not something that recently changed.  I updated the
commit description lightly to make this clear.

Regards,

						- Ted
