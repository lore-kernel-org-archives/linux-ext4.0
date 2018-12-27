Return-Path: <SRS0=rhwh=PE=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from albireo.enyo.de ([5.158.152.32]:48678 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbeL0SJO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 27 Dec 2018 13:09:14 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, libc-alpha@sourceware.org,
        qemu-devel@nongnu.org, ericvh@gmail.com, rminnich@sandia.gov,
        lucho@ionkov.net, hpa@zytor.com, arnd@arndb.de
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
        <957967d7-5717-8ada-fb30-dfdf19898b6b@linaro.org>
Date: Thu, 27 Dec 2018 19:09:11 +0100
In-Reply-To: <957967d7-5717-8ada-fb30-dfdf19898b6b@linaro.org> (Adhemerval
        Zanella's message of "Thu, 27 Dec 2018 15:58:47 -0200")
Message-ID: <87pntmu9iw.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Adhemerval Zanella:

> Also for glibc standpoint, although reverting it back to use getdents 
> syscall for non-LFS mode might fix this issue for architectures that
> provides non-LFS getdents syscall it won't be a fix for architectures 
> that still provides off_t different than off64_t *and* only provides 
> getdents64 syscall.
>
> Currently we only have nios2 and csky (unfortunately).  But since generic 
> definition for off_t and off64_t still assumes non-LFS support, all new
> 32-bits ports potentially might carry the issue.

For csky, we could still change the type of the non-standard d_off
field to long long int.  This way, only telldir would have to fail
when truncation is necessary, as mentioned below:

>> There is another annoying aspect: The standards expose d_off through
>> the telldir function, and that returns long int on all architectures
>> (not off_t, so unchanged by _FILE_OFFSET_BITS).  That's mostly a
>> userspace issue and thus needing different steps to resolve (possibly
>> standards action).
