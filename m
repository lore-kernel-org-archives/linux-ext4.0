From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fs/ext4/inode.c::mpage_map_and_submit_extent - unused variable
 warning
Date: Sun, 7 Jul 2013 06:51:08 -0400
Message-ID: <20130707105108.GA408@thunk.org>
References: <20130707115455.274b50dc@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35625 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab3GGKvX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Jul 2013 06:51:23 -0400
Content-Disposition: inline
In-Reply-To: <20130707115455.274b50dc@stein>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 07, 2013 at 11:54:55AM +0200, Stefan Richter wrote:
> Hi,
>=20
> gcc 4.6.3 says:
> fs/ext4/inode.c: In function =E2=80=98ext4_writepages=E2=80=99:
> fs/ext4/inode.c:2219:6: warning: =E2=80=98err=E2=80=99 may be used un=
initialized in this function [-Wuninitialized]
> fs/ext4/inode.c:2161:6: note: =E2=80=98err=E2=80=99 was declared here
>=20
> It would be an actual bug if mpage_map_and_submit_extent(handle, mpd,=
 ...)
> can be called with mpd->map.m_len =3D=3D 0.  Can it?

It can't and we have a patch queued up to remove the warning.

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
