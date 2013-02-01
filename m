From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4-next: Backport of jbd2 fixes?
Date: Fri, 1 Feb 2013 09:08:37 -0500
Message-ID: <20130201140837.GB1438@thunk.org>
References: <CA+icZUU=Ra4j6-dWbfP2fZDfRb+onQWo3HrejMsqTYO4v62o1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46509 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713Ab3BAOIl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Feb 2013 09:08:41 -0500
Content-Disposition: inline
In-Reply-To: <CA+icZUU=Ra4j6-dWbfP2fZDfRb+onQWo3HrejMsqTYO4v62o1A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 01, 2013 at 10:33:04AM +0100, Sedat Dilek wrote:
> Hi Ted,
>=20
> will those JBD2 fixes in ext4.git#dev [1] get also into mainline kern=
el(s)?
>=20
> [ Cut-n-paste out of tig ]
>=20
> 2013-01-31 13:00 Theodore Ts'o      =E2=94=82 o jbd2: track request d=
elay statistics
> 2013-01-30 00:41 Theodore Ts'o      =E2=94=82 o jbd2: commit as soon =
as
> possible after log_start_commit <--- T-b-me (Linux-Next + 3.8-rc5+)
> 2013-01-30 00:39 Eric Sandeen       =E2=94=82 o jbd2: don't wake kjou=
rnald
> unnecessarily <--- T-b-me (Linux-Next + 3.8-rc5+)
>=20
> I see no "CC: linux-stable"... and none of my Tested-by#s :-).

I might be willing to add a cc linux-stable to Eric's commit, since
it's pretty simple and it does fix a very long-standing performance
regression.  But technically these commits are intended to be
***performance*** improvements.  The fact that your inherently
dangerous use of using loop devices over FUSE happens to not deadlock
when doing a suspend/resume after applying this patch is nice, but it
is absolutely an unintended side effect.

It doesn't change the fact that it's inherently dangerous, and it may
break at any one time, and I would be surprised if kernel developers
would be willing to stand behind this as as a supported
configurations.  If this is something Ubuntu is doing, and you have a
support contract with Ubuntu, I suggest you ask them to look into
this.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
