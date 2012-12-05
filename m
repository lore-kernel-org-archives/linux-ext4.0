From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix inline data build warning found by kernel
 build testing.
Date: Wed, 5 Dec 2012 01:23:36 -0500
Message-ID: <20121205062336.GA11198@thunk.org>
References: <1354523302-6790-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36869 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab2LEGXl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 01:23:41 -0500
Content-Disposition: inline
In-Reply-To: <1354523302-6790-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 03, 2012 at 04:28:22PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> This patch just tries to silence all the build warning found
> by Fengguang's kernel build testing. It has following fixes:
> 1. change all walk_page_buffers to ext4_walk_page_buffers to avoid
>    a conflict with ocfs2.
> 2. make ext4_get_inline_xattr_pos static.
> 3. make ext4_xattr_ibody_set static.
> 4. change two or more data types in declaration specifiers for
>    ext4_convert_inline_data.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Theodore Tso <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

I've folded these changes into their respective inline data patches.

Cheers,

						- Ted
