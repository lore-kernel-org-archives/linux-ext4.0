From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't calc checksum in update_backups in online
 resize.
Date: Thu, 20 Sep 2012 11:54:49 -0400
Message-ID: <20120920155449.GA14430@thunk.org>
References: <1348122823-4930-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51744 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab2ITPy7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2012 11:54:59 -0400
Content-Disposition: inline
In-Reply-To: <1348122823-4930-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 20, 2012 at 02:33:43PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> update_backups is used to backup all the metadata blocks, so we should
> not take it for granted that 'data' is pointed to a super block and use
> ext4_superblock_csum_set to calculate the checksum there. In case
> the data is a group descriptor block, it will corrupt the last group
> descriptor. And e2fsck will complain it.
> 
> As all the metadata checksum should already be OK when we do the backup,
> remove the wrong ext4_superblock_csum_set and it should be just fine.
> 
> Reported-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Applied.  Thanks for finding the fix!!

					- Ted
