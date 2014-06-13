From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Thu, 12 Jun 2014 19:57:50 -0700
Message-ID: <CAKP4w2SoKaSbm=R855X1s2xhwLRMr2z0o+OAegHEZcJqCwhCCg@mail.gmail.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com> <20140613023605.GC9743@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:54609 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaFMC6L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2014 22:58:11 -0400
Received: by mail-ob0-f177.google.com with SMTP id uy5so2223384obc.22
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2014 19:58:11 -0700 (PDT)
In-Reply-To: <20140613023605.GC9743@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2014 at 7:36 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> What is 'secure discard'?  How does it differ from regular discard?
> I guess it means 'really make this go away physical media'?

It tells the device to really get rid of all the data for the sectors
and not just put them back into the pool of free ones. Mostly useful
for flash storage. eMMC spec introduces secure erase which is
currently used for other things than secure trimming. The eMMC
controller is then responsible for making sure the data is not
available anymore.

>> +             if (secure_trim && !blk_queue_secdiscard(q))
>> +                     return -EOPNOTSUPP;
>> +
>> +             if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> +                            EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
>> +                     ext4_msg(sb, KERN_ERR,
>> +                              "FITRIM not supported with bigalloc");
>> +                     return -EOPNOTSUPP;
>> +             }
>
> Huh?  I don't think this belongs in this patch.

Yuck. Messed up cherry-pick without paying enough attention. Will clean up.


> Also, any plans to bring SFITRIM to the other FSes?

Probably any FS with the plumbing for some form of secure discard and
FITRIM should be easy enough.
Have not looked into it yet beyond ext4 and F2FS.

--
