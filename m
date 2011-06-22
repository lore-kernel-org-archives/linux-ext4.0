From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Help required for Debugging JBD
Date: Wed, 22 Jun 2011 22:29:28 +0300
Message-ID: <BANLkTimps6FyqNNUXFg2D6iAkFkLrKORMg@mail.gmail.com>
References: <4E00CC36.80707@gmail.com>
	<BANLkTimhig+_Lb52KMcRyk5S4YQcdYozVg@mail.gmail.com>
	<4E02342E.4060203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51380 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab1FVT33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 15:29:29 -0400
Received: by wwe5 with SMTP id 5so1180033wwe.1
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jun 2011 12:29:28 -0700 (PDT)
In-Reply-To: <4E02342E.4060203@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 22, 2011 at 9:27 PM, Niraj Kulkarni
<kulkarniniraj14@gmail.com> wrote:
> Hi,
> =A0 =A0 Thanks for that SysRq tip. Now I am able to get some logs.
>
> From OOPS message, it showed an assertion failure on
> =A0 =A0J_ASSERT_JH(jh, jh->b_transaction =3D=3D journal->j_committing=
_transaction);
>
> In my code, I've modified journal_commit_transaction such that it col=
lects
> all buffer_head in a linked list, with their corresponding
> buffer numbers in other list.
> =A0 =A0 I collect all buffers (data + metadata ) and push them all
> simultaneously and pass list of block numbers through a special ioctl=
 call.
>
> The problem that I see in my code is that all buffers are handled in =
same
> way as all data buffers in original code. ie metadata buffers are
> getting unfiled instead of refiling.

I am not sure what you are saying, but it sounds bad.
data buffers and metadata buffers are handled very differently.

>
> I am attaching my patch. Please can you see and check if that indeed =
is
> problem here?
>

JBD is one complicated piece of work (to me), so even if I do find time
to review your patch, it's not going to be easy for me.

> Also what can be possible solution to it? separation of buffers in 2 =
list
> (data, metadata) and handling them separately?
>

Without looking at your patches, I have a lead for you.
Lookup the "Journal guided RAID resync" patches.
They do something similar to what you describe, for a different purpose=
,
but they also maintain a list of data blocks and yes, they deal with th=
em
separately.
These patches have been already tested, so they used to be in good shap=
e,
but are not uptodate.

Good luck,
Amir.

> (Being a kernel noob, my coding does not conform to any standard. So =
please
> point out any blunders I've committed in my patch)
>
> Thank You
> Niraj
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
