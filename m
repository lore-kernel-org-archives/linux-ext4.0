Return-Path: <SRS0=J55O=OU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbeLKRlT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 12:41:19 -0500
Date: Tue, 11 Dec 2018 09:41:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [BUG BISECT next] Files cannot be opened after "fsverity: Move
 verity status check to fsverity_file_open"
Message-ID: <20181211174116.GB221175@gmail.com>
References: <CAJKOXPdNS+Qs6t1GwrgYhWT5EbtORJwYMzSrDPf8oAxv7ndNBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKOXPdNS+Qs6t1GwrgYhWT5EbtORJwYMzSrDPf8oAxv7ndNBg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 11, 2018 at 03:15:53PM +0100, Krzysztof Kozlowski wrote:
> Hi,
> 
> Bisect from today's next pointed me to:
> commit 4de97efb578a094e8fbf279522d41eb9ece1e3e0
> Author: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Date:   Sat Dec 8 12:21:43 2018 +0530
>     fsverity: Move verity status check to fsverity_file_open
> 
> as a reason of "Operation not supported" when reading any file from
> mounted ext4fs (from SD card). Rootfs from nfsroot works but reading
> from /home with ext4fs fails.
> 
> Mounts:
> 192.168.1.10:/srv/nfs/odroidhc1 on / type nfs4
> (rw,relatime,vers=4.0,rsize=131072,wsize=131072,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.1.12,local_lock=none,addr=192.168.1.10)
> /dev/mmcblk0p2 on /home type ext4 (rw,relatime)
> 
> Configuration:
> 1. Arch ARM Linux
> 2. exynos_defconfig
>   - All my Odroid boards (ARMv7, Exynos)
>     Systemd: v239, v238
> 3. All boards boot from TFTP with NFS root (NFSv4)
> No specific errors in boot log:
> https://krzk.eu/#/builders/21/builds/1034/steps/12/logs/serial0
> 
> Let me know if you need any more data.
> 
> Best regards,
> Krzysztof

Thanks Krzysztof.  Ted, this is the same bug I pointed out in my review of this
patch yesterday (https://patchwork.kernel.org/patch/10719197/#22371523).  Can
you fix or revert the two broken patches?  Thanks,

- Eric
