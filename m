Return-Path: <SRS0=cNy7=PF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45872 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732266AbeL1Lx1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Dec 2018 06:53:27 -0500
Received: by mail-qt1-f194.google.com with SMTP id e5so23076809qtr.12
        for <linux-ext4@vger.kernel.org>; Fri, 28 Dec 2018 03:53:26 -0800 (PST)
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
To: Florian Weimer <fw@deneb.enyo.de>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, libc-alpha@sourceware.org,
        qemu-devel@nongnu.org, ericvh@gmail.com, rminnich@sandia.gov,
        lucho@ionkov.net, hpa@zytor.com, arnd@arndb.de
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
 <957967d7-5717-8ada-fb30-dfdf19898b6b@linaro.org>
 <87pntmu9iw.fsf@mid.deneb.enyo.de>
From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Message-ID: <ae0530c9-5c46-5560-9734-1eacaf173b8d@linaro.org>
Date: Fri, 28 Dec 2018 09:53:21 -0200
MIME-Version: 1.0
In-Reply-To: <87pntmu9iw.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 27/12/2018 16:09, Florian Weimer wrote:
> * Adhemerval Zanella:
> 
>> Also for glibc standpoint, although reverting it back to use getdents 
>> syscall for non-LFS mode might fix this issue for architectures that
>> provides non-LFS getdents syscall it won't be a fix for architectures 
>> that still provides off_t different than off64_t *and* only provides 
>> getdents64 syscall.
>>
>> Currently we only have nios2 and csky (unfortunately).  But since generic 
>> definition for off_t and off64_t still assumes non-LFS support, all new
>> 32-bits ports potentially might carry the issue.
> 
> For csky, we could still change the type of the non-standard d_off
> field to long long int.  This way, only telldir would have to fail
> when truncation is necessary, as mentioned below:

I think it makes no sense to continue making non-LFS as default for
newer 32 bits ports, the support will be emulated with LFS syscalls.
