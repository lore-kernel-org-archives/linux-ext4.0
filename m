Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094523D647A;
	Tue,  1 Sep 2026 02:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788230553; cv=none; b=ueqedY18rlECJrdKXOvualhl7ZijXwIX1JuvAayYHj8igAqezwH7WEyIFWwpZPEy6l/gcjG2rbzKuym16zsGNI+xhaUC1Q0fj6xjl4/yc0TA8daz5AsIObMtXqFvFUJKQkRiFFCJuEsuAFTe2bCvoUDhdSzfpV667B9OYvWVEBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788230553; c=relaxed/simple;
	bh=f8cUvQr4SN6kSkXKV2fOi8juRid33vv6DwaKQMI0W4k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZbAjVIP6WeY+ffhO6/SuAiObZXc6l4inq03w21mWNW8Zm2wxN0oUUHQQeSpyvTgYCys4j/mjIjus5MnvOxlzEhJXD6+LBncIwLKC98uwUbVhsbqIkjrr/+UH6V+BUtkxfG4JbDWnN5Z4BEeuzVdRyl8NnU5e0jv/jMP045Pi6RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=A0Fh0pQm; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="A0Fh0pQm"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LL0W8CeNgEMKMcIbN4r+qUTUQsLcK7A36KE0FRo5UcI=;
	b=A0Fh0pQmI7C2hPcC0amBJ1qYBkK7obbqDvixwwZLL6MV3N1/I2ZQBvHNODG9p4SQ2OPKyzd0y
	7rnauNdYlsUX7M+JhQ2bfSPyBFesEnhhjSeXnJsrYdqi4dDKAHoz61SnTSAEFHmcwdfm12ol+G6
	8dX2IQna8yN4elhbt5q0wDg=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hYqbZ4DDSzpTJ4;
	Tue,  1 Sep 2026 10:30:50 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D1CB4057D;
	Tue,  1 Sep 2026 10:42:09 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 1 Sep
 2026 10:42:07 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<bcrl@kvack.org>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <kuniyu@google.com>,
	<willemb@google.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
	<kees@kernel.org>, <cyphar@cyphar.com>, <tglx@kernel.org>,
	<ruanjinjie@huawei.com>, <sdf@fomichev.me>, <nb@tipi-net.de>,
	<liuhangbin@gmail.com>, <da-x@monatomic.org>, <jeff@garzik.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: [PATCH v2 09/12] soreuseport: publish num_socks with acquire/release
Date: Tue, 1 Sep 2026 10:42:31 +0800
Message-ID: <20260901024234.135119-10-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260901024234.135119-1-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500011.china.huawei.com (7.185.36.131)

Replace the smp_wmb()/smp_rmb() barrier pair with
smp_store_release()/smp_load_acquire() on reuse->num_socks.
Writers publish socks[] updates via release before incrementing
or decrementing the count; readers acquire the count before
accessing socks[], ensuring they observe a consistent view.

The detach path gains proper ordering between the socks[] write and
the decrement, which was previously unordered.

No functional change intended.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Assisted-by: DeepSeek:DeepSeek-V3
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 net/core/sock_reuseport.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 29948cb44b7d..6d3c511d1def 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -125,9 +125,8 @@ static void __reuseport_add_sock(struct sock *sk,
 				 struct sock_reuseport *reuse)
 {
 	reuse->socks[reuse->num_socks] = sk;
-	/* paired with smp_rmb() in reuseport_(select|migrate)_sock() */
-	smp_wmb();
-	reuse->num_socks++;
+	/* paired with smp_load_acquire() in reuseport_(select|migrate)_sock() */
+	smp_store_release(&reuse->num_socks, reuse->num_socks + 1);
 	reuseport_get_incoming_cpu(sk, reuse);
 }
 
@@ -140,7 +139,8 @@ static bool __reuseport_detach_sock(struct sock *sk,
 		return false;
 
 	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
-	reuse->num_socks--;
+	/* paired with smp_load_acquire() in reuseport_(select|migrate)_sock() */
+	smp_store_release(&reuse->num_socks, reuse->num_socks - 1);
 	reuseport_put_incoming_cpu(sk, reuse);
 
 	return true;
@@ -583,11 +583,9 @@ struct sock *reuseport_select_sock(struct sock *sk,
 		goto out;
 
 	prog = rcu_dereference(reuse->prog);
-	socks = READ_ONCE(reuse->num_socks);
+	/* paired with smp_store_release() in __reuseport_add_sock() */
+	socks = smp_load_acquire(&reuse->num_socks);
 	if (likely(socks)) {
-		/* paired with smp_wmb() in __reuseport_add_sock() */
-		smp_rmb();
-
 		if (!prog || !skb)
 			goto select_by_hash;
 
@@ -634,13 +632,11 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 	if (!reuse)
 		goto out;
 
-	socks = READ_ONCE(reuse->num_socks);
+	/* paired with smp_store_release() in __reuseport_add_sock() */
+	socks = smp_load_acquire(&reuse->num_socks);
 	if (unlikely(!socks))
 		goto failure;
 
-	/* paired with smp_wmb() in __reuseport_add_sock() */
-	smp_rmb();
-
 	hash = migrating_sk->sk_hash;
 	prog = rcu_dereference(reuse->prog);
 	if (!prog || prog->expected_attach_type != BPF_SK_REUSEPORT_SELECT_OR_MIGRATE) {
-- 
2.34.1

