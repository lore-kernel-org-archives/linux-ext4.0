From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/7 v2] ext4: add physical block and status member into
 extent status tree
Date: Wed, 16 Jan 2013 23:42:13 -0500
Message-ID: <20130117044213.GA19734@thunk.org>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43907 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464Ab3AQEmU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jan 2013 23:42:20 -0500
Content-Disposition: inline
In-Reply-To: <1357901627-3068-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2013 at 06:53:43PM +0800, Zheng Liu wrote:
>  struct extent_status {
>  	struct rb_node rb_node;
>  	ext4_lblk_t es_lblk;	/* first logical block extent covers */
>  	ext4_lblk_t es_len;	/* length of extent in block */
> +	ext4_fsblk_t es_pblk;	/* first physical block */
> +	int es_status;		/* record the status of extent */
>  };

Given that we only support 48 bits for the physical block number, and
we only need two bits for es_status, one thing we could do to save
memory is to stash the es_status bits in the top two bits of es_pblk.

       	     	       		      	     - Ted
