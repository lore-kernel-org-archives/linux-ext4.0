From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: ext4_mb_mark_free_simple: Fix integer value truncation
Date: Thu, 3 Nov 2016 13:32:33 -0600
Message-ID: <2AE0DCBF-5AB6-47B2-B9F6-B738AFF2EAF2@dilger.ca>
References: <1478164472-28376-1-git-send-email-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2264933D-DB6D-41EA-B647-76D0486ABEF0"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        aneesh.kumar@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35909 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756858AbcKCTcj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2016 15:32:39 -0400
Received: by mail-oi0-f65.google.com with SMTP id 128so8424266oih.3
        for <linux-ext4@vger.kernel.org>; Thu, 03 Nov 2016 12:32:39 -0700 (PDT)
In-Reply-To: <1478164472-28376-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2264933D-DB6D-41EA-B647-76D0486ABEF0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 3, 2016, at 3:14 AM, Chandan Rajendra =
<chandan@linux.vnet.ibm.com> wrote:
>=20
> 'border' variable is set to a value of 2 times the block size of the
> underlying filesystem. With 64k block size, the resulting value won't
> fit into a 16-bit variable. Hence this commit changes the data type of
> 'border' to 'unsigned int'.
>=20
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/mballoc.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index f418f55..a937ac7 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -669,7 +669,7 @@ static void ext4_mb_mark_free_simple(struct =
super_block *sb,
> 	ext4_grpblk_t min;
> 	ext4_grpblk_t max;
> 	ext4_grpblk_t chunk;
> -	unsigned short border;
> +	unsigned int border;
>=20
> 	BUG_ON(len > EXT4_CLUSTERS_PER_GROUP(sb));
>=20
> --
> 2.5.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_2264933D-DB6D-41EA-B647-76D0486ABEF0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWBuQ0XKl2rkXzB/gAQgNCRAApGlZNtWZQfASdJqkdx6QATtnnxR+jml9
dkt8VR49Efs1+nlptxrBNvcGSc9YF4Z0RzyKSIDHN3ZT8lXc7j5bZxP9YgRLTlmv
+9+l/3Kou3wUQeY2iChGNUksVNRPljsAD8ecUnNuJCpqU5V3B6n0SfLHhZEomCzE
0O/QRfROthE7CRAMyJw137+iyrWTyzpweYWyVcoJx0JAsVVTJnH8LXCNzGsnFdUi
ybv5Rxl9Z20kpUtXNuE9ersFzeIjuLjId/nF3XzWuaVRmNRtlNt72YSZj4rJddS8
R/9AmHZ0HFtNvHYZiJOd0NuRGMnGGi8vsxMMkHQ1ajD7Q6nvigxUecyJauMQaqKI
c99RLoUa7XhaPWaN4IB+gD+Ex+Vab0rNPi/p/B4DvnAUWOdwjAMarZkHY8KMGBrh
5AetJa3B34rB7f3vgaglMC1K58pGkI7f7o14+bD9YvkaXIKw5yWaq1NSfDy5wG0w
RItinF22T5Hc9R+S0niMikxb8KwSR5YF4sDqWl+KKZDHSdK6ooBfhPxOoRhGy49w
MP91O9mvaalz8NiM73CnFogNPoOqvwolf91ALQKLIWgmvbrZ0qdSi5Z+6CQD53f0
XYQR8EwJkur4517RR2J1ZmMybBzRhB6svUdGaiTU44IEqaghjrWL5KpTf+IllAZ8
X6aBMupYdr8=
=SwRD
-----END PGP SIGNATURE-----

--Apple-Mail=_2264933D-DB6D-41EA-B647-76D0486ABEF0--
