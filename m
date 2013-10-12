From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 26/31] libext2fs: openfs() musn't allow bigalloc without
 EXT2_FLAGS_64BITS
Date: Fri, 11 Oct 2013 21:36:37 -0400
Message-ID: <20131012013637.GD22656@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012928.28415.62086.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1310071450260.1975@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45081 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab3JLCyX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 22:54:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310071450260.1975@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 02:50:52PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Mon, 30 Sep 2013, Darrick J. Wong wrote:
> > Currently, only the 64-bit bitmap implementation supports the block=
<->cluster
> > conversions that bigalloc requires.  Therefore, if we have a bigall=
oc
> > filesystem, require EXT2_FLAGS_64BITS be passed in to ext2fs_open()=
=2E
> >=20
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
