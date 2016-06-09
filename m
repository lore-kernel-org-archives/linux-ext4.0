From: Jan Kara <jack@suse.cz>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1
 kernel
Date: Thu, 9 Jun 2016 16:59:17 +0200
Message-ID: <20160609145917.GA19882@quack2.suse.cz>
References: <20160531140922.GM5140@eguan.usersys.redhat.com>
 <20160531154017.GC5357@thunk.org>
 <20160601063822.GH10350@eguan.usersys.redhat.com>
 <20160601165800.GI10350@eguan.usersys.redhat.com>
 <20160602085840.GH19636@quack2.suse.cz>
 <20160602121750.GC32574@quack2.suse.cz>
 <20160603101612.GJ10350@eguan.usersys.redhat.com>
 <20160603115844.GB2470@quack2.suse.cz>
 <20160608125631.GA19589@quack2.suse.cz>
 <pan$6abef$45fa540$7a7a0c36$ef55c356@applied-asynchrony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbcFIO7Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jun 2016 10:59:25 -0400
Content-Disposition: inline
In-Reply-To: <pan$6abef$45fa540$7a7a0c36$ef55c356@applied-asynchrony.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please use reply-to-all when replying to emails. Usually I read mailing
lists with much smaller frequency than directly sent email...

On Wed 08-06-16 14:23:49, Holger Hoffst=E4tte wrote:
> On Wed, 08 Jun 2016 14:56:31 +0200, Jan Kara wrote:
> (snip)
> > Attached patch fixes the issue for me. I'll submit it once a full x=
fstests
> > run finishes for it (which may take a while as our server room is c=
urrently
> > moving to a different place).
> >=20
> > 								Honza
> > --=20
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> > From 3a120841a5d9a6c42bf196389467e9e663cf1cf8 Mon Sep 17 00:00:00 2=
001
> > From: Jan Kara <jack@suse.cz>
> > Date: Wed, 8 Jun 2016 10:01:45 +0200
> > Subject: [PATCH] ext4: Fix deadlock during page writeback
> >=20
> > Commit 06bd3c36a733 (ext4: fix data exposure after a crash) uncover=
ed a
> > deadlock in ext4_writepages() which was previously much harder to h=
it.
> > After this commit xfstest generic/130 reproduces the deadlock on sm=
all
> > filesystems.
>=20
> Since you marked this for -stable, just a heads-up that the previous =
patch
> for the data exposure was rejected from -stable (see [1]) because it
> has the mismatching "!IS_NOQUOTA(inode) &&" line, which didn't exist
> until 4.6. I removed it locally but Greg probably wants an official p=
atch.
>=20
> So both this and the previous patch need to be submitted.

This patch is actually independent fix to the previous one. Just the
previous patch made the bug more visible. Regarding the backport - yeah=
, I
have it on my todo list.

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
