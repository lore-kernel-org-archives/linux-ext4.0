From: "Mattthew L. Martin" <linux@clearskydata.com>
Subject: Re: Significant difference in 'file size' and 'disk usage' for single
 files
Date: Mon, 6 Nov 2017 10:35:54 -0500
Message-ID: <07f4b566-7ec5-6d36-74bb-d41b694b3194@clearskydata.com>
References: <472fde11-654a-4826-0256-46149e90216e@web.de>
 <d2136540-6e7c-9e19-1ba4-fbf304b63362@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: mfe555 <mfe555@web.de>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:43166 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753470AbdKFPf4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Nov 2017 10:35:56 -0500
Received: by mail-qt0-f177.google.com with SMTP id j58so11415535qtj.0
        for <linux-ext4@vger.kernel.org>; Mon, 06 Nov 2017 07:35:56 -0800 (PST)
In-Reply-To: <d2136540-6e7c-9e19-1ba4-fbf304b63362@web.de>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I filed a bug for this a while ago:

https://bugzilla.kernel.org/show_bug.cgi?id=151491

We would be happy to help track this down as it is a pain to manage this 
on running servers.

Matthew


On 11/5/17 06:16, mfe555 wrote:
> Some follow-up:
>
> The issue only occurs with "bigalloc" enabled.
>
>     echo 3 > /proc/sys/vm/drop_caches
>
> seems to detach the blocked disk space from the files (so that 'du 
> file' no longer includes the offset), but it does not free the space, 
> 'df' still shows all file overheads as used disk space.
>
>
>
> Am 02.11.2017 um 20:17 schrieb mfe555:
>> Hi, I'm using ext4 on a Linux based Enigma2 set-top box, kernel 4.8.3.
>>
>> When creating a fresh file, there is a significant difference in file 
>> size (ls -la) and disk usage (du). When making two copies of the file ..
>>
>> gbquad:/hdd/test# cp file file.copy1
>> gbquad:/hdd/test# cp file file.copy2
>> gbquad:/hdd/test# ls -la
>> -rw-------    1 root     root     581821460 Nov  1 18:52 file
>> -rw-------    1 root     root     581821460 Nov  1 18:56 file.copy1
>> -rw-------    1 root     root     581821460 Nov  1 18:57 file.copy2
>> gbquad:/hdd/test# du *
>> 607232  file
>> 658176  file.copy1
>> 644864  file.copy2
>>
>> ... all three files show an overhead in the ~10% range, and the 
>> overhead is different for these files although their md5sums are equal.
>>
>> When deleting a file (rm), the overhead remains occupied on the disk. 
>> For example, after deleting "file", "df" reports approx. 581821460 
>> more bytes free, not 607232 kbytes more free space. The overhead 
>> (607232 kB - 581821460 B =pprox. 39 MB) remains blocked.
>>
>> When re-booting, the blocked space becomes free again, and in 
>> addition the overhead of those files that were not deleted also 
>> disappears, so that after a reboot the'file size' and 'disk usage' 
>> match for all files (except for rounding up to some block size).
>>
>> A colleague and I have observed this on two different "kernel 4.8.3" 
>> boxes and three ext4 disks, but not on a "kernel 3.14" box also using 
>> ext4.
>>
>> Can anyone help me with this ?
>>
>> Thanks a lot
>> Lukas
>>
>
