From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/37] mke2fs: set gdt csum when creating packed fs
Date: Mon, 12 May 2014 00:22:37 -0400
Message-ID: <20140512042237.GL5480@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231315.31890.10293.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021355380.2154@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33871 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaELEWl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 00:22:41 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405021355380.2154@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2014 at 01:55:59PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 1 May 2014, Darrick J. Wong wrote:
>=20
> > Date: Thu, 01 May 2014 16:13:15 -0700
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > To: tytso@mit.edu, darrick.wong@oracle.com
> > Cc: linux-ext4@vger.kernel.org
> > Subject: [PATCH 08/37] mke2fs: set gdt csum when creating packed fs
> >=20
> > When we're creating a fs with metadata blocks packed at the beginni=
ng
> > (packed_meta_blocks=3D1 in mke2fs.conf), set the group descriptor
> > checksum or else we create DOA filesystems with checksum errors.
>=20
> Makes sense. Thanks!
>=20
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
