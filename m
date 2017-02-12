From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: Re: [PATCH 1/3] mke2fs: enable large directroy support
Date: Sun, 12 Feb 2017 20:50:48 +0300
Message-ID: <CAO3qy=GPK-XP+88Eig7v=QvMEhH1fgbiL-kJ8Cnb_K5jS=56uQ@mail.gmail.com>
References: <CAO3qy=F_CxQQ0bUtOm5CZbE0QQ78vyviMStOgg8nryUZZymung@mail.gmail.com>
 <20170125203121.s2o4cskgmruvjnrt@thunk.org> <74D6C84E-BC8B-4060-9345-3DC8DAEB9EED@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:41867 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751217AbdBLRuw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 12 Feb 2017 12:50:52 -0500
Received: from pps.filterd (m0075554.ppops.net [127.0.0.1])
        by mx0a-000cda01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1CHmxD7000991
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 12:50:51 -0500
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com [209.85.220.199])
        by mx0a-000cda01.pphosted.com with ESMTP id 28jgx7jc7a-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 12:50:51 -0500
Received: by mail-qk0-f199.google.com with SMTP id t84so80042216qke.7
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 09:50:51 -0800 (PST)
In-Reply-To: <74D6C84E-BC8B-4060-9345-3DC8DAEB9EED@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

>We have kernel-side patches for this feature. Artem, could you push a vers=
ion of the ext4 patches for the latest kernel to the list?

Yes, sure. I will push it here soon.

Best regards,
Artem Blagodarenko.

On Thu, Feb 2, 2017 at 8:11 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> We have kernel-side patches for this feature. Artem, could you push a ver=
sion of the ext4 patches for the latest kernel to the list?
>
> Cheers, Andreas
>
>> On Jan 25, 2017, at 13:31, Theodore Ts'o <tytso@mit.edu> wrote:
>>
>>> On Tue, Jan 24, 2017 at 07:34:13PM +0300, Artem Blagodarenko wrote:
>>> The INCOMPAT_LARGEDIR feature allows larger directories to
>>> be created, both with directory sizes over 2GB and and a
>>> maximum htree depth of 3 instead of the current limit of 2.
>>> These features are needed in order to exceed the currently
>>> limit of approximately 10M entries in a single directory.
>>>
>>> debugfs, e2fsck, ext2fs, mke2fs and tune2fs support is
>>> added.
>>>
>>> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
>>> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>>
>> Where are the kernel-side changes for this feature?
>>
>> And could you *please* use git send-email's --chain-reply-to option,
>> or set the sendemail.chainReplyTo in your git config.  (Or if you're
>> not using git send-email, send the e-mail using that format).
>>
>> It makes it much easier to figure out which patch goes with which
>> other patch in a patch series, especially when you start sending
>> revised versions of the patches.
>>
>>                    - Ted
>>



--=20
Artem Blagodarenko Ph.D.=C2=B7 SW Developer on my.seagate.com
Seagate Technology, LLC
www.seagate.com
