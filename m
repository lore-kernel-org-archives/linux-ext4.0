From: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH]: ext4: fix big endian  (was: not enough memory for 522250 flex groups)
Date: Thu, 06 Nov 2008 17:06:57 +0100
Message-ID: <jefxm4alem.fsf@sykes.suse.de>
References: <200811061600.54264.borntraeger@de.ibm.com>
	<200811061651.49602.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200811061651.49602.borntraeger@de.ibm.com> (Christian
	Borntraeger's message of "Thu, 6 Nov 2008 16:51:49 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> Index: kvm/fs/ext4/super.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- kvm.orig/fs/ext4/super.c
> +++ kvm/fs/ext4/super.c
> @@ -1455,7 +1455,7 @@ static int ext4_fill_flex_info(struct su
> =20
>  	/* We allocate both existing and potentially added groups */
>  	flex_group_count =3D ((sbi->s_groups_count + groups_per_flex - 1) +
> -			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
> +			    (le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks + 1) <<

You need to put the "+ 1" after the swap.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
