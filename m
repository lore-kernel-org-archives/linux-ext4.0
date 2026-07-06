Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FD83D5C26;
	Mon,  6 Jul 2026 06:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783318814; cv=none; b=VkL3Pz/1Z4if6WpScsbDt+331BqIJO2oL6goVYtBWxwV2CMyhHWWy8Qg0fe5+uQMDHp+fdNssOzRLL+WDc7OjVA6wcC+ESd6drdTfyGkKcD1TxNW2Y6NWQ8bHDm+euobXlabX7Yg0OISfIWbnG5WFHv4wgLx1Qpua0yoCyyg2+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783318814; c=relaxed/simple;
	bh=pLUSXjgVOyB6ewzDMD2B/aTj2n2b3ii/EXLHyurcTzs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=lWEAEpYcw/ktbFmtO8T5/93rvokspmz+0umsDypaBgzX83HQSj2uxcpkzkGfT1t7v+bd66ySsTJcsBCKe7eja/5Ekju8UQAoIpt6bHp250Q78J5Dq4tACkFw2PfFUi9Ezb4mmCUUTfT88ZEcshs1Pv50EAXhIrhF6o9MfBP6mmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-8c-6a4b48fecb9f
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
Subject: [PATCH v19 11/40] dept: apply sdt_might_sleep_{start,end}() to swait
Date: Mon,  6 Jul 2026 15:18:59 +0900
Message-Id: <20260706061928.66713-12-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxTG97/3f//30niTm07cVZO5NXOgm6JG3Vlmln7Yh7uZLSSTDw4T
	bex1LePFlZfJ3DLqnAPWKjFCY7uCL9C1WsW0EgZpGasgYmTSgKVAKyITwptsBcteHKyw+eXk
	l+c5ec7z4XC0Msqs4fS5BbIhV5OtIgqsmF5xftOitDtri6khDULGVgz/2BpZmP/bRsOi/yYC
	93UjBZM3YghmHCYE1lEbC33xKQQ1F7wEJqt+I2Cp7Ebgdx4j8KiigYbgnUkEX1+sJ1Bl92Bo
	etDMwpBjFINlnICtq4eBh04rC9FTlRg674cYmBw9TWCo4wQDnv52BHO9wxR4RhKGf+A1OFsd
	IeDzd2Loaf6eQIltnoH6sTAFnVYXhsGuUyzU9QUpCFc8QnDl8QUC/ZYpFpy/Wxhw+bsI3Dy3
	Clw1PyCI1cYxnJhdYKDD3EpB5OQEhpbSBxS01TcmDrpDBMasdgpuPJmi4HZ0loXLQQw240kE
	331ThaG0LU5DQ/s8C8bZIQTHIzvgj2sjDNjntqrVkrvajaTasr8oqckaZaXjLQOJ0TbNSF7n
	Rumib5ySPJfKiFQ+3UtJkZCPSE3Db0q/9loo6XxJJS39ZHezkrf2K2lwYYROX/2RYpdWztYX
	yYa0tw8odLHhe8zhdu5IuK6ZLUG/kHKUxInCdnExcBY9475+47JOhBQxHP6TXuKVwkui1zzK
	lCMFRws960STw4yXjOeF98Vwa3R5CQvrxVuub5eZF3aKwTM+9r/QdeLla63LelJCv/rUTi2x
	UtghDs504KVQUfAmiXftjf+3WC3+7AzjCsSfQ89dQkp9blGORp+9fbOuOFd/ZPPBvBwPSjyd
	48unmT+iWPeHASRwSLWCB/V7WUpGU5RfnBNAIkerVvKvpu7OUvJaTfHnsiFvv6EwW84PoLUc
	Vr3Ab4t/plUKH2sK5E9k+bBseOZSXNKaEpS8fm3f62MZMaKOu4bTS/lDR1MLZ5LNKQWzx6rf
	CXYnv+vz7W3Rpm6qDCRn7iwzP3x5w6cv6h5fydtbk174AZ9ZODF3/a3xJwu34nzp6bK4/o3y
	L1aFtHfPHG1iiyyOgRR6V04k47664BXTIb3bqsHFhv7exTrtngyTbd/ttIkJnQrn6zRbN9KG
	fM2/2XUSonADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfUxTZxTGfe+9vffS2HlTSbx+JLpGJzETNQ5yokYlW8IbGWrMnImZH43e
	QKFUbLVadZul66hMDXZrEQqKMJoJDGvBD9DGAgEdzElFpCoVa2odA1aHBcNHZYVl/5z8zvM8
	5+T8cVhSelM0j1WoDglqlVwpo8WUePNaw/IITslYWVyYCCbjt9DTGxDBY72bguGwiYLiK9U0
	RGw3GDA5C0VwrzuHgo6aKgS9wyYE78ZtJBjrJymImFsZCI8+Y8CiRzDpakVg9ZhJ8HbcIaG6
	Tk/AW8d7GvqbhxBY/AEaCvr0FITspxEUBW0M9LUkw2DvLRFM+l4T0D0ygMAeeE9AwJ2LIGLN
	hItltdFx6xsaxu8/IKHA0oHgkt9HwlDfCwR1rc8RuH7JoeFV/jUSOgMfwKPhEA2/WX6gYdBT
	TMDfDhpKc1wi8Pzej6DEZkYQfOoiwFB+hQZriZOC+hcNDHj6JwjosZoJqHKmQq89SEF7fhkR
	PTeaujoHbAUGIlr+JMDy6y0CRu2VzMYKhN8Zz1K4svY6gY0PIzSuvlCN8PiYGeFwhYHExvxo
	2zwQIvF3tUdwRfsAjceGu2jsGimlcFsZj38+NUbgc/eX4/oiH7M1aad43X5BqdAK6hXr94rT
	h/xdouwW9qi3ooE5if6g81AMy3Of8N1P9NNMc0t5r3eUnOJYbhFfeyYoykNiluQ6F/Kn7Weo
	KWM2l8p73b7pEMUt4e9dzp1mCZfIe366zfy3dCFf5XBP6zFRvWaihJhiKZfAPwvdpfKRuBTN
	qESxCpU2S65QJsRrMtN1KsXR+H0Hspwo+k/2ryfO3UThzuQmxLFINlMCGzdlSEVyrUaX1YR4
	lpTFSj6KS8mQSvbLdccE9YE96sNKQdOE5rOUbI5k0w5hr5RLkx8SMgUhW1D/7xJszLyTyJaw
	uLB1g2lB6tDxtpTtiyuteJby4Mu+a+ttufrzjbr6uT/u9umS2z5TheyOoCb8ffvnH5ebkjSO
	uLe5RVvefDUoXP1rRwtkaHNMq7/oGVlQN368sdh54oR/TVq33hD/VAsfDshnL9rp9k9uk3Wd
	mnX2n7xdNb5v5n+ags6/XJ305XYZpUmXr1pGqjXyfwH4BuCSSwMAAA==
X-CFilter-Loop: Reflected
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Make dept able to track dependencies by swaits.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/swait.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index d324419482a0..277ac74f61c3 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -6,6 +6,7 @@
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/dept_sdt.h>
 #include <asm/current.h>
 
 /*
@@ -161,6 +162,7 @@ extern void finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
 	struct swait_queue __wait;					\
 	long __ret = ret;						\
 									\
+	sdt_might_sleep_start(NULL);					\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	for (;;) {							\
 		long __int = prepare_to_swait_event(&wq, &__wait, state);\
@@ -176,6 +178,7 @@ extern void finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
 		cmd;							\
 	}								\
 	finish_swait(&wq, &__wait);					\
+	sdt_might_sleep_end();						\
 __out:	__ret;								\
 })
 
-- 
2.17.1

