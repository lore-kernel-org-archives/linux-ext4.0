Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9ED5C282C0
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 01:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADB9A2184C
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 01:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qpp1Ghay"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfAXByl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 20:54:41 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]:46407 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfAXByl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2019 20:54:41 -0500
Received: by mail-qk1-f178.google.com with SMTP id q1so2301103qkf.13
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 17:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fCgrTgUuSAO16HjfvMdHBikSKbG+8jnLVOWJVag6J4I=;
        b=Qpp1GhayhXWGHDL9ycBwhb8+3ohmu1TXeZEy6OgkIby7TG3Bn+jGwnIBrVmEDXwxIt
         mzlMeK7fH4ke9tYZkZzGChzSPIm6o0lkXpOy/8suHacfjtRlMIjoNibJEQriwVc2v2hk
         b1bSqXfNZmLfONVCgNnRQMHqUWLslTReQitFgfcbsX5Mz2OSuzlWYnvW9XzVdbjFOkOi
         t3W7fvL4gfcMBXgPGv8FYZu9vamv1eHjtUV9VmArwqCikoqg+EE+R3TWoBlTA6sGDyj2
         AbpZ6kX3SEMP+PSC7sOCTKEd4DP9j325oUzTkrOQ8Z3ZA1rsGT0BfKzxmbsI9QJVW6db
         fOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fCgrTgUuSAO16HjfvMdHBikSKbG+8jnLVOWJVag6J4I=;
        b=BU1aJHNXIbsk4AT5K/3qSi3AK8oK42Kam+c1sUyc3AxV0Sq8U+tL11Q6lu2pRNd9+U
         tqC6iq93U/vdshcX8nLLHqZ9ThwiM3IKCRb1dMD1OS9XJDTnA74M5ES1McfUVVwGp+nw
         WMzSb+Zb9TB4i9esvGq7xw8N1rCPOYNc4ARLYJDUMJf9jzQTeMYwzEw1YbmDDYftFthz
         oZ4ihAyFjkV2KMJS4alnRilJYbBOlGjjj3kUIO7O0Opk7tWgiJAQhxmVNd4WxRJ3R89R
         WHEDZEVnuMuW2/tqDw4zUZxpCSS6m7ZuTt/6RQ0ci6ZC/WMtQGPlV7plhyzRT1hWekM6
         X/jA==
X-Gm-Message-State: AJcUukdkA4EwCXsROe8qh7bI3PtZN/+4QlgMj8Q+CIQqQdis/qr5EwTT
        5tKkyxZmZVtg+NNodJxrJwavPw3mdu6oJ1osscc=
X-Google-Smtp-Source: ALg8bN6hluPFisiz1FSJGuiyk/+k5aH6Ox0G9t8yNj1Svm5HNUoNOr8TouYyXr82T9o4teyxSo3SUNbIzj+/EFo32P0=
X-Received: by 2002:a37:b785:: with SMTP id h127mr3915143qkf.294.1548294879653;
 Wed, 23 Jan 2019 17:54:39 -0800 (PST)
MIME-Version: 1.0
References: <9abbdde6145a4887a8d32c65974f7832@exmbdft5.ad.twosigma.com>
In-Reply-To: <9abbdde6145a4887a8d32c65974f7832@exmbdft5.ad.twosigma.com>
From:   Liu Bo <obuil.liubo@gmail.com>
Date:   Wed, 23 Jan 2019 17:54:28 -0800
Message-ID: <CANQeFDD78G0f8V2YYKq+wMpiVPzmZ8SJ_6xWtgyZ6FvAUKpe8w@mail.gmail.com>
Subject: Re: Phantom full ext4 root filesystems on 4.1 through 4.14 kernels
To:     Elana Hashman <Elana.Hashman@twosigma.com>
Cc:     "tytso@mit.edu" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Nov 8, 2018 at 10:11 AM Elana Hashman
<Elana.Hashman@twosigma.com> wrote:
>
> Hi Ted,
>
> We've run into a mysterious "phantom" full filesystem issue on our Kubern=
etes fleet. We initially encountered this issue on kernel 4.1.35, but are s=
till experiencing the problem after upgrading to 4.14.67. Essentially, `df`=
 reports our root filesystems as full and they behave as though they are fu=
ll, but the "used" space cannot be accounted for. Rebooting the system, rem=
ounting the root filesystem read-only and then remounting as read-write, or=
 booting into single-user mode all free up the "used" space. The disk slowl=
y fills up over time, suggesting that there might be some kind of leak; we =
previously saw this affecting hosts with ~200 days of uptime on the 4.1 ker=
nel, but are now seeing it affect a 4.14 host with only ~70 days of uptime.
>

I wonder if this ext4 enabled bigalloc (can be checked by dumpe2fs -h $disk=
).
So bigalloc is known to cause leak space, and it's been just fixed recently=
.

thanks,
liubo

> Here is some data from an example host, running the 4.14.67 kernel. The r=
oot disk is ext4.
>
> $ uname -a
> Linux <hostname> 4.14.67-ts1 #1 SMP Wed Aug 29 13:28:25 UTC 2018 x86_64 G=
NU/Linux
> $ grep ' / ' /proc/mounts
> /dev/disk/by-uuid/<some-uuid> / ext4 rw,relatime,errors=3Dremount-ro,data=
=3Dordered 0 0
>
> `df` reports 0 bytes free:
>
> $ df -h /
> Filesystem                                              Size  Used Avail =
Use% Mounted on
> /dev/disk/by-uuid/<some-uuid>   50G   48G     0 100% /
>
> Deleted, open files account for almost no disk capacity:
>
> $ sudo lsof -a +L1 /
> COMMAND    PID   USER   FD   TYPE DEVICE SIZE/OFF NLINK    NODE NAME
> java      5313 user    3r   REG    8,3  6806312     0 1315847 /var/lib/ss=
s/mc/passwd (deleted)
> java      5313 user   11u   REG    8,3    55185     0 2494654 /tmp/classp=
ath.1668Gp (deleted)
> system_ar 5333 user    3r   REG    8,3  6806312     0 1315847 /var/lib/ss=
s/mc/passwd (deleted)
> java      5421 user    3r   REG    8,3  6806312     0 1315847 /var/lib/ss=
s/mc/passwd (deleted)
> java      5421 user   11u   REG    8,3   149313     0 2494486 /tmp/java.f=
zTwWp (deleted)
> java      5421 tsdist   12u   REG    8,3    55185     0 2500513 /tmp/clas=
spath.7AmxHO (deleted)
>
> `du` can only account for 16GB of file usage:
>
> $ sudo du -hxs /
> 16G     /
>
> But what is most puzzling is the numbers reported by e2freefrag, which do=
n't add up:
>
> $ sudo e2freefrag /dev/disk/by-uuid/<some-uuid>
> Device: /dev/disk/by-uuid/<some-uuid>
> Blocksize: 4096 bytes
> Total blocks: 13107200
> Free blocks: 7778076 (59.3%)
>
> Min. free extent: 4 KB
> Max. free extent: 8876 KB
> Avg. free extent: 224 KB
> Num. free extent: 6098
>
> HISTOGRAM OF FREE EXTENT SIZES:
> Extent Size Range :  Free extents   Free Blocks  Percent
>     4K...    8K-  :          1205          1205    0.02%
>     8K...   16K-  :           980          2265    0.03%
>    16K...   32K-  :           653          3419    0.04%
>    32K...   64K-  :          1337         15374    0.20%
>    64K...  128K-  :           631         14151    0.18%
>   128K...  256K-  :           224         10205    0.13%
>   256K...  512K-  :           261         23818    0.31%
>   512K... 1024K-  :           303         56801    0.73%
>     1M...    2M-  :           387        135907    1.75%
>     2M...    4M-  :           103         64740    0.83%
>     4M...    8M-  :            12         15005    0.19%
>     8M...   16M-  :             2          4267    0.05%
>
> This looks like a bug to me; the histogram in the manpage example has per=
centages that add up to 100% but this doesn't even add up to 5%.
>
> After a reboot, `df` reflects real utilization:
>
> $ df -h /
> Filesystem                                              Size  Used Avail =
Use% Mounted on
> /dev/disk/by-uuid/<some-uuid>   50G   16G   31G  34% /
>
> We are using overlay2fs for Docker, as well as rbd mounts; I'm not sure h=
ow they might interact.
>
> Thanks for your help,
>
> --
> Elana Hashman
> ehashman@twosigma.com
