From: Renaud Mariana <rmariana@online.net>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Thu, 8 Dec 2016 14:14:01 +0100 (CET)
Message-ID: <1374656539.9149859.1481202841260.JavaMail.zimbra@online.net>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net> <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca> <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net> <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca> <53212988-1445-45A4-B56F-0F240013B64C@dilger.ca> <8760mv4mhi.fsf@turtle.gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        debian-dpkg@lists.debian.org
To: Sven Joachim <svenjoac@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.online.net ([62.210.16.11]:45414 "EHLO mail.online.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752986AbcLHNOH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Dec 2016 08:14:07 -0500
In-Reply-To: <8760mv4mhi.fsf@turtle.gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

Thanks Sven for this link

This slowdown is related to an old issue :
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=824636
but amplified by the nbd layer (tcp massive zero writes)

I quote the fix:
Ftrace showed that the delay is caused by sb_issue_zeroout() in
ext4_ext_zeroout() called by ext4_ext_convert_to_initialized(). This
call chain is initially triggered by fallocate().
this can be disabled using the max_zeroout parameter.
echo 0 > /sys/fs/ext4/sdb2/extent_max_zeroout_kb

in my case echo 3 > /sys/fs/ext4/nbd0/extent_max_zeroout_kb
seems sufficient for dpkg and may be other intensive fallocate applications ?
dpkg time is then reduced to an acceptable time of 20s.

Is there any recommendations / warnings with this value extent_max_zeroout_kb = 3 ?

Cheers Renaud

