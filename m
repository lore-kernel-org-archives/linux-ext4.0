From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to
 return errors and handle them gracefully.
Date: Sun, 24 Apr 2011 17:06:30 -0700
Message-ID: <BANLkTinTYfML7uw4-Uq4jzMgTCUadDCpTQ@mail.gmail.com>
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
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35850 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab1DYAGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2011 20:06:51 -0400
Received: by qwk3 with SMTP id 3so797251qwk.19
        for <linux-ext4@vger.kernel.org>; Sun, 24 Apr 2011 17:06:50 -0700 (PDT)
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
> =A0How about "ext4_journal_start_tryhard()"? I don't like "nofs" beca=
use
> the fact whether we use GFP_NOFS is separate from the fact whether we=
 are
> able to handle memory allocation failure.

Hi Jan,

Sorry for taking so long to respond to this. I'm sending the updated
set of patches after incorporating your previous comments. As
suggested I have added a wrapper routine ext4_journal_start_tryhard()
for the transaction allocation which can't fail and does
its allocation using GFP_NOFS. Regular ext4_journal_start() uses GFP_KE=
RNEL.


--=20
Thanks a lot -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
