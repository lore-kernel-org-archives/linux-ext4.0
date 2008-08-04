From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Mon, 04 Aug 2008 13:23:53 +0200
Message-ID: <1217849033.3275.3.camel@localhost>
References: <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1217383118.27664.14.camel@mingming-laptop>
	 <1217417361.3373.15.camel@localhost>
	 <1217527631.6317.6.camel@mingming-laptop> <20080801054932.GF8736@mit.edu>
	 <1217613795.12413.15.camel@mingming-laptop> <20080801191015.GH8654@mit.edu>
	 <20080802000305.GA8433@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mingming Cao <cmm@us.ibm.com>,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37447 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbYHDKNz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 06:13:55 -0400
In-Reply-To: <20080802000305.GA8433@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le vendredi 01 ao=C3=BBt 2008 =C3=A0 20:03 -0400, Theodore Tso a =C3=A9=
crit :
> In any case, I figurd out why my patch wasn't enough.  There was a bu=
g
> in ext4_ext_journal_restart:
>=20
> int ext4_ext_journal_restart(handle_t *handle, int needed)
> {
> 	int err;
>=20
> 	if (handle->h_buffer_credits > needed)
> 		return 0;
> 	err =3D ext4_journal_extend(handle, needed);
> 	if (err)
> 		return err;
> 	return ext4_journal_restart(handle, needed);
> }
>=20
> This is buggy; ext4_journal_extend returns < 0 on an error, 0 if the
> handle was successfully extended without needing a journal restart,
> and > 0 if the ext4_journal_restart() needs to be called.  So the
> current code returns a failure and doesn't restart the journal when i=
t
> is needed, and calls ext4_journal_restart() needlessly when it is not
> needed and the handle could be extended without closing the current
> transaction.
>=20
> The fix is a simple one-liner:
>=20
> int ext4_ext_journal_restart(handle_t *handle, int needed)
> {
> 	int ret;
>=20
> 	if (handle->h_buffer_credits > needed)
> 		return 0;
> 	err =3D ext4_journal_extend(handle, needed);
> 	if (ret < =3D 0)
> 		return ret;
> 	return ext4_journal_restart(handle, needed);
> }
>=20
> This seems to indicate ext4_ext_journal_restart() has never been
> called in anger by the ext4_ext_truncate() code.  We may want to
> double check it with a really big, mongo extent tree and make sure it
> does the right thing one of these days.
>=20
> 							- Ted
>=20

=46YI, I have just tried this fix, and i don't see the "orphan list che=
ck
failed" messages any more.

=46red




--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
