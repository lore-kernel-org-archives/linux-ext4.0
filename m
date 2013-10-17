From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't cache out of order extents
Date: Thu, 17 Oct 2013 11:58:25 -0400
Message-ID: <20131017155825.GB3605@thunk.org>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
 <alpine.LFD.2.00.1310171534440.3212@localhost.localdomain>
 <20131017144044.GA3605@thunk.org>
 <alpine.LFD.2.00.1310171704300.3212@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47310 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab3JQP6e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Oct 2013 11:58:34 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310171704300.3212@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 05:22:58PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I agree, since ext4_ext_check() should be really only used when
> reading data from disk. That said, we might actually remove the
> check from ext4_ext_precache() and ext4_ext_remove_space() because
> it seems to be that the check has already been done in ext4_iget()
> and it should be enough to check it once when reading from disk,
> right ?

Yes, since we do call ext4_ext_check() in ext4_iget() to verify the
root node of the extent tree located in ei->i_blocks[], it's strictly
speaking not necessary.  OTOH, there are at most four entries in
i_blocks[] that need to be verified, and it's a bit easier for the
contents of i_blocks[] to get corrupted by buggy code, so it's a
toss-up whether it's really worth it to remove it from those two
places, which aren't really hotspots.  It could be argued that are
plenty of other places that where we're not validating the root extent
tree node, so we might as well remove it from those two functions,
though.

> > Eryu's patch, or something like it, will still be needed so that in
> > the case of errors=3Dcountinue, we don't end up calling BUG_ON().
>=20
> Hmm shouldn't we avoid that data in the case that it's corrupted
> rather than using it ? It seems like this is what the code would do
> anyway even with errors=3Dcontinue when __ext4_ext_check() returns
> error.

Hmm, maybe we should set a flag indicating that the inode is bad, and
then cause attempts to read or write the contents of that inode should
return EIO.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
