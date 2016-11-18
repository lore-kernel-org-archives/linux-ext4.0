From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] ext4: sanity check the block and cluster size at mount time
Date: Fri, 18 Nov 2016 01:38:10 -0700
Message-ID: <DF4FD9C9-580B-4DBE-BD88-6E7067EC69E9@dilger.ca>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com> <20161118042610.13464-1-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_4F770C02-CBE4-487B-95EC-CF3C4E14DDF9"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kernel@kyup.com,
        bp@alien8.de, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161118042610.13464-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_4F770C02-CBE4-487B-95EC-CF3C4E14DDF9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 17, 2016, at 9:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> If the block size or cluster size is insane, reject the mount.  This
> is important for security reasons (although we shouldn't be just
> depending on this check).
>=20
> Ref: http://www.securityfocus.com/archive/1/539661
> Ref: https://bugzilla.redhat.com/show_bug.cgi?id=3D1332506
> Reported-by: Borislav Petkov <bp@alien8.de>
> Reported-by: Nikolay Borisov <kernel@kyup.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
> fs/ext4/ext4.h  |  1 +
> fs/ext4/super.c | 17 ++++++++++++++++-
> 2 files changed, 17 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 35ccbdc2d64e..12f50ef56fe1 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3567,7 +3567,15 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
> 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
> 		ext4_msg(sb, KERN_ERR,
> -		       "Unsupported filesystem blocksize %d", =
blocksize);
> +		       "Unsupported filesystem blocksize %d (%d)",

Would be good to indicate what the second value is, like "(%d bits)".

Cheers, Andreas

> +			 blocksize, le32_to_cpu(es->s_log_block_size));
> +		goto failed_mount;
> +	}
> +	if (le32_to_cpu(es->s_log_block_size) >
> +	    (EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "Invalid log block size: %u",
> +			 le32_to_cpu(es->s_log_block_size));
> 		goto failed_mount;
> 	}
>=20
> @@ -3699,6 +3707,13 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 				 "block size (%d)", clustersize, =
blocksize);
> 			goto failed_mount;
> 		}
> +		if (le32_to_cpu(es->s_log_cluster_size) >
> +		    (EXT4_MAX_CLUSTER_LOG_SIZE - =
EXT4_MIN_BLOCK_LOG_SIZE)) {
> +			ext4_msg(sb, KERN_ERR,
> +				 "Invalid log cluster size: %u",
> +				 le32_to_cpu(es->s_log_cluster_size));
> +			goto failed_mount;
> +		}
> 		sbi->s_cluster_bits =3D =
le32_to_cpu(es->s_log_cluster_size) -
> 			le32_to_cpu(es->s_log_block_size);
> 		sbi->s_clusters_per_group =3D
> --
> 2.11.0.rc0.7.gbe5a750
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_4F770C02-CBE4-487B-95EC-CF3C4E14DDF9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWC699HKl2rkXzB/gAQhNDQ/+LT8WwH7nt8DqTnH+WtFy+asc+UZ0NTMT
Rl8uJqRtwHPdum1wd6qRVUNJ3rJvhzy3AFAXhdouxsSBEa3AMAuPPG/vw1y5bUzH
VYam8F97gKf2RJKBTG5BbGpHLCUiSPu8DBOu5UosgMeTJjbqCYLT9sP0oAtMmtbF
dIoIiz4fkhviVLG0GW8JFhaOyuhL65iNUH1egFfJDLW4HmicTR0/ZMgO7/zzbckm
DQU7Il4R0QRx/wuwIxUy8rshSJ0Mybrt1GLSRUv6zATLFzDl2Fb6tvGZf0Eg9Pu+
iACeiKJc+3O89AVzJxY5IA2OZolc1DBQ5N2kQjw43cz5oH79akSY6WNz5tjqvZhJ
gFRVenn5246o9yRXIpBSuUGigYuAwkAMCyJDnH7kfsil5WT1bimwCuMVj4CCHEDH
g2rj6+DDCiNtSkc3m/kEeKrI1/rwQKS7iz8Z3tpW9oWF1vrDECfkQbJSNVvHiJVD
0dacI1FnKbq8GnpfmxTgUvTx+6TND67yMw1MQjh+s3K++MyjuWW7FxtCHe9ArRkm
gtbGt5lbhNzLTqudIvEHUrWslnnGQBg3VJkf7sagRimwFX8t+PkdcBllDKKykiCG
coQau1Rzmb4FEEjXvaOl4EmgM7GGIsbb+4WAY1eDbRSdI2Pp81MCbAWAUcjT1gag
i8u9YEtx5M8=
=7yht
-----END PGP SIGNATURE-----

--Apple-Mail=_4F770C02-CBE4-487B-95EC-CF3C4E14DDF9--
