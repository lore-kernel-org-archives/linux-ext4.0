Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C803C109C;
	Mon,  6 Jul 2026 06:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783318792; cv=none; b=GIVPeQlRM9UfAX29Lh/eaNPLqhkNRvUg6WHOf5o4MCanq1Wdpyzlsht3iPybmzCtOukPmVuwZJQYoM89dfysnQJHYgPlFb5CujRnAz1pceRjxk21VdIV3bp5zKSXRvcpr9CYHw5yZ+jV4qvaYUlFw41DPLDf4Xpx6iIjAojdmhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783318792; c=relaxed/simple;
	bh=RX0BVWE27Cost6W7zXdbtvLSq8FC7lANMhyhh7fOZCU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=mPY78k2qzqmA1XU5eDcxigofXvbdIGkf7JNdKSwDL1M5R4OpA9fwq35Ud9JNFm5tL/qs0haXn0gRDv0of7WnqUROdMeQ4itg+AoyHdO+sjIYIznidc99VFFk5MSjrSDDaA1WudTwrQZ1gA0eYyFg2T/864QAT334La47zmbpUIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-92-6a4b48fba6c7
From: Byungchul Park <byungchul@sk.com>
To: linux-kernel@vger.kernel.org
Cc: max.byungchul.park@gmail.com,
	kernel_team@skhynix.com,
	torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	will@kernel.org,
	tglx@linutronix.de,
	rostedt@goodmis.org,
	joel@joelfernandes.org,
	sashal@kernel.org,
	daniel.vetter@ffwll.ch,
	duyuyang@gmail.com,
	johannes.berg@intel.com,
	tj@kernel.org,
	tytso@mit.edu,
	willy@infradead.org,
	david@fromorbit.com,
	amir73il@gmail.com,
	gregkh@linuxfoundation.org,
	kernel-team@lge.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	mhocko@kernel.org,
	minchan@kernel.org,
	hannes@cmpxchg.org,
	vdavydov.dev@gmail.com,
	sj@kernel.org,
	jglisse@redhat.com,
	dennis@kernel.org,
	cl@linux.com,
	penberg@kernel.org,
	rientjes@google.com,
	vbabka@suse.cz,
	ngupta@vflare.org,
	linux-block@vger.kernel.org,
	josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	jlayton@kernel.org,
	dan.j.williams@intel.com,
	hch@infradead.org,
	djwong@kernel.org,
	dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com,
	melissa.srw@gmail.com,
	hamohammed.sa@gmail.com,
	harry.yoo@oracle.com,
	chris.p.wilson@intel.com,
	gwan-gyeong.mun@intel.com,
	boqun.feng@gmail.com,
	longman@redhat.com,
	yunseong.kim@ericsson.com,
	ysk@kzalloc.com,
	yeoreum.yun@arm.com,
	netdev@vger.kernel.org,
	matthew.brost@intel.com,
	her0gyugyu@gmail.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	sumit.semwal@linaro.org,
	gustavo@padovan.org,
	christian.koenig@amd.com,
	andi.shyti@kernel.org,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	surenb@google.com,
	mcgrof@kernel.org,
	petr.pavlu@suse.com,
	da.gomez@kernel.org,
	samitolvanen@google.com,
	paulmck@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	chuck.lever@oracle.com,
	neil@brown.name,
	okorniev@redhat.com,
	Dai.Ngo@oracle.com,
	tom@talpey.com,
	trondmy@kernel.org,
	anna@kernel.org,
	kees@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mark.rutland@arm.com,
	ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com,
	wangkefeng.wang@huawei.com,
	broonie@kernel.org,
	kevin.brodsky@arm.com,
	dwmw@amazon.co.uk,
	shakeel.butt@linux.dev,
	ast@kernel.org,
	ziy@nvidia.com,
	yuzhao@google.com,
	baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com,
	joel.granados@kernel.org,
	richard.weiyang@gmail.com,
	geert+renesas@glider.be,
	tim.c.chen@linux.intel.com,
	linux@treblig.org,
	alexander.shishkin@linux.intel.com,
	lillian@star-ark.net,
	chenhuacai@kernel.org,
	francesco@valla.it,
	guoweikang.kernel@gmail.com,
	link@vivo.com,
	jpoimboe@kernel.org,
	masahiroy@kernel.org,
	brauner@kernel.org,
	thomas.weissschuh@linutronix.de,
	oleg@redhat.com,
	mjguzik@gmail.com,
	andrii@kernel.org,
	wangfushuai@baidu.com,
	linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-modules@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	2407018371@qq.com,
	dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com,
	neilb@ownmail.net,
	bagasdotme@gmail.com,
	wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com,
	geert@linux-m68k.org,
	ojeda@kernel.org,
	alex.gaynor@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	rust-for-linux@vger.kernel.org
Subject: [PATCH v19 03/40] dept: add lock dependency tracker APIs
Date: Mon,  6 Jul 2026 15:18:51 +0900
Message-Id: <20260706061928.66713-4-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTHfe597tPbQpObitmdStQmbosKbM4tJ242EiXeaIxLNFmmH7Sz
	VylCMa2gmBhBwFUEUxsRoSBFpAKtiK0byNKFYWCaQYSps/KiIFgnr6JtjfLStRC/nPzO+f9z
	XpLD0orHzGJWqzsi6nXqZCWRYdlYZEXMjLAt6UtLMQJj7knw+4wYSm84CBidxQx01tkRPPMb
	EcyY2yTge98jgcIsBEF3GwLHrSwK3tbPEhi58wZB4cAQgaJXWRhKvBYJvGrdAsG+lxTYhmYp
	GGr+BUH5FReBqY77NFQM9NHgrj5F4IXpVxoe+icI3Cs8S2Csq5SC8XoC1lNuBsosZgTZlTcI
	XCxzYrjd3ySBrpFpCnovmimwO7fDM5sXh4YSsBRlU6HwHwWF13+noL2yF8Pz6hIJjHjNBBoy
	+yXgfNIaWjrfS4OxyY/BOfgvA+7u1VBx+iqG4su9oZtnfAjaGp9T8KCplMBTR5CBeyU1GO43
	XWdgoN/DgKujnYbAuSXQeb6AAY/pBdqoEd7lnsNCres3SnBcdiBh6oMZCb6qbFrINYXSO6MT
	tJDjOipU/T1KhA/+R0RwB6xYON8RI9wu6ZMIOX90SwSrM01wVa/6IXa37HuNmKxNF/Vxqn2y
	xJF/fj5cxh/LGrYzmeihIg9JWZ5bxwfq8uk8xM7x+CQKlwn3Oe/xvKfDHMUt510FXiYPyVia
	e7CMz7cV4LCwkIvnx3OCcybMreQfNUwwYZZz3/DBt7Nkvv8y3l7fPOeRct/yddNlVJgVIU/P
	xF943lMu5WuLE+b5U/7Pag82IbkVLahFCq0uPUWtTV4Xm5ih0x6L3Z+a4kShd7OdmN7TiN50
	7mxBHIuUkXLYuDVJwajTDRkpLYhnaWWU/LMvtiUp5Bp1xnFRn7pXn5YsGlrQEhYrP5GvDRzV
	KLiD6iPiIVE8LOo/qhQrXZyJbEWtzczdPWPKNYYV3QNb9usyF2FV/ZPBNT9q7Dd3/PR1dPnm
	iAv+AxG32l8+Tbj03WndicGeXZPDdFzD2pgEzyEqqrH3cfzYprbo+BY3Pnhzw7UNU1WquAp3
	2usqX1fEUtWZXarIwPqY1Elx9K5pxTVaOlNTefW41ZIe/TrYXDO8W4kNieqvVtF6g/p/lC74
	/moDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+93XrqPFZQldCrFGD4uekHagKIPIX0kRFAQZ5WqX3HyyqWUQ
	OXW0LEMH28q1NMsRvtMemq3MyB4WOc200qY1LdNcPsPn2oT+OXwO38+B88eXJaUP6MWsMi5R
	UMfJY2SMmBLv35q+bgqHqzZ2WleDXnceOpwuGj5q6ygYG9VTcL28hIEZy0MR6Cuv0fCqLY2C
	prJiBM4xPYK/UxYSdDUeCmYMDSIYnfgiAqMWgcfegMDkMJDQ3vSUhJJ7WgJGKmYZ6H8+jMDY
	7WLA3KelwG27jCC31yKCvhdh8NtZS4On8wcBbeMDCGyuWQJcdRcQzJiiIa+gyntu+sPA1Lv3
	JJiNTQhudneSMNzXheBew1cE9jtpDPRk3yehxbUAPoy5GXhtvMTAb8d1AgYrGMhPs9PgeNuP
	wGoxIOj9bCcg/VY5AyZrJQU1XY9E4OifJqDDZCCguHIfOG29FDRmFxDed73W3UVgMacT3vGT
	AGNpLQETtiJRaCHCf3VXKFxU9YDAuuYZBpfcKEF4atKA8GhhOol12d71+YCbxBlVp3Fh4wCD
	J8daGWwfz6fwmwIe3744SeCcd+twTW6n6MDOI+JtCiFGmSyoN2yPFEf1N59IsPJntL+K6VT0
	QZqJWJbnNvODQygT+bEMt4pvb58gfezPLeWrsnrpTCRmSa4lkL9sy6J8wUJuJz+Y4ZmTKG4F
	3/rQTftYwgXznpFZxsc8F8gXV9TNOX5cCF82bSV8LPU6X9wvqWwkzkfzipC/Mi45Vq6MCV6v
	iY5KiVOeWX8yPrYSedtkOzedU41GW8LqEcci2XwJhO5VSWl5siYlth7xLCnzl6wMCldJJQp5
	yllBHX9cnRQjaOrREpaSLZLsPSxESrlT8kQhWhASBPX/lGD9FqeirUvWOpuDAju2aMtbV6+C
	N/mHEp/lnc21lt4mt4WEsV2OXdZv1QNlKq6mJyCA2r6G1x1NCdiVYzAeVRCp5icRh98HjS9f
	eKSnVjV/WWnDE5NZf9V04NjjhCR3aFRGePeEovpkxPfhPSE4Ie9x5CfX7tO7FcONGbER3942
	NR/cPLRDRmmi5JvWkGqN/B9kJym+SQMAAA==
X-CFilter-Loop: Reflected
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Wrap the base APIs for easier annotation on typical lock.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept_ldt.h | 78 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 include/linux/dept_ldt.h

diff --git a/include/linux/dept_ldt.h b/include/linux/dept_ldt.h
new file mode 100644
index 000000000000..8047d0a531f1
--- /dev/null
+++ b/include/linux/dept_ldt.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Lock Dependency Tracker
+ *
+ * Started by Byungchul Park <max.byungchul.park@gmail.com>:
+ *
+ *  Copyright (c) 2020 LG Electronics, Inc., Byungchul Park
+ *  Copyright (c) 2024 SK hynix, Inc., Byungchul Park
+ */
+
+#ifndef __LINUX_DEPT_LDT_H
+#define __LINUX_DEPT_LDT_H
+
+#include <linux/dept.h>
+
+#ifdef CONFIG_DEPT
+#define LDT_EVT_L			1UL
+#define LDT_EVT_R			2UL
+#define LDT_EVT_W			1UL
+#define LDT_EVT_RW			(LDT_EVT_R | LDT_EVT_W)
+#define LDT_EVT_ALL			(LDT_EVT_L | LDT_EVT_RW)
+
+#define ldt_init(m, k, su, n)		dept_map_init(m, k, su, n)
+#define ldt_lock(m, sl, t, n, i)					\
+	do {								\
+		if (n)							\
+			dept_ecxt_enter_nokeep(m);			\
+		else if (t)						\
+			dept_ecxt_enter(m, LDT_EVT_L, i, "trylock", "unlock", sl);\
+		else {							\
+			dept_wait(m, LDT_EVT_L, i, "lock", sl);		\
+			dept_ecxt_enter(m, LDT_EVT_L, i, "lock", "unlock", sl);\
+		}							\
+	} while (0)
+
+#define ldt_rlock(m, sl, t, n, i, q)					\
+	do {								\
+		if (n)							\
+			dept_ecxt_enter_nokeep(m);			\
+		else if (t)						\
+			dept_ecxt_enter(m, LDT_EVT_R, i, "read_trylock", "read_unlock", sl);\
+		else {							\
+			dept_wait(m, q ? LDT_EVT_RW : LDT_EVT_W, i, "read_lock", sl);\
+			dept_ecxt_enter(m, LDT_EVT_R, i, "read_lock", "read_unlock", sl);\
+		}							\
+	} while (0)
+
+#define ldt_wlock(m, sl, t, n, i)					\
+	do {								\
+		if (n)							\
+			dept_ecxt_enter_nokeep(m);			\
+		else if (t)						\
+			dept_ecxt_enter(m, LDT_EVT_W, i, "write_trylock", "write_unlock", sl);\
+		else {							\
+			dept_wait(m, LDT_EVT_RW, i, "write_lock", sl);	\
+			dept_ecxt_enter(m, LDT_EVT_W, i, "write_lock", "write_unlock", sl);\
+		}							\
+	} while (0)
+
+#define ldt_unlock(m, i)		dept_ecxt_exit(m, LDT_EVT_ALL, i)
+
+#define ldt_downgrade(m, i)						\
+	do {								\
+		if (dept_ecxt_holding(m, LDT_EVT_W))			\
+			dept_map_ecxt_modify(m, LDT_EVT_W, NULL, LDT_EVT_R, i, "downgrade", "read_unlock", -1);\
+	} while (0)
+
+#define ldt_set_class(m, n, k, sl, i)	dept_map_ecxt_modify(m, LDT_EVT_ALL, k, 0UL, i, "lock_set_class", "(any)unlock", sl)
+#else /* !CONFIG_DEPT */
+#define ldt_init(m, k, su, n)		do { (void)(k); } while (0)
+#define ldt_lock(m, sl, t, n, i)	do { } while (0)
+#define ldt_rlock(m, sl, t, n, i, q)	do { } while (0)
+#define ldt_wlock(m, sl, t, n, i)	do { } while (0)
+#define ldt_unlock(m, i)		do { } while (0)
+#define ldt_downgrade(m, i)		do { } while (0)
+#define ldt_set_class(m, n, k, sl, i)	do { } while (0)
+#endif
+#endif /* __LINUX_DEPT_LDT_H */
-- 
2.17.1

