From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: allow specifying external journal by pathname mount
 option
Date: Wed, 31 Jul 2013 09:16:03 -0500
Message-ID: <51F91C23.7020402@redhat.com>
References: <51F83D90.5080708@redhat.com> <20130731140545.GA22930@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Leonardo Menezes Vaz <lvaz@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759627Ab3GaOQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 10:16:08 -0400
In-Reply-To: <20130731140545.GA22930@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/31/13 9:05 AM, Jan Kara wrote:
> On Tue 30-07-13 17:26:24, Eric Sandeen wrote:
>> It's always been a hassle that if an external journal's
>> device number changes, the filesystem won't mount.
>> And since boot-time enumeration can change, device number
>> changes aren't unusual.
>>
>> The current mechanism to update the journal location is by
>> passing in a mount option w/ a new devnum, but that's a hassle;
>> it's a manual approach, fixing things after the fact.
>>
>> Adding a mount option, "-o journal_path=/dev/$DEVICE" would
>> help, since then we can do i.e.
>>
>> # mount -o journal_path=/dev/disk/by-label/$JOURNAL_LABEL /mnt
>>
>> and it'll mount even if the devnum has changed, as shown here:
>>
>> # losetup /dev/loop0 journalfile
>> # mke2fs -L mylabel-journal -O journal_dev /dev/loop0 
>> # mkfs.ext3 -L mylabel -J device=/dev/loop0 /dev/sdb1
>>
>> Change the journal device number:
>>
>> # losetup -d /dev/loop0
>> # losetup /dev/loop1 journalfile 
>>
>> And today it will fail:
>>
>> # mount /dev/sdb1 /mnt/test
>> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>>        missing codepage or helper program, or other error
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail  or so
>>
>> # dmesg | tail -n 1
>> [17343.240702] EXT3-fs (sdb1): error: couldn't read superblock of external journal
>>
>> But with this new mount option, we can specify the new path:
>>
>> # mount -o journal_path=/dev/loop1 /dev/sdb1 /mnt/test
>> #
>>
>> (which does update the encoded device number, incidentally):
>>
>> # umount /dev/sdb1
>> # dumpe2fs -h /dev/sdb1 | grep "Journal device"
>> dumpe2fs 1.41.12 (17-May-2010)
>> Journal device:	          0x0701
>>
>> But best of all we can just always mount by journal-path, and
>> it'll always work:
>>
>> # mount -o journal_path=/dev/disk/by-label/mylabel-journal /dev/sdb1 /mnt/test
>> #
>>
>> So the journal_path option can be specified in fstab, and as long as
>> the disk is available somewhere, and findable by label (or by UUID),
>> we can mount.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> The patch is a little hacky, doing all the work in option parsing,
>> just to get to a journal devnum like the old option expected, only
>> to later re-decode it when we really want to open it.
>>
>> I could clean it up so that both journal-update mount options
>> find the bdev, rather than ending with an encoded device number,
>> which must then be decoded & re-opened, if that seems better.
>>
>> But this was expedient enough to get the idea out on the list.
>>
>> If we like it, I'll do ext4 as well.
>   Yeah, it looks like a good idea. You could just lookup the path via
> kern_path() and then take the device numbers from the inode so you won't
> have to do the decode-recode dance. That would look like the cleanest option
> to me.
> 
> 								Honza

Ah, thanks for the suggestion, I'll give that a shot.

-Eric
