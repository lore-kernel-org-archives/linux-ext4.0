From: Lubos Uhliarik <uhliarik@seznam.cz>
Subject: Re: [RFC][PATCH 0/1] ext4: Undelete Feature for Ext4
Date: Fri, 18 Apr 2014 18:01:38 +0200
Message-ID: <1397836898.21164.13.camel@zerobox.home>
References: <1395155370.15587.9.camel@zerobox.home>
	 <20140318171425.GC8506@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com,
	vojnar@fit.vutbr.cz
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.seznam.cz ([77.75.72.43]:35501 "EHLO smtp1.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaDRQBx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 12:01:53 -0400
In-Reply-To: <20140318171425.GC8506@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tytso,

I tried to do some power failure tests, but I was unable to simulate an
error, as you described.

I analysed code by myself, but I don't see any problem with starting a
new transaction in function ext4_ext_rm_leaf. If in this function new
transaction is created and system will crash in the middle of deleting
the file, eh_entries in extent_header will have correct value, so it
shouldn't cause any problem (eh_entries is decremented in the same
transaction, as zeroing out ex->len etc.).=20

I hope, you will understand, what I want to say.=20

If I'm wrong, please let me know.

Regards,

Lubos

tytso@mit.edu p=C3=AD=C5=A1e v =C3=9At 18. 03. 2014 v 13:14 -0400:
> On Tue, Mar 18, 2014 at 04:09:30PM +0100, Lubos Uhliarik wrote:
> > The main changes in patch are following:
> >=20
> > a) commented out zeroing ex->ee_len, ee->start_hi and ee->start_lo,
> > because these entries are essential for undelete process
>=20
> The reason why we have to zero out ex->ee_len, etc. is because the
> truncate operation can sometimes span multiple journal transactions.
> So as a result, we need to keep the file system consistent if we are
> interrupted (i.e., via a power fail event) while in the middle of a
> truncate operation.
>=20
> It's a rare case, but it can happen if the journal is almost full at
> the time when the truncate eoperation has started, such that there is
> no room for to exntend the transaction handle, and so we are forced t=
o
> start a new transaction (and possibly wait for a journal checkpoint
> operation).
>=20
> In theory, it would be possible to figure out in advance whether or
> not we could fit the truncate in a single transaction, but it would
> require making the truncate operation be a two-pass operation --- onc=
e
> to determine how many blocks needs to be modified, and once to
> actually do the truncate operation.
>=20
> > This patch shouldn't break ext4, I tested it with xfs_tests and tes=
ts=20
> > were successfull.
>=20
> I'm guessing you didn't do power fail testing --- and this is very
> important when messing with the design truncate/unlink code path.
>=20
> Regards,
>=20
> 						- Ted


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
