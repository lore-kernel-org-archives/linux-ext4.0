Return-Path: <SRS0=vjzE=OW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:15687 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726500AbeLMH4N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Dec 2018 02:56:13 -0500
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Question about commit "ext4: always initialize the crc32c checksum
 driver"
To: "Theodore Y. Ts'o" <tytso@mit.edu>
CC: <linux-ext4@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>,
        yangerkun <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Message-ID: <d686d167-9ad2-bfd6-3464-fb35c10ae63d@huawei.com>
Date: Thu, 13 Dec 2018 15:56:04 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I am checking a CVE patch a45403b515 "ext4: always initialize the crc32c checksum driver"[1]
in CVE-2018-1094[2] recently, and have a question about the commit log in this patch.

The patch commit log said:

> The extended attribute code now uses the crc32c checksum for hashing
> purposes, so we should just always always initialize it.  We also want
> to prevent NULL pointer dereferences if one of the metadata checksum
> features is enabled after the file sytsem is originally mounted.

This first fix is clear. But I don't understand the second fix. IIUC, the kernel does not call
ext4_set_feature_metadata_csum() to enable metadata checksum, and this feature can only be enabled
by mkfs,turn2fs or change the image directly. So this feature bit will never change once the
file system is mounted, the second case could never happen ?

BTW, does this patch need on the old kernel before dec214d00e "ext4: xattr inode deduplication" ?

------
[1]. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a45403b51582a
[2]. https://nvd.nist.gov/vuln/detail/CVE-2018-1094

Thanks,
Yi.
