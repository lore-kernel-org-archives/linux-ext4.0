Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49990418363
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 12:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789736383; cv=none; b=LMI7k01PPB2RcoIunubu7OyF1CWTl6QeBXKlsd7PcyVMbPREMEgtGrx1UCOpmODSO3cRQD0jpifCQeDGOZ7CsYLVcBbSuYBJGIM52kfgVf+NAmqJN2yu2OcK2rpa7tiq7mns+MZn1GPwaKPbAYT+FJnTvAYEhm4L3hdH+VNqdys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789736383; c=relaxed/simple;
	bh=7KuYwaqXHalpvewsaXdlKsC9aFuY0ov7ZAzcJPT3JtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jrcixVtJzNHsd/kztqndcUe54dUDBYDhEdcRltwMfF5e79HXCeQ+ID2umcb7nfl2zNSCptWzVYWlvi4SSSeOX8NyNTQXvFAA9bsdeNZ+wkxM/Qi6AnCzxk1Nhj6/OZna8HZJRh+FQaq+zoDLHY5KIVWYAs5Vap8t41H3RIF0Pl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FqMSsghl; arc=none smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FqMSsghl"
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910c9ff1cso58726385a.3
        for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 05:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789736380; x=1790341180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=odRslDZtptoB4bSALlgDyegntO86pYgsjKQf7Y8JBek=;
        b=FqMSsghlJAFgn4eudN7kquGm2E5lq1PAhjcSt0HlE7YT92GCCRNGJv4l4rtiCUxiyA
         rHQujzM4gMj2UpetNOX38+Fcg9RUpEACtvlj2xEqUmA+lEPuZH9rt+wwhXcdrFb5jAyy
         TZt30i386mR6Ztqh0e81YlP0jRLkNHjizsT8jLHAHSb8P2DYuJCr+iRckTYQOl32tKWc
         ZWw2te3wWt/Yc9K6T/R+O1Sfo4U+LaKUnCAE3YhcK0mNL+X2si7QQ27L4VnpKZMWWC1U
         34ZVKRub3LCfNrHlFZIHzLM4UKsHH3+DXduzTrcEcgouoqlT7PkO1nZXWJYZVtRNnN5u
         +Mhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789736380; x=1790341180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=odRslDZtptoB4bSALlgDyegntO86pYgsjKQf7Y8JBek=;
        b=WM3W15sApVAJK7Kc86yueJ0o9gunkKpp2NsflfycNbXQaKkl5FbSUCtZLw4A47qb60
         K79sgB6AAcVWRr46uPJQ4If1W0Q4xlVdFOZjb2u1hzgPjr++V6zSTGK8aykmsAX7VX8/
         9H18u33Tt4YzS55lqGrIm3o5RPO9J1HoWl6Hc2qatpMbpim6pdaz6wv/l1VeEHw1qk6F
         YzNkCFFKU3msDqpniHno/BDV0qHk0Q0UuDKoBScpupuUj2c91vxr6NrJknpuglCgptES
         vrEjUhLecjKKz/ejaG8HtWRVmBetwuTYLbyB8uJ6P8WBsSuCs66SgD6dY+U5RMS9Ciqk
         BbAA==
X-Gm-Message-State: AFuF++l3r6MjTkjkc7hkqwsHHC64HI9MKiGG/FdSgvqRKyNm/+QrDqdi
	31eWOWHhPmcJFsVEK9GAFKuGzT+M3MWyg5zPRXajtk/WGlp58DevURyrDcuBcA==
X-Gm-Gg: AYBFou09qR8SZurOJYFLYSiXYUhxH042hg1cjzAXIxb2OrmA6HwtB4lZyQk2419pKjv
	8Sz0tD6cRZPrrczu4EfXl2ZGXjcNFbSjK39urpJfin/IPQb0RdrKsh/Mks9bExedAS43a43cCFp
	wLOB2AiIq8Y0QvU5x55m5mPBY3dbN6eYMgqEPnULmi5JQe58xxxfLKwzCRJiKtbVz4/YE/8Hgu2
	O4b0ALlzRVS7kRL8gD2ArKmBVWUtYPNomNV1cFsC5JEa4gVI4O+VjWyDTODA0oHeDoAdI5HUP41
	e7Lcg9Fg2F7eMbcvXSu10Ix5UOcWMFqzEmNPp69DzKUFWFbwXO3MShqIV2rnveKwR0d+Tdigzi1
	7Nd3/0ZmjP27Y9zQNKpqBJTv1PBBhkonEHL+fXGicLXZl11HtnaY9gIbetmnlaAGD3RRlsQXliI
	DLRs/caagriNlaWld/j+fFcy26nAgMj/zZv6UvSJo6WnrCZFZgGvkUZflDgt378sO3GMX4cogaO
	4zLalE1NG0ZXKdKMNZbDsUcEFn6Zo7uhsJy6Ip6UJCZtpSQZ0oWugXA0suW7fq1dNK9ERt9q8WM
	O2TV5dl/xSfDRg==
X-Received: by 2002:a05:620a:8086:b0:93a:269e:1dc9 with SMTP id af79cd13be357-93bdc6ae60cmr313128085a.31.1789736380002;
        Fri, 18 Sep 2026 05:59:40 -0700 (PDT)
Received: from localhost.localdomain (pool-173-71-97-169.cmdnnj.fios.verizon.net. [173.71.97.169])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0ccc10bsm136319085a.1.2026.09.18.05.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 05:59:39 -0700 (PDT)
From: Akira Patafio <kokokoala4211@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH] libblkid: bounds-check volume-supplied offsets in NTFS/exFAT probes
Date: Fri, 18 Sep 2026 08:59:34 -0400
Message-ID: <20260918125934.57676-1-kokokoala4211@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

probe_ntfs() and probe_exfat() use four fields read straight from the
volume without validating them, and each one produces an out-of-bounds
read. blkid is normally the first thing to touch a newly inserted
filesystem - udisks2 runs it on hotplug, and on Android vold runs it on
removable media before any fsck and before any mount, under a dedicated
blkid_untrusted SELinux domain - so the input is attacker-supplied
whenever the medium is.

1. mft_record_size, probe.c:709

   cluster_per_mft_record is a signed byte from the boot sector. When
   negative it means the record size is 2^-value, computed as
   1 << (0 - cluster_per_mft_record), so the shift exponent can reach
   128. Shifting an int by >= 32 is undefined; in practice the result
   comes out below 4, get_buffer() allocates exactly that many bytes,
   and the memcmp(buf_mft, "FILE", 4) that follows reads past it.

   Reject an exponent that cannot fit, and require the record to be at
   least as large as the header that every later read indexes into.

2. The attribute walk, probe.c:754

   attr_off starts at mft->attrs_offset, a 16-bit volume field, and is
   advanced by attr->len each iteration. The loop dereferences the
   attribute first and checks attr_off against mft_record_size only
   afterwards, so the very first read can be up to 64 KiB past the
   record buffer.

   Move the check to the top of the loop, before the dereference.

3. The NTFS volume label, probe.c:774

   val_len is clamped to sizeof(label_str), but val_off - the
   attribute's value_offset, equally volume-supplied - is not, so the
   copy loop can start at an arbitrary offset past the record. What it
   reads is written into label_str and published as the LABEL tag, so
   this site does not just read out of bounds, it surfaces the result.

   Bound value_offset + value_len against the record size.

4. The exFAT volume label, probe.c:1523

   label->length is a single byte and can ask for up to 255 characters,
   510 bytes, out of a 30-byte name field. exFAT permits at most 11, so
   clamp to that. Note this is a behaviour change for a malformed
   volume claiming a longer label: it is now truncated to 11 characters
   rather than read past the field. util-linux's copy of this code
   clamps the same way.

None of these is a write, and none crashes an unsanitized build; the
practical worst case is heap adjacent to the probe buffer appearing in
a volume label.

Found by fuzzing the blkid entry point with libFuzzer under ASan and
UBSan on aarch64, then reduced to four hand-built images of 64-256 KiB.
Tested on this tree by driving blkid_get_dev() over each image the way
a caller does: 13 AddressSanitizer heap-buffer-overflow reports before
(1, 8, 2 and 2 across the four), none after. A well-formed exFAT
superblock through the same path is unaffected, still reporting
LABEL="MYSD" UUID="1234-5678" TYPE="exfat". Verified on both x86_64 and
aarch64.

Signed-off-by: Akira Patafio <kokokoala4211@gmail.com>
---
 lib/blkid/probe.c | 57 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 6a3bb24..7986bb2 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -705,11 +705,27 @@ static int probe_ntfs(struct blkid_probe *probe,
 	if ((bytes_per_sector < 512) || (sectors_per_cluster == 0))
 		return 1;
 
-	if (ns->cluster_per_mft_record < 0)
+	if (ns->cluster_per_mft_record < 0) {
+		/*
+		 * A negative value means the record size is 2^-value bytes.
+		 * cluster_per_mft_record is read straight from the volume, so
+		 * without this check the shift exponent can reach 128 and the
+		 * shift is undefined.
+		 */
+		if (ns->cluster_per_mft_record < -30)
+			return 1;
 		mft_record_size = 1 << (0-ns->cluster_per_mft_record);
-	else
+	} else
 		mft_record_size = ns->cluster_per_mft_record *
 			sectors_per_cluster * bytes_per_sector;
+
+	/*
+	 * Everything below reads inside a buffer of mft_record_size bytes: the
+	 * "FILE" magic, the record header, and the attribute walk. A record too
+	 * small to hold the header is not a valid NTFS volume.
+	 */
+	if (mft_record_size < (int) sizeof(struct master_file_table_record))
+		return 1;
 	nr_clusters = blkid_le64(ns->number_of_sectors) / sectors_per_cluster;
 
 	if ((blkid_le64(ns->mft_cluster_location) > nr_clusters) ||
@@ -751,7 +767,20 @@ static int probe_ntfs(struct blkid_probe *probe,
 	label_str[0] = 0;
 
 	while (1) {
-		attr = (struct file_attribute *) (buf_mft + attr_off);
+		int cur_off = attr_off;
+
+		/*
+		 * attrs_offset, and every attr->len that advances attr_off,
+		 * come straight from the volume. The existing check below
+		 * runs AFTER the attribute has already been dereferenced, so
+		 * bound the offset here, before it is used.
+		 */
+		if (cur_off < 0 ||
+		    cur_off + (int) sizeof(struct file_attribute) >
+							mft_record_size)
+			break;
+
+		attr = (struct file_attribute *) (buf_mft + cur_off);
 		attr_len = blkid_le16(attr->len);
 		attr_type = blkid_le32(attr->type);
 		val_off = blkid_le16(attr->value_offset);
@@ -770,6 +799,16 @@ static int probe_ntfs(struct blkid_probe *probe,
 			if (val_len > sizeof(label_str))
 				val_len = sizeof(label_str)-1;
 
+			/*
+			 * value_offset is relative to the attribute and is also
+			 * volume-supplied. val_len is clamped just above but
+			 * val_off was not, so the copy below could start at an
+			 * arbitrary offset past the record.
+			 */
+			if (val_off < 0 ||
+			    cur_off + val_off + (int) val_len > mft_record_size)
+				break;
+
 			for (i=0, cp=label_str; i < val_len; i+=2,cp++) {
 				val = ((__u8 *) attr) + val_off + i;
 				*cp = val[0];
@@ -1520,7 +1559,17 @@ static int probe_exfat(struct blkid_probe *probe,
     label = find_exfat_entry_label(probe, sb);
     if (label) {
         unsigned char utf8_label[128];
-        unicode_16le_to_utf8(utf8_label, sizeof(utf8_label), label->name, label->length * 2);
+        /*
+         * label->length is a single volume-supplied byte, so it can claim up
+         * to 255 characters - 510 bytes - from a 30-byte name field. exFAT
+         * permits at most 11.
+         */
+        unsigned int label_len = label->length;
+
+        if (label_len > 11)
+            label_len = 11;
+        unicode_16le_to_utf8(utf8_label, sizeof(utf8_label), label->name,
+                             label_len * 2);
         blkid_set_tag(probe->dev, "LABEL", (char *) utf8_label, 0);
     } else {
         blkid_set_tag(probe->dev, "LABEL", "disk", 4);
-- 
2.50.1

