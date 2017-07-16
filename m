From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Which kernel do I need to use ext4 64-bit.
Date: Sun, 16 Jul 2017 11:26:01 -0500
Message-ID: <789629f3-d70f-5588-65ec-a45d5c3259a9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34180 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdGPQ0D (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Jul 2017 12:26:03 -0400
Received: by mail-oi0-f48.google.com with SMTP id q4so17730129oif.1
        for <linux-ext4@vger.kernel.org>; Sun, 16 Jul 2017 09:26:03 -0700 (PDT)
Received: from [192.168.3.68] ([47.187.202.234])
        by smtp.googlemail.com with ESMTPSA id p124sm17169633oic.4.2017.07.16.09.26.01
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jul 2017 09:26:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I asked this question on linux-ext3 and apparently I cannot post it 
there as moderator has to approve it, and he is neither approving or 
disapproving my message. May be the list is dormant now and everything 
happens here. Any way here is my question.

> Is there a kernel version restriction for 64bit ext4 FS creation/use? 
> Google does not seem to find any info on this. I have mythbuntu  14.04 
> distro that has
>> zym [rramesh] 473 > uname -a
>> Linux zym 3.13.0-119-generic #166-Ubuntu SMP Wed May 3 12:18:55 UTC 
>> 2017 x86_64 x86_64 x86_64 GNU/Linux
> Can I create a 64bit ext4 under this kernel and mount/use?
>
> BTW, my resize2fs cannot grow the file system beyond 16TB. I assume 
> this is due to current FS being 32bit. I need to make it 64bit. What 
> is the best way to go about doing this *on my distro*?
>> zym [rramesh] 474 > resize2fs
>> resize2fs 1.42.9 (4-Feb-2014)
>> Usage: resize2fs [-d debug_flags] [-f] [-F] [-M] [-P] [-p] device 
>> [new_size]
>
> Ramesh 

Ramesh
