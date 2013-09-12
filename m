From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH 2/2] ext4: use kobj_completion in ext4_sb_info
Date: Wed, 11 Sep 2013 21:52:18 -0400
Message-ID: <52311E52.4040001@suse.com>
References: <522F5A6D.50100@suse.com> <20130912014813.GA12918@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pWqmTJp1aufcAdVPig3H1r63i23lHS9Hv"
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Greg KH <gregkh@linux.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3ILBwc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Sep 2013 21:52:32 -0400
In-Reply-To: <20130912014813.GA12918@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pWqmTJp1aufcAdVPig3H1r63i23lHS9Hv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/11/13 9:48 PM, Theodore Ts'o wrote:
> On Tue, Sep 10, 2013 at 01:44:13PM -0400, Jeff Mahoney wrote:
>> Now that we have the kobj_completion structure available, let's use it=

>> in ext4.
>>
>> Note that we aggregate the del/put/wait_for_completion in one
>> kobj_completion_del_and_wait call. Since the kobject isn't used for
>> anything while the fs is shutting down and we wait until it's released=

>> before continuing anyway, this is safe.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>=20
> I don't have a huge objection to this, but given that it's not fixing
> a bug, and it's not saving _that_ many lines of code, if you want to
> run the first patch through Greg's tree (which is fine with me), I
> might wait to merge this patch until 3.13, so it's not obvious that
> it's worth dealing with the inter-tree dependency, since it
> complicates testing on my end.
>=20
> Does that sound reasonable?

Works for me. The ext4 case isn't something I'm in a huge rush to get in
-- it was just the most obvious (to me) existing users of the
kobj/completion pair.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--pWqmTJp1aufcAdVPig3H1r63i23lHS9Hv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iQIcBAEBAgAGBQJSMR5VAAoJEB57S2MheeWye/4P/2f5TBwQY7Zz0WO9YsyPmLY8
yVA5NPisFxQ0upDs6e9qT3Eac0Tk27cZ3nRP9+2WsKwvRuH5mew5st0F0kjxcJCC
3QFHY0hUofAx2jF/CICHc3wX8UjhSd1dYjN/U+kjhj3M3YzA6CiCtVzVPPFpwbsY
rNUdTGCW8flINKpcLohkZrVFcroCiKdz0UJb0MiAQrS3LHYl2cZL2H/o76saEIAn
F6Kb3tcd7LkxXqDC+eOTislHdZQjALEk8wtpIcovI3TyPilJksRSbBuW57JfTEQu
wAJdEkkQiD7sN4HAac6hxe3CkPeLSd3YefMlSa6DJXwOztgcXS+OoLCf3Pte/8u7
KaKqbDq0D5CPLcedvOu+t8FU/UXwMUD62I8+fztj15kYNMowvyupOuztaUKfFRey
JJ8346caO1vhUYsBz1yMzTEJMZ7xodqhQetN5c/WILoyJKzUh+TgNdiQ0EW5kJtM
HzqIxJnlgPzl7rheKzLtmfULYGMHCVlvdgwuDrkV7fxvVhf4cnYSPyy6y9rcoeB0
4/AcqPh7gmKoOHUgm4MeSs2NQfS/ZHpD8pSnE/TySHQufCzGlGIVns7zuaw7GrR8
UQHcQIdtydXASAkhCZOa02pgWSe0rMQFPXWJugFr/3X0HQnEcboysF6t21XTxnnC
JaOzrhImpGJraAf+Rvtd
=w9oq
-----END PGP SIGNATURE-----

--pWqmTJp1aufcAdVPig3H1r63i23lHS9Hv--
