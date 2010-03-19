From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH, RFC 3/3] ext4: Add option for squelching ext4 errors to prevent dmesg from filling up
Date: Fri, 19 Mar 2010 16:56:13 -0600
Message-ID: <7C462C5D-0B00-45A8-95A4-AEF74EBC534E@oracle.com>
References: <1268959842-4697-1-git-send-email-tytso@mit.edu> <1268959842-4697-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:33283 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0CSW5s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Mar 2010 18:57:48 -0400
In-Reply-To: <1268959842-4697-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-18, at 18:50, Theodore Ts'o wrote:
> @@ -363,12 +363,19 @@ void ext4_error_inode(const char *function,  
> struct inode *inode,
> {
> 	va_list args;
>
> +	if (!ext4_test_inode_state(inode, EXT4_STATE_ERR_SQUELCHED) ||
> +	    !(EXT4_SB(inode->i_sb)->s_mount_flags & EXT4_MF_FS_SQUELCH)) {
> +		va_start(args, fmt);
> +		printk(KERN_CRIT "EXT4-fs error (device %s): %s: "
> +		       "inode #%lu: (comm %s) ",
> +		       inode->i_sb->s_id, function, inode->i_ino,
> +		       current->comm);
> +		vprintk(fmt, args);
> +		printk("\n");
> +		va_end(args);

Shouldn't this really be using ext4_msg()?

Cheers, Andreas
--
Andreas Dilger
Principal Engineer, Lustre Group
Oracle Corporation Canada Inc.

