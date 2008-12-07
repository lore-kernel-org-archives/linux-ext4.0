From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH] atomic: fix a typo in atomic_long_xchg()
Date: Sun, 07 Dec 2008 23:24:29 +0100
Message-ID: <493C4D1D.3000300@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>	<4936EB04.8000609@cosmosbay.com>	<20081206202233.3b74febc.akpm@linux-foundation.org>	<493BCF60.1080409@cosmosbay.com> <20081207092854.f6bcbfae.akpm@linux-foundation.org>
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
Received: from gw1.cosmosbay.com ([86.65.150.130]:32957 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYLGWZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 17:25:03 -0500
In-Reply-To: <20081207092854.f6bcbfae.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton a =E9crit :
> We can do lots of things in 2.6.29.  Including just making ->counters
> an array of atomic_t.

I was playing with this idea this week (but using atomic_long_t),
and this is why I bother you with all this stuff : cleanup patches
before work for 2.6.29

My idea was using atomic_long_t so that 64bit arches dont need=20
a spinlock any more, and new percpu_lcounter would be ok for
counters that dont need s64 but a plain long (nr_files, network
counters...)

struct percpu_lcounter {
        atomic_long_t count;
#ifdef CONFIG_SMP
#ifdef CONFIG_HOTPLUG_CPU
        struct list_head list;  /* All percpu_counters are on a list */
#endif
        atomic_long_t *counters;
#endif
};

void __percpu_lcounter_add(struct percpu_lcounter *fbc, long amount, s3=
2 batch)
{
        long count;
        atomic_long_t *pcount;

        pcount =3D per_cpu_ptr(fbc->counters, get_cpu());
        count =3D atomic_long_add_return(amount, pcount);
        if (unlikely(count >=3D batch || count <=3D -batch)) {
                atomic_long_add(count, &fbc->count);
                atomic_long_sub(count, pcount);
        }
        put_cpu();
}


long percpu_lcounter_sum(struct percpu_lcounter *fbc)
{
        long accumulator =3D 0, val;
        int cpu;

        for_each_online_cpu(cpu) {
                atomic_long_t *pcount =3D per_cpu_ptr(fbc->counters, cp=
u);

                val =3D atomic_long_xchg(pcount, 0);
                accumulator +=3D val;
        }
        return atomic_long_add_return(accumulator, &fbc->count);
}

Then I found the following typo :

[PATCH] atomic: fix a typo in atomic_long_xchg()

atomic_long_xchg() not correctly defined for 32bit arches.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.=
h
index 4ec0a29..7abdaa9 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -251,7 +251,7 @@ static inline long atomic_long_add_unless(atomic_lo=
ng_t *l, long a, long u)
 #define atomic_long_cmpxchg(l, old, new) \
 	(atomic_cmpxchg((atomic_t *)(l), (old), (new)))
 #define atomic_long_xchg(v, new) \
-	(atomic_xchg((atomic_t *)(l), (new)))
+	(atomic_xchg((atomic_t *)(v), (new)))
=20
 #endif  /*  BITS_PER_LONG =3D=3D 64  */
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
