From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] percpu_counters: Add new function
	percpu_counter_sum_and_sub
Date: Fri, 22 Aug 2008 11:01:16 -0700
Message-ID: <1219428076.6306.8.camel@mingming-laptop>
References: <1219412074-30584-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219412074-30584-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49543 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbYHVSBw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2008 14:01:52 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7MI1iiI020541
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 14:01:44 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7MI1IfO234284
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 14:01:18 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7MI1HXM030427
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 14:01:18 -0400
In-Reply-To: <1219412074-30584-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-22=E4=BA=94=E7=9A=84 19:04 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> percpu_counter_sum_and_sub(struct percpu_counter *fbc, s64 amount)
>=20
> This will be later used by ext4 code. It adds up the local
> per cpu counter values to global count and subtract amount
> from the gloabl count if gloabl count is > amount. This is
> used during block resrevation to check within a lock we
> have sufficient free blocks if so also claim the blocks.
>=20

I'd  suggest repost the patch to lkml for this new interface change whe=
n
this patch is ready. It would be nice to have ext4 part of change which
use this interface being sent together in a series.


Patch looks fine except a small place, see comment below.

You could add Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  include/linux/percpu_counter.h |   17 +++++++++++++++++
>  lib/percpu_counter.c           |   27 +++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_co=
unter.h
> index af485b1..978db67 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -36,6 +36,7 @@ void percpu_counter_destroy(struct percpu_counter *=
fbc);
>  void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
>  void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s3=
2 batch);
>  s64 __percpu_counter_sum(struct percpu_counter *fbc);
> +s64 __percpu_counter_sum_and_sub(struct percpu_counter *fbc, s64 amo=
unt);
>=20
>  static inline void percpu_counter_add(struct percpu_counter *fbc, s6=
4 amount)
>  {
> @@ -53,6 +54,12 @@ static inline s64 percpu_counter_sum(struct percpu=
_counter *fbc)
>  	return __percpu_counter_sum(fbc);
>  }
>=20
> +static inline int percpu_counter_sum_and_sub(struct percpu_counter *=
fbc,
> +						s64 amount)
> +{
> +	return __percpu_counter_sum_and_sub(fbc, amount);
> +}
> +
>  #if BITS_PER_LONG =3D=3D 64
>  static inline s64 fbc_count(struct percpu_counter *fbc)
>  {
> @@ -146,6 +153,16 @@ static inline s64 percpu_counter_sum(struct perc=
pu_counter *fbc)
>  	return percpu_counter_read(fbc);
>  }
>=20
> +static inline int percpu_counter_sum_and_sub(struct percpu_counter *=
fbc,
> +						s64 amount)
> +{
> +	if (fbc->count >=3D amount) {
> +		percpu_counter_sub(fbc, amount);
> +		return 0;
> +	}
> +	return -E2BIG;
> +}
> +
>  #endif	/* CONFIG_SMP */
>=20
>  static inline void percpu_counter_inc(struct percpu_counter *fbc)
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index a866389..0336062 100644
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -71,6 +71,33 @@ s64 __percpu_counter_sum(struct percpu_counter *fb=
c)
>  }
>  EXPORT_SYMBOL(__percpu_counter_sum);
>=20
> + /*
> +  * Add up all the per-cpu counts. If the result is greater than
> +  * amount subtract amount from result and return 0. Otherwise retur=
n
> +  * -E2BIG
> +  */
> +s64 __percpu_counter_sum_and_sub(struct percpu_counter *fbc, s64 amo=
unt)

Seems it returns 0 for success, and error code on failur. In this case,
should the return value type as s64?

I noticed previous ly  the caller returns "int" type, so this might be
just a copy-and-paste error.

+static inline int percpu_counter_sum_and_sub(struct percpu_counter
*fbc,


> +{
> +	s64 ret;
> +	int cpu;
> +
> +	spin_lock(&fbc->lock);
> +	ret =3D fbc->count;
> +	for_each_online_cpu(cpu) {
> +		s32 *pcount =3D per_cpu_ptr(fbc->counters, cpu);
> +		ret +=3D *pcount;
> +		*pcount =3D 0;
> +	}
> +	if (ret >=3D amount) {
> +		fbc->count =3D ret - amount;
> +		spin_unlock(&fbc->lock);
> +		return 0;
> +	}
> +	spin_unlock(&fbc->lock);
> +	return -E2BIG;
> +}
> +EXPORT_SYMBOL(__percpu_counter_sum_and_sub);
> +
>  static struct lock_class_key percpu_counter_irqsafe;
>=20
>  int percpu_counter_init(struct percpu_counter *fbc, s64 amount)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
