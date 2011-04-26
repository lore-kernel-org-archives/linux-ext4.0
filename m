From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Tue, 26 Apr 2011 15:41:47 +0800
Message-ID: <BANLkTikJjHKchRTt3t2jW+O_1wba9v8jmg@mail.gmail.com>
References: <1303762999-20541-1-git-send-email-curtw@google.com>
	<4194C4D6-BE86-42CA-BBB4-A8A0E7E94EAC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org,
	jim@meyering.net, cmm@us.ibm.com, hughd@google.com, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57685 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab1DZHls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 03:41:48 -0400
Received: by pzk9 with SMTP id 9so117476pzk.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 00:41:48 -0700 (PDT)
In-Reply-To: <4194C4D6-BE86-42CA-BBB4-A8A0E7E94EAC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This function is only called from write path which flushes pages to
disk,  actually, pages' state have been set right at time when
write_end() is called.  Why did we handle pages' state in this
function?


On Tue, Apr 26, 2011 at 6:40 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-04-25, at 2:23 PM, Curt Wohlgemuth wrote:
>> In the bio completion routine, we should not be setting
>> PageUptodate at all -- it's set at sys_write() time, and is
>> unaffected by success/failure of the write to disk.
>>
>> This can cause a page corruption bug when
>>
>> =A0 =A0block size < page size
>>
>> @@ -203,46 +203,29 @@ static void ext4_end_bio(struct bio *bio, int =
error)
>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* If this is a partial write which happ=
ened to make
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* all buffers uptodate then we can opti=
mize away a
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* bogus readpage() for the next read().=
 Here we
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* 'discover' whether the page went upto=
date as a
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* result of this (potentially partial) =
write.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!partial_write)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
>> -
>
> I think this is the important part of the code - if there is a read-a=
fter-write for a file that was written in "blocksize" units (blocksize =
< pagesize), does the page get set uptodate when all of the blocks have=
 been written and/or the writing is at EOF? =A0Otherwise, a read-after-=
write will always cause data to be fetched from disk needlessly, even t=
hough the uptodate information is already in cache.
>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
