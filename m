From: Theodore Tso <tytso@mit.edu>
Subject: Re: PATCH: Making mb_history length a dynamic tunable
Date: Sat, 18 Apr 2009 08:53:21 -0400
Message-ID: <20090418125320.GA19186@mit.edu>
References: <6601abe90904071020gdce65d2madc6df30c182c5cd@mail.gmail.com> <532480950904180051m3226b309wc42cded4e73be028@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57057 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZDRMxZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 08:53:25 -0400
Content-Disposition: inline
In-Reply-To: <532480950904180051m3226b309wc42cded4e73be028@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 18, 2009 at 12:51:43AM -0700, Michael Rubin wrote:
> On Tue, Apr 7, 2009 at 10:20 AM, Curt Wohlgemuth <curtw@google.com> w=
rote:
> > Hi:
> >
> > Since we frequently run in memory-constrained systems with many par=
titions,
> > the ~68K for each partition for the mb_history buffer can be excess=
ive. =A0The
> > following creates a new proc file under /proc/fs/ext4/ to control t=
he number
> > of entries at mount time.
> >
> > If the notion of a history length tunable is okay, but the location=
 should
> > be under /sys/fs/ext4/ instead of /proc/fs/ext4/, I can change this=
=2E =A0The
> > leftover files under /proc/fs/ext4/<partition>/ are a bit confusing=
 to me.
> >
>=20
> Does the silence mean that there is no interest in this CL?

No, just that you hit the ext4 dev's during the Linux storage and
filesystem workshop, and some of us are still trying to catch up from
that.  This does seem like a reasonable patch.

Yes, it should be in /sys/fs/ext4 (and this should actually be easier
to support than /proc/fs/ext4).  I've left some stuff under /proc
because /sys uses the paradigm of returning a single file per
individual tunable, which works great for most things, but it's not so
hot for things like /proc/fs/ext4/<dev>/mb_history.  However, tunables
should go under /sys/fs/ext4.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
