From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Tue, 26 Apr 2011 08:37:19 -0700
Message-ID: <BANLkTikKNY4ksntoxVEEyTAhKOC-ymng8A@mail.gmail.com>
References: <1303762999-20541-1-git-send-email-curtw@google.com>
	<4194C4D6-BE86-42CA-BBB4-A8A0E7E94EAC@dilger.ca>
	<BANLkTim0_yS_zHEs9sksFq4u_FFEHGO+7g@mail.gmail.com>
	<BANLkTikA83YP4p3JL=SFqNAnNzvPSaC7Bg@mail.gmail.com>
	<EBD186D7-7A9A-4EA4-AB05-D1E9CF2D5006@dilger.ca>
	<BANLkTi=K=ui2oyB_+H77Kkb=NXW+7MjY1A@mail.gmail.com>
	<BANLkTinuX21XfDCsrH0M8htB6Nkzo4kO=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	jim@meyering.net, cmm@us.ibm.com, hughd@google.com, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:56579 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1DZPhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 11:37:24 -0400
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id p3QFbLXr031182
	for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 08:37:21 -0700
Received: from qwi4 (qwi4.prod.google.com [10.241.195.4])
	by wpaz13.hot.corp.google.com with ESMTP id p3QFarC8001583
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 08:37:20 -0700
Received: by qwi4 with SMTP id 4so755821qwi.1
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 08:37:19 -0700 (PDT)
In-Reply-To: <BANLkTinuX21XfDCsrH0M8htB6Nkzo4kO=A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 25, 2011 at 11:59 PM, Yongqiang Yang <xiaoqiangnk@gmail.com=
> wrote:
> On Tue, Apr 26, 2011 at 12:32 PM, Curt Wohlgemuth <curtw@google.com> =
wrote:
>> On Mon, Apr 25, 2011 at 5:58 PM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>> On 2011-04-25, at 5:20 PM, Curt Wohlgemuth wrote:
>>>> On Mon, Apr 25, 2011 at 3:45 PM, Curt Wohlgemuth <curtw@google.com=
> wrote:
>>>>> On Mon, Apr 25, 2011 at 3:40 PM, Andreas Dilger <adilger@dilger.c=
a> wrote:
>>>>>> On 2011-04-25, at 2:23 PM, Curt Wohlgemuth wrote:
>>>>>>> In the bio completion routine, we should not be setting
>>>>>>> PageUptodate at all -- it's set at sys_write() time, and is
>>>>>>> unaffected by success/failure of the write to disk.
>>>>>>>
>>>>>>> This can cause a page corruption bug when
>>>>>>>
>>>>>>> =A0 =A0block size < page size
>>>>>>>
>>>>>>> @@ -203,46 +203,29 @@ static void ext4_end_bio(struct bio *bio,=
 int error)
>>>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>>>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* If this is a partial write which=
 happened to make
>>>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* all buffers uptodate then we can=
 optimize away a
>>>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* bogus readpage() for the next re=
ad(). Here we
>>>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* 'discover' whether the page went=
 uptodate as a
>>>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* result of this (potentially part=
ial) write.
>>>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!partial_write)
>>>>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(page)=
;
>>>>>>> -
>>>>>>
>>>>>> I think this is the important part of the code - if there is a r=
ead-after-write for a file that was written in "blocksize" units (block=
size < pagesize), does the page get set uptodate when all of the blocks=
 have been written and/or the writing is at EOF? =A0Otherwise, a read-a=
fter-write will always cause data to be fetched from disk needlessly, e=
ven though the uptodate information is already in cache.
>>>>>
>>>>> Hmm, that's a good question. =A0I would kind of doubt that the pa=
ge
>>>>> would be marked uptodate when the final block was written, and th=
is
>>>>> might be what the code above was trying to do. =A0It wasn't doing=
 it
>>>>> correctly :-), but it might have possibly avoided the extra read =
when
>>>>> it there was no error.
>>>>>
>>>>> I'll look at this some more, and see if I can't test for your sce=
nario
>>>>> above. =A0Perhaps at least checking that all BHs in the page are =
mapped
>>>>> + uptodate =3D> SetPageUptodate would not be out of line.
>>>>
>>>> My testing is now showing the read coming through after writing to=
 the
>>>> 4 blocks of a 4K file, using 1K blocksize.
>>>
>>> Sorry, but could you please clarify? =A0Does "read coming through" =
mean that there is an IO sent to the disk, or that the page is uptodate=
 and the read is handled from the page cache?
>>
>> Wow, even I don't understand what I wrote above...
>>
>> What I meant to write was: =A0In my experiments, I do *not* see a re=
ad
>> going down to disk after the writes for the individual blocks. =A0I
>> basically did this:
>>
>> ---------------------------
>> dd if=3D/dev/zero of=3Dbar bs=3D1k count=3D1 seek=3D3 conv=3Dnotrunc
>> dd if=3D/dev/zero of=3Dbar bs=3D1k count=3D1 seek=3D0 conv=3Dnotrunc
>> dd if=3D/dev/zero of=3Dbar bs=3D1k count=3D1 seek=3D1 conv=3Dnotrunc
>> dd if=3D/dev/zero of=3Dbar bs=3D1k count=3D1 seek=3D2 conv=3Dnotrunc
>>
>> sync
> try to evict all cache pages
> echo 1 > proc/sys/vm/drop_caches

But this won't prove anything.  Andreas was worried about an
extraneous read from disk when the page in the page cache was in fact
up to date.  If we evict the page cache, then we *better* read from
disk...

Curt

>
>>
>> dd if=3Dbar of=3Dfoo bs=3D1k count=3D4
>> ---------------------------
>>
>>>
>>>> =A0And it seems to me that
>>>> this is taken care of in __block_commit_write(), which is called f=
rom
>>>> all the .write_end callbacks for ext4, at least.
>>>
>>> It does indeed look like that should be handling this case. =A0It w=
ould be good to verify that this is still true with your patch, just in=
 case theory and reality don't align.
>>
>> I see the same *non-read from disk* with 1k blocks both with my patc=
h,
>> and with a vanilla kernel.
>>
>> Thanks,
>> Curt
>>
>>>
>>> Cheers, Andreas
>>>
>>>
>>>
>>>
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
