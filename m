From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2, RFC] ext4: ignore journal checksum on remount; don't
 fail
Date: Thu, 12 Feb 2015 23:09:09 -0500
Message-ID: <20150213040909.GE2268@thunk.org>
References: <54DA34BB.8030806@redhat.com>
 <54DA366E.8060109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	=?iso-8859-1?B?Q/NucuRk?= <conradsand.arma@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39392 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbbBMEJM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2015 23:09:12 -0500
Content-Disposition: inline
In-Reply-To: <54DA366E.8060109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 10, 2015 at 10:48:46AM -0600, Eric Sandeen wrote:
> As of v3.18, ext4 started rejecting a remount which changes the
> journal_checksum option.
>=20
> Prior to that, it was simply ignored; the problem here is that
> if someone has this in their fstab for the root fs, now the box
> fails to boot properly, because remount of root with the new options
> will fail, and the box proceeds with a readonly root.
>=20
> I think it is a little nicer behavior to accept the option, but
> warn that it's being ignored, rather than failing the mount,
> but that might be a subjective matter...
>=20
> Reported-by: C=F3nr=E4d <conradsand.arma@gmail.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
