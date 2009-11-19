From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] A request to reserve a "tree id" field on ext[34] inodes
Date: Wed, 18 Nov 2009 22:33:52 -0800
Message-ID: <BC3BF6F1-81BA-49A3-98BA-46A0F87D4A3D@sun.com>
References: <4B02AD8B.2030202@openvz.org>
 <0D1BE31B-34F9-40A1-8C7F-6A9FFF18DA8E@sun.com> <87lji4svcg.fsf@openvz.org>
 <87skcb20ge.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Pavel Emelyanov <xemul@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43971 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZKSGeF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2009 01:34:05 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nAJ6Y8Ig019887
	for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2009 22:34:08 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KTC00F00FIIBR00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 18 Nov 2009 22:34:08 -0800 (PST)
In-reply-to: <87skcb20ge.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-18, at 09:43, Dmitry Monakhov wrote:
> In other point of view it may be too expensive reserve the last 4
> bytes in EXT4_GOOD_OLD_INODE. At the same time store tree_id as xattr.
> result in space wasting.

Since the xattr is stored inside the inode, and you are accessing this  
from the kernel, it is using only 24 bytes of space used for your tree  
ID (20 bytes ext4_xattr_entry, including 3-byte name, 4 bytes data).   
It also has virtually no performance overhead because it is kept in  
the inode itself.

If you consider that the use of tree_id is not likely to be commonly  
used, then it would be "wasting" 4 bytes of space in everyone else's  
inodes to reserve this field in the inode (whether in the old inode or  
the larger ext4 inode).

> But in fact new inode has room for space
> reservation. We may store it like it is done for i_version_hi field
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -494,6 +494,7 @@ struct ext4_inode {
> 	__le32  i_crtime;       /* File Creation time */
> 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 |  
> epoch) */
> 	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
> +	__le32	i_disk_tree_id; /* directory tree quota id */
> };


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

