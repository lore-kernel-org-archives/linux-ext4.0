From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: use sync_inode_metadata() when sync inode
 metadata
Date: Sun, 2 Dec 2012 23:51:58 -0500
Message-ID: <20121203045158.GA6378@thunk.org>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
 <1354257706-6582-2-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36418 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab2LCEwF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Dec 2012 23:52:05 -0500
Content-Disposition: inline
In-Reply-To: <1354257706-6582-2-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 30, 2012 at 02:41:44PM +0800, Guo Chao wrote:
> We have a dedicated interface to sync inode metadata.
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>

Thanks, applied.

						- Ted
