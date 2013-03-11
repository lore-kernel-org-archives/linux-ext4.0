From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 2/5] ext4: add self-testing infrastructure to do a
 sanity check
Date: Sun, 10 Mar 2013 21:01:47 -0400
Message-ID: <20130311010147.GB10090@thunk.org>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <1362579435-6333-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52333 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab3CKBBx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Mar 2013 21:01:53 -0400
Content-Disposition: inline
In-Reply-To: <1362579435-6333-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 06, 2013 at 10:17:12PM +0800, Zheng Liu wrote:
> +				printk("ES insert assertation failed for inode: %lu "
> +				       "we can find an extent at block "

FYI, I changed all of the printk() messages to pr_warn().

  	      	     	      	       - Ted
