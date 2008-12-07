From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH, take2] percpu_counter: FBC_BATCH might be too big
Date: Sun, 07 Dec 2008 19:30:10 +0100
Message-ID: <493C1632.2000901@cosmosbay.com>
References: <4939513C.3090101@cosmosbay.com>	<493B9699.8080603@cosmosbay.com> <20081207090918.595627b2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Travis <travis@sgi.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([86.65.150.130]:40738 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbYLGSkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 13:40:25 -0500
In-Reply-To: <20081207090918.595627b2.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton a =E9crit :
> On Sun, 07 Dec 2008 10:25:45 +0100 Eric Dumazet <dada1@cosmosbay.com>=
 wrote:
>=20
>> In this second version I guarded hotcpu_notifier() call by
>> a #ifdef CONFIG_HOTPLUG_CPU
>>
>> I wonder why hotcpu_notifier() is not a null op if !CONFIG_HOTPLUG_C=
PU
>>
>> Thank you
>>
>> [PATCH] percpu_counter: FBC_BATCH might be too big
>>
>> For NR_CPUS >=3D 16 values, FBC_BATCH is 2*NR_CPUS
>>
>> Considering more and more distros are using high NR_CPUS values,
>> it makes sense to use a more sensible value for FBC_BATCH.
>>
>> A sensible value is 2*num_online_cpus(), with a minimum value of 32
>> (This minimum value helps branch prediction in __percpu_counter_add(=
))
>>
>> We already have a hotcpu notifier, so we can adjust FBC_BATCH dynami=
cally.
>=20
> Yup, anything using NR_CPUS is probably wrong.
>=20
>> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_c=
ounter.h
>> index 9007ccd..c42a184 100644
>> --- a/include/linux/percpu_counter.h
>> +++ b/include/linux/percpu_counter.h
>> @@ -24,11 +24,7 @@ struct percpu_counter {
>>  	s32 *counters;
>>  };
>> =20
>> -#if NR_CPUS >=3D 16
>> -#define FBC_BATCH	(NR_CPUS*2)
>> -#else
>> -#define FBC_BATCH	(NR_CPUS*4)
>> -#endif
>> +extern int FBC_BATCH;
>=20
> y:/usr/src/linux-2.6.28-rc7> grep -r FBC_BATCH . | wc -l
> 7
>=20
> Can we fix this properly please?  It should now become lower case, an=
d
> it was a pretty dopey name anyway - now would be a good time to impro=
ve
> it. `percpu_counter_batch'?

Yes

>=20
>>  int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
>>  int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount)=
;
>> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
>> index a866389..e21ce7c 100644
>> --- a/lib/percpu_counter.c
>> +++ b/lib/percpu_counter.c
>> @@ -114,6 +114,16 @@ void percpu_counter_destroy(struct percpu_count=
er *fbc)
>>  }
>>  EXPORT_SYMBOL(percpu_counter_destroy);
>> =20
>> +int FBC_BATCH __read_mostly =3D 32;
>> +EXPORT_SYMBOL(FBC_BATCH);
>> +
>> +static void compute_batch_value(void)
>> +{
>> +	int nr =3D num_online_cpus();
>> +
>> +	FBC_BATCH =3D max(32, nr*2);
>> +}
>> +
>>  #ifdef CONFIG_HOTPLUG_CPU
>>  static int __cpuinit percpu_counter_hotcpu_callback(struct notifier=
_block *nb,
>>  					unsigned long action, void *hcpu)
>> @@ -121,6 +131,7 @@ static int __cpuinit percpu_counter_hotcpu_callb=
ack(struct notifier_block *nb,
>>  	unsigned int cpu;
>>  	struct percpu_counter *fbc;
>> =20
>> +	compute_batch_value();
>>  	if (action !=3D CPU_DEAD)
>>  		return NOTIFY_OK;
>> =20
>> @@ -139,11 +150,14 @@ static int __cpuinit percpu_counter_hotcpu_cal=
lback(struct notifier_block *nb,
>>  	mutex_unlock(&percpu_counters_lock);
>>  	return NOTIFY_OK;
>>  }
>> +#endif
>> =20
>>  static int __init percpu_counter_startup(void)
>>  {
>> +	compute_batch_value();
>> +#ifdef CONFIG_HOTPLUG_CPU
>>  	hotcpu_notifier(percpu_counter_hotcpu_callback, 0);
>> +#endif
>>  	return 0;
>>  }
>>  module_init(percpu_counter_startup);
>> -#endif
>=20
> hm, now what's going on in there?  We should be able to drop the #ifd=
ef
> CONFIG_HOTPLUG_CPU from lib/percpu_counter.c altogether.=20
> hotcpu_notifier() will do the right thing, and the compiler should
> generate no code for percpu_counter_hotcpu_callback() if
> CONFIG_HOTPLUG_CPU=3Dn. =20
>=20
> Do
>=20
> 	$EDITOR  $(grep -l hotcpu_notifier */*.c)
>=20
> and you'll see lots of code gets it right, and lots of code gets it w=
rong.

I see nothing interesting, I must be blind.

lib/percpu_counter.c: In function 'percpu_counter_startup':
lib/percpu_counter.c:158: error: 'percpu_counter_hotcpu_callback' undec=
lared (first use in this function)
lib/percpu_counter.c:158: error: (Each undeclared identifier is reporte=
d only once
lib/percpu_counter.c:158: error: for each function it appears in.)
make[1]: *** [lib/percpu_counter.o] Error 1

static int __init percpu_counter_startup(void)
{
        compute_batch_value();
        hotcpu_notifier(percpu_counter_hotcpu_callback, 0); << ERROR >>
        return 0;
}
module_init(percpu_counter_startup);

# grep hotcpu_notifier include/linux/cpu.h
#define hotcpu_notifier(fn, pri) {                          \
#define hotcpu_notifier(fn, pri)    do { (void)(fn); } while (0)  << ER=
ROR >>


If changed to :

static struct notifier_block __cpuinitdata percpu_counter_cpu_notifier =
=3D {
        .notifier_call  =3D percpu_counter_hotcpu_callback,
};
static int __init percpu_counter_startup(void)
{
        compute_batch_value();
        register_hotcpu_notifier(&percpu_counter_cpu_notifier);
        return 0;
}
module_init(percpu_counter_startup);

Then error is :
lib/percpu_counter.c:156: error: 'percpu_counter_hotcpu_callback' undec=
lared here (not in a function)
make[1]: *** [lib/percpu_counter.o] Error 1


So the only way seems to add an ugly

#define percpu_counter_hotcpu_callback NULL

Is is what you name "the right thing" ?

Thanks

[PATCH] percpu_counter: FBC_BATCH should be a variable

=46or NR_CPUS >=3D 16 values, FBC_BATCH is 2*NR_CPUS

Considering more and more distros are using high NR_CPUS values,
it makes sense to use a more sensible value for FBC_BATCH.

A sensible value is 2*num_online_cpus(), with a minimum value of 32
(This minimum value helps branch prediction in __percpu_counter_add())

We already have a hotcpu notifier, so we can adjust FBC_BATCH dynamical=
ly.

We rename FBC_BATCH to percpu_counter_batch since its not a constant
anymore.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/ext4/ext4.h                 |    6 +++---
 fs/ext4/inode.c                |    2 +-
 include/linux/percpu_counter.h |    8 ++------
 lib/percpu_counter.c           |   16 +++++++++++++++-
 4 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b0537c8..6c46c64 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1225,11 +1225,11 @@ do {								\
 } while (0)
=20
 #ifdef CONFIG_SMP
-/* Each CPU can accumulate FBC_BATCH blocks in their local
+/* Each CPU can accumulate percpu_counter_batch blocks in their local
  * counters. So we need to make sure we have free blocks more
- * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
+ * than percpu_counter_batch  * nr_cpu_ids. Also add a window of 4 tim=
es.
  */
-#define EXT4_FREEBLOCKS_WATERMARK (4 * (FBC_BATCH * nr_cpu_ids))
+#define EXT4_FREEBLOCKS_WATERMARK (4 * (percpu_counter_batch * nr_cpu_=
ids))
 #else
 #define EXT4_FREEBLOCKS_WATERMARK 0
 #endif
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index be21a5a..db661e7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2497,7 +2497,7 @@ static int ext4_nonda_switch(struct super_block *=
sb)
 	/*
 	 * switch to non delalloc mode if we are running low
 	 * on free block. The free block accounting via percpu
-	 * counters can get slightly wrong with FBC_BATCH getting
+	 * counters can get slightly wrong with percpu_counter_batch getting
 	 * accumulated on each CPU without updating global counters
 	 * Delalloc need an accurate free block accounting. So switch
 	 * to non delalloc when we are near to error range.
diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_coun=
ter.h
index 9007ccd..99de7a3 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -24,11 +24,7 @@ struct percpu_counter {
 	s32 *counters;
 };
=20
-#if NR_CPUS >=3D 16
-#define FBC_BATCH	(NR_CPUS*2)
-#else
-#define FBC_BATCH	(NR_CPUS*4)
-#endif
+extern int percpu_counter_batch;
=20
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
@@ -39,7 +35,7 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc);
=20
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 =
amount)
 {
-	__percpu_counter_add(fbc, amount, FBC_BATCH);
+	__percpu_counter_add(fbc, amount, percpu_counter_batch);
 }
=20
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *f=
bc)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..519b877 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -114,6 +114,16 @@ void percpu_counter_destroy(struct percpu_counter =
*fbc)
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
=20
+int percpu_counter_batch __read_mostly =3D 32;
+EXPORT_SYMBOL(percpu_counter_batch);
+
+static void compute_batch_value(void)
+{
+	int nr =3D num_online_cpus();
+
+	percpu_counter_batch =3D max(32, nr*2);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_bl=
ock *nb,
 					unsigned long action, void *hcpu)
@@ -121,6 +131,7 @@ static int __cpuinit percpu_counter_hotcpu_callback=
(struct notifier_block *nb,
 	unsigned int cpu;
 	struct percpu_counter *fbc;
=20
+	compute_batch_value();
 	if (action !=3D CPU_DEAD)
 		return NOTIFY_OK;
=20
@@ -139,11 +150,14 @@ static int __cpuinit percpu_counter_hotcpu_callba=
ck(struct notifier_block *nb,
 	mutex_unlock(&percpu_counters_lock);
 	return NOTIFY_OK;
 }
+#else
+#define percpu_counter_hotcpu_callback NULL
+#endif /* CONFIG_HOTPLUG_CPU */
=20
 static int __init percpu_counter_startup(void)
 {
+	compute_batch_value();
 	hotcpu_notifier(percpu_counter_hotcpu_callback, 0);
 	return 0;
 }
 module_init(percpu_counter_startup);
-#endif

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
