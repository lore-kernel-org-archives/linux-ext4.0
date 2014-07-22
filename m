From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: free bh on csum verify error in do_one_pass
Date: Tue, 22 Jul 2014 12:31:14 -0400
Message-ID: <20140722163114.GD25291@thunk.org>
References: <53C83C1F.8020303@redhat.com>
 <alpine.LFD.2.00.1407181104330.12453@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50622 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbaGVUfH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:35:07 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1407181104330.12453@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 11:04:45AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 17 Jul 2014, Eric Sandeen wrote:
>=20
> > Date: Thu, 17 Jul 2014 16:11:59 -0500
> > From: Eric Sandeen <sandeen@redhat.com>
> > To: ext4 development <linux-ext4@vger.kernel.org>
> > Subject: [PATCH] e2fsck: free bh on csum verify error in do_one_pas=
s
> >=20
> > Coverity (re-)spotted this; it was triaged as a false positive,
> > but it seems pretty clear that the bh (which was just checked)
> > isn't currently freed before the function exits.
>=20
> Looks good.
>=20
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
