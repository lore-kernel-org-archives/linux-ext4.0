From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Filesystem size problem.
Date: Fri, 9 Dec 2016 18:18:47 -0800
Message-ID: <CAEUYfyOPDSusSNtbUge5C4sJn7oZA_kJY8AubPfFH8B3nLUuCw@mail.gmail.com>
References: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com>
 <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com> <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:32899 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbcLJCSs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2016 21:18:48 -0500
Received: by mail-qk0-f178.google.com with SMTP id x190so35690128qkb.0
        for <linux-ext4@vger.kernel.org>; Fri, 09 Dec 2016 18:18:48 -0800 (PST)
In-Reply-To: <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 9, 2016 at 12:29 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Dec 8, 2016, at 10:40 PM, Simon Matthews <simon.d.matthews@gmail.com> wrote:
>>
>> I have an ext3 filesystem that will not mount under newer versions of
>> the kernel and I hope someone here can help.
>>
>> Obviously, one solution is "backup and re-create from scratch". I have
>> the backups, but I hope that there may be a quicker method to fix the
>> issues.
>>
>> The root issue is that the filesystem is very slightly smaller than
>> the allocated space. The filesystem exists on a MDRAID device and I
>> think that when I converted the MDRAID to a newer metadata version, it
>> truncated the available size, slightly. However, how I got here isn't
>> really important, fixing it now is.
>
> Running "e2fsck -fy" should fix this.  I'd recommend to use the latest
> version of e2fsck.

The system has v1.42.13 installed. Is that recent enough?

Simon


>
> Cheers, Andreas
>
>>
>> With an slightly older kernel (4.0.5), the filesystem can be mounted.
>> With 4.4.26, the ext3 support is provided by the ext4 subsystem and it
>> appears that it will not accept the size issues. dmesg showed this
>> from the mount attempt:
>>
>> md5: detected capacity change from 0 to 2839999799296
>> [ 1162.508338] EXT4-fs (md5): mounting ext3 file system using the ext4 subsystem
>> [ 1162.508560] EXT4-fs (md5): bad geometry: block count 693359344
>> exceeds size of device (693359326 blocks)
>>
>> As I stated, the difference is very small, so it was working OK for a long time.
>>
>> My attempts to re-size the filesystem did not work. I don't have the
>> error messages available. Getting the system up and running was more
>> important at the time.
>>
>> Apart from "backup and re-create", how can I fix this? What would be
>> the correct options to use with resize2fs (if that is the correct
>> approach)? fsck gave me some serious warnings about possibly
>> destroying the filesystem, so I did not want to do this without
>> advice.
>>
>> Simon
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas
>
>
>
>
>
