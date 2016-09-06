From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: improve ext4lazyinit scalability V2
Date: Tue, 06 Sep 2016 12:49:09 +0300
Message-ID: <87poohcq96.fsf@dmlp.Dlink>
References: <1471263815-26022-1-git-send-email-dmonakhov@openvz.org> <20160815150520.GA22082@quack2.suse.cz> <20160906033954.k22xaasbn26s4wo4@thunk.org> <20160906083608.GB28922@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35115 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755581AbcIFJtT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Sep 2016 05:49:19 -0400
Received: by mail-lf0-f51.google.com with SMTP id l131so48477196lfl.2
        for <linux-ext4@vger.kernel.org>; Tue, 06 Sep 2016 02:49:18 -0700 (PDT)
In-Reply-To: <20160906083608.GB28922@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jan Kara <jack@suse.cz> writes:

> On Mon 05-09-16 23:39:54, Ted Tso wrote:
>> Dmitry, thanks for the patch, and Jan, thanks for the review.
>>=20
>> This is what I've added to the ext4 tree, which should reflect all of
>> the comments which Jan made.
>
> Hum, one comment still:
>
>> +			if (down_read_trylock(&elr->lr_super->s_umount)) {
>> +				if (sb_start_write_trylock(elr->lr_super)) {
>> +					progress =3D 1;
>> +					/*
>> +					 * We hold sb->s_umount, sb can not
>> +					 * be removed from the list, it is
>> +					 * now safe to drop li_list_mtx
>> +					 */
>> +					mutex_unlock(&eli->li_list_mtx);
>> +					err =3D ext4_run_li_request(elr);
>> +					sb_end_write(elr->lr_super);
>> +					mutex_lock(&eli->li_list_mtx);
>> +					n =3D pos->next;
>>  				}
>> +				up_read((&elr->lr_super->s_umount));
>> +			}
>> +			/* error, remove the lazy_init job */
>> +			if (err) {
>> +				ext4_remove_li_request(elr);
>> +				continue;
>> +			}
>> +			if (!progress) {
>> +				elr->lr_next_sched =3D jiffies +
>> +					(prandom_u32()
>> +					 % (EXT4_DEF_LI_MAX_START_DELAY * HZ));
>> +				if (time_before(elr->lr_next_sched,
>> +						next_wakeup))
>> +					next_wakeup =3D elr->lr_next_sched;
>>  			}
>> -
>> -			if (time_before(elr->lr_next_sched, next_wakeup))
>> -				next_wakeup =3D elr->lr_next_sched;
>>  		}
>
> ext4_run_li_request() can also update elr->lr_next_sched. So we need to
> update next_wakeup even in progress =3D=3D 1 case (i.e., I'd leave the up=
date
> of next_wakeup as is in the old code...). Otherwise the patch looks good.
Yes. That is correct. Simply last hank shoul not be deleted.

Theodore, please fold patch attached to original one.

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCgAGBQJXzpEVAAoJELhyPTmIL6kBevwH/RTeh5sfZRYRX93zhtkXOPsL
efLGKD+MJ6ydeB4EoiVDkIGt09M8UeMWYWl+d5okF8QPcY3B+qrwnRIT7/87hph7
9v2nRvPF6nspsw8SJqKkOyuKG4wuRmIHgMSgh86frx5qgoTSP9bLS0zdYFV1Yfzd
uJ/J3xU2NKcho1GpDeSWJbUawt1Me/LUf1FrklR90jA/lJaVDDbgEYwqqfj4xx6X
0PhltPg5PMGFDxpM7Vuwt1nHeYv/jRqhZbln59Ul98y+rMIfQys4s9wtXfp43ao9
fG1X6XRb43nen4vQX24zyEkXlgpQX8CPMRDPMLrHUlqQmahAxFcKzyM6EpaC6PI=
=1alA
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=lazy-init-v2-update-next-sched.patch
Content-Description: lazyinit-v2-update-next-sched.patch

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bf91679..9692bbf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2871,6 +2871,9 @@ cont_thread:
 						next_wakeup))
 					next_wakeup = elr->lr_next_sched;
 			}
+
+			if (time_before(elr->lr_next_sched, next_wakeup))
+				next_wakeup = elr->lr_next_sched;
 		}
 		mutex_unlock(&eli->li_list_mtx);
 

--=-=-=
Content-Type: text/plain



>
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=--
