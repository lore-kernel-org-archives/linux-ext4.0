From: Andrew Zhu Aday <andrew.aday@columbia.edu>
Subject: Re: KASAN: use-after-free in move_expired_inodes
Date: Sat, 4 Nov 2017 17:02:34 -0400
Message-ID: <CAHAAGFnSeXrqmO+CpP40NK=yTU7nPANXyqxbcHLaheX+rvTThw@mail.gmail.com>
References: <CAASgV=tSiiiXgCzuk03AyvrLS72zJxzF1rL4JkFgLnxBDzqhug@mail.gmail.com>
 <CAASgV=uFkfFg3HeG_GnHWbCc=-OFq6nqH7bDKQt2HymdD+wiDA@mail.gmail.com>
 <CAASgV=vQpA4c96o-G4tng_KaYWDj+hKn5AW2OEzfGqT=9J9CzQ@mail.gmail.com> <CAHAAGFm+md4QVKQFmAKgbHXhvSjyxu1asDj2QEucRzh+_ENFmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Shankara Pailoor <sp3485@columbia.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outprodmail02.cc.columbia.edu ([128.59.72.51]:48236 "EHLO
        outprodmail02.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751534AbdKDVCi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Nov 2017 17:02:38 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id vA4Kw5hC040770
        for <linux-ext4@vger.kernel.org>; Sat, 4 Nov 2017 17:02:37 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id F14286D
        for <linux-ext4@vger.kernel.org>; Sat,  4 Nov 2017 17:02:37 -0400 (EDT)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu [128.59.72.15])
        by hazelnut (Postfix) with ESMTP id D2C897E
        for <linux-ext4@vger.kernel.org>; Sat,  4 Nov 2017 17:02:37 -0400 (EDT)
Received: from mail-lf0-f69.google.com (mail-lf0-f69.google.com [209.85.215.69])
        by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id vA4L2aVM041224
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sat, 4 Nov 2017 17:02:37 -0400
Received: by mail-lf0-f69.google.com with SMTP id t5so1800244lfe.1
        for <linux-ext4@vger.kernel.org>; Sat, 04 Nov 2017 14:02:37 -0700 (PDT)
In-Reply-To: <CAHAAGFm+md4QVKQFmAKgbHXhvSjyxu1asDj2QEucRzh+_ENFmw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

cc shankara

On Sat, Nov 4, 2017 at 4:05 PM, Andrew Zhu Aday
<andrew.aday@columbia.edu> wrote:
> ---------- Forwarded message ----------
> From: Shankara Pailoor <sp3485@columbia.edu>
> Date: Tue, Oct 31, 2017 at 10:05 PM
> Subject: Fwd: KASAN: use-after-free in move_expired_inodes
> To: Andrew Zhu Aday <andrew.aday@columbia.edu>
>
>
> ---------- Forwarded message ----------
> From: Shankara Pailoor <sp3485@columbia.edu>
> Date: Tue, Oct 31, 2017 at 10:04 PM
> Subject: Re: KASAN: use-after-free in move_expired_inodes
> To: LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
> linux-fsdevel@vger.kernel.org
>
>
> Hi Al, etc,
>
> I was unable to find a reproducer but I was looking at
> move_expired_inodes (fs/fs-writeback.c 1093.c) and how do you ensure
> that the inode can't be freed after retrieving it from the work queue?
> Any insights would be appreciated.
>
> Regards,
> Shankara
>
> On Tue, Oct 31, 2017 at 9:24 AM, Shankara Pailoor <sp3485@columbia.edu> wrote:
>> Hi,
>>
>> We got the following error:
>>
>> BUG: KASAN: use-after-free in move_expired_inodes+0xce6/0xdf0
>> Write of size 8 at addr ffff8800a3a36bf8 by task kworker/u8:0/5
>>
>> while fuzzing with Syzkaller on 4.14-rc4 on x86_64. Included is the
>> trace of the crash along with the programs running around the time of
>> the crash.
>>
>> Programs can be found here: https://pastebin.com/RYGtNn3z
>>
>> Stack trace here: https://pastebin.com/SaJXWMg3
>>
>> We don't have a C reproducer but we will send one if we have it.
>>
>> Regards,
>> Shankara
