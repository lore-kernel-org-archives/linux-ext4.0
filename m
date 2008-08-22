From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] percpu_counters: make fbc->count read atomic on 32
	bit architecture
Date: Fri, 22 Aug 2008 11:29:54 -0700
Message-ID: <1219429794.6306.34.camel@mingming-laptop>
References: <1219412074-30584-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:48320 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYHVS37 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2008 14:29:59 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7MITuQi016594
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 14:29:57 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7MITu8L145516
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 12:29:56 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7MITt3X004404
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 12:29:56 -0600
In-Reply-To: <1219412074-30584-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-22=E4=BA=94=E7=9A=84 19:04 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> fbc->count is of type s64. The change was introduced by
> 0216bfcffe424a5473daa4da47440881b36c1f4 which changed the type
> from long to s64. Moving to s64 also means on 32 bit architectures
> we can get wrong values on fbc->count.
>=20
> percpu_counter_read is used within interrupt context also. So
> use the irq safe version of spinlock while reading
>=20

It's quit expensive to hold the lock to do percpu_counter_read  on 32
bit arch, the common case.
=20
The type of the global counter and local counter were explictly
specified using s64 and s32 The global counter is changed from long to
s64, while the local counter is changed from long to s32, so we could
avoid doing 64 bit update in most cases.  After all the percpu counter
read is not a accurate value.=20

Mingming
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/percpu_counter.h |   23 +++++++++++++++++++++--
>  1 files changed, 21 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_co=
unter.h
> index 9007ccd..af485b1 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -53,10 +53,29 @@ static inline s64 percpu_counter_sum(struct percp=
u_counter *fbc)
>  	return __percpu_counter_sum(fbc);
>  }
>=20
> -static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> +#if BITS_PER_LONG =3D=3D 64
> +static inline s64 fbc_count(struct percpu_counter *fbc)
>  {
>  	return fbc->count;
>  }
> +#else
> +/* doesn't have atomic 64 bit operation */
> +static inline s64 fbc_count(struct percpu_counter *fbc)
> +{
> +	s64 ret;
> +	unsigned long flags;
> +	spin_lock_irqsave(&fbc->lock, flags);
> +	ret =3D fbc->count;
> +	spin_unlock_irqrestore(&fbc->lock, flags);
> +	return ret;
> +
> +}
> +#endif
> +
> +static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> +{
> +	return fbc_count(fbc);
> +}
>=20
>  /*
>   * It is possible for the percpu_counter_read() to return a small ne=
gative
> @@ -65,7 +84,7 @@ static inline s64 percpu_counter_read(struct percpu=
_counter *fbc)
>   */
>  static inline s64 percpu_counter_read_positive(struct percpu_counter=
 *fbc)
>  {
> -	s64 ret =3D fbc->count;
> +	s64 ret =3D fbc_count(fbc);
>=20
>  	barrier();		/* Prevent reloads of fbc->count */
>  	if (ret >=3D 0)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
