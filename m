From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Mon, 08 Dec 2008 09:44:58 -0800
Message-ID: <1228758298.7096.5.camel@mingming-laptop>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081206202233.3b74febc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:35846 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYLHRpH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 12:45:07 -0500
In-Reply-To: <20081206202233.3b74febc.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E5=9C=A8 2008-12-06=E5=85=AD=E7=9A=84 20:22 -0800=EF=BC=8CAndrew Morto=
n=E5=86=99=E9=81=93=EF=BC=9A=20
> On Wed, 03 Dec 2008 21:24:36 +0100 Eric Dumazet <dada1@cosmosbay.com>=
 wrote:
>=20
> > Eric Dumazet a __crit :
> > > Hi Andrew
> > >=20
> > > While working on percpu_counter on net-next-2.6, I found
> > > a CPU unplug race in percpu_counter_destroy()
> > >=20
> > > (Very unlikely of course)
> > >=20
> > > Thank you
> > >=20
> > > [PATCH] percpu_counter: fix CPU unplug race in percpu_counter_des=
troy()
> > >=20
> > > We should first delete the counter from percpu_counters list
> > > before freeing memory, or a percpu_counter_hotcpu_callback()
> > > could dereference a NULL pointer.
> > >=20
> > > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> > > ---
> > > lib/percpu_counter.c |    4 ++--
> > > 1 files changed, 2 insertions(+), 2 deletions(-)
> > >=20
> >=20
> > Well, this percpu_counter stuff is simply not working at all.
> >=20
> > We added some percpu_counters to network tree for 2.6.29 and we get
> > drift bugs if calling __percpu_counter_sum() while some heavy duty
> > benches are running, on a 8 cpus machine
> >=20
> > 1) __percpu_counter_sum() is buggy, it should not write
> > on per_cpu_ptr(fbc->counters, cpu), or another cpu
> > could get its changes lost.
> >

Oh, you are right, I missed that, thanks for pointing this out.

>=20
> > __percpu_counter_sum should be read only (const struct percpu_count=
er *fbc),
> > and no locking needed.
>=20
> No, we can't do this - it will break ext4.
>=20

Yes, the needs was coming from the ext4 delayed allocation needs more
accurate free blocks counter to prevent too late ENOSPC issue.  The
intention was trying to get percpu_counter_read_positive()  be more
accurate so that ext4 could avoid going to the slow path very often.

But I overlooked that the update to the local counter race issue. Sorry
about it!

> Take a closer look at 1f7c14c62ce63805f9574664a6c6de3633d4a354 and at
> e8ced39d5e8911c662d4d69a342b9d053eaaac4e.
>=20
> I suggest that what we do is to revert both those changes.  We can
> worry about the possibly-unneeded spin_lock later, in a separate patc=
h.
>=20
> It should have been a separate patch anyway.  It's conceptually
> unrelated and is not a bugfix, but it was mixed in with a bugfix.
>=20
> Mingming, this needs urgent consideration, please.  Note that I had t=
o
> make additional changes to ext4 due to the subsequent introduction of
> the dirty_blocks counter.
>=20
>=20


>=20
> Please read the below changelogs carefully and check that I have got =
my
> head around this correctly - I may not have done.
>=20
> What a mess.
>=20
>=20
I looked at those two revert patches, they looks correct to me.

Thanks alot to take care of the mess.

Mingming
>=20
>=20
> From: Andrew Morton <akpm@linux-foundation.org>
>=20
> Revert
>=20
>     commit 1f7c14c62ce63805f9574664a6c6de3633d4a354
>     Author: Mingming Cao <cmm@us.ibm.com>
>     Date:   Thu Oct 9 12:50:59 2008 -0400
>=20
>         percpu counter: clean up percpu_counter_sum_and_set()
>=20
> Before this patch we had the following:
>=20
> percpu_counter_sum(): return the percpu_counter's value
>=20
> percpu_counter_sum_and_set(): return the percpu_counter's value, copy=
ing
> that value into the central value and zeroing the per-cpu counters be=
fore
> returning.
>=20
> After this patch, percpu_counter_sum_and_set() has gone, and
> percpu_counter_sum() gets the old percpu_counter_sum_and_set()
> functionality.
>=20
> Problem is, as Eric points out, the old percpu_counter_sum_and_set()
> functionality was racy and wrong.  It zeroes out counters on "other" =
cpus,
> without holding any locks which will prevent races agaist updates fro=
m
> those other CPUS.
>=20
> This patch reverts 1f7c14c62ce63805f9574664a6c6de3633d4a354.  This me=
ans
> that percpu_counter_sum_and_set() still has the race, but
> percpu_counter_sum() does not.
>=20
> Note that this is not a simple revert - ext4 has since started using
> percpu_counter_sum() for its dirty_blocks counter as well.
>=20
>=20
> Note that this revert patch changes percpu_counter_sum() semantics.=20
>=20
> Before the patch, a call to percpu_counter_sum() will bring the count=
er's
> central counter mostly up-to-date, so a following percpu_counter_read=
()
> will return a close value.
>=20
> After this patch, a call to percpu_counter_sum() will leave the count=
er's
> central accumulator unaltered, so a subsequent call to
> percpu_counter_read() can now return a significantly inaccurate resul=
t.
>=20
> If there is any code in the tree which was introduced after
> e8ced39d5e8911c662d4d69a342b9d053eaaac4e was merged, and which depend=
s
> upon the new percpu_counter_sum() semantics, that code will break.
>=20
>=20
Acked-by: Mingming Cao <cmm@us.ibm.com>
>=20
> Reported-by: Eric Dumazet <dada1@cosmosbay.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: <linux-ext4@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  fs/ext4/balloc.c               |    4 ++--
>  include/linux/percpu_counter.h |   12 +++++++++---
>  lib/percpu_counter.c           |    8 +++++---
>  3 files changed, 16 insertions(+), 8 deletions(-)
>=20
> diff -puN fs/ext4/balloc.c~revert-percpu-counter-clean-up-percpu_coun=
ter_sum_and_set fs/ext4/balloc.c
> --- a/fs/ext4/balloc.c~revert-percpu-counter-clean-up-percpu_counter_=
sum_and_set
> +++ a/fs/ext4/balloc.c
> @@ -609,8 +609,8 @@ int ext4_has_free_blocks(struct ext4_sb_
>=20
>  	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
>  						EXT4_FREEBLOCKS_WATERMARK) {
> -		free_blocks  =3D percpu_counter_sum(fbc);
> -		dirty_blocks =3D percpu_counter_sum(dbc);
> +		free_blocks  =3D percpu_counter_sum_and_set(fbc);
> +		dirty_blocks =3D percpu_counter_sum_and_set(dbc);
>  		if (dirty_blocks < 0) {
>  			printk(KERN_CRIT "Dirty block accounting "
>  					"went wrong %lld\n",
> diff -puN include/linux/percpu_counter.h~revert-percpu-counter-clean-=
up-percpu_counter_sum_and_set include/linux/percpu_counter.h
> --- a/include/linux/percpu_counter.h~revert-percpu-counter-clean-up-p=
ercpu_counter_sum_and_set
> +++ a/include/linux/percpu_counter.h
> @@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percp
>  void percpu_counter_destroy(struct percpu_counter *fbc);
>  void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
>  void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s3=
2 batch);
> -s64 __percpu_counter_sum(struct percpu_counter *fbc);
> +s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
>=20
>  static inline void percpu_counter_add(struct percpu_counter *fbc, s6=
4 amount)
>  {
> @@ -44,13 +44,19 @@ static inline void percpu_counter_add(st
>=20
>  static inline s64 percpu_counter_sum_positive(struct percpu_counter =
*fbc)
>  {
> -	s64 ret =3D __percpu_counter_sum(fbc);
> +	s64 ret =3D __percpu_counter_sum(fbc, 0);
>  	return ret < 0 ? 0 : ret;
>  }
>=20
> +static inline s64 percpu_counter_sum_and_set(struct percpu_counter *=
fbc)
> +{
> +	return __percpu_counter_sum(fbc, 1);
> +}
> +
> +
>  static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
>  {
> -	return __percpu_counter_sum(fbc);
> +	return __percpu_counter_sum(fbc, 0);
>  }
>=20
>  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> diff -puN lib/percpu_counter.c~revert-percpu-counter-clean-up-percpu_=
counter_sum_and_set lib/percpu_counter.c
> --- a/lib/percpu_counter.c~revert-percpu-counter-clean-up-percpu_coun=
ter_sum_and_set
> +++ a/lib/percpu_counter.c
> @@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
>   * Add up all the per-cpu counts, return the result.  This is a more=
 accurate
>   * but much slower version of percpu_counter_read_positive()
>   */
> -s64 __percpu_counter_sum(struct percpu_counter *fbc)
> +s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
>  {
>  	s64 ret;
>  	int cpu;
> @@ -62,9 +62,11 @@ s64 __percpu_counter_sum(struct percpu_c
>  	for_each_online_cpu(cpu) {
>  		s32 *pcount =3D per_cpu_ptr(fbc->counters, cpu);
>  		ret +=3D *pcount;
> -		*pcount =3D 0;
> +		if (set)
> +			*pcount =3D 0;
>  	}
> -	fbc->count =3D ret;
> +	if (set)
> +		fbc->count =3D ret;
>=20
>  	spin_unlock(&fbc->lock);
>  	return ret;
> _
>=20
>=20
>=20
>=20
> From: Andrew Morton <akpm@linux-foundation.org>
>=20
> Revert
>=20
>     commit e8ced39d5e8911c662d4d69a342b9d053eaaac4e
>     Author: Mingming Cao <cmm@us.ibm.com>
>     Date:   Fri Jul 11 19:27:31 2008 -0400
>=20
>         percpu_counter: new function percpu_counter_sum_and_set
>=20
>=20
> As described in
>=20
> 	revert "percpu counter: clean up percpu_counter_sum_and_set()"
>=20
> the new percpu_counter_sum_and_set() is racy against updates to the
> cpu-local accumulators on other CPUs.  Revert that change.
>=20
> This means that ext4 will be slow again.  But correct.
>=20

Acked-by: Mingming Cao <cmm@us.ibm.com>

> Reported-by: Eric Dumazet <dada1@cosmosbay.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: <linux-ext4@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  fs/ext4/balloc.c               |    4 ++--
>  include/linux/percpu_counter.h |   12 +++---------
>  lib/percpu_counter.c           |    7 +------
>  3 files changed, 6 insertions(+), 17 deletions(-)
>=20
> diff -puN fs/ext4/balloc.c~revert-percpu_counter-new-function-percpu_=
counter_sum_and_set fs/ext4/balloc.c
> --- a/fs/ext4/balloc.c~revert-percpu_counter-new-function-percpu_coun=
ter_sum_and_set
> +++ a/fs/ext4/balloc.c
> @@ -609,8 +609,8 @@ int ext4_has_free_blocks(struct ext4_sb_
>=20
>  	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
>  						EXT4_FREEBLOCKS_WATERMARK) {
> -		free_blocks  =3D percpu_counter_sum_and_set(fbc);
> -		dirty_blocks =3D percpu_counter_sum_and_set(dbc);
> +		free_blocks  =3D percpu_counter_sum_positive(fbc);
> +		dirty_blocks =3D percpu_counter_sum_positive(dbc);
>  		if (dirty_blocks < 0) {
>  			printk(KERN_CRIT "Dirty block accounting "
>  					"went wrong %lld\n",
> diff -puN include/linux/percpu_counter.h~revert-percpu_counter-new-fu=
nction-percpu_counter_sum_and_set include/linux/percpu_counter.h
> --- a/include/linux/percpu_counter.h~revert-percpu_counter-new-functi=
on-percpu_counter_sum_and_set
> +++ a/include/linux/percpu_counter.h
> @@ -35,7 +35,7 @@ int percpu_counter_init_irq(struct percp
>  void percpu_counter_destroy(struct percpu_counter *fbc);
>  void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
>  void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s3=
2 batch);
> -s64 __percpu_counter_sum(struct percpu_counter *fbc, int set);
> +s64 __percpu_counter_sum(struct percpu_counter *fbc);
>=20
>  static inline void percpu_counter_add(struct percpu_counter *fbc, s6=
4 amount)
>  {
> @@ -44,19 +44,13 @@ static inline void percpu_counter_add(st
>=20
>  static inline s64 percpu_counter_sum_positive(struct percpu_counter =
*fbc)
>  {
> -	s64 ret =3D __percpu_counter_sum(fbc, 0);
> +	s64 ret =3D __percpu_counter_sum(fbc);
>  	return ret < 0 ? 0 : ret;
>  }
>=20
> -static inline s64 percpu_counter_sum_and_set(struct percpu_counter *=
fbc)
> -{
> -	return __percpu_counter_sum(fbc, 1);
> -}
> -
> -
>  static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
>  {
> -	return __percpu_counter_sum(fbc, 0);
> +	return __percpu_counter_sum(fbc);
>  }
>=20
>  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
> diff -puN lib/percpu_counter.c~revert-percpu_counter-new-function-per=
cpu_counter_sum_and_set lib/percpu_counter.c
> --- a/lib/percpu_counter.c~revert-percpu_counter-new-function-percpu_=
counter_sum_and_set
> +++ a/lib/percpu_counter.c
> @@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
>   * Add up all the per-cpu counts, return the result.  This is a more=
 accurate
>   * but much slower version of percpu_counter_read_positive()
>   */
> -s64 __percpu_counter_sum(struct percpu_counter *fbc, int set)
> +s64 __percpu_counter_sum(struct percpu_counter *fbc)
>  {
>  	s64 ret;
>  	int cpu;
> @@ -62,12 +62,7 @@ s64 __percpu_counter_sum(struct percpu_c
>  	for_each_online_cpu(cpu) {
>  		s32 *pcount =3D per_cpu_ptr(fbc->counters, cpu);
>  		ret +=3D *pcount;
> -		if (set)
> -			*pcount =3D 0;
>  	}
> -	if (set)
> -		fbc->count =3D ret;
> -
>  	spin_unlock(&fbc->lock);
>  	return ret;
>  }
> _
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
