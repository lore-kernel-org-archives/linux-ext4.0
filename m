From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2/ext3:useless code for return value
Date: Fri, 7 May 2010 18:23:48 +0200
Message-ID: <20100507162348.GD3265@atrey.karlin.mff.cuni.cz>
References: <4BE2C5D5.2050207@redflag-linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tj@kernel.org, Christoph Lameter <cl@linux-foundation.org>,
	hch@lst.de, akpm@linux-foundation.org, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: =?utf-8?B?Iua9mOWNq+W5syhQZXRlciBQYW4pIg==?=
	<wppan@redflag-linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48232 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756847Ab0EGQXt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2010 12:23:49 -0400
Content-Disposition: inline
In-Reply-To: <4BE2C5D5.2050207@redflag-linux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> When rsv is the right hand side of goal, we should return NULL,
> because now rsv's prev is NULL, or we return rsv.
>=20
> Signed-off-by: Peter Pan(=E6=BD=98=E5=8D=AB=E5=B9=B3) <wppan@redflag-=
linux.com>
>=20
> ---
>  fs/ext2/balloc.c |    6 +-----
>  fs/ext3/balloc.c |    6 +-----
>  2 files changed, 2 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 3cf038c..023990f 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -323,11 +323,7 @@ search_reserve_window(struct rb_root *root,
> ext2_fsblk_t goal)
>  	 * side of the interval containing the goal.  If it's the RHS,
>  	 * we need to back up one.
>  	 */
> -	if (rsv->rsv_start > goal) {
> -		n =3D rb_prev(&rsv->rsv_node);
> -		rsv =3D rb_entry(n, struct ext2_reserve_window_node, rsv_node);
> -	}
> -	return rsv;
> +    return (rsv->rsv_start < goal) ? rsv : NULL;
  Hmm, I'm not sure I understand your reasoning. Suppose we have an RB-=
tree
with two intervals 0-10, 20-30. Interval 0-10 is in the root. Now we se=
arch
for goal 15. In the root we go to right because 10<15, in the next node=
 we go
to left because 15 < 20. Then the loop terminates. Now your code would =
return
NULL but previous code would return rb_prev of interval 20-30 which is =
0-10.
And that is what we want as far as I understand what we expect from the
function...

								Honza
--=20
Jan Kara <jack@suse.cz>
SuSE CR Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
