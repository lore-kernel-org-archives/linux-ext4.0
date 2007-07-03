From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Date: Tue, 03 Jul 2007 12:19:32 +0530
Message-ID: <4689F17C.7050304@linux.vnet.ibm.com>
References: <1183275465.4010.130.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:35026 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXGCGux (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2007 02:50:53 -0400
In-Reply-To: <1183275465.4010.130.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Mingming Cao wrote:
> 
> Index: linux-2.6.22-rc4/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-13 17:19:11.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-13 17:24:45.000000000 -0700
> @@ -2846,8 +2846,8 @@ out:
>  		i_size_write(inode, off+len-towrite);
>  		EXT4_I(inode)->i_disksize = inode->i_size;
>  	}
> -	inode->i_version++;
>  	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_version = 1;
>  	ext4_mark_inode_dirty(handle, inode);
>  	mutex_unlock(&inode->i_mutex);
>  	return len - towrite;


Is this correct ? . Why do we set the qutoa file inodes version to 1  during write ?


- aneesh
