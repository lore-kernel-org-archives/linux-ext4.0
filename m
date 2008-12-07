From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Sun, 07 Dec 2008 14:28:00 +0100
Message-ID: <493BCF60.1080409@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>	<4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:43910 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYLGN2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 08:28:37 -0500
In-Reply-To: <20081206202233.3b74febc.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton a =E9crit :
> On Wed, 03 Dec 2008 21:24:36 +0100 Eric Dumazet <dada1@cosmosbay.com>=
 wrote:
>=20
>> Eric Dumazet a __crit :
>>
>> 1) __percpu_counter_sum() is buggy, it should not write
>> on per_cpu_ptr(fbc->counters, cpu), or another cpu
>> could get its changes lost.
>>
>> __percpu_counter_sum should be read only (const struct percpu_counte=
r *fbc),
>> and no locking needed.
>=20
> No, we can't do this - it will break ext4.
>=20
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
> Please read the below changelogs carefully and check that I have got =
my
> head around this correctly - I may not have done.
>=20


Hum... e8ced39d5e8911c662d4d69a342b9d053eaaac4e is probably following
the wrong path, but I see the intent. Even in the 'nr_files' case, it c=
ould
help to reduce excessive calls to percpu_counter_sum()

What we can do is to use two s64 counters (only in SMP):

s64 reference_count
s64 shadow_count

One that is guaranteed to be touched with appropriate locking
in __percpu_counter_add()

Another one that might be changed by percpu_counter_sum(), without
any locking, acting as a shadow.

Thanks

[PATCH] percpu_counter: Fix __percpu_counter_sum()

commit e8ced39d5e8911c662d4d69a342b9d053eaaac4e (percpu_counter:=20
new function percpu_counter_sum_and_set) was to make __percpu_counter_s=
um()
being able to recompute the estimate of a percpu_counter value.

Problem is that we cannot write on other cpus counters without racing.

What we can do is to use two s64 counter, one acting as a reference
that we should not change in __percpu_counter_sum(), another one, shado=
wing
the reference.

percpu_counter_read() is reading the shadow
percpu_counter_sum() reads the reference and recompute the shadow.

If a given percpu_counter is never 'summed', then its shadow_counter
is always equal to its reference.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/percpu_counter.h |    9 +++++----
 lib/percpu_counter.c           |   27 +++++++++++++++++----------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_coun=
ter.h
index 9007ccd..71b5c5d 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -17,7 +17,8 @@
=20
 struct percpu_counter {
 	spinlock_t lock;
-	s64 count;
+	s64	   reference_count;
+	s64	   shadow_count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
@@ -55,7 +56,7 @@ static inline s64 percpu_counter_sum(struct percpu_co=
unter *fbc)
=20
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return fbc->shadow_count;
 }
=20
 /*
@@ -65,9 +66,9 @@ static inline s64 percpu_counter_read(struct percpu_c=
ounter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *=
fbc)
 {
-	s64 ret =3D fbc->count;
+	s64 ret =3D percpu_counter_read(fbc);
=20
-	barrier();		/* Prevent reloads of fbc->count */
+	barrier();		/* Prevent reloads of fbc->shadow_count */
 	if (ret >=3D 0)
 		return ret;
 	return 1;
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..44ec857 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -14,6 +14,9 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
=20
+/*
+ * Note : This function is racy
+ */
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
@@ -23,7 +26,8 @@ void percpu_counter_set(struct percpu_counter *fbc, s=
64 amount)
 		s32 *pcount =3D per_cpu_ptr(fbc->counters, cpu);
 		*pcount =3D 0;
 	}
-	fbc->count =3D amount;
+	fbc->reference_count =3D amount;
+	fbc->shadow_count =3D amount;
 	spin_unlock(&fbc->lock);
 }
 EXPORT_SYMBOL(percpu_counter_set);
@@ -38,7 +42,8 @@ void __percpu_counter_add(struct percpu_counter *fbc,=
 s64 amount, s32 batch)
 	count =3D *pcount + amount;
 	if (count >=3D batch || count <=3D -batch) {
 		spin_lock(&fbc->lock);
-		fbc->count +=3D count;
+		fbc->reference_count +=3D count;
+		fbc->shadow_count +=3D count;
 		*pcount =3D 0;
 		spin_unlock(&fbc->lock);
 	} else {
@@ -57,16 +62,16 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc=
)
 	s64 ret;
 	int cpu;
=20
-	spin_lock(&fbc->lock);
-	ret =3D fbc->count;
+	ret =3D fbc->reference_count;
 	for_each_online_cpu(cpu) {
 		s32 *pcount =3D per_cpu_ptr(fbc->counters, cpu);
 		ret +=3D *pcount;
-		*pcount =3D 0;
 	}
-	fbc->count =3D ret;
-
-	spin_unlock(&fbc->lock);
+	/*
+	 * Update fbc->shadow_count so that percpu_counter_read()
+	 * can have a better idea of this counter 'value'
+	 */
+	fbc->shadow_count =3D ret;
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
@@ -76,7 +81,8 @@ static struct lock_class_key percpu_counter_irqsafe;
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
 	spin_lock_init(&fbc->lock);
-	fbc->count =3D amount;
+	fbc->shadow_count =3D amount;
+	fbc->reference_count =3D amount;
 	fbc->counters =3D alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
@@ -132,7 +138,8 @@ static int __cpuinit percpu_counter_hotcpu_callback=
(struct notifier_block *nb,
=20
 		spin_lock_irqsave(&fbc->lock, flags);
 		pcount =3D per_cpu_ptr(fbc->counters, cpu);
-		fbc->count +=3D *pcount;
+		fbc->reference_count +=3D *pcount;
+		fbc->shadow_count +=3D *pcount;
 		*pcount =3D 0;
 		spin_unlock_irqrestore(&fbc->lock, flags);
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
