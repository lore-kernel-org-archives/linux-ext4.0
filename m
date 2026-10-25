Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792960771;
	b=wWG9ygaQEH78g+4HN3IfkyGVCHiyl4B2YfHj+UPd4cuDkXSVO6Ywv4k6EaoMW0G+8bfU
	 xaiSKKFjkDjvont+0BMRz35No60ak71grLS17hMwwaGpOGUM+wX+owtrsAEC5TRFXIucF
	 nfbZCoGpYlAx7dDB+rsbATiuggb7v9TjAcRLtkG1+ztNUXpbDM6Om1ZJp0s/DiqYXWkG2
	 uTOyQE2t5U9RIsXvSWaWuyDNzJIGgrCpWSi5X90xFGxc8UARDL9T/ioAryZDgPPIX34d9
	 DYfMU6LNB2LB/Vxam+d/WdwXzKuWlnY3G5dZJdeE4qxDCKiVqG2AxKLF5lhTN5FK1iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792960771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dec6d23kzD9Q7ZmgTNaLfCaR3TzF+qKAdsnxeeBx+Qk=;
	b=5VjIbbib1YBRzp0kaL7Ila5RnBZQeIeBm93SZSDvE44IGJIaH0ogJeem3ssT5kHJIBUx
	 0mL3fWf16aKv4GuoMAONRWgRq+Sql31c20IekC6FhduGMcCYekHJN8BLIX+l88nU/8XvP
	 iosSSz7iYYUrtomPSzK2asZ7tV/oSHEF7gf1KTpvFgUpKv4ajBh8xnbZkmqitJcUZUBy0
	 TXrrj5+jkA+fSln9DkO3BL0FoUGemWyaLrjth2nx4cfQwJT/BKSj3bISd0YiiglwSu710
	 Yhb8pjAXoLL2Pu4miaAGNtANMnCJBCt4qCealVHeBjvx8tIWgJAscFu9Eispm7lR7ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iSToPKTP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C3F606A31A;
	Sun, 25 Oct 2026 20:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iSToPKTP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B87C1F01825;
	Sun, 25 Oct 2026 20:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792960771;
	bh=Dec6d23kzD9Q7ZmgTNaLfCaR3TzF+qKAdsnxeeBx+Qk=;
	h=From:To:Cc:Subject:Date;
	b=iSToPKTPDNDUaXbuV1jJFmBiMVnkKX8KG92NdwNokA9KpYlv8kvLJ77rJ6Ff2OC64
	 B0+5gSWk92sPlFZBNMujMaYXdWDiwpMpvYeR/rhkBovuTDLEuYKBaDRtLqLOhiVG95
	 FU8E14i1657mzsPlsMkDu60KJ14dzl71px8W1BVWeoZfPmXvN63+yY3tpUJXTT+7r7
	 0yR6XyCr2XJhhFLjgcsHBaE8erCrbiA0QwC2PC5LKafNF06F7oTwno6syFiR73a9v+
	 SYTSqta1GeWULcIY00+ImdRvrKdbcnk31RS4wXhWpnB4Tq1WKVG0mBZg59Nl2OjATA
	 UwWDKnaZ/8TrA==
From: Eric Biggers <ebiggers@kernel.org>
To: fsverity@lists.linux.dev
Cc: linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] fsverity: Be more careful with return value of ->get_verity_descriptor()
Date: Sun, 25 Oct 2026 13:38:31 -0700
Message-ID: <20261025203831.120095-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If fsverity_operations::get_verity_descriptor() returns that the verity
descriptor has 0 size, then a zero-size buffer is allocated to hold it,
and it's called again with bufsize=0.

But bufsize=0 is a special case that says to return the actual size.  If
in the meantime the filesystem has decided that the size is some
actually valid size, it will return that size, and then
validate_fsverity_descriptor() will read from ZERO_SIZE_PTR and crash.

Of course, for the filesystem to misbehave in that strange way, it
generally would require direct writes to the block device.

Regardless, fsverity_get_descriptor() might as well guard against it.
Make it do so.  Specifically, validate that the first call to
->get_verity_descriptor() returns at least the minimum descriptor size,
and validate that the second call returns the same size as the first.

Fixes: fd2d1acfcadf ("fs-verity: add the hook for file ->open()")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/verity/open.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index 6646290430380..78a65154b8957 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -270,12 +270,6 @@ static bool validate_fsverity_descriptor(struct inode *inode,
 					 const struct fsverity_descriptor *desc,
 					 size_t desc_size)
 {
-	if (desc_size < sizeof(*desc)) {
-		fsverity_err(inode, "Unrecognized descriptor size: %zu bytes",
-			     desc_size);
-		return false;
-	}
-
 	if (desc->version != 1) {
 		fsverity_err(inode, "Unrecognized descriptor version: %u",
 			     desc->version);
@@ -314,31 +308,37 @@ static bool validate_fsverity_descriptor(struct inode *inode,
 int fsverity_get_descriptor(struct inode *inode,
 			    struct fsverity_descriptor **desc_ret)
 {
-	int res;
+	int size, res;
 	struct fsverity_descriptor *desc;
 
-	res = inode->i_sb->s_vop->get_verity_descriptor(inode, NULL, 0);
-	if (res < 0) {
-		fsverity_err(inode,
-			     "Error %d getting verity descriptor size", res);
-		return res;
+	size = inode->i_sb->s_vop->get_verity_descriptor(inode, NULL, 0);
+	if (size < 0) {
+		fsverity_err(inode, "Error %d getting verity descriptor size",
+			     size);
+		return size;
 	}
-	if (res > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
-		fsverity_err(inode, "Verity descriptor is too large (%d bytes)",
-			     res);
+	if (size < sizeof(*desc) || size > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
+		fsverity_err(inode,
+			     "Verity descriptor has invalid size (%d bytes)",
+			     size);
 		return -EMSGSIZE;
 	}
-	desc = kmalloc(res, GFP_KERNEL);
+	desc = kmalloc(size, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
-	res = inode->i_sb->s_vop->get_verity_descriptor(inode, desc, res);
+	res = inode->i_sb->s_vop->get_verity_descriptor(inode, desc, size);
 	if (res < 0) {
 		fsverity_err(inode, "Error %d reading verity descriptor", res);
 		kfree(desc);
 		return res;
 	}
-
-	if (!validate_fsverity_descriptor(inode, desc, res)) {
+	if (res != size) {
+		fsverity_err(inode, "Verity descriptor size changed (%d => %d)",
+			     size, res);
+		kfree(desc);
+		return -EINVAL;
+	}
+	if (!validate_fsverity_descriptor(inode, desc, size)) {
 		kfree(desc);
 		return -EINVAL;
 	}

base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
-- 
2.56.0

