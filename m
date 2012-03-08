From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Wed, 7 Mar 2012 16:23:48 -0800
Message-ID: <4F57FC14.5090207@panasas.com>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:52762 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2CHAYA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Mar 2012 19:24:00 -0500
In-Reply-To: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/07/2012 03:40 PM, Theodore Ts'o wrote:
> 
> We've recently discovered a workload at Google where the page
> stablization patches (specifically commit 0e499890c1f: ext4: wait for
> writeback to complete while making pages writable) resulted in a
> **major** performance regression.  As in, kernel threads that were
> writing to log files were getting hit by up to 2 seconds stalls, which
> very badly hurt a particular application.  

That 2 seconds hit I think I know how to fix somewhat with a smarter
write-back. I want to talk about this in LSF with people

> Reverting this commit fixed the performance regression.
> 
> The main reason for the page stablizatoin patches was for DIF/DIX
> support, right?   So I'm wondering if we should just disable the calls
> to wait_on_page_writeback if CONFIG_BLKDEV_INTEGRITY is not defined.
> i.e., something like this.
> 
> What do people think?  I have a feeling this is going to be very
> controversial....
> 

NACK

It's not a CONFIG_ thing it's: Is this particular device needs stable pages?

As I stated many times before, the device should have a property that
says if it needs stable pages or not. The candidates for stable pages are:

	- DIF/DIX enabled devices
	- RAID-1/4/5/6 devices
	- iscsi devices with data digest signature
	- Any other checksum enabled block device.

A fedora distro will have CONFIG_BLKDEV_INTEGRITY set then you are always
out of luck, even with devices that can care less.

Please submit a proper patch, even a temporary mount option. But this is
ABI. The best is to find where to export it as part of the device's
properties sysfs dir. And inspect that

> 					- Ted
> 

Thanks
Boaz

> ext4: Disable page stablization if DIF/DIX not enabled
> 
> Requiring processes which are writing to files which are under writeback
> until the writeback is complete can result in massive performance hits.
> This is especially true if writes are being throttled due to I/O cgroup
> limits and the application is running on an especially busy server.
> 
> If CONFIG_BLKDEV_INTEGRITY is not enabled, disable page stablization,
> since that's the main case where this is needed, and page stablization
> can be very painful.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 1a30db7..d25c60f 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2333,7 +2333,9 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		ret = -EAGAIN;
>  		goto out_unlock;
>  	}
> +#ifdef CONFIG_BLKDEV_INTEGRITY
>  	wait_on_page_writeback(page);
> +#endif
>  	return 0;
>  out_unlock:
>  	unlock_page(page);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5f8081c..01f86c5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4638,8 +4638,10 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (page_has_buffers(page)) {
>  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>  					ext4_bh_unmapped)) {
> +#ifdef CONFIG_BLKDEV_INTEGRITY
>  			/* Wait so that we don't change page under IO */
>  			wait_on_page_writeback(page);
> +#endif
>  			ret = VM_FAULT_LOCKED;
>  			goto out;
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

