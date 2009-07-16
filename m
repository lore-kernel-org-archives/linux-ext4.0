From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] configure: Disable uuidd by default
Date: Thu, 16 Jul 2009 15:18:05 -0400
Message-ID: <200907161518.06698.vapier@gentoo.org>
References: <E1MRWBp-0000yk-N0@zelda.netsplit.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1845810.S9ZeBu6asH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	util-linux-ng@vger.kernel.org
To: Scott James Remnant <scott@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40221 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbZGPTSI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 15:18:08 -0400
In-Reply-To: <E1MRWBp-0000yk-N0@zelda.netsplit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1845810.S9ZeBu6asH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 16 July 2009 14:52:21 Scott James Remnant wrote:
> -[  --disable-uuidd         disable building the uuid daemon],
> +[  --enable-uuidd         disable building the uuid daemon],

help text should be inverted now as well
-mike

--nextPart1845810.S9ZeBu6asH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iQIcBAABAgAGBQJKX3zuAAoJEEFjO5/oN/WBk2wP/3YhYePGf5ke+FgwQgAYsSdi
2x62jeeubggg4AL5RMM8ZwF22XBD6Ogt4ASehIC2G/W+t5m0zW2g/TEId7KinjWj
PtR3rhqdrwC8DDpe9Sm7NsrNseTGdHNiIiQzFD640PpqaLFKahsHEEiOl7y4tu1q
bU/Tq6FEP6rO7MJ6OCcZFbNpEE5ZO0WBwHOy6ukKVuecsJC+ceVn7jtb9S5zCwAg
dq3ucmbRqnyg6zmxiyrQKWrkbYJ1z2esPYovLsrf0zoTzjDjLqGGfP+rp2dZcMdS
uAekaCrK2QvzX+yDbzQBG5A1LunVR/sFwQIxW9tivMoIdtZ1zu/4shpXZrL9QL/K
s+V8zRAPVn3KpUmYAbVYw3r7dPjtqWRfBgHIBfAyTJGIu0Fgu89aSG+7Xk5JH/tg
8h7n2OAMJY74+4OFptchK0RsWk7kNbay3aET7Rzt5t+pCiKHOpcvppLE/Y6Sq1tM
xzZ9Jtd1/ILCRwF8ggThsLjcjfB0gh1BOTB0u0rFC2oGhU0fCXWDKFRTfqmkQ9dA
x4NBfCcARfjVrdmRf+diUM4Tbxlzf2eo4bc6Khj/ByTuwC2vqqbrYevJh+Ojxi6j
0IhBji6vzocqg/JZ/bFlzuZlGx7b/Ssi5FhGukaANJVHExtEHPVNAsJ8fsbEa4kW
E63XpWoIXsf/BI66TgPm
=S6zB
-----END PGP SIGNATURE-----

--nextPart1845810.S9ZeBu6asH--
