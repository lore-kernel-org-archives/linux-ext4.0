From: Dmitry Monakhov <dmonakhov@sw.ru>
Subject: Re: [PATCH] ext4:fix invariant checking in ext4_rebalance_reservation
Date: Tue, 19 Jun 2007 09:56:05 +0400
Message-ID: <20070619055605.GA20172@localhost.sw.ru>
References: <20070614072352.GA6517@localhost.sw.ru> <4672202C.4080304@clusterfs.com> <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com> <20070616080200.GA14349@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:15260 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbXFSFzT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2007 01:55:19 -0400
Content-Disposition: inline
In-Reply-To: <20070616080200.GA14349@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 12:02 =D0=A1=D0=B1=D1=82 16 =D0=98=D1=8E=D0=BD     , Dmitry Monakhov=
 wrote:
> Variable "free" was declarated as __u64 so conidition (free < 0) alwa=
ys
> false, even if free was overflowed during substraction.
> ---
>  fs/ext4/balloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 43ae8f8..a9655f1 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1909,8 +1909,8 @@ void ext4_rebalance_reservation(struct ext4_res=
ervation_slot *rs, __u64 free)
>  			chunk =3D free;
>  		if (rs[i].rs_reserved || i =3D=3D smp_processor_id()) {
>  			rs[i].rs_reserved =3D chunk;
> +			BUG_ON(free < chunk);
>  			free -=3D chunk;
> -			BUG_ON(free < 0);
>  		}
>  	}
>  	BUG_ON(free);
> --=20
> 1.5.2
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
