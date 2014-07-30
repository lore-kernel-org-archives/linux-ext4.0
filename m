From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 2/6] fiemap: add fe_phys_length and EXTENT_PHYS_LENGTH flag
Date: Wed, 30 Jul 2014 14:06:16 -0600
Message-ID: <D8092848-4221-4590-93F6-B99DAC1C9340@dilger.ca>
References: <cover.1406739708.git.dsterba@suse.cz> <f257ce29393707293c0ce056bd8c6a7b3daa6082.1406739708.git.dsterba@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_00E7CCA7-83E9-400E-95F1-80CEB4C45037"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mfasheh-IBi9RG/b67k@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f257ce29393707293c0ce056bd8c6a7b3daa6082.1406739708.git.dsterba-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_00E7CCA7-83E9-400E-95F1-80CEB4C45037
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


On Jul 30, 2014, at 11:18 AM, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org> wrote:
> Add a new member to fiemap_extent that represents the physical extent
> length. This value is undefined if the flag EXTENT_PHYS_LENGTH is not
> set.

The description here of PHYS_LENGTH makes sense...

The patch description should also mention the name of the new member,
namely "fe_phys_length"

> +#define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010 /* Physical length of extent
> +						    * not the same as logical */

But the comment doesn't match.  This implies that if PHYS_LENGTH is
set, fe_phys_length != fe_logi_length, but I don't think that is
necessarily correct.  I think it makes more sense to just set
PHYS_LENGTH when fe_phys_length is valid, and if PHYS_LENGTH is not
set then fe_phys_length aware applications should just use
fe_phys_length = fe_logi_length, and older applications would just
use fe_length for both as they would already today.

Cheers, Andreas






--Apple-Mail=_00E7CCA7-83E9-400E-95F1-80CEB4C45037
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9lQOHKl2rkXzB/gAQKpuw/6A2AImmTn8LGApwztQs9J/443KmMAIP8K
OBKsMaLL8K84nsoFqnp6WnZKCmPDGb7GhVDNMcJgBgGdNd1aQWCeuy9+8H89GLQP
62iYI9LR+d3bypthFMdjtJaNA7Uk+Wz5ShnBnJFuewPu0IF5xydxEM5TlRcKmqyV
JtSwxyYZduU43lPfmtbjxWDlZWL+MybLFn9dcYzw8oFQNn7iJIVpswDvHdT93l17
rBAs8xvZovNuXSrbSvrULhUncDw3iS7eK6wev76qQ9iY8BnVwJ3+0c/gWIAnXHQp
b1du3ccLpMrc9YNhQn2yM3gNV6AKNV/u3dBUOtRV+qVw5nPBApAtLpD4HOuZ6ORG
0x1h/4I2p3HtgwoEYOK5Y1nsQQho7b5IkYhk7GikYZdAdBZ3m0Ym7qMVPGLKPgNx
hq//wzT1wUih6w0EbaI3dnmLv8haGMgL2vRKvhnvit4dLHDYew42vqAVB9TohjkG
DKQlUgv6eyaVzxrTopQHm4J1AWocGvqGf4J3tiABg2Z53KS9858qkFIJl/U5m009
qLcv0vpbV7bNRGKceN1W5Ji9tfWjU3FR5U+f+U8xMvm0DNxE5Muddke1+NwLjBvE
4ODmIFb9Tfwa1aWn1tPWRa0/Uv/pG+pwVKYaoCNIYFIzRhuATqhnHlQR2V43hom3
APmgbwvUYQw=
=S2WY
-----END PGP SIGNATURE-----

--Apple-Mail=_00E7CCA7-83E9-400E-95F1-80CEB4C45037--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
