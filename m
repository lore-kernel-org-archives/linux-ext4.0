Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37637 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbfABNQo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2019 08:16:44 -0500
Received: by mail-qk1-f195.google.com with SMTP id g125so17791675qke.4
        for <linux-ext4@vger.kernel.org>; Wed, 02 Jan 2019 05:16:43 -0800 (PST)
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
To: Joseph Myers <joseph@codesourcery.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        libc-alpha@sourceware.org, qemu-devel@nongnu.org, ericvh@gmail.com,
        rminnich@sandia.gov, lucho@ionkov.net, hpa@zytor.com, arnd@arndb.de
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
 <957967d7-5717-8ada-fb30-dfdf19898b6b@linaro.org>
 <87pntmu9iw.fsf@mid.deneb.enyo.de>
 <ae0530c9-5c46-5560-9734-1eacaf173b8d@linaro.org>
 <alpine.DEB.2.21.1812311657050.27287@digraph.polyomino.org.uk>
From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Message-ID: <a5092631-2ddf-1790-5f27-777646ef3d34@linaro.org>
Date: Wed, 2 Jan 2019 11:16:37 -0200
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1812311657050.27287@digraph.polyomino.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 31/12/2018 15:03, Joseph Myers wrote:
> On Fri, 28 Dec 2018, Adhemerval Zanella wrote:
> 
>>>> Currently we only have nios2 and csky (unfortunately).  But since generic 
>>>> definition for off_t and off64_t still assumes non-LFS support, all new
>>>> 32-bits ports potentially might carry the issue.
>>>
>>> For csky, we could still change the type of the non-standard d_off
>>> field to long long int.  This way, only telldir would have to fail
>>> when truncation is necessary, as mentioned below:
>>
>> I think it makes no sense to continue making non-LFS as default for
>> newer 32 bits ports, the support will be emulated with LFS syscalls.
> 
> Any new 32-bit port that uses 64-bit time_t will also use 64-bit offsets 
> (because we don't have any glibc configurations that support the 
> combination of 64-bit time with 32-bit offsets, and don't want to add 
> them).  That should apply for RISC-V 32-bit at least.
> 
> I've filed <https://sourceware.org/bugzilla/show_bug.cgi?id=24050> for 
> missing overflow checks in telldir when the default off_t is wider than 
> long int (currently just applies to x32; not sure why we don't see glibc 
> test failures on x32 resulting from the quiet truncation, as the issue is 
> certainly there in the source code).
> 

What about csky? Should we still make it use 32-bit offsets as default
configuration even when kernel does not support it natively?
