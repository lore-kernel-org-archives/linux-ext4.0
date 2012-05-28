From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: cleanup in ext4_discard_allocated_blocks()
Date: Mon, 28 May 2012 17:54:34 -0400
Message-ID: <20120528215434.GB5610@thunk.org>
References: <1330271677-10200-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46070 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab2E1Vyh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 17:54:37 -0400
Content-Disposition: inline
In-Reply-To: <1330271677-10200-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 26, 2012 at 11:54:37PM +0800, Zheng Liu wrote:
> remove 'len' variable in ext4_discard_allocated_blocks() because it is useless.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
