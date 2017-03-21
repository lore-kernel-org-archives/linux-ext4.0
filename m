From: Manish Katiyar <mkatiyar@gmail.com>
Subject: ext4 scaling limits ?
Date: Tue, 21 Mar 2017 13:07:27 -0700
Message-ID: <CAE0An6fc6tX6ACQYdTYdP+CwN=RDKuv_oaW0xeNrBLY_1AvOtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35611 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758263AbdCUUID (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Mar 2017 16:08:03 -0400
Received: by mail-vk0-f48.google.com with SMTP id x75so106280725vke.2
        for <linux-ext4@vger.kernel.org>; Tue, 21 Mar 2017 13:08:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I was looking at e2fsck code to see if there are any limits on running
e2fsck on large ext4 filesystems. From the code it looks like all the
required metadata while e2fsck is running is only kept in memory and
is only flushed to disk when the appropriate changes are corrected.
(Except the undo file case).
There doesn't seem to be a case/code where we have to periodically
flush some tracking metadata while it is running, just because we have
too much of incore tracking data and may ran out of memory (looks like
code will simply return failure if ext2fs_get_mem() returns failure)

Appreciate if someone can confirm that my understanding is correct ?

Thanks -
Manish
