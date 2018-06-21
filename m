From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/6] ext4: use ktime_get_real_seconds for i_dtime
Date: Thu, 21 Jun 2018 11:27:12 -0600
Message-ID: <F6095896-5B1A-4A20-9293-086A9350F75C@dilger.ca>
References: <20180620153322.54221-1-arnd@arndb.de>
 <20180620153322.54221-3-arnd@arndb.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E6769417-94BF-43FF-8F93-8EAFD27B5C24";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        y2038@lists.linaro.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Tahsin Erdogan <tahsin@google.com>,
        Miao Xie <miaoxie@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620153322.54221-3-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_E6769417-94BF-43FF-8F93-8EAFD27B5C24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Jun 20, 2018, at 9:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> We only care about the low 32-bit for i_dtime as explained in commit
> b5f515735bea ("ext4: avoid Y2038 overflow in recently_deleted()"), so
> the use of get_seconds() is correct here, but that function is getting
> removed in the process of the y2038 fixes, so let's use the modern
> ktime_get_real_seconds() here.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks OK, one minor cleanup possible.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/inode.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2ea07efbe016..600e2063d1df 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -317,7 +317,7 @@ void ext4_evict_inode(struct inode *inode)
> 	 * (Well, we could do this if we need to, but heck - it works)
> 	 */
> 	ext4_orphan_del(handle, inode);
> -	EXT4_I(inode)->i_dtime	= get_seconds();
> +	EXT4_I(inode)->i_dtime	= ktime_get_real_seconds();

Not strictly necessary, but it might be good from a code clarity POV
to use:

	EXT4_I(inode)->i_dtime	= (__u32)ktime_get_real_seconds();

so that it is more clear we are aware that this is being truncated
to a 32-bit value.

Cheers, Andreas






--Apple-Mail=_E6769417-94BF-43FF-8F93-8EAFD27B5C24
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlsr3/AACgkQcqXauRfM
H+DRYg//cC5j8y+Lv/9+T+/li60E2dnTqpKtRjjQ6i+yp+UWqYRCxOjPzsZzrlxo
MBoJ0HWR9QmT48wgMbnOapNCsf9uhOfazrGs7ps3E9ukKlnSoA5aFUcf/jnvsNlV
nRQSfq5u4UMptsrO2MpJeAcNQHBI5EKrsfSbyy+TjdGOHEJHZY0h7XfXU3G5U0Wf
qtKuKzI72Q+XbPCbAfX9xDpGXDihVwhyBj3vHHLGnHPLu02cS2jahqFd7PQ73qNV
P2Ho3uypo66CwnOikN8eQc0CaipwBcts7wvntvVzXhzBsKgxcscuJnkXBON9UImA
5xhN4T/+I0s5RlKigjNffY0pyyoQSrr1tEsn2VUBNXn7BxJ2jucqp4PPjQzDlcM4
Gq31QkPD2nTHWUeMC40rFoHACN1opkegpOdIuARio18i3wyoav9Jyn2TlEvG982u
HGJPXowgzMicW6X1TXm+9C53QpipsLJpOampRWTlsIvhLohWKRDgo7L1lglGJPAQ
hPo+IJyxIg8qyN17R5hVIw1kNEYFj1BsdbD7Tvgm7wnwkLvkJuYD0aaw4OHRls3F
qCpMBPw9e1tQTKlJmLIPrnY97JB16aIGEukUXP/H2ng0wMgxuNpx2Xlocb/XPBAh
QdEthlWI6GuPqqXqFoqjqsjXdYXaMWVAlrfZ3AmGQXvwI8m4Ags=
=SGjj
-----END PGP SIGNATURE-----

--Apple-Mail=_E6769417-94BF-43FF-8F93-8EAFD27B5C24--
