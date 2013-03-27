From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/7] ext4: refactor punch hole code
Date: Tue, 26 Mar 2013 22:38:16 -0400
Message-ID: <20130327023816.GC2697@thunk.org>
References: <1364170014-10295-1-git-send-email-tytso@mit.edu>
 <1364170014-10295-5-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1303261334060.2455@(none)>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56167 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab3C0CiT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 22:38:19 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303261334060.2455@(none)>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 01:54:19PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +	/* Wait all existing dio workers, newcomers will block on i_mutex=
 */
> > +	ext4_inode_block_unlocked_dio(inode);
>=20
> This was not present in the indirect punch hole code, does it means
> that there was a bug ? If so maybe it's worth mentioning in the
> description?=20

Yes, I'm pretty sure it was a bug.  The
ext4_inode_block_unlocked_dio() call was added in the extents code
path by commit 02d262dffcf4c.  The problem is that i_mutex will not
block DIO readers in dioread_nolock mode.  One of the problems with
not having done the code refactorization earlier was that a bug fixed
in one code path doesn't necessarily get fixed in another.

I'll add a comment to this effect in the commit description.

> > +	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> > +		credits =3D ext4_writepage_trans_blocks(inode);
> > +	else
> > +		credits =3D ext4_blocks_for_truncate(inode);
> > +	handle =3D ext4_journal_start(inode, EXT4_HT_TRUNCATE,
> > +				    ext4_blocks_for_truncate(inode));
>=20
> Hmm, shouldn't we be using 'credits' instead of
> ext4_blocks_for_truncate(inode) here ?

Yes, good catch!

Thanks,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
