From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix sleep inside spinlock issue aka #14739 V2
Date: Wed, 16 Dec 2009 00:44:10 +0100
Message-ID: <20091215234409.GE9554@quack.suse.cz>
References: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
 <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
 <87bpi6zquv.fsf_-_@openvz.org>
 <20091215214806.GD9554@quack.suse.cz>
 <c18d6aa20912151516g3ad5e0a6iccaaa3a77a7a5f63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	cmm@us.ibm.com, tytso@mit.edu
To: Dmitry Monakhov <rjevskiy@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56081 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZLOXoV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Dec 2009 18:44:21 -0500
Content-Disposition: inline
In-Reply-To: <c18d6aa20912151516g3ad5e0a6iccaaa3a77a7a5f63@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 16-12-09 02:16:36, Dmitry Monakhov wrote:
> 2009/12/16 Jan Kara <jack@suse.cz>:
> > On Thu 10-12-09 20:22:16, Dmitry Monakhov wrote:
> >>
> >> drop i_block_reservation_lock before vfs_dq_reserve_block().
> >> this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=3D14739
> >>
> >> changes from previous version:
> >> =A0- simplify the patch according to Jan's comments
> > =A0Dmitry, I suppose I should also merge this patch together with y=
our other
> > fixes, right? For some reason, it was not part of the last submissi=
on of
> > your patch series...
> yes. it is not in the series because it is another bug, and it is not
> depended from
> other patches.
> Please merge newst version of the patch http://patchwork.ozlabs.org/p=
atch/40896/
> This version is affected by stupid bug, see at the bottom of the patc=
h.
> In fact this patch does help Justin Maggard to overcome his issue.
>=20
> BTW  i've also have another patch http://patchwork.ozlabs.org/patch/4=
0805/
> it was acked by you, but ASAIK it was't pushed to the ext4 queue yet.
  OK, I've added both patches to my tree. Usually Ted takes care of ext=
4
fixes but given that I carry also other ext4 quota fixes, I think I can
merge these as well if he does not object.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
