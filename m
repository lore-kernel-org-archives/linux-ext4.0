From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to
 specify if the caller can deal with ENOMEM
Date: Fri, 27 May 2011 23:16:00 -0700
Message-ID: <BANLkTimsOKkRO=8k2GK8wY+LaYXRZaqkYQ@mail.gmail.com>
References: <4DDCAF18.8030809@gmail.com> <20110525074457.GA4427@quack.suse.cz>
 <4DDCB3FA.2070009@gmail.com> <20110525081333.GB4427@quack.suse.cz> <20110526022251.GG9520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38010 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1E1GQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 May 2011 02:16:21 -0400
Received: by vxi39 with SMTP id 39so1770593vxi.19
        for <linux-ext4@vger.kernel.org>; Fri, 27 May 2011 23:16:20 -0700 (PDT)
In-Reply-To: <20110526022251.GG9520@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 7:22 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, May 25, 2011 at 10:13:33AM +0200, Jan Kara wrote:
>> >
>> > =A0 =A0ok.. I will do it as a separate patch.
>> =A0 Well, patch 2/3 does not really make too much sense without it (=
errok
>> parameter isn't used) so there's no reason to do it as a separate pa=
tch.
>> Just add it to this patch please.
>
> Agreed; right now this whole patch series is a no-op, since errok
> isn't getting used for anything. =A0So fixing errok so it's passed to
> start_this_handle() seems to be more in the category of "fix the
> patch" more than anything else.
>
> One more thing; perhaps we should be passing in a integer so we can
> pass in a flag word. =A0That way you don't need to have a fail_ok
> variant. =A0It's a lot more obvious if you have a call:
>
> =A0 =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, 1, JBD2_FAIL_=
OK);
>
> What we can also do is this:
>
> =A0 =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, 1, JBD2_FAIL_=
OK | JBD2_TOPLEVEL);
>
> What JBD2_TOPLEVEL means is that caller is from a top-level file
> system function, such as ext4_symlink() or ext4_chmod(), such that
> start_this_handle() can use GFP_KERNEL instead of GFP_NOFS. =A0GFP_NO=
=46S
> is needed for any function that might get called by the direct reclai=
m
> path (i.e., the writepage() function). =A0But for the top-level
> symlink() or chmod() function, it's actually OK to allocate memory
> using GFP_KERNEL, since there's no potential recursion problem.

Hi Ted,

Resending version 2 of the three patch series after updating them as
you suggested above.

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
