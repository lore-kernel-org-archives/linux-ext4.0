From: Andreas Dilger <adilger@sun.com>
Subject: Re: Patch queue update
Date: Thu, 24 Jan 2008 09:26:56 -0700
Message-ID: <20080124162656.GJ18433@webber.adilger.int>
References: <20080124145051.GC14348@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20637 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbYAXQ1e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 11:27:34 -0500
Received: from pd4mr4so.prod.shaw.ca
 (pd4mr4so-qfe3.prod.shaw.ca [10.0.141.215]) by l-daemon
 (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JV5005O8PP0ZA40@l-daemon> for linux-ext4@vger.kernel.org; Thu,
 24 Jan 2008 09:27:00 -0700 (MST)
Received: from pn2ml10so.prod.shaw.ca ([10.0.121.80])
 by pd4mr4so.prod.shaw.ca (Sun Java System Messaging Server 6.2-7.05 (built Sep
 5 2006)) with ESMTP id <0JV500MFBPOX4B20@pd4mr4so.prod.shaw.ca> for
 linux-ext4@vger.kernel.org; Thu, 24 Jan 2008 09:26:59 -0700 (MST)
Received: from webber.adilger.int ([68.147.251.212])
 by l-daemon (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with SMTP id <0JV5002P6POWCA40@l-daemon> for linux-ext4@vger.kernel.org; Thu,
 24 Jan 2008 09:26:57 -0700 (MST)
In-reply-to: <20080124145051.GC14348@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 24, 2008  20:20 +0530, Aneesh Kumar K.V wrote:
> @@ -89,6 +89,8 @@ When mounting an ext4 filesystem, the following option are accepted:
>  extents			ext4 will use extents to address file data.  The
>  			file system will no longer be mountable by ext3.
>  
> +noextents		ext4 will not use extents for new files created.
> +

s/new files created/newly created files/

>  journal_checksum	Enable checksumming of the journal transactions.
>  			This will allow the recovery code in e2fsck and the
>  			kernel to detect corruption in the kernel.  It is a
> @@ -206,6 +208,10 @@ nobh			(a) cache disk block mapping information
>  			"nobh" option tries to avoid associating buffer
>  			heads (supported only for "writeback" mode).
>  
> +mballoc		(*)	Use the mutliblock allocator for block allocation
> +nomballoc		disabled multiblock allocator for block allocation.
> +stripe=n		filesystem blocks per stripe for a RAID configuration.

Please provide a more verbose description of what a "stripe" is, since the
RAID terminology is sadly vague.  Something like "number of filesystem blocks 
that mballoc will try to use for allocation size and alignment.  For RAID5/6
systems this should be the number of data disks * number of filesystem blocks
per data disk."


> @@ -3948,9 +3942,8 @@ repeat:
>  			spin_unlock(&pa->pa_lock);
>  			spin_unlock(&ei->i_prealloc_lock);
>  			printk(KERN_ERR "uh-oh! used pa while discarding\n");
> -			dump_stack();
> -			current->state = TASK_UNINTERRUPTIBLE;
> -			schedule_timeout(HZ);
> +			WARN_ON(1);

This printk and dump stack can just go away, we have removed it from our
mballoc patch as well because it was only needed for determining how often
this condition is hit and is otherwise useless.

> @@ -577,14 +529,12 @@ err_out:
>  	 *
>  	 * FIXME!! we may be touching bitmaps in different block groups.
>  	 */
> -
>  	if (ext4_journal_extend(handle,
>  			4 + 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb)) != 0) {
>  
>  		ext4_journal_restart(handle,
>  				4 + 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
>  	}
> -

There don't actually need to be braces here either.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
