From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Wed, 03 May 2017 08:17:17 +0000
Message-ID: <bug-195561-13602-RWKTjxuQvc@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58388 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751696AbdECIRV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 May 2017 04:17:21 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 53B9C28576
        for <linux-ext4@vger.kernel.org>; Wed,  3 May 2017 08:17:20 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

--- Comment #25 from James tao (tao1hua@aliyun.com) ---
I am working on Broadcom ARM chipset base on Android 7.0. I met the same
problem. and the kernel version is 4.1.20.
I set a tf card as "internal share storage". When I try to copy a file(file
size must more than 2.3G) from data partition to sdcard(the filesystem of tf
card is ext4). 
 cp /data/xxx.data /sdcard/ 

the Kernel print log:
[  982.761411] EXT4-fs error (device dm-1): ext4_validate_block_bitmap:380:
comm kworker/u4:2: bg 17: block 557056: invalid block bitmap
[  982.815546] EXT4-fs (dm-1): Remounting filesystem read-only

TF card mount as readonly.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
