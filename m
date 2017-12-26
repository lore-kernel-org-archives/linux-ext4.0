From: rong zhao <zhaorbox@gmail.com>
Subject: Question about enlarge ext4 more than 16T
Date: Tue, 26 Dec 2017 18:09:47 +0800
Message-ID: <CAOHr082HDDUt6xwtjrfdTaCOr+zBmrPbUZqO0gy-f4qShZqm5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:44535 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdLZKJs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Dec 2017 05:09:48 -0500
Received: by mail-io0-f195.google.com with SMTP id w127so32191289iow.11
        for <linux-ext4@vger.kernel.org>; Tue, 26 Dec 2017 02:09:48 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

  Recently, I met a problem when extending ext4.



At first, I cannot format ext4 more than 16T, then I upgraded
e2fsprogs to version 1.43.7 which is the latest stable version.

I can create more than 16T by command:

mke2fs -O 64bit -t ext4 /dev/mapper/xxx

After format it, I mount it under folder /nfs/xxx, it works good.

Then I find I cannot extend it online, steps:

1. lvextend to extend LVM size
2. resize2fs /dev/mapper/xxx, it reports cannot online resize
3. "dumpe2fs /dev/mapper/xxx | grep feature" command shows this
filesystem has no resize_inode flag

I tried many times and find if I created more than 16T, it has no
resize_inode flag, seems they are opposite, cannot enable at the same
time.

I find this page: https://bugzilla.redhat.com/show_bug.cgi?id=982871

According to this page, it seems on rhel7, it should be able to
enlarge online, but unfortunately, I failed on rhel6 and I can only
have rhel6.

If I umount /nfs/xxx first, then resize2fs can work expectedly,
however, this indicates we must stop our service for about 15~30
minutes. This is what I do not want.


Then I see there is an old patch talking about this issue:

https://patchwork.ozlabs.org/patch/256822/

>From this patch, it seems that extend ext4 for more than 16T is
possible, but I always fail on redhat 6.7.

At last, let me make a summary of my question:
1. if I create an ext4 FS more than 16T, it has no resize_inode flag,
so I cannot extend it online
2. if I create an ext4 FS less than 16T, even with -O 64bit option, I
cannot extend it to more than 16T, I tried online and offline

Please suggest, thank you very much.
