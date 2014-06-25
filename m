From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: About changing the UUID of external journal device
Date: Wed, 25 Jun 2014 17:28:33 +0400
Message-ID: <20140625132833.GG643@azat>
References: <CAPBYzXNb18pwCijLTRrprMjUDGuCwRso7pa0K2foObqr_9pHpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chin Tzung Cheng <chintzung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:60079 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaFYN2k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jun 2014 09:28:40 -0400
Received: by mail-lb0-f170.google.com with SMTP id 10so1872317lbg.29
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jun 2014 06:28:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAPBYzXNb18pwCijLTRrprMjUDGuCwRso7pa0K2foObqr_9pHpQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 25, 2014 at 05:31:15PM +0800, Chin Tzung Cheng wrote:
> Hi,
> I have problem while I create a ext4 volume with external journal device.
> The UUID of external journal device is not the one I specify.
> 
> First, I create a journal device(/dev/sda4).
> 
> [root@localhost sbin]# ./mke2fs -O journal_dev /dev/sda4
> [root@localhost sbin]# ./blkid /dev/sda4
> /dev/sda4: UUID="1313c286-7803-4a40-9010-74964554d13f" TYPE="jbd"
> 
> I use tune2fs to change the UUID of journal device. blkid shows the
> UUID is changed.
> 
> [root@localhost sbin]# ./tune2fs  /dev/sda4 -U
> aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
> [root@localhost sbin]# ./blkid /dev/sda4
> /dev/sda4: UUID="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa" TYPE="jbd"
> 
> Make an ext4 volume with external journal device (dev/sda4)
> 
> [root@localhost sbin]# ./mke2fs /dev/sda3 -t ext4 -J device=/dev/sda4
> 
> [root@localhost sbin]# ./dumpe2fs -h /dev/sda3 | grep UUID
> dumpe2fs 1.42.10 (18-May-2014)
> Filesystem UUID:          d8f038e5-9539-4b1d-8ccb-63cc56771fc5
> Journal UUID:             1313c286-7803-4a40-9010-74964554d13f
> 
> However, the journal device UUID of ext4 volume is still the old one.
> It's not the new one.
> 
> Test environment
> Kernel version: 3.12.10
> e2fsprogs version: 1.42.10
> 
> Any help would be appreciated.

Hi,
I'm *not an expert*, but here is what you can do:
[ vdc === sda3, vdb ===sda4 ]

# e2fsck -vvv /dev/vdc
e2fsck 1.42.10 (18-May-2014)
External journal does not support this filesystem

/dev/vdc: ********** WARNING: Filesystem still has errors **********

# debugfs -w /dev/vdc 
debugfs 1.42.10 (18-May-2014)
debugfs:  set_super_value journal_uuid
"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"

# dumpe2fs -h /dev/vdc | fgrep UUID
dumpe2fs 1.42.10 (18-May-2014)
Filesystem UUID:          85050e89-6b52-4146-b697-8439a7b04b13
Journal UUID:             aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa

# e2fsck -vvv /dev/vdc
e2fsck 1.42.10 (18-May-2014)
External journal has multiple filesystem users (unsupported).

/dev/vdc: ********** WARNING: Filesystem still has errors **********

# dumpe2fs -h /dev/vdb | fgrep Journal\ users: -A10
dumpe2fs 1.42.10 (18-May-2014)
Journal users:            4a383cca-3d1e-40c3-8ab2-38bc5f770eea
                          fa89e7ed-ff86-4c94-bc91-739ad888c4a4
                          85050e89-6b52-4146-b697-8439a7b04b13

[ Only in case when you have multiple users for journal dev: ]
-------------------------------------------------------------

# mke2fs -O journal_dev /dev/vdb
mke2fs 1.42.10 (18-May-2014)
/dev/vdb contains a jbd file system
Proceed anyway? (y,n) y
Creating filesystem with 1310720 4k blocks and 0 inodes
Filesystem UUID: e81064f2-fd57-4af3-b690-06985cbbe4b0
Superblock backups stored on blocks: 

Zeroing journal device: 

# tune2fs /dev/vdb -U aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
# e2fsck -f /dev/vdc
e2fsck 1.42.10 (18-May-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vdc: 11/327680 files (0.0% non-contiguous), 23134/1310720 blocks

I will try to dig into sources, to find the reason.


> 
> Thanks,
> chintzung
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Respectfully
Azat Khuzhin
