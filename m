From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: remove redundant initialization in
 ext4_fill_super()
Date: Mon, 3 Dec 2012 00:01:21 -0500
Message-ID: <20121203050120.GC6378@thunk.org>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
 <1354257706-6582-4-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36425 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab2LCFBX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Dec 2012 00:01:23 -0500
Content-Disposition: inline
In-Reply-To: <1354257706-6582-4-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 30, 2012 at 02:41:46PM +0800, Guo Chao wrote:
> We use kzalloc() to allocate sbi, no need to zero its field.
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>

Thanks, applied.

					- Ted
