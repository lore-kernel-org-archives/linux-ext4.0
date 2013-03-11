From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 3/5] ext4: fix wrong m_len value after unwritten
 extent conversion
Date: Sun, 10 Mar 2013 21:07:18 -0400
Message-ID: <20130311010718.GC10090@thunk.org>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <1362579435-6333-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52338 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3CKBHX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Mar 2013 21:07:23 -0400
Content-Disposition: inline
In-Reply-To: <1362579435-6333-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 06, 2013 at 10:17:13PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> We always assume that the return value of ext4_ext_map_blocks is equal
> to map->m_len

Note that in general, this is _never_ safe to assume.  There are a
number of times when the number of blocks mapped is less than what the
caller originally requested, both when allocating blocks (and there
isn't the requestd number of contiguous blocks available), and when
EXT4_GET_BLOCKS_CREATE is not set.

					- Ted
