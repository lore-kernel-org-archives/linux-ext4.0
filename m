From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Mon, 25 Apr 2011 15:45:59 -0700
Message-ID: <BANLkTim0_yS_zHEs9sksFq4u_FFEHGO+7g@mail.gmail.com>
References: <1303762999-20541-1-git-send-email-curtw@google.com>
	<4194C4D6-BE86-42CA-BBB4-A8A0E7E94EAC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, jim@meyering.net, cmm@us.ibm.com,
	hughd@google.com, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29714 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1DYWqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 18:46:03 -0400
Received: from kpbe16.cbf.corp.google.com (kpbe16.cbf.corp.google.com [172.25.105.80])
	by smtp-out.google.com with ESMTP id p3PMk1Bc029599
	for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 15:46:01 -0700
Received: from qwc9 (qwc9.prod.google.com [10.241.193.137])
	by kpbe16.cbf.corp.google.com with ESMTP id p3PMjY09023605
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 15:46:00 -0700
Received: by qwc9 with SMTP id 9so45958qwc.13
        for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 15:45:59 -0700 (PDT)
In-Reply-To: <4194C4D6-BE86-42CA-BBB4-A8A0E7E94EAC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas:

On Mon, Apr 25, 2011 at 3:40 PM, Andreas Dilger <adilger@dilger.ca> wro=
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

Hmm, that's a good question.  I would kind of doubt that the page
would be marked uptodate when the final block was written, and this
might be what the code above was trying to do.  It wasn't doing it
correctly :-), but it might have possibly avoided the extra read when
it there was no error.

I'll look at this some more, and see if I can't test for your scenario
above.  Perhaps at least checking that all BHs in the page are mapped
+ uptodate =3D> SetPageUptodate would not be out of line.

Thanks,
Curt



>
> Cheers, Andreas
>
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
