From: tytso@mit.edu
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Mon, 17 Mar 2014 17:00:30 -0400
Message-ID: <20140317210030.GB15218@thunk.org>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
 <20140316190820.GB14162@thunk.org>
 <alpine.LFD.2.00.1403171358580.30625@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPg==?=@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42692 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaCQVAc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2014 17:00:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1403171358580.30625@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 17, 2014 at 01:59:35PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > The "dev2" branch in the ext4 git tree has all the patches in this
> > series (1, 2, and 5) --- 3 was included earlier applied on top of t=
he
> > "dev" branch.  The "test" branch is the dev2 branch with the
> > xfs-collapse-range branch pulled in, which actually enables the
> > ZERO_RANGE flags (as well as the collapse range patches).
> >=20
> > When I tried testing with the "test" branch, things failed pretty
> > quickly.  I've attached two of these in this patch set.  I'm guessi=
ng
> > it's some kind of memory corruption problem.  These failures are
> > pretty repeatable, and it fails fast.

Can you let me know when you've had a chance to take a look at this
failure?  Once we put back the EOFBLOCK_FL code, I suspect we should
be fine with the first two patches in this patch series, but patch #5
plus the xfs-collapse-range branch appears to still have issues.

Thanks!!

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
