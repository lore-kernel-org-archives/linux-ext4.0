From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to
 return errors and handle them gracefully.
Date: Sat, 29 Jan 2011 21:40:03 -0800
Message-ID: <AANLkTi=x_RufCNMGaM1DBbYKPKdO-JoQP5YCdDz6dfAc@mail.gmail.com>
References: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com>
 <20110123054049.GC3237@thunk.org> <20110123062900.GA7436@noexit>
 <20110124133143.GA5058@quack.suse.cz> <AA32FD05-E9BD-40AB-8495-EAD0547B5E02@dilger.ca>
 <20110125114656.GB4088@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Joel Becker <jlbec@evilplan.org>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38095 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1A3FkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 00:40:24 -0500
Received: by qwa26 with SMTP id 26so4504907qwa.19
        for <linux-ext4@vger.kernel.org>; Sat, 29 Jan 2011 21:40:24 -0800 (PST)
In-Reply-To: <20110125114656.GB4088@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 25, 2011 at 3:46 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 24-01-11 18:06:24, Andreas Dilger wrote:
>> > =A0jbd2_journal_start can always fail e.g. because the journal is =
aborted.
>> > So it really just means no memory failures...
>> >
>> >>> The tradeoff is that long-term, the code is more readable (as op=
posed
>> >>> to having people look up what a random "true" or "false" value m=
eans).
>> >>> But short-term, while it will make the patch smaller, it also ma=
kes
>> >>> the patch harder audit, since we need to look at all of the plac=
es
>> >>> where we _haven't_ made a change to make sure those call sites c=
an
>> >>> tolerate an error return.
>> >>
>> >> =A0 =A0I think we should start with jbd2_journal_start_can_fail()=
 or
>> >> something like it, and change it back to jbd2_journal_start() in =
the
>> >> next window. =A0It's a silly name, but it catches exactly what yo=
u are
>> >> worried about.
>> >
>> > =A0Yes, I think this would be nice for auditting (but for that mat=
ter
>> > current interface with additional argument isn't bad either and we=
 can
>> > just do the rename to _nofail in the final patch...).
>>
>> The reason I don't like the "true" and "false" arguments is that it =
isn't
>> at all clear which functions have "false" because they cannot fail, =
and
>> which ones just haven't been updated yet.
>>
>> In that light, I'd prefer to add _two_ new functions, one that indic=
ates
>> the function needs to retry (as it does now), and one that indicates=
 that
>> the caller will handle the error. =A0That way it is clear which func=
tions
>> have been investigated, and which ones haven't been looked at yet. =A0=
Once
>> all of the functions have been changed, we can remove the old
>> jbd2_journal_start() function to catch any patches that have not bee=
n
>> updated to the new functions.
> =A0I agree this would be good for the transition period but once we g=
o
> through all the callsites, I'd prefer to do a rename and have just
> jbd2_journal_start() be the one which does not retry.
>
>> Maybe jbd2_journal_start_canfail() and jbd2_journal_start_retry()?
> =A0As I said above, I'd like the first one to live only temporarily s=
o
> I don't care about the name. The second one is probably better than
> _nofail() but I still don't feel it describes well what the function
> does...

Hi all,

Have we reached on any conclusion yet on the function name which I can
use to send my updated patch ? My preference from the above list is to
use ext4_journal_start_nofs() as that seems the closest match, but I
would like hear the conclusion from experts.

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
