From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH REC 0/3] ext4:Factor common code from convert and split unwritten.
Date: Thu, 14 Apr 2011 22:34:38 +0800
Message-ID: <BANLkTim9okgKc1omQ5dAvTHDrhfA_bpODw@mail.gmail.com>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110414141424.GG3682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	cmm@us.ibm.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:35136 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab1DNOej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 10:34:39 -0400
Received: by pxi2 with SMTP id 2so960603pxi.10
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 07:34:38 -0700 (PDT)
In-Reply-To: <20110414141424.GG3682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2011 at 10:14 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 13, 2011 at 10:40:48PM -0700, Yongqiang Yang wrote:
>> These patches factor common code from ext4_ext_convert_to_initialize=
d() and
>> ext4_split_unwritten_extents(), so that extent-move-on-write in snap=
shot and
>> punch-hole can be built on the common code as well.
>>
>> ext4:Add a function merging extent right and left.
>> ext4:Add two functions splitting an extent.
>> ext4:Reimplement convert and split_unwritten.
>
> Hi Yongqiang,
>
> I'd like to hear back from Mingming and Allison about whether these
> patches conflict with their punch patches, since my understanding was
> they were planning on doing very similar things (and at least would b=
e
> working in the very similar parts of the code).
>
> I agree that the extents code here could definitely use this cleanup,
> and I'm really glad that you worked on this; thank you! =A0I just wan=
t
> to make sure work you are doing is coordinated with the work that
> Allison and Mingming are working on.

I knew it and Mingming told me that common code should be factor out
in previous emails.  so I cced patches to Mingming and Allison.
extent-move-on-write in ext4-snapshots needs a function splitting an
initialized extent.

These patches indeed need advices, reviews  and even tests from
Mingming and Allison.

Thank you,
Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
