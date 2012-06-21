From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v2 1/4] ext4: Remove useless marking of superblock dirty
Date: Thu, 21 Jun 2012 16:11:45 +0300
Message-ID: <1340284305.13910.216.camel@sauron.fi.intel.com>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1333367140-28370-2-git-send-email-artem.bityutskiy@linux.intel.com>
	 <1334215249.13842.36.camel@sauron.fi.intel.com>
	 <1335775045.2584.3.camel@sauron.fi.intel.com>
	 <1338558820.2536.151.camel@sauron.fi.intel.com>
	 <20120601151601.GA13826@thunk.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4FgDzXIlXlZP/7SKdO47"
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759567Ab2FUNHq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2012 09:07:46 -0400
In-Reply-To: <20120601151601.GA13826@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-4FgDzXIlXlZP/7SKdO47
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-01 at 11:16 -0400, Ted Ts'o wrote:
> I will make sure this patchset
> gets reviewed and queued for 3.5.

Hi Ted,

just a reminder. The patch does not apply cleanly but the conflicts are
simple and they are around the SB checksum stuff. Do you want me to
re-send?

--=20
Best Regards,
Artem Bityutskiy

--=-4FgDzXIlXlZP/7SKdO47
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP4x2RAAoJECmIfjd9wqK0cgEP/Rwcp7wz0lHRb6Cg3esQXNX2
MIhTPgQx3F9y9HTxnMbv8TidVnUY5WEsuq+eLWlH+6+9DMfkSxgsHEwSbeSTrLx1
/8+vcZbKX2z3Guw5dAtfnIzL9YkDhhOuXCPgXsv7yWpAjY1BukcFKyo/yQ++6Nic
/i62ORo33yW/Re6snFJrwaipPqSnSUldI2VAjIUnvPmc7O3vvhiaLcnx/OYaW82s
7LypUF0a2ytGz36W5Z67q4+e1i/rGNDsk5n2W55yuYuHJTQhB8nQ7pyEfTU9eT0h
Ho2sd1fc98AHY9uQBPZviIU+2lAWbvtNUfyHowaEFZmLbNFFoIWLPdURjGqlBXOZ
Aa0PXwLD21tgPS4HSgImgSKn28k7Ale6khCYk7Kp0O6KS293GizhNvWoRq4v/ItY
sRzGo8TULakwT8sLwtec0m12RpUKcyKAF5llQUrlOiyP5laZa0ayn1ehxlpWio3/
6yonH9WwWc8QRvjiKDz1bIZwgklqDh4D6ae2oMXgHGgW6RHGHk7/g/Hk+s8slW99
gJy5l2PPHSLTSpG4uzCv3WI/o43q1Ln8Ka1Pewz+keT1ziWV1nEAxF9Ip07gDL32
WMIw3Pk34+VclfEKn+5ugL+cRIk4YLsrC2csFx4dIDTaAJ1iE3BD1C5SVUPVUQAb
NhyhTqhRfDxBSXjJsWZh
=s/ol
-----END PGP SIGNATURE-----

--=-4FgDzXIlXlZP/7SKdO47--

