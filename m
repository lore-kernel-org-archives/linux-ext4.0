Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail2.sequans.com ([194.98.51.148]:61670 "EHLO
        mail2.sequans.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729936AbeKVEdV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 23:33:21 -0500
To: <linux-ext4@vger.kernel.org>
Subject: Metadata_csum is still enabled after trying to disable it.
Message-Id: <E1gPWbq-0006F7-IZ@eureka>
From: Jean-Christophe Guillain <jcguillain@sequans.com>
Date: Wed, 21 Nov 2018 18:48:18 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I see a strange behaviour when playing with the metadata_csum parameter of ext4.
(I use a Debian Stretch, with a kernel 4.9.0-8-amd64 #1 SMP Debian 4.9.110-3+deb9u6 (2018-10-08) x86_64 GNU/Linux)

How to reproduce :

* I enable metada checksum : OK
    root@test# tune2fs -O metadata_csum /dev/my_vol
    tune2fs 1.43.4 (31-Jan-2017)
    Enabling checksums could take some time.
    Proceed anyway (or wait 5 seconds) ? (y,N) y

* I check : Checksum enabled
    root@test# tune2fs -l /dev/my_vol
    tune2fs 1.43.4 (31-Jan-2017)
    Filesystem volume name:   <none>
    [...]
    Journal backup:           inode blocks
    Checksum type:            crc32c
    Checksum:                 0xb0e3a180

* I change filesystem UUID : OK
    root@test# tune2fs -U random /dev/my_vol
    tune2fs 1.43.4 (31-Jan-2017)
    Setting UUID on a checksummed filesystem could take some time.
    Proceed anyway (or wait 5 seconds) ? (y,N) y

* I disable metadata checksum : OK
    root@test# tune2fs -O ^metadata_csum /dev/my_vol
    tune2fs 1.43.4 (31-Jan-2017)
    Disabling checksums could take some time.
    Proceed anyway (or wait 5 seconds) ? (y,N) y

* I change filesystem UUID : It looks like metada checksum still is enabled
    root@test# tune2fs -U random /dev/my_vol
    tune2fs 1.43.4 (31-Jan-2017)
    Setting UUID on a checksummed filesystem could take some time.
    Proceed anyway (or wait 5 seconds) ? (y,N) y

* I fsck the filesystem to see if it could fix this.
    root@test# e2fsck -f /dev/my_vol
    2fsck 1.43.4 (31-Jan-2017)
    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    /dev/my_vol: 16303/3932160 files (0.9% non-contiguous), 1829950/15728640 blocks

* I check : metadata checksum looks like disabled
    root@test# tune2fs -l /dev/my_vol tune2fs 1.43.4 (31-Jan-2017)
    Filesystem volume name:   <none>
    [...]
    Journal backup:           inode blocks

* I change filesystem UUID : It looks like metada checksum still is enabled
    root@test# tune2fs -U random /dev/my_vol
    tune2fs 1.43.4 (31-Jan-2017)
    Setting UUID on a checksummed filesystem could take some time.
    Proceed anyway (or wait 5 seconds) ? (y,N) y

Is it a bug ?
How can I actually disable this parameter ?

Best regards,
jC Guillain


-- IMPORTANT NOTICE: 

The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
