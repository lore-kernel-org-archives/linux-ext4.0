From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/7] mke2fs: create a regular file if necessary
Date: Wed, 30 Apr 2014 10:18:15 -0400
Message-ID: <20140430141815.GE9213@thunk.org>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
 <1398556834-31913-4-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1404301410590.2100@localhost.localdomain>
 <20140430140657.GB9213@thunk.org>
 <alpine.LFD.2.00.1404301611290.2100@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41982 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933466AbaD3OSR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 10:18:17 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404301611290.2100@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 30, 2014 at 04:14:16PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > Hmm, it occurs to me if the user typo's the file name in and the us=
er
> > specifies the size explicitly (i.e., "mke2fs /dev/scd3 2T) , it cou=
ld
> > result in the the root file system filling up.  I'm not sure that's
> > big of a deal, since the user can always control-C the mke2fs and t=
hen
> > delete the typo'ed file name.  Do we think this is a real problem?
> > I'm not too worried...
>=20
> Oops, yes that would be nasty :) I'm not too worried either, but
> I've done my share of typos as well, so I am not sure. And since
> we're already asking a lot of questions anyway maybe we can ask
> about this one as well ?

The problem is if we do this, then scripts will do "mke2fs -F ..." to
avoid the query, and I'd really like to avoid training script authors
to do this.  It undoes the point of some of the other patches in this
patch series.

We could have some proceed_questions() fail to "yes", and some fail to
"no", but I'm wondering if we really want to go to that level of
complexity....

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
