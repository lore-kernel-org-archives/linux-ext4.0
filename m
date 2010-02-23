From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: deprecate obsoleted mount options
Date: Mon, 22 Feb 2010 17:28:12 -0700
Message-ID: <57C5D8FD-F729-4C01-8485-6E76E7D2BDE6@sun.com>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
 <1266432013-9241-3-git-send-email-dmonakhov@openvz.org>
 <E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com>
 <20100218205218.GL5337@thunk.org> <87d401jnml.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56953 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab0BWQyI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2010 11:54:08 -0500
In-reply-to: <87d401jnml.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-19, at 07:39, Dmitry Monakhov wrote:
> This patch deprecate some obsoleted functions.
> It is not obvious what should we do in case of deprecated options on  
> mount.
> Just printk and continue or fail the mount, i've implemented the  
> last one.
> BTW: Do we need similar patch for e2fslib?

I think deprecating an option is not the same as removing it  
entirely.  Even though I don't think these options are in wide usage,  
I'd still prefer to add a printk() to the parsing code first, leave it  
for a year, then remove them entirely after that.

> #define EXT4_MOUNT_OLDALLOC		0x00002  /* Don't use the new Orlov  
> allocator */
> -#define EXT4_MOUNT_GRPID		0x00004	/* Create files with directory's  
> group */
> #define EXT4_MOUNT_DEBUG		0x00008	/* Some debugging messages */
> #define EXT4_MOUNT_ERRORS_CONT		0x00010	/* Continue on errors */
> #define EXT4_MOUNT_ERRORS_RO		0x00020	/* Remount fs ro on errors */
> #define EXT4_MOUNT_ERRORS_PANIC		0x00040	/* Panic on errors */
> -#define EXT4_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
> #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
> #define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
> #define EXT4_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */

I'd prefer to leave a comment like "/* was EXT4_MOUNT_GRPID -  
2010/02/21 */" so that it is clear that these values were previously  
in use, and should not be re-used until other options are exhausted...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

