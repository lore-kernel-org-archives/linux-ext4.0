From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v3] xfstests:Make 225 compare map and fiemap at each block.
Date: Tue, 24 May 2011 10:42:23 +0800
Message-ID: <BANLkTikWgG2E1EYcm+B2zxBCY=KH-Rb0Dw@mail.gmail.com>
References: <1306134423-10028-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110524015105.GE32466@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sandeen@redhat.com, josef@redhat.com, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43676 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1EXCmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 22:42:24 -0400
Received: by vxi39 with SMTP id 39so4596723vxi.19
        for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 19:42:23 -0700 (PDT)
In-Reply-To: <20110524015105.GE32466@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you for your review.
On Tue, May 24, 2011 at 9:51 AM, Dave Chinner <david@fromorbit.com> wro=
te:
> On Mon, May 23, 2011 at 03:07:03PM +0800, Yongqiang Yang wrote:
>> Due to my carelessness, =A0I induced a ugly patch to ext4's fiemap, =
as a result
>> delayed-extents that did not start at the head block of a page was i=
gnored
>> in ext4 with 1K block, but 225 could not find it.
>
> When ext4 is using 1k block sizes, fiemap-tester does not find
> problems that may exist on ext4 with delayed allocation extents on
> the first block of a page.
>
>> So I looked into the 225
>> and could not figure out logic in compare_map_and_fiemap(), which se=
emed to
>> mix extents with blocks.
>
> Once again, "I don't understand it" is not a reason for a whoelsale
> rewrite.
>
>> Then I made 225 compare map and fiemap at each block,
>> the new 225 can find the bug I induced and another bug in ext4 with =
1k block,
>> which ignored delayed-extents after a hole, which did not start at t=
he head
>> block of a page.
>
> Which means that the first paragraph should read:
>
> "When ext4 is using 1k block sizes, fiemap-tester does not find
> problems that may exist on ext4 with delayed allocation extents on
> the first block of a page or directly after a hole."
>
> That's a concise description of the overall problem you are fixing
> in this patch. Next you need to describe the different changes being
> made in the patch and the bugs they are fixing. =A0There appear to be=
:
>
> =A0 =A0 =A0 =A0- an off-by one in map array allocation
> =A0 =A0 =A0 =A0- zeroing the end block in the map array
> =A0 =A0 =A0 =A0- making check_weird_fs_hole() verify bytes read by pr=
ead()
> =A0 =A0 =A0 =A0- moving truncate/seek of the test file around
> =A0 =A0 =A0 =A0- changing the way map/fiemap are compared
Yes, thank you.
>
> Also, you haven't addressed any of the comments I made in my
> original review:
>
> =A0 =A0 =A0 =A0- removing the changelog from the header comment
The change is large, so I think  it's convenient for others to leave
an e-mail in the file in case that they have some questions.   e.g.  I
should cc to josef this time.  If you don't think it is necessary, I
will remove it.

> =A0 =A0 =A0 =A0- adding comments on check_data/check_hole explaining =
what
> =A0 =A0 =A0 =A0 =A0they are checking
Sorry, I will adding comments in later version.
> =A0 =A0 =A0 =A0- explaining why the existing map/fiemap compare could=
n't
> =A0 =A0 =A0 =A0 =A0detect the problems with delayed extents on ext4? =
i.e.
> =A0 =A0 =A0 =A0 =A0what's the bug that you are fixing so we can deter=
mine if
> =A0 =A0 =A0 =A0 =A0it really does need a rewrite to fix?
I will try to figure it out.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
