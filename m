From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 1/5] jbd2: Pass extra bool parameter in journal routines
 to specify if its ok to fail the journal transaction allocation.
Date: Thu, 12 May 2011 23:37:05 -0700
Message-ID: <BANLkTikP3axXkZ=v8EbpbzyoeSeARZC_Ew@mail.gmail.com>
References: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com> <20110511155447.GH5057@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55092 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1EMGhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 May 2011 02:37:25 -0400
Received: by qwk3 with SMTP id 3so1137453qwk.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 23:37:25 -0700 (PDT)
In-Reply-To: <20110511155447.GH5057@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Thanks for your patient feedback.

On Wed, May 11, 2011 at 8:54 AM, Jan Kara <jack@suse.cz> wrote:
> =A0Hi,
>
> =A0sorry I got to your patches with a delay. One general note - pleas=
e do
> not attach patches. It is enough to have them in the email...
>
> On Sun 24-04-11 17:10:41, Manish Katiyar wrote:
>> Pass extra bool parameter in journal routines to specify if its ok t=
o
>> fail the journal transaction allocation. If 'true' is passed
>> transaction allocation is done through GFP_KERNEL =A0and ENOMEM is
>> returned else GFP_NOFS is used.
> =A0Please, do not mix error handling with gfp masks. Instead just ren=
ame
> jbd2__journal_start() to jbd2_journal_start() and change gfp_mask par=
ameter
> to "bool errok".

ok.

> Use GFP_NOFS gfp mask for start_this_handle().
I think I didn't completely understand this line. You meant passing
GFP_KERNEL or GFP_NOFS based on errok right ?

> Also your patch series should be bisectable - that means it must comp=
ile
> and run after any of the patches. So you cannot really change
> jbd2_journal_start() prototype without changing all the filesystems u=
sing
> it. In this case, just include in this patch a simple change for ext4=
 and
> ocfs2 to pass 'false' in the additional argument.

ok.. Will submit the first patch as everyone passing false as the
errok argument.

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
