Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6ED377572;
	Mon, 23 Feb 2026 23:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889091; cv=none; b=Z7Oqj9wMBAQkGosLkARjm9EKwLHQ1aNI6PbRJfRj0o2ngif+NArPDSD6/LLvUnFvOG8o7xN1aPDxDlRMX92aKtJWPy0kaZ82idf5UziwOxW35S76wKAqYzMn2U0jABEZkLOkOOMEOOATDkQo2sSGGdRzVXVsaS0jIKHnQBp87E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889091; c=relaxed/simple;
	bh=QWmAhJ4/uLMy48ArCgQGOSVIRV+HzRmvRUTnn6pAp4s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adoGX2NCCt50Q44kts1WdLMe6kTrdF/j3qL5j3hl3+lbZpcSlIcW8Dyid39y4mkAkz4bOqvqf/2i7ndW2e0MAga24xXXy01o19NazzAqPwZMswwHuolH3bscUh8GXOrOILQwdSeXBItxwlfbB+YncK4NN8PkoiEeZWDPWqsnZK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1slWimg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1slWimg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16F3C116C6;
	Mon, 23 Feb 2026 23:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771889091;
	bh=QWmAhJ4/uLMy48ArCgQGOSVIRV+HzRmvRUTnn6pAp4s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i1slWimg7qrwHmOqYbVNTA6ciBBmvZRKFIrOFBp2/rlIBxnCRljaAFzQjAYjR9usb
	 aLL0JkaIBsNuPtuJElVrepzANY7g7fg+EK5ZqVtnxtlMfUEJ5oHBQ5WKE4iaZ/Z6Wt
	 uC+gACULhhlt9FoXEvbhekYzki7YZUL/lQNEz0KbTrOJKfbH0qk+ioKbQkb+iu+ipz
	 GZYczscZo289EfztUQPlyuycUTfhEvhufAA+oOY3wqXfzv9CcqaBAApoHldwUJdHe9
	 9Yjzhz88Yxuuv0EDwW+btzgxKVwIBpgRhYccsu3S4Rzxw3ltocjOh77985Dw1bFQaA
	 A1QUvjyhR4+UQ==
Date: Mon, 23 Feb 2026 15:24:50 -0800
Subject: [PATCH 3/5] fuse: prevent iomap bpf programs from writing to most of
 the system
From: "Darrick J. Wong" <djwong@kernel.org>
To: miklos@szeredi.hu, djwong@kernel.org
Cc: bpf@vger.kernel.org, joannelkoong@gmail.com, bpf@vger.kernel.org,
 john@groves.net, bernd@bsbernd.com, neal@gompa.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177188736859.3938194.1245756213398236681.stgit@frogsfrogsfrogs>
In-Reply-To: <177188736765.3938194.6770791688236041940.stgit@frogsfrogsfrogs>
References: <177188736765.3938194.6770791688236041940.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The stub implementation fuse_iomap_bpf_ops_btf_struct_access has the
unfortunate behavior of allowing the bpf program to write to any struct
pointer passed into the function!  We don't want to allow random updates
to struct fuse_inode, but we will eventually want to pass the pointer
as a dumb cookie to the kfunc added a few patches from now.

Therefore, look up the btf types of the two structs for which the bpf
program *can* write, and disallow all writes to any other structs.
This requires a new export from the bpf subsystem.

Cc: bpf@vger.kernel.org
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/fuse/fuse_iomap_bpf.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/btf.c         |    1 +
 2 files changed, 50 insertions(+)


diff --git a/fs/fuse/fuse_iomap_bpf.c b/fs/fuse/fuse_iomap_bpf.c
index d4b826e4440ca7..13b5d4b96b66b5 100644
--- a/fs/fuse/fuse_iomap_bpf.c
+++ b/fs/fuse/fuse_iomap_bpf.c
@@ -5,6 +5,7 @@
  * Copied from: Joanne Koong <joannelkoong@gmail.com>
  */
 #include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
 
 #include "fuse_i.h"
 #include "fuse_dev_i.h"
@@ -12,6 +13,8 @@
 #include "fuse_iomap_i.h"
 #include "fuse_trace.h"
 
+static const struct btf_type *iomap_begin_out_type, *iomap_ioend_out_type;
+
 /* spinlock for atomically updating fuse_conn <-> bpf_ops pointers */
 static DEFINE_SPINLOCK(fuse_iomap_bpf_ops_lock);
 
@@ -38,6 +41,14 @@ static int fuse_iomap_bpf_ops_btf_struct_access(struct bpf_verifier_log *log,
 						const struct bpf_reg_state *reg,
 						int off, int size)
 {
+	const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
+
+	if (t != iomap_begin_out_type && t != iomap_ioend_out_type) {
+		bpf_log(log,
+			"Cannot write to memory from a fuse-iomap program\n");
+		return -EACCES;
+	}
+
 	return 0;
 }
 
@@ -47,8 +58,46 @@ static const struct bpf_verifier_ops fuse_iomap_bpf_verifier_ops = {
 	.btf_struct_access	= fuse_iomap_bpf_ops_btf_struct_access,
 };
 
+static const struct btf_type *
+fuse_iomap_find_struct_type(struct btf *btf, const char *name)
+{
+	struct btf *some_btf;
+	const struct btf_type *ret;
+	s32 type_id;
+
+	type_id = bpf_find_btf_id(name, BTF_KIND_STRUCT, &some_btf);
+	if (type_id < 0)
+		return ERR_PTR(-ENOENT);
+
+	/*
+	 * It's only safe to alias a btf_type without a ref to the btf object
+	 * if the type is from the current module because the btf object won't
+	 * go away until the module unloads.
+	 */
+	if (some_btf == btf)
+		ret = btf_type_by_id(some_btf, type_id);
+	else
+		ret = ERR_PTR(-ENOENT);
+	btf_put(some_btf);
+
+	return ret;
+}
+
 static int fuse_iomap_bpf_ops_init(struct btf *btf)
 {
+	const struct btf_type *t1, *t2;
+
+	t1 = fuse_iomap_find_struct_type(btf, "fuse_iomap_begin_out");
+	if (IS_ERR(t1))
+		return PTR_ERR(t1);
+
+	t2 = fuse_iomap_find_struct_type(btf, "fuse_iomap_ioend_out");
+	if (IS_ERR(t2))
+		return PTR_ERR(t2);
+
+	iomap_begin_out_type = t1;
+	iomap_ioend_out_type = t2;
+
 	return 0;
 }
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 4872d2a6c42d3a..9a5b6480243f14 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1890,6 +1890,7 @@ void btf_put(struct btf *btf)
 		call_rcu(&btf->rcu, btf_free_rcu);
 	}
 }
+EXPORT_SYMBOL_GPL(btf_put);
 
 struct btf *btf_base_btf(const struct btf *btf)
 {

