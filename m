From: tytso@mit.edu
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Mon, 17 Mar 2014 16:57:41 -0400
Message-ID: <20140317205741.GA15218@thunk.org>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
 <20140316190820.GB14162@thunk.org>
 <20140317021909.GD14162@thunk.org>
 <alpine.LFD.2.00.1403171346280.30625@localhost.localdomain>
 <20140317132901.GA2773@thunk.org>
 <alpine.LFD.2.00.1403171603390.30625@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	=?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPkB0aHVuay5v?=@thunk.org,
	=?utf-8?Q?rg?=@thunk.org, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPg==?=@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42688 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbaCQU5q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2014 16:57:46 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1403171603390.30625@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 17, 2014 at 04:10:52PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Yes, shared/243 is actually looking at the file system using debugfs
> trying to figure out whether this flag is set or not. And that is
> what is failing.
>=20
> See the 243.full output:
>=20
> Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io).
> EOFBLOCK_FL bit is not set.
> Error: Current bit state incorrect.
>=20
> However I am not really sure why is this in shared since this is
> only useful for ext4.

Ah, I agree, it's confusing/wrong for this test to be in shared/243;
we should probably rename it to ext4/243 for now.

> I believe that we're not very consistent with that anyway. That was
> part of the reason why we got rid of it in e2fsck. However I agree
> that this might cause additional problems. So it might be better to
> just keep this in kernel for now...

Yeah, there are some really otherwise hard to solve races were we
might not set EOFBLOCK_FL.  We kept tripping over them when running
xfstests, but it was otherwise pretty hard to hit.

Perhaps we should set a date, say in another two years, when we make
this go away.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
