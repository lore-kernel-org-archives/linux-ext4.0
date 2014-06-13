From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Thu, 12 Jun 2014 20:02:23 -0700
Message-ID: <CAKP4w2Tux8nuWW-uOfY+t+B84=PMmt3sFZ8cA6UMg42dSTo0-A@mail.gmail.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com> <539A63C1.8010809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:35082 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaFMDCn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2014 23:02:43 -0400
Received: by mail-oa0-f45.google.com with SMTP id o6so2216783oag.4
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2014 20:02:43 -0700 (PDT)
In-Reply-To: <539A63C1.8010809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2014 at 7:36 PM, Eric Sandeen <sandeen@redhat.com> wrote:

> IOWS: your commit log says what, but not why.

Will upload a version with some more "why".


> You're adding a new high-level IOCTL, so let's get a bit more
> visibility than just linux-ext4; linux-fsdevel cc'd.

Wasn't too sure about that one, because I didn't feel like committing
to other FSes for now even if they do have FITRIM.
Will remember to include them.

>> +             if (secure_trim && !blk_queue_secdiscard(q))
>> +                     return -EOPNOTSUPP;
>> +
>> +             if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> +                            EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
>> +                     ext4_msg(sb, KERN_ERR,
>> +                              "FITRIM not supported with bigalloc");
>> +                     return -EOPNOTSUPP;
>> +             }
>> +
>
> This last conditional is unrelated to the patch; if BIGALLOC has another
> incomplete part of its implementation, please send it as a standalone patch,
> not buried in this one.

Yup. My bad.

--
