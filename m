From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Fri, 23 Mar 2012 10:55:15 +0200
Message-ID: <1332492915.18717.44.camel@sauron.fi.intel.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322133521.GA25897@thunk.org>
	 <1332424585.18717.34.camel@sauron.fi.intel.com>
	 <20120322150602.GD25897@thunk.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-czOoxqNsLD7+PygKmT9F"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21087 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089Ab2CWIwX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Mar 2012 04:52:23 -0400
In-Reply-To: <20120322150602.GD25897@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-czOoxqNsLD7+PygKmT9F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-22 at 11:06 -0400, Ted Ts'o wrote:
> Does that seem reasonable to you?

Yes, thank you.

One note, just FYI, xfs and jfs do not use s_dirt. Here are the FSes
which make use of it:

fs/affs
fs/exofs
fs/ext4
fs/fat
fs/hfs
fs/hfsplus
fs/jffs2
fs/reiserfs
fs/sysv
fs/udf
fs/udf
fs/ufs

(mostly old citizens).

--=20
Best Regards,
Artem Bityutskiy

--=-czOoxqNsLD7+PygKmT9F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPbDpzAAoJECmIfjd9wqK0A2sP/1rsQbg0W3BXBAwxyGh2dJPw
vUSi8bBILsV7yBRVAXkF3VShf+bw0MsEPndopdOOEz+fn+wKnABEby1QyziHDG8z
F1+UqXrsLfUtWlgf6OPOPa8Q6RueaeJgqnoEQO17XlpTRGHxjikCHXXxnQMnOlnq
1EFKofhSZewE8wf7LUr5kBaT9FdXD6rwXv06wFfIlzbSNutyuJ9Woz+wouZSZPNu
MWjN6a9c2v6FMIRNoZJSiOHgTjAQWRH3mEYDTkrv6vFNu6M5A9jxXuLx0B2xSHJc
Dr7DCXc1XwXz70HAfAzwiJUGbj74AiIspDCt3L6oqwLskZQWBScSzWvlvy+kNfFr
onaz3lRAs3aXDUQ9w7FZfp0zmUh5ndVn44oi89Wte2H10Zwn4cE9qd6uLPCsDZHz
eDWUGG0D/eEZTarqHYbW1aevOuSH12pztV4bf3Ez5HFhIzSNjkQE9Hsq84dtLHS6
XSuEn+5j7hE0VJOCaT2APzwpgwsoSGPz77xw1oObrqSnst7aQ2L4187nbvWhC08b
XEqMUBmfHNlTtwRZc1+19ju4hnmO7j5oApEsiSFxoL88J8ekgd1n7RUYt+/pcRhf
Ll3nxVn+Wr+pKADOXOyV5EMhEfgCKaJlKmNg+pPOFfHzzB7ugpZJITQ0LfakQ6fH
lVBAGKiutfegb4+yFLo7
=yH2o
-----END PGP SIGNATURE-----

--=-czOoxqNsLD7+PygKmT9F--

