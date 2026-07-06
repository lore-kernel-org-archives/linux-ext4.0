Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFBE3DEFFB
	for <linux-ext4@vger.kernel.org>; Mon,  6 Jul 2026 06:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783318859; cv=none; b=lslFwOB2yEErOmmXywca4Hl4uYSz/sfadHF53RzS8/iELlxzYBoWNBW6KzLUZgc9NUHpIg8FfIq1iI7Afvg26p2xa9pTdi80SentLnpkkAT7uldTh34qozNQ7IvKjx3HsOOyU0bnYf9fXvWcVia6X4GLy48jPGPe5SXxgJr2FS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783318859; c=relaxed/simple;
	bh=9o9SI0ONdb1WbiIWXrCSb5nX53qir4UGX5Gt0IQgpYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=GwxYtOMf3XwR4pDjoFQqnm/0V9J/4YgjCpozXf6K/YBzBdA2ubGFsAb5xezu6y71/nF9uYYQo4XRhzHg4ajY/v2cQ48PJokB/JDCt54ELqaTh/lwYhQAvzUPkcWXxsSyJIenHxCsK4edY+taW/AU4pf4CjzpUcy0hCTBGZUVb1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-44-6a4b48ff61c3
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
Subject: [PATCH v19 17/40] dept: apply timeout consideration to swait
Date: Mon,  6 Jul 2026 15:19:05 +0900
Message-Id: <20260706061928.66713-18-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSb0xTZxSHfd/73reXhs5r1XjFBLCG6TRjsqE5yZaFD5u5m39CYkwM+6AN
	3IxCaV1RlC3L6EZdXYR1XVo2XKGIFFTcagvbsEOR0SxByFrQjmkJotXMYTcUWhxSWavxy8mT
	8zvn+fTjGGWIzeA0uoOSQafWqqicyKPpLS/jd7aXbW61cmA2fQLhiQgLIWMfgdismUDixE8y
	mIiZEcw9PsGAqWeRgM2IoLPLiGHG/YSCbTJCoeGekUB0wseCK/IEQ8JeDs0nvRSm7NMUHg//
	zkCDLYCgZXKcgTuWbgZGIy9ANPgdBuenvSwEh6YQ2B0eAj03L8ggbLdiuGI5iZNeCvbzq2Co
	NUzAVZMDtzoaZbAwmQeLTj2Mf2kjMHt1EsO3TWEKI2cDBNr+CGKI16+BwFd1LIxZ7iCYirsY
	uHvtKIbTvcMUTje3I2ib/YeBz//yUbj6pw/BRfNNDG0dURY8nSEKv8buY/h6xEkhZG2mMN/u
	R9Dtn5OBcWYCQW14Czxy32bhXCKECgrEOVM9Ec94f8SiaSRBxc6mTiSaLMlR6z0szseuUbE3
	7iTiqWPzWOxpHJeJtRevy0Sn55BYOxBlRW/HRrH1l3tYbHkYYwuzi+RvlEhaTZVkeOXN/fLS
	HyJGdGCGHmnwn2Jr0CD7BUrjBD5f+NsaoM95sP4BTjHl1wtjY/8xKV7BZwveurvJeznH8KNZ
	wnFXHUkFy/m3BUe3PxlwHOFzBNt5fQoV/FbBH858pswSzrr7nmrSkuvvFxxP9Up+i3Dj399I
	SinwzWnCwPQwfvawWrjcMUYsSOFES84gpUZXVaHWaPNzS6t1miO5xfoKD0q2zfXxwns/o4eB
	3f2I55AqXQEF75YpWXVVZXVFPxI4RrVC8eKG7WVKRYm6+kPJoN9nOKSVKvvRGo6oVilejR8u
	UfLvqw9K5ZJ0QDI8TzGXllGDtm3S7mgq/ibD19jGlp87OmXuu9SVNxBK9zhmXtq0w5n+YMNH
	OcT9erat4q29hfl7fFnBtcOKzEdyz4VdXUU9OvazrrzRoDyuV3kWlwyFr6+0BfdWL7u83rq0
	aFui2PJae8A7NzhOtPPyfne5I/PY/f25O4NX1hFt9/Ta45k3pA9UpLJUnbeRMVSq/wd0YKNR
	aQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSWUxTYRCF/e/WS7V6U4leV0yNaNwXNOMSt0T9A7HxTWKMWvUqZbcFBIzR
	glVUMNjYEikoIhRCq0UWFU2V1ICKGkFUQEAwqShhqUuLYbNeNL5Mzsw582UehiXld+nprDo6
	TtBEqyIVjJSSKtenLvHhkPDl9uKZkKY/BW0dLhre66op8HrSKMix2xgYNd+TQFrZVRqeNaVQ
	UH/biqDDm4bg17CZBH2Vj4JRQ60EPIOtEjDqEPgctQhMDQYSmusfk2Cr0BHws/Q3Az1PfiAw
	fnIxkNWto8BtSUeQ3WWWQHfNDujreEiDr/0LAU0DvQgsrt8EuKrPIRg1RcD1/HJx3fSNgeFX
	r0nIMtYjuPGpnYQf3Z0IKmo/InAUpzDwObOShEbXRHjrdTPw3HiRgb6GHAL6SxnIS3HQ0PCy
	B0Gu2YCg64ODgNSbdgZMuWUUVHU+kEBDzwgBbSYDAdayndBh6aLgRWY+IZ4rpu5MBXNWKiGW
	rwQYbz0kYNBSItlciPAv/SUKl5TfJbD+zSiDbddsCA8PGRD2FKaSWJ8ptk963SQ+U34cF77o
	ZfCQ9x2DHQN5FK7L53HB+SECX361BFdlt0t2bdkj3XBYiFQnCJplGw9Iw+wuHYr9ySRm1RTQ
	p1EdfQH5sTwXxNdd+k6MaYabzzc3D5Jj2p+bw5dndIkZKUtyjQF8uiWDGjMmc9v43Moa0WBZ
	ipvHG+/EjEkZt4avaZv9DxnAW0ur/2L8xPHtkdy/eDm3mm91P6UykTQPjStB/urohCiVOnL1
	Um1EWFK0OnHpoZioMiR+k+XkyOX7yNO4w4k4FikmyGBzcLicViVok6KciGdJhb8scEFIuFx2
	WJWULGhi9mviIwWtE81gKcVUWfBu4YCcO6qKEyIEIVbQ/HcJ1m/6afRo7bGKAElt3/eD8ftW
	dU5Lfh3cN+lcoqJAcehB09r7TvuW3m/7VlUb1MlH2ui8Im1R4pGWgbhbJqVu1uJ18RfnLrLO
	DQ3ca9G6g5Qx2zfcax3va9l+IsKH+rGwst+pb1dOqlzp7d86Jehp+MmzCdbjV2Y5zlft36SU
	zffY6FA25ZGC0oapViwkNVrVH1dU5FdJAwAA
X-CFilter-Loop: Reflected
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to swait, assuming an input 'ret' in ___swait_event()
macro is used as a timeout value.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/swait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index 277ac74f61c3..233acdf55e9b 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -162,7 +162,7 @@ extern void finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
 	struct swait_queue __wait;					\
 	long __ret = ret;						\
 									\
-	sdt_might_sleep_start(NULL);					\
+	sdt_might_sleep_start_timeout(NULL, __ret);			\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	for (;;) {							\
 		long __int = prepare_to_swait_event(&wq, &__wait, state);\
-- 
2.17.1

