From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Silence warning in ext4_writepages()
Date: Fri, 5 Jul 2013 21:58:32 -0400
Message-ID: <20130706015832.GA32062@thunk.org>
References: <1372788869-24456-1-git-send-email-jack@suse.cz>
 <alpine.LFD.2.00.1307031204000.3892@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35390 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab3GFB6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jul 2013 21:58:39 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1307031204000.3892@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 03, 2013 at 12:07:25PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Tue, 2 Jul 2013, Jan Kara wrote:
>=20
> > Date: Tue,  2 Jul 2013 20:14:29 +0200
> > From: Jan Kara <jack@suse.cz>
> > To: Ted Tso <tytso@mit.edu>
> > Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
> > Subject: [PATCH] ext4: Silence warning in ext4_writepages()
> >=20
> > The loop in mpage_map_and_submit_extent() is guaranteed to always r=
un at
> > least once since the caller of mpage_map_and_submit_extent() makes =
sure
> > map->m_len > 0. So make that explicit using do-while instead of pur=
e
> > while which also silences the compiler warning about uninitialized =
'err'
> > variable.
>=20
> Looks good.
>=20
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
