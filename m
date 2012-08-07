From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/36 v4] libext2fs: add EXT4_INLINE_DATA_FL flag for
 inode
Date: Tue, 7 Aug 2012 14:27:28 -0400
Message-ID: <20120807182728.GA29928@thunk.org>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
 <1343735309-30579-6-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43463 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab2HGS1a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Aug 2012 14:27:30 -0400
Content-Disposition: inline
In-Reply-To: <1343735309-30579-6-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 07:47:58PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Add EXT4_INLINE_DATA_FL flag.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

I've accepted this patch into the next branch, along with a related
change to libe2p/pf.c so that lsattr will display the inline data
flag.

					- Ted
