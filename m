From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: improve ext4lazyinit scalability
Date: Mon, 08 Aug 2016 16:18:58 +0300
Message-ID: <87bn13iekd.fsf@openvz.org>
References: <1468931432-1568-1-git-send-email-dmonakhov@openvz.org> <20160804182016.GC12861@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34610 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbcHHNTG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Aug 2016 09:19:06 -0400
Received: by mail-wm0-f67.google.com with SMTP id q128so15401171wma.1
        for <linux-ext4@vger.kernel.org>; Mon, 08 Aug 2016 06:19:05 -0700 (PDT)
In-Reply-To: <20160804182016.GC12861@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jan Kara <jack@suse.cz> writes:

> Hi Dmitry!
>
> Some spelling fixes below:
>
> On Tue 19-07-16 16:30:32, Dmitry Monakhov wrote:
>> ext4lazyinit is global thread. This thread performs itable initalization
>> under
>         ^^ li_list_mtx mutex.
>
>> It basically does followes:
>                     ^^^^ following
>
>> ext4_lazyinit_thread
>>   ->mutex_lock(&eli->li_list_mtx);
>>   ->ext4_run_li_request(elr)
>>     ->ext4_init_inode_table-> Do a lot of IO if list is large
> 						^^ the
>
>> And when new mounts/umount arrives they have to block on ->li_list_mtx
>                ^^^^ mount      ^^ arrive
>
>> because  lazy_thread holds it during full walk procedure.
>> ext4_fill_super
>>  ->ext4_register_li_request
>>    ->mutex_lock(&ext4_li_info->li_list_mtx);
>>    ->list_add(&elr->lr_request, &ext4_li_info >li_request_list);
>> In my case mount takes 40minutes on server with 36 * 4Tb HDD.
>> Convenient user may face this in case of very slow dev ( /dev/mmcblkXXX)
>    ^^^ Common?
>
>> Even more. I one of filesystem was frozen lazyinit_thread will simply bl=
ocks
>              ^^ If     ^^^ filesystems				    block ^^
>
>> on sb_start_write() so other mount/umounts will suck forever.
> 					^^ umount ^^^ be stuck
>
>> This patch changes logic like follows:
>> - grap ->s_umount read sem before process new li_request after that it i=
s safe
>     ^^ grab                         ^^ processing         ^^^^. After
>>   to drop list_mtx because all callers of li_remove_requers are holds ->=
s_umount
>             ^^ li_list_mtx                   ^^ li_remove_request  ^^ hol=
ding
>>   for write.
>> - li_thread skip frozen SB's
>               ^^ skips
>
>> Locking:
>> Locking order is asserted by umout path like follows: s_umount ->li_list=
_mtx
>                                ^^ umount
>
>> so the only way to to grab ->s_mount inside li_thread is via down_read_t=
rylock
>                   ^^^^^ should be just one 'to'
>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>
>> ---
>>  fs/ext4/super.c | 53 ++++++++++++++++++++++++++++++++++++--------------=
---
>>  1 file changed, 36 insertions(+), 17 deletions(-)
>>=20
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 3822a5a..0ee193f 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -2635,7 +2635,6 @@ static int ext4_run_li_request(struct ext4_li_requ=
est *elr)
>>  	sb =3D elr->lr_super;
>>  	ngroups =3D EXT4_SB(sb)->s_groups_count;
>>=20=20
>> -	sb_start_write(sb);
>>  	for (group =3D elr->lr_next_group; group < ngroups; group++) {
>>  		gdp =3D ext4_get_group_desc(sb, group, NULL);
>>  		if (!gdp) {
>> @@ -2662,8 +2661,6 @@ static int ext4_run_li_request(struct ext4_li_requ=
est *elr)
>>  		elr->lr_next_sched =3D jiffies + elr->lr_timeout;
>>  		elr->lr_next_group =3D group + 1;
>>  	}
>> -	sb_end_write(sb);
>> -
>>  	return ret;
>>  }
>>=20=20
>> @@ -2713,9 +2710,9 @@ static struct task_struct *ext4_lazyinit_task;
>>  static int ext4_lazyinit_thread(void *arg)
>>  {
>>  	struct ext4_lazy_init *eli =3D (struct ext4_lazy_init *)arg;
>> -	struct list_head *pos, *n;
>>  	struct ext4_li_request *elr;
>>  	unsigned long next_wakeup, cur;
>> +	LIST_HEAD(request_list);
>>=20=20
>>  	BUG_ON(NULL =3D=3D eli);
>>=20=20
>> @@ -2728,21 +2725,43 @@ cont_thread:
>>  			mutex_unlock(&eli->li_list_mtx);
>>  			goto exit_thread;
>>  		}
>> -
>> -		list_for_each_safe(pos, n, &eli->li_request_list) {
>> -			elr =3D list_entry(pos, struct ext4_li_request,
>> -					 lr_request);
>> -
>> -			if (time_after_eq(jiffies, elr->lr_next_sched)) {
>> -				if (ext4_run_li_request(elr) !=3D 0) {
>> -					/* error, remove the lazy_init job */
>> -					ext4_remove_li_request(elr);
>> -					continue;
>> +		list_splice_init(&eli->li_request_list, &request_list);
>
> Do you really need this temporary list? You could as well iterate through
> the original list if you fetch the next entry after you reacquire
> li_list_mtx and before you remove current entry from the list...
Yes. Probably this will be better. I'll resend updated version.
>
>> +		while (!list_empty(&request_list)) {
>> +			int err =3D 0;
>> +			int progress =3D 0;
>> +
>> +			elr =3D list_entry(request_list.next,
>> +					 struct ext4_li_request, lr_request);
>> +			list_move(request_list.next, &eli->li_request_list);
>> +			if (time_before(jiffies, elr->lr_next_sched)) {
>> +				if (time_before(elr->lr_next_sched, next_wakeup))
>> +					next_wakeup =3D elr->lr_next_sched;
>> +				continue;
>> +			}
>> +			if (down_read_trylock(&elr->lr_super->s_umount)) {
>> +				if (sb_start_write_trylock(elr->lr_super)) {
>> +					progress =3D 1;
>> +					/* We holds sb->s_umount, sb can not
> 						^^ hold
>
> Also we use the following comment style in ext4:
>
> /*
>  * text here
>  * text here
>  */
>
>> +					 * be removed from the list, it is
>> +					 * now safe to drop li_list_mtx
>> +					 */
>> +					mutex_unlock(&eli->li_list_mtx);
>> +					err =3D ext4_run_li_request(elr);
>> +					sb_end_write(elr->lr_super);
>> +					mutex_lock(&eli->li_list_mtx);
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
>>  			}
>> -
>> -			if (time_before(elr->lr_next_sched, next_wakeup))
>> -				next_wakeup =3D elr->lr_next_sched;
>>  		}
>>  		mutex_unlock(&eli->li_list_mtx);
>
> Otherwise the patch looks good to me.
>
> 									Honza
> --=20
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJXqIbDAAoJELhyPTmIL6kBq34IAMgVkMLHJWfVEGA1Igzx9jzq
52uQy5+E6IQZanVdddgudKuyolxJDzMZMsDoAPXdX+uB5Pjs5u2CdFlILB80xWxu
r9afi+xKrfFPVosapM/g7jlaHxtBJolDUZrMHWP3G8TTchd4EAD+Josc+AWeBniK
1GVC/FLeLhvDuubfM2W5Zvw1DITh5Cax+lXXcK56v341hyQVBXUnjVtMGTImH3hl
cJ4OCgtUD9VaZ/B2rXMCHNNZSTLPl+VAhDHItEaNTfv6SpKPA61biDPFgr5nS2in
k3lSjwdyU9I0Kz16fMLYHhhqYPTrCwDvwAeEeAvV12G6gmhG2zfXrBSwkKYHdHY=
=+Hd7
-----END PGP SIGNATURE-----
--=-=-=--
