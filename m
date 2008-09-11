From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Date: Thu, 11 Sep 2008 20:11:06 +0900
Message-ID: <059C75EDB49641A49EF986D81EED4200@nsl.ad.nec.co.jp>
References: <20080908205245t-sato@mail.jp.nec.com>
	<20080908171020.GA22521@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080908171020.GA22521@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hi,

Christoph Hellwig wrote:
>> --- linux-2.6.27-rc5.org/fs/block_dev.c 2008-08-29 07:52:02.000000000 +0900
>> +++ linux-2.6.27-rc5-freeze/fs/block_dev.c 2008-09-05 20:00:29.000000000 +0900
>> @@ -285,6 +285,8 @@ static void init_once(void *foo)
>>      INIT_LIST_HEAD(&bdev->bd_holder_list);
>>  #endif
>>      inode_init_once(&ei->vfs_inode);
>> +     /* Initialize mutex for freeze. */
>> +     mutex_init(&bdev->bd_fsfreeze_mutex);
>
> Why not just freeze_mutex?

The Linux kernel has already had the name of "freezer" in the part of
power-management.  So I named the above mutex "fsfreeze"
(filesystem freeze) to distinguish it from the existent "freezer".
Andrew pointed it out.

>>  struct super_block *freeze_bdev(struct block_device *bdev)
>>  {
>>       struct super_block *sb;
>>
>> +    mutex_lock(&bdev->bd_fsfreeze_mutex);
>> +    if (bdev->bd_fsfreeze_count > 0) {
>> +        bdev->bd_fsfreeze_count++;
>> +        sb = get_super(bdev);
>> +        mutex_unlock(&bdev->bd_fsfreeze_mutex);
>> +        return sb;
>> +    }
>> +    bdev->bd_fsfreeze_count++;
>> +
>>      down(&bdev->bd_mount_sem);
>
> Note that we still have duplication with the bd_mount_sem.  I think
> you should look into getting rid of it and instead do a check of
> the freeze_count under proper freeze_mutex protection.

In the original implementation,
while the filesystem is frozen, subsequent mounts wait for unfreeze
with the semaphore (bd_mount_sem).
But if we replace the semphore with the check of the freeze_count,
subsequent mounts will abort.
I think the original behavior shouldn't be changed, so the existing bd_mount_sem
is better.

>> @@ -244,6 +274,8 @@ void thaw_bdev(struct block_device *bdev
>>  }
>>
>>        up(&bdev->bd_mount_sem);
>> +     mutex_unlock(&bdev->bd_fsfreeze_mutex);
>> +     return 0;
>
> Why do you add a return value here if we always return 0 anyway?

I forgot to remove the unneeded return value in above old patch.
But I need to implement a return value in the new patch
because thaw_bdev() needs to return an IO error which occurs
in unlockfs().
Eric pointed it out.

Cheers, Takashi
