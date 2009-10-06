From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH][RFC] vfs: add message print mechanism for the mount/umount
 into the VFS layer
Date: Tue, 06 Oct 2009 10:03:06 -0700
Message-ID: <4ACB784A.3090604@oracle.com>
References: <20091006125142.b766ad98.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: viro@zeniv.linux.org.uk, tytso@mit.edu,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:33747 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZJFREB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Oct 2009 13:04:01 -0400
In-Reply-To: <20091006125142.b766ad98.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Toshiyuki Okajima wrote:
>   	up_write(&namespace_sem);
> +	/* 
> +	 * message output at mount for log observers
> +	 */
> +	if (newmnt->mnt_flags & MNT_VERBOSE_MSG) {
> +		printk(KERN_INFO "Device %s mounted file system type %s read-%s\n",
> +					sb->s_id, sb->s_type->name,
> +					sb->s_flags & MS_RDONLY ? "only" : "write");
> +		/* fs specific messages for mount */
> +		if (sb->s_op != NULL && sb->s_op->mount_msg != NULL)
> +			sb->s_op->mount_msg(sb);
> +	}
>  	return 0;

How about allowing the fs to over-ride the default message? Reduces the 
clutter.
Same on the umount.


+	if (newmnt->mnt_flags & MNT_VERBOSE_MSG) {
+		if (sb->s_op != NULL && sb->s_op->mount_msg != NULL)
+			sb->s_op->mount_msg(sb);
+		else
+			printk(KERN_INFO "Device %s mounted file system type %s read-%s\n",
+				sb->s_id, sb->s_type->name,
+				sb->s_flags & MS_RDONLY ? "only" : "write");
+	}



