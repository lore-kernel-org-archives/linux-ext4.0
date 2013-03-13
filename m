From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Metadata reservation for unwritten extent conversion
Date: Wed, 13 Mar 2013 13:25:21 -0400
Message-ID: <20130313172521.GC5604@thunk.org>
References: <alpine.LFD.2.00.1303131629350.7128@dhcp-1-104.brq.redhat.com>
 <alpine.LFD.2.00.1303131706180.18319@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53166 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab3CMRZX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 13:25:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303131706180.18319@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 13, 2013 at 05:09:51PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> Well, we can not actually revert that patch because it introduces
> da_reserve_metadata() which is used elsewhere in the commit:
>=20
> ext4: reserve metadata block for every delayed write
>=20
> I can resend the patch which uses da_reserve_metadata() so you can us=
e
> it instead the old version

That sounds like the best thing to do.  I assume you will be simply
taking the da_reserve_metadata() function introduced in the
to-be-dropped commit:

> ext4: Reserve metadata if writing into uninitialized

=2E.. and moving it into the "reserve metadata block for every delayed
write" patch?

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
