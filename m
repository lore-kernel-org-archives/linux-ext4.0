From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Mon, 25 Apr 2011 16:20:42 -0700
Message-ID: <BANLkTikA83YP4p3JL=SFqNAnNzvPSaC7Bg@mail.gmail.com>
References: <1303762999-20541-1-git-send-email-curtw@google.com>
	<4194C4D6-BE86-42CA-BBB4-A8A0E7E94EAC@dilger.ca>
	<BANLkTim0_yS_zHEs9sksFq4u_FFEHGO+7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, jim@meyering.net, cmm@us.ibm.com,
	hughd@google.com, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:38107 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1DYXU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 19:20:58 -0400
Received: from hpaq12.eem.corp.google.com (hpaq12.eem.corp.google.com [172.25.149.12])
	by smtp-out.google.com with ESMTP id p3PNKqeL029185
	for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 16:20:52 -0700
Received: from qyk7 (qyk7.prod.google.com [10.241.83.135])
	by hpaq12.eem.corp.google.com with ESMTP id p3PNKkgb002379
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 16:20:47 -0700
Received: by qyk7 with SMTP id 7so1169619qyk.5
        for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2011 16:20:43 -0700 (PDT)
In-Reply-To: <BANLkTim0_yS_zHEs9sksFq4u_FFEHGO+7g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi again Andreas:

On Mon, Apr 25, 2011 at 3:45 PM, Curt Wohlgemuth <curtw@google.com> wro=
te:
> Hi Andreas:
>
> On Mon, Apr 25, 2011 at 3:40 PM, Andreas Dilger <adilger@dilger.ca> w=
rote:
>> On 2011-04-25, at 2:23 PM, Curt Wohlgemuth wrote:
>>> In the bio completion routine, we should not be setting
>>> PageUptodate at all -- it's set at sys_write() time, and is
>>> unaffected by success/failure of the write to disk.
>>>
>>> This can cause a page corruption bug when
>>>
>>> =A0 =A0block size < page size
>>>
>>> @@ -203,46 +203,29 @@ static void ext4_end_bio(struct bio *bio, int=
 error)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* If this is a partial write which hap=
pened to make
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* all buffers uptodate then we can opt=
imize away a
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* bogus readpage() for the next read()=
=2E Here we
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* 'discover' whether the page went upt=
odate as a
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* result of this (potentially partial)=
 write.
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!partial_write)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page);
>>> -
>>
>> I think this is the important part of the code - if there is a read-=
after-write for a file that was written in "blocksize" units (blocksize=
 < pagesize), does the page get set uptodate when all of the blocks hav=
e been written and/or the writing is at EOF? =A0Otherwise, a read-after=
-write will always cause data to be fetched from disk needlessly, even =
though the uptodate information is already in cache.
>
> Hmm, that's a good question. =A0I would kind of doubt that the page
> would be marked uptodate when the final block was written, and this
> might be what the code above was trying to do. =A0It wasn't doing it
> correctly :-), but it might have possibly avoided the extra read when
> it there was no error.
>
> I'll look at this some more, and see if I can't test for your scenari=
o
> above. =A0Perhaps at least checking that all BHs in the page are mapp=
ed
> + uptodate =3D> SetPageUptodate would not be out of line.

My testing is now showing the read coming through after writing to the
4 blocks of a 4K file, using 1K blocksize.  And it seems to me that
this is taken care of in __block_commit_write(), which is called from
all the .write_end callbacks for ext4, at least.

Thanks,
Curt

>
> Thanks,
> Curt
>
>
>
>>
>> Cheers, Andreas
>>
>>
>>
>>
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
