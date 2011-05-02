From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Need of revoke mechanism in JBD
Date: Mon, 2 May 2011 13:42:48 +0300
Message-ID: <BANLkTimaR0n-YmtBe6xWKCkOc+PoBNa72w@mail.gmail.com>
References: <4DB68257.4070407@gmail.com>
	<BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
	<BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
	<20110426122558.GF9486@thunk.org>
	<BANLkTin35yOg+ndy3i4vTT7RHxtFso+HCA@mail.gmail.com>
	<20110501222813.GD2819@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ding Dinghua <dingdinghua85@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Niraj Kulkarni <kulkarniniraj14@gmail.com>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58571 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab1EBKmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 06:42:51 -0400
Received: by eyx24 with SMTP id 24so1695882eyx.19
        for <linux-ext4@vger.kernel.org>; Mon, 02 May 2011 03:42:50 -0700 (PDT)
In-Reply-To: <20110501222813.GD2819@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 2, 2011 at 1:28 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Apr 29, 2011 at 10:45:23PM +0300, Amir Goldstein wrote:
>>
>> Actually, the original paper has no mention of revoke records.
>> I went out to look for useful documentation on journal forget/revoke
>> and came back empty handed as well.
>
> Stephen Tweedie gave a talk back in 2000 which covered revoke records=
=2E
> There's a transcript of his talk here:
>
> http://olstrans.sourceforge.net/release/OLS2000-ext3/OLS2000-ext3.htm=
l
>
> The link to the audio file of the talk is dead, but I managed to find
> a copy of the mp3 file on Google. =A0To make sure it doesn't get lost
> I've made a copy of it. =A0The original and the copy can be found at:
>
> http://ftp.gnumonks.org/pub/congress-talks/ols2000/high/cd1/2000-07-2=
0_15-05-22_A_64.mp3
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/presentations/2000=
-07-20_15-05-22_A_64.mp3
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

Thanks for that! It was an interesting read, a little piece of history =
for me.

Clearly, at the time of this talk, revoke code was still on the design =
table
and committed_data is not mentioned, so either it was not introduced ye=
t
or just wasn't in the scope of the talk.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
