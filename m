From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Ext4: Update ext4 documentation
Date: Wed, 19 Jan 2011 15:27:57 -0700
Message-ID: <C9957B84-6B84-435F-83FF-8932ED36678A@dilger.ca>
References: <1295365843-29414-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:64380 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab1ASW17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jan 2011 17:27:59 -0500
In-Reply-To: <1295365843-29414-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-18, at 08:50, Lukas Czerner wrote:
> +Table of Ext4 specific ioctls
> +..............................................................................
> + Ioctl			      Description
> + EXT4_IOC_GETFLAGS	      Get additional attributes associated with files
> +			      in Ext4. The argument point to the integer.
> +			      Meaning of the particular bits are defined in
> +			      fs/ext4/ext4.

This is actually the same value as the FS_IOC_GETFLAGS ioctl.

> + EXT4_IOC_SETFLAGS	      Set additional attributes associated with files
> +			      in Ext4. The argument point to the integer.
> +			      Meaning of the particular bits are defined in
> +			      fs/ext4/ext4. If the file is a subject to quota,
> +			      setting inode flags is prohibited.

Likewise, this is the same value as FS_IOC_SETFLAGS.

> + EXT4_IOC_GETVERSION
> + EXT4_IOC_GETVERSION_OLD
> +			      Get the inode i_generation number stored for
> +			      each inode. This is particularly useful for
> +			      NFS in cases when one inode is unlinked and
> +			      then a new inode is created with the same inode
> +			      number. NFS daemon should know that it is not
> +			      the same inode, thus i_generation is needed.
> +			      All that said, it is normally changed only when
> +			      new inode is created.

Similarly, the FS_IOC_GETVERSION matches EXT4_IOC_GETVERSION_OLD.  Sadly, the move of this ioctl number to FS_IOC_GETVERSION used the old 'v' ioctl number that conflicts with a number of ioctls instead of the new 'f' ioctl number...

Cheers, Andreas





