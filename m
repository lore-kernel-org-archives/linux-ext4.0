From: Sven Joachim <svenjoac@gmx.de>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Wed, 07 Dec 2016 19:34:17 +0100
Message-ID: <8760mv4mhi.fsf@turtle.gmx.de>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net>
        <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca>
        <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net>
        <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca>
        <53212988-1445-45A4-B56F-0F240013B64C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Renaud Mariana <rmariana@online.net>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        debian-dpkg@lists.debian.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64263 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932192AbcLGSeZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Dec 2016 13:34:25 -0500
In-Reply-To: <53212988-1445-45A4-B56F-0F240013B64C@dilger.ca> (Andreas
        Dilger's message of "Wed, 7 Dec 2016 11:16:42 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2016-12-07 11:16 -0700, Andreas Dilger wrote:

> Add debian-dpkg mailing list to CC.
>
> On Dec 7, 2016, at 10:58 AM, Andreas Dilger <adilger@dilger.ca> wrote:
>> 
>> On Dec 7, 2016, at 2:52 AM, Renaud Mariana <rmariana@online.net> wrote:
>>> 
>>> Here are my answers, hope it will help solve this issue, thanks.
>>> 
>>> Recap:
>>> dpkg kibana on ext4 over a nbd device takes 10 minutes
>>> with xfs it's only 30s.
>>> with ext4 no extends only 30s.
>>> 
>>> 
>>> kernels :
>>> 4.5.7 has this issue as older kernel like 4.4.34
>>> The issue is also when nbd client & server run on same host
>>> 
>>> 
>>> How small are the files?
>>> here is the histogram of file sizes : http://pasteboard.co/6HC3nKyk2.png
>>> We can see 5000 files around 512 Bytes.
>> 
>> Definitely there is no value to use fallocate for 512-byte files, or any
>> of the files that can be written in a single write() syscall.  I'd expect
>> any reasonable tool to be using a write buffer of at least 2-4MB these
>> days to get good performance, so writes below the buffer size shouldn't
>> use fallocate() at all.

It should be noted that the latest dpkg (1.18.15) only uses fallocate
for files which are at least 16 KiB in size[1], so it would be nice if
Renaud could recheck with that version, or cherry-pick the patch into
whatever version he uses.

>>> dpkg using fallocate() ?
>>> Yes, there are 16044 calls by the same process
>>> what are these uninitialized extents ?
>> 
>> Uninitialized extents are preallocated ranges of a file on disk that will
>> read back as zero, but are not necessarily zero-filled at allocation time.
>> For large files that are written randomly (or written slowly and may have
>> contention from other writers) fallocate() + uninitialized extents will
>> preallocate the space for the file so that it is (largely) contiguous on
>> disk and overwrites will not result in random block allocation.

Cheers,
       Sven


1. https://anonscm.debian.org/cgit/dpkg/dpkg.git/commit/?id=a971ad91437af8880cad4703695dcf12ee45959b
