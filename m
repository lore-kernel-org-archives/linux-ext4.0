From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext3: call blkdev_issue_flush on fsync
Date: Fri, 26 Mar 2010 13:24:58 -0600
Message-ID: <37C3E508-AE2F-4FA5-9536-7F59B26CBBAC@sun.com>
References: <1269622243-26689-1-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36966 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0CZTZG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 15:25:06 -0400
In-reply-to: <1269622243-26689-1-git-send-email-surbhi.palande@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-26, at 10:50, Surbhi Palande wrote:
> To ensure that bits are truly on-disk after an fsync,
> we should call blkdev_issue_flush if barriers are supported.
>
> @@ -87,5 +89,7 @@ int ext3_sync_file(struct file * file, struct  
> dentry *dentry, int datasync)
> 		ret = sync_inode(inode, &wbc);
> 	}
> out:
> +	if (journal && (journal->j_flags & JFS_BARRIER))
> +		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
> 	return ret;


I don't think we need yet ANOTHER barrier here.  If the filesystem is  
mounted in data={journaled,ordered} mode it will have flushed the data  
to disk as part of the journal commit.  If there is an external  
journal, there were patches posted to have it flush the data on the  
filesystem device at transaction commit time.

Since fsync on any inode always implies sync of the journal, the only  
time that this would be needed is if we are running in no-journal  
mode, or possibly in data=writeback mode.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

