From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: only call ext4_truncate when size <= isize
Date: Sat, 6 Jun 2015 16:20:11 -0400
Message-ID: <20150606202011.GC15306@thunk.org>
References: <1432049337-3520-1-git-send-email-jbacik@fb.com>
 <alpine.LFD.2.00.1506021008030.4950@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Josef Bacik <jbacik@fb.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51160 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbbFFU0v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Jun 2015 16:26:51 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1506021008030.4950@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 02, 2015 at 10:08:18AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Tue, 19 May 2015, Josef Bacik wrote:
>=20
> > Date: Tue, 19 May 2015 11:28:57 -0400
> > From: Josef Bacik <jbacik@fb.com>
> > To: tytso@mit.edu, linux-ext4@vger.kernel.org
> > Subject: [PATCH] ext4: only call ext4_truncate when size <=3D isize
> >=20
> > At LSF we decided that if we truncate up from isize we shouldn't tr=
im fallocated
> > blocks that were fallocated with KEEP_SIZE and are past the new i_s=
ize.  This
> > patch fixes ext4 to do this.  Thanks,
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
