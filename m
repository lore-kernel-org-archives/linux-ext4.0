From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 v2] ext4: check free inode count before allocaing an
 inode
Date: Sun, 23 Sep 2012 23:17:24 -0400
Message-ID: <20120924031724.GB2129@thunk.org>
References: <1346937415-2866-1-git-send-email-xiaoqiangnk@gmail.com>
 <1346937415-2866-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52097 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab2IYScf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2012 14:32:35 -0400
Content-Disposition: inline
In-Reply-To: <1346937415-2866-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 06, 2012 at 09:16:55PM +0800, Yongqiang Yang wrote:
> Recnetly, I ecountered some corrupted filesystems in which some
> groups' free inode counts were 65535, it seemed that free inode
> count was overflow.  This patch teaches ext4 to check free inode
> count before allocaing an inode.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

						- Ted
