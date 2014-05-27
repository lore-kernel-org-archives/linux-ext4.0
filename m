From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: fix create_inode warnings with LLVM
Date: Tue, 27 May 2014 12:51:21 -0400
Message-ID: <20140527165121.GD1158@thunk.org>
References: <1400627542-75060-1-git-send-email-adilger@dilger.ca>
 <alpine.LFD.2.00.1405271834430.2055@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35180 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbaE0QvY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 12:51:24 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405271834430.2055@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 27, 2014 at 06:34:52PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Tue, 20 May 2014, Andreas Dilger wrote:
>=20
> > Date: Tue, 20 May 2014 17:12:22 -0600
> > From: Andreas Dilger <adilger@dilger.ca>
> > To: tytso@mit.edu
> > Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
> > Subject: [PATCH] misc: fix create_inode warnings with LLVM
> >=20
> > Fix name clash in do_mknod_internal() due to local variables named
> > "major" and "minor" shadowing identical macro names.
> >=20
> > Also, no need to set the major and minor device for a FIFO inode.
> >=20
> > Signed-off-by: Andreas Dilger <adilger@dilger.ca>
>=20
> Looks good, thanks!
>=20
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
