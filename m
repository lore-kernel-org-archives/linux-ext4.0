From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Date: Tue, 27 May 2008 19:20:11 +0900
Message-ID: <7654D29B4EC648FD8E32AB331941F941@nsl.ad.nec.co.jp>
References: <20080522175020t-sato@mail.jp.nec.com>
	<20080525193211.GA24328@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080525193211.GA24328@infradead.org>
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

>> +    if (test_and_set_bit(BD_FREEZE_OP, &bdev->bd_state))
>> +        return ERR_PTR(-EBUSY);
>> +
>> +    sb = get_super_without_lock(bdev);
>> +
>> +    /* If super_block has been already frozen, return. */
>> +    if (sb && sb->s_frozen != SB_UNFROZEN) {
>> +        put_super(sb);
>> +       clear_bit(BD_FREEZE_OP, &bdev->bd_state);
>> +       return sb;
>> +    }
>
> The BD_FREEZE_OP flag in the block_device already prevents multiple
> freezes for a singe block device, so there is no need for this
> additional check and the get_super_without_lock helper.

I think the above check is needed because BD_FREEZE_OP is used to
guarantee that the following two operations are done atomically.
1. Check if the filesystem has already been frozen.
   (sb->s_frozen != SB_UNFROZEN)
2. Do the filesystem specific freeze operation
   (write_super_lockfs)

The freeze operation can be done again for the frozen filesystem
unless the filesystem is checked.
And if write_super_lockfs doesn't consider that the filesystem
has already been frozen, a problem might occur.

>>  down(&bdev->bd_mount_sem);
> 
> And with that flag bd_mount_sem is also obsolete for preventing the
> multiple freeze operations.  

bd_mount_sem is needed because it is used to guarantee that the freeze
operation never run while mounting (get_sb_bdev()).

> We still need investigate what
> synchronization we need vs unmount which also takes bd_mount_sem without
> every having document what it exactly protects.

And s_umount (semaphore) is acquired in get_user() (called by freeze_bdev())
to guarantee that unmount never run while the filesystem is frozen.

Cheers, Takashi
