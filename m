From: Greg Harmon <gharm@google.com>
Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
Date: Fri, 22 Mar 2013 15:19:39 -0700
Message-ID: <CABFC-fPe3Kw+pvcddR_0+8BDTDkV+XfcyUOGZn9BO2Xs=iM8bQ@mail.gmail.com>
References: <1363881045-21673-1-git-send-email-lczerner@redhat.com>
 <877gl0yc2k.fsf@openvz.org> <CABFC-fO3HrWFXJhyPMPKRy6Up3vGp_JUQs_VJGRyXwph1M95Cw@mail.gmail.com>
 <514cb91d.8a48340a.33fd.ffff9fa3SMTPIN_ADDED_BROKEN@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:48874 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422924Ab3CVWUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2013 18:20:21 -0400
Received: by mail-ve0-f181.google.com with SMTP id pa12so2153271veb.40
        for <linux-ext4@vger.kernel.org>; Fri, 22 Mar 2013 15:20:21 -0700 (PDT)
In-Reply-To: <514cb91d.8a48340a.33fd.ffff9fa3SMTPIN_ADDED_BROKEN@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 22, 2013 at 1:03 PM, Luk=C3=A1=C5=A1 Czerner <lczerner@redh=
at.com> wrote:
> On Fri, 22 Mar 2013, Greg Harmon wrote:
>
>> Date: Fri, 22 Mar 2013 10:10:46 -0700
>> From: Greg Harmon <gharm@google.com>
>> To: Dmitry Monakhov <dmonakhov@openvz.org>
>> Cc: Lukas Czerner <lczerner@redhat.com>,
>>     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
>>     Theodore Ts'o <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com=
>
>> Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
>>
>> [Resending without html.]
>> I haven't looked at ext4 in awhile now. CC'ing Ted and Curt in case
>> they want to chime in. See comment below as well.
>>
>> On Thu, Mar 21, 2013 at 9:03 AM, Dmitry Monakhov <dmonakhov@openvz.o=
rg> wrote:
>> > On Thu, 21 Mar 2013 16:50:45 +0100, Lukas Czerner <lczerner@redhat=
=2Ecom> wrote:
>> >> Block requests from fallocate has been normalized originally. The=
n it was
>> >> changed by 556b27abf73833923d5cd4be80006292e1b31662 not to normal=
ize it.
>> >> And then it was changed by 3c6fe77017bc6ce489f231c35fed3220b66918=
36
>> >> again to normalize the request.
>> >>
>> >> The fact is that we _never_ want to normalize the request from
>> >> fallocate. We know exactly how much space we're going to use and =
we do
>> >> not want anyone to mess with the request and there is no point in=
 doing
>> >> so.
>> > Looks reasonable.
>> > Reviewed-by:Dmitry Monakhov <dmonakhov@openvz.org>
>> >>
>> >> Commit 3c6fe77017bc6ce489f231c35fed3220b6691836 mentioned that
>>
>> Is this a publicly available commit? I did not find it with a quick
>> google search.
>> Anyway, I don't see a problem with this commit off-hand, but I'll
>> defer to Ted or Curt.
>
> Yes it is publicly available (git show
> 3c6fe77017bc6ce489f231c35fed3220b6691836). I cc'ed you because you
> are the author of that commit and this one if effectively
> reverting it, so I was curious whether you have anything to say
> about it in case I've missed something.
>
> Thanks!

Not sure why I was having trouble finding those commits earlier;
(ec22ba8edb507395c95fbc617eea26a6b2d98797 is in git but not indexed on
google). Thanks for the notice.

-Greg

> -Lukas
>
>>
>> -Greg Harmon
>>
>> >> large fallocate requests were not physically contiguous. However =
it is
>> >> important to see why that is the case. Because the request is so =
big the
>> >> allocator will try to find free group to allocate from skipping b=
lock
>> >> groups which are used, which is fine. However it will only alloca=
te
>> >> extents of 2^15-1 block (limitation of uninitialized extent size)
>> >> which will leave one block in each block group free which will ma=
ke the
>> >> extent tree physically non-contiguous, however _only_ by one bloc=
k which
>> >> is perfectly fine.
>> >>
>> >> This will never happen when we normalize the request because for =
some
>> >> reason (maybe bug) it will be normalized to much smaller request =
(2048
>> >> blocks) and those extents will then be merged together not leavin=
g any
>> >> free block in between - hence physically contiguous. However the =
fact
>> >> that we're splitting huge requests into ton of smaller ones and t=
hen
>> >> merging extents together is very _very_ bad for fallocate perform=
ance.
>> >>
>> >> The situation is even worst since with commit
>> >> ec22ba8edb507395c95fbc617eea26a6b2d98797 we no longer merge
>> >> uninitialized extents so we end up with absolutely _huge_ extent =
tree
>> >> for bigger fallocate requests which is also bad for performance b=
ut not
>> >> only when fallocate itself, but even when working with the file
>> >> later on.
>> >>
>> >> Fix this by disabling normalization for fallocate. From my simple=
 testing
>> >> with this commit fallocate is much faster on non fragmented file
>> >> system. On my system fallocate 15T is almost 3x faster with this =
patch
>> >> and removing this file is almost 2x faster - tested on real hardw=
are.
>> >>
>> >> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> >> ---
>> >>  fs/ext4/extents.c |   18 ++++++++++--------
>> >>  1 files changed, 10 insertions(+), 8 deletions(-)
>> >>
>> >> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> >> index e2bb929..a40a602 100644
>> >> --- a/fs/ext4/extents.c
>> >> +++ b/fs/ext4/extents.c
>> >> @@ -4422,16 +4422,18 @@ long ext4_fallocate(struct file *file, in=
t mode, loff_t offset, loff_t len)
>> >>               trace_ext4_fallocate_exit(inode, offset, max_blocks=
, ret);
>> >>               return ret;
>> >>       }
>> >> -     flags =3D EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
>> >> -     if (mode & FALLOC_FL_KEEP_SIZE)
>> >> -             flags |=3D EXT4_GET_BLOCKS_KEEP_SIZE;
>> >> +
>> >>       /*
>> >> -      * Don't normalize the request if it can fit in one extent =
so
>> >> -      * that it doesn't get unnecessarily split into multiple
>> >> -      * extents.
>> >> +      * We do NOT want the requests from fallocate to be normali=
zed
>> >> +      * ever!. We know exactly how much we want to allocate and
>> >> +      * we do not need to do any mumbo-jumbo with it. Requests b=
igger
>> >> +      * than uninit extent size, will be divided automatically i=
nto
>> >> +      * biggest possible extents.
>> >>        */
>> >> -     if (len <=3D EXT_UNINIT_MAX_LEN << blkbits)
>> >> -             flags |=3D EXT4_GET_BLOCKS_NO_NORMALIZE;
>> >> +     flags =3D EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
>> >> +             EXT4_GET_BLOCKS_NO_NORMALIZE;
>> >> +     if (mode & FALLOC_FL_KEEP_SIZE)
>> >> +             flags |=3D EXT4_GET_BLOCKS_KEEP_SIZE;
>> >>
>> >>  retry:
>> >>       while (ret >=3D 0 && ret < max_blocks) {
>> >> --
>> >> 1.7.7.6
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
