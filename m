From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to
 return errors and handle them gracefully.
Date: Fri, 4 Feb 2011 14:44:57 -0800
Message-ID: <AANLkTim779kmcr0Zjz9a9EGkBHwbFqgV7hxokXPBc522@mail.gmail.com>
References: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com>
 <20110123054049.GC3237@thunk.org> <20110123062900.GA7436@noexit>
 <20110124133143.GA5058@quack.suse.cz> <AA32FD05-E9BD-40AB-8495-EAD0547B5E02@dilger.ca>
 <20110125114656.GB4088@quack.suse.cz> <AANLkTi=x_RufCNMGaM1DBbYKPKdO-JoQP5YCdDz6dfAc@mail.gmail.com>
 <20110204155358.GF4104@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Joel Becker <jlbec@evilplan.org>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39304 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1BDWpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Feb 2011 17:45:18 -0500
Received: by qyk12 with SMTP id 12so2397815qyk.19
        for <linux-ext4@vger.kernel.org>; Fri, 04 Feb 2011 14:45:17 -0800 (PST)
In-Reply-To: <20110204155358.GF4104@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 4, 2011 at 7:53 AM, Jan Kara <jack@suse.cz> wrote:
> On Sat 29-01-11 21:40:03, Manish Katiyar wrote:
> =A0Hi Manish,
>
>> Have we reached on any conclusion yet on the function name which I c=
an
>> use to send my updated patch ? My preference from the above list is =
to
>> use ext4_journal_start_nofs() as that seems the closest match, but I
>> would like hear the conclusion from experts.
> =A0How about "ext4_journal_start_tryhard()"?

Thanks Jan,

I will post an updated patch of the full series using
ext4_journal_start_tryhard() once other patches have been reviewed.

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
