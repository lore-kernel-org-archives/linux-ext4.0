From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Date: Fri, 29 Aug 2008 18:37:28 +0900
Message-ID: <328724AE665B49F8A8B60D92187C4BBF@nsl.ad.nec.co.jp>
References: <20080818212819t-sato@mail.jp.nec.com> <20080822181458.GA15469@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>,
	<viro@ZenIV.linux.org.uk>, <linux-ext4@vger.kernel.org>,
	<xfs@oss.sgi.com>, "Christoph Hellwig" <hch@infradead.org>,
	<axboe@kernel.dk>, <mtk.manpages@googlemail.com>,
	<linux-kernel@vger.kernel.org>
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:63741 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYH2Jiv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2008 05:38:51 -0400
In-Reply-To: <20080822181458.GA15469@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Christoph Hellwig wrote:
>On Mon, Aug 18, 2008 at 09:28:19PM +0900, Takashi Sato wrote:
>> +    down(&bdev->bd_freeze_sem);
>> +    bdev->bd_freeze_count++;
>> +    if (bdev->bd_freeze_count > 1) {
>> +            sb = get_super(bdev);
>> +            drop_super(sb);
>> +            up(&bdev->bd_freeze_sem);
>> +            return sb;
>> +    }
>> +
>>      down(&bdev->bd_mount_sem);
>
>Now you have a reference counter of freezes which actually is pretty
>sensible, but also needs some documentation.  What I don't understand
>here at all is why you do the get_super/drop_super in the already frozen
>case.

Even if the filesystem has already been frozen, the superblock
should be returned. Because a caller should recognize the success of
freeze_bdev() and call thaw_bdev() to decrease the reference count. 
But I will remove drop_super() as it should be called in thaw_bdev().

>
>Now that the freeze_count has replaced one of the uses of bd_mount_sem
>you should also replace the other use in the unmount path by simply
>checking for the freez_count and abort if it's set.  To do so you'll
>need to hold the bd_mount_sem over the whole unmount operation to
>prevent new frezes from coming in.

In the original implementation,
unmount is protected by s_umount(semaphore),
not bd_mount_sem.  So, unmount task waits for unfreeze.
I think this original behavior shouldn't be changed, 
so the existing s_umount lock is better.

>
>As others noted it should be a mutex and not a semaphore.

As you said, we should use the mutex.
I will replace it.

>
>>  /*
>> + * ioctl_freeze - Freeze the filesystem.
>> + *
>> + * @filp:   target file
>> + *
>> + * Call freeze_bdev() to freeze the filesystem.
>> + */
>> +static int ioctl_freeze(struct file *filp)
>
>This is not quite kerneldcoc format, which would ne a /** as commnt
>start.  But I don't think the comment is actually needed, it's a pretty
>obvious file scope function. (Same commnt also applies to ioctl_thaw)

I will remove these comments.

>
>> +    struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
>> +
>> +    if (!capable(CAP_SYS_ADMIN))
>> +            return -EPERM;
>> +
>> +    /* If filesystem doesn't support freeze feature, return. */
>> +    if (sb->s_op->write_super_lockfs == NULL)
>> +            return -EOPNOTSUPP;
>> +
>> +    /* If a regular file or a directory isn't specified, return. */
>> +    if (sb->s_bdev == NULL)
>> +            return -EINVAL;
>
>I don't understand this commnt.  What you are checking is that the
>filesystem has a non-NULL s_bdev, which implies a not blockdevice-backed
>filesystem.

I will fix the comment as :
" If a blockdevice-backed filesystem isn't specified, return."

Cheers, Takashi
