From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/6] ext4: use 64-bit timestamps for mmp_time
Date: Thu, 21 Jun 2018 11:20:24 -0600
Message-ID: <711B183B-8F48-49C0-AC33-907384D10672@dilger.ca>
References: <20180620153322.54221-1-arnd@arndb.de>
 <20180620153322.54221-2-arnd@arndb.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E79BA00D-983B-49F2-BC1F-60E7BA4D0162";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        y2038@lists.linaro.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620153322.54221-2-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_E79BA00D-983B-49F2-BC1F-60E7BA4D0162
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jun 20, 2018, at 9:32 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> The mmp_time field is 64 bits wide, which is good, but calling
> get_seconds() results in a 32-bit value on 32-bit architectures. Using
> ktime_get_real_seconds() instead returns 64 bits everywhere.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/mmp.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 27b9a76a0dfa..39da4eb48361 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -147,7 +147,7 @@ static int kmmpd(void *data)
> 
> 	mmp_block = le64_to_cpu(es->s_mmp_block);
> 	mmp = (struct mmp_struct *)(bh->b_data);
> -	mmp->mmp_time = cpu_to_le64(get_seconds());
> +	mmp->mmp_time = cpu_to_le64(ktime_get_real_seconds());
> 	/*
> 	 * Start with the higher mmp_check_interval and reduce it if
> 	 * the MMP block is being updated on time.
> @@ -165,7 +165,7 @@ static int kmmpd(void *data)
> 			seq = 1;
> 
> 		mmp->mmp_seq = cpu_to_le32(seq);
> -		mmp->mmp_time = cpu_to_le64(get_seconds());
> +		mmp->mmp_time = cpu_to_le64(ktime_get_real_seconds());
> 		last_update_time = jiffies;
> 
> 		retval = write_mmp_block(sb, bh);
> @@ -244,7 +244,7 @@ static int kmmpd(void *data)
> 	 * Unmount seems to be clean.
> 	 */
> 	mmp->mmp_seq = cpu_to_le32(EXT4_MMP_SEQ_CLEAN);
> -	mmp->mmp_time = cpu_to_le64(get_seconds());
> +	mmp->mmp_time = cpu_to_le64(ktime_get_real_seconds());
> 
> 	retval = write_mmp_block(sb, bh);
> 
> --
> 2.9.0
> 


Cheers, Andreas






--Apple-Mail=_E79BA00D-983B-49F2-BC1F-60E7BA4D0162
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlsr3lgACgkQcqXauRfM
H+ASfw//foruYMBroerLYos6rc4jWqUdoTo9h8hB1HTM4E9GxUcZKBy1rRDCd+hr
Y3jTyFozDB5RwtPfcBX7AF0SzaTC4+tJ96YyNetl2t4eKETl7OSEKM8QplFa/djF
WXD9muJfZbQ4cntrphl+n6UpBY/jbC15HdeYhwRNHLIOfkAzp2BAKe+Okdo1o+hk
zcavA0Cx1To+Vy2W96ahuEMwdVHk0lFpBs8pJJ9j0VEM7OdiIRFTatJMSdHTKZUR
FggB6CNbUSK77NXzuzb0vPfwEtnSuOH9wI7dj+axRn8iPLBY+NGMtgAbKXztpE+4
Tl7NryRC2PKKebmKteSzhFJqUGg4T6YUrUlIPDUsqCBtGmg2tlonePZbj0tBKDkd
UgZGIy+zgR1S8b9GFkdwViEjLNhllqBWPvRqkCrtSpvMah0G8Grtwwoty+IlVFT+
LJqnHvfB2VFh0YfWE6Y2pQ9aiOINzUeE02M6X8bDOOa+pBURuumg5oWdzp6xhthh
kY7CKpjQEK7mHeEH0k8Lf8a5XE0yg+UMe23xdUPLA0B6Pw9n8Vc/HRSh/TcUwYkv
9q/2VcesBRcSHgy+T0hu/LEodqx6Eux7gFvcnSX8ifoUtnVyh6OpIT2geUUESSm/
n7kGL1+fE0482DXFdo4uZXR4hOtEj/VKBZUklf7lTR+1RXtcJ9E=
=WQ5v
-----END PGP SIGNATURE-----

--Apple-Mail=_E79BA00D-983B-49F2-BC1F-60E7BA4D0162--
