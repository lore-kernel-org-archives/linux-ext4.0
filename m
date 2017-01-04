From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Wed, 4 Jan 2017 18:35:50 -0500
Message-ID: <20170104233550.oy7nzc3rxppmejbk@thunk.org>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
 <20170104215424.GB14021@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, Valdis.Kletnieks@vt.edu,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41016 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969710AbdADXf7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 4 Jan 2017 18:35:59 -0500
Content-Disposition: inline
In-Reply-To: <20170104215424.GB14021@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 04, 2017 at 01:54:24PM -0800, Darrick J. Wong wrote:
> 
> if (inode->i_nlink == 0) {
> 	ext4_warning_inode(inode, "nlink is already 0");
> 	return;
> }

We can't do that because the place where Zhangyi is proposing to
change is in fs/inode.c:drop_nlink(), so we can't add a call to
ext4_error() or ext4_warning().

So how exactly how did we get into this state?  When we read the inode
into memory, if i_nlink is zero, we declare the file system as
corrupted immediately.

So I assume this is happening the on-disk i_links_count (which is read
into inode->i_nlink) was too low.  So I think the way we should be
handling this is in unlink and rename, before we let i_nlink drop to
zero, we need to check to see if there are other dcache entries
pointing at the inode.  If so, we need to call ext4_error(), and in
the errors=continue case, return EFSCORRUPTED (aka EUCLEAN).

    		    	  	 	      - Ted
