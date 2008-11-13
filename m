From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] filesystems: use has_capability_noaudit interface for
	reserved blocks checks
Date: Wed, 12 Nov 2008 16:19:18 -0800
Message-ID: <1226535558.12488.30.camel@mingming-laptop>
References: <1226430769.3353.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, dedekind@infradead.org,
	ext-adrian.hunter@nokia.com, linux-mtd@lists.infradead.org,
	dushistov@mail.ru, jmorris@namei.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:54948 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYKMATW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2008 19:19:22 -0500
In-Reply-To: <1226430769.3353.5.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-11-11=E4=BA=8C=E7=9A=84 14:12 -0500=EF=BC=8CEric Paris=E5=
=86=99=E9=81=93=EF=BC=9A
> ext[2,3,4], ufs, and ubifs all check for  CAP_SYS_RESOURCE to determi=
ne
> if they should allow reserved blocks to be used.  A process not havin=
g
> this capability is not failing some security decision and should not =
be
> audited.  Thus move to using has_capability_noaudit.
>=20
Looks fine to me.

Eric Sandeen has  mentioned earlier about the security audit issue with
ext4. We fixed it in ext4, with this it is even better.


Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
>=20
> I would like to push this patch through the security tree (since that=
's
> the only place the new cap_noaudit interface exists), but I'd like to
> get an ACK from each subsystem maintainer.
>=20
>  fs/ext2/balloc.c     |    2 +-
>  fs/ext3/balloc.c     |    2 +-
>  fs/ext4/balloc.c     |    2 +-
>  fs/ubifs/budget.c    |    3 ++-
>  fs/ufs/balloc.c      |    2 +-
>  security/commoncap.c |    1 +
>  security/security.c  |    1 +
>  7 files changed, 8 insertions(+), 5 deletions(-)
>=20
>=20
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 6dac7ba..e06d96d 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -1192,7 +1192,7 @@ static int ext2_has_free_blocks(struct ext2_sb_=
info *sbi)
>=20
>  	free_blocks =3D percpu_counter_read_positive(&sbi->s_freeblocks_cou=
nter);
>  	root_blocks =3D le32_to_cpu(sbi->s_es->s_r_blocks_count);
> -	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
> +	if (free_blocks < root_blocks + 1 && !has_capability_noaudit(curren=
t, CAP_SYS_RESOURCE) &&
>  		sbi->s_resuid !=3D current->fsuid &&
>  		(sbi->s_resgid =3D=3D 0 || !in_group_p (sbi->s_resgid))) {
>  		return 0;
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index f5b57a2..f224ee4 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -1421,7 +1421,7 @@ static int ext3_has_free_blocks(struct ext3_sb_=
info *sbi)
>=20
>  	free_blocks =3D percpu_counter_read_positive(&sbi->s_freeblocks_cou=
nter);
>  	root_blocks =3D le32_to_cpu(sbi->s_es->s_r_blocks_count);
> -	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
> +	if (free_blocks < root_blocks + 1 && !has_capability_noaudit(curren=
t, CAP_SYS_RESOURCE) &&
>  		sbi->s_resuid !=3D current->fsuid &&
>  		(sbi->s_resgid =3D=3D 0 || !in_group_p (sbi->s_resgid))) {
>  		return 0;
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index d2003cd..a7c7c52 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -626,7 +626,7 @@ int ext4_has_free_blocks(struct ext4_sb_info *sbi=
, s64 nblocks)
>  	/* Hm, nope.  Are (enough) root reserved blocks available? */
>  	if (sbi->s_resuid =3D=3D current->fsuid ||
>  	    ((sbi->s_resgid !=3D 0) && in_group_p(sbi->s_resgid)) ||
> -	    capable(CAP_SYS_RESOURCE)) {
> +	    has_capability_noaudit(current, CAP_SYS_RESOURCE)) {
>  		if (free_blocks >=3D (nblocks + dirty_blocks))
>  			return 1;
>  	}
> diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
> index 1a4973e..d17b8b4 100644
> --- a/fs/ubifs/budget.c
> +++ b/fs/ubifs/budget.c
> @@ -32,6 +32,7 @@
>=20
>  #include "ubifs.h"
>  #include <linux/writeback.h>
> +#include <linux/capability.h>
>  #include <asm/div64.h>
>=20
>  /*
> @@ -363,7 +364,7 @@ long long ubifs_calc_available(const struct ubifs=
_info *c, int min_idx_lebs)
>   */
>  static int can_use_rp(struct ubifs_info *c)
>  {
> -	if (current->fsuid =3D=3D c->rp_uid || capable(CAP_SYS_RESOURCE) ||
> +	if (current->fsuid =3D=3D c->rp_uid || has_capability_noaudit(curre=
nt, CAP_SYS_RESOURCE) ||
>  	    (c->rp_gid !=3D 0 && in_group_p(c->rp_gid)))
>  		return 1;
>  	return 0;
> diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
> index 0d9ada1..ad4398b 100644
> --- a/fs/ufs/balloc.c
> +++ b/fs/ufs/balloc.c
> @@ -411,7 +411,7 @@ u64 ufs_new_fragments(struct inode *inode, void *=
p, u64 fragment,
>  	/*
>  	 * There is not enough space for user on the device
>  	 */
> -	if (!capable(CAP_SYS_RESOURCE) && ufs_freespace(uspi, UFS_MINFREE) =
<=3D 0) {
> +	if (!has_capability_noaudit(current, CAP_SYS_RESOURCE) && ufs_frees=
pace(uspi, UFS_MINFREE) <=3D 0) {
>  		unlock_super (sb);
>  		UFSD("EXIT (FAILED)\n");
>  		return 0;
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 73999f6..5401e77 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -55,6 +55,7 @@ int cap_capable(struct task_struct *tsk, int cap, i=
nt audit)
>  		return 0;
>  	return -EPERM;
>  }
> +EXPORT_SYMBOL(cap_capable);
>=20
>  int cap_settime(struct timespec *ts, struct timezone *tz)
>  {
> diff --git a/security/security.c b/security/security.c
> index 346f21e..d061eb1 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -170,6 +170,7 @@ int security_capable_noaudit(struct task_struct *=
tsk, int cap)
>  {
>  	return security_ops->capable(tsk, cap, SECURITY_CAP_NOAUDIT);
>  }
> +EXPORT_SYMBOL(security_capable_noaudit);
>=20
>  int security_acct(struct file *file)
>  {
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
