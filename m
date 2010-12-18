From: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sat, 18 Dec 2010 17:15:43 -0500
Message-ID: <1292710543.17128.14.camel@nayuki>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
	 <AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
	 <AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
	 <4D0A7278.3080506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Olaf van der Spek <olafvdspek@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45679 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab0LRWPr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Dec 2010 17:15:47 -0500
In-Reply-To: <4D0A7278.3080506@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-12-16 at 15:11 -0500, Ric Wheeler wrote:
> On 12/16/2010 07:22 AM, Olaf van der Spek wrote:
> > On Thu, Dec 9, 2010 at 1:03 PM, Olaf van der Spek<olafvdspek@gmail.=
com>  wrote:
> >> Hi,
> >>
> >> Since the introduction of ext4, some apps/users have had issues wi=
th
> >> file corruption after a system crash. It's not a bug in the FS AFA=
IK
> >> and it's not exclusive to ext4.
> >> Writing a temp file, fsync, rename is often proposed. However, the
> >> durable aspect of fsync isn't always required and this way has oth=
er
> >> issues.
> >> What is the recommended way for atomic non-durable (complete) file=
 writes?
> >>
> >> I'm also wondering why FSs commit after open/truncate but before
> >> write/close. AFAIK this isn't necessary and thus suboptimal.
> > Somebody?
> >
> > Olaf
>=20
> Getting an atomic IO from user space down to storage is not really tr=
ivial.
>=20
> What I think you would have to do is:
>=20
> (1) understand the alignment and minimum IO size of your target stora=
ge device=20
> which you can get from /sys/block (or libblkid)

Hmm. I=E2=80=99m doing a little interpretation of what Olaf said here; =
but I
think you may have misunderstood the question?

He doesn=E2=80=99t care about whether or not the file is securely writt=
en to
disk (durable); however he doesn=E2=80=99t want to see any partially wr=
itten
files. In other words, something like

     1. Write to temp file
     2. Rename temp file over original file

Where the rename is only committed to disk once the entire contents of
the file have been written securely =E2=80=93 whenever that may eventua=
lly
happen.

He doesn=E2=80=99t want to synchronously wait for the file to be writte=
n,
because the new data isn=E2=80=99t particularly important. The only imp=
ortant
thing is that the file either contains the old or new data after a
filesystem crash; not incomplete data. So, it=E2=80=99s more of an orde=
ring
problem, I think? (Analogous to putting some sort of barrier between th=
e
file write/close and the file rename to maintain ordering.)

Hopefully I=E2=80=99ve interpreted the original question correctly, bec=
ause this
is something I would find interesting as well.

--=20
Calvin Walton <calvin.walton@gmail.com>

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
