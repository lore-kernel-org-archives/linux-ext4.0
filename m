Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713878;
	b=EC2Ru4yStMsiz3fVm7nhNrwCp1t//DHhRoodPQY8NCvCpTI/IW4vwjeDx5jIExx7NrTP
	 iffYDHloX/hzLa+7v4PDMqO1EM0EjXJrjzKVU2W3sdtArlYPFBP9Yyd0lLZ3yv0APq7qs
	 6FoEh3ahhawH+4C403Vp5Hadh0hT9M8BrnAWiDhJ3kOzcO+hWbMKNXNOvajJBlhVJ0Qi4
	 Eoy5ncM2o7cKk+A5EXzRsilNx08p7V7gxLJ2HE2rRUqJivgql6zD9tNH3dXV0FKqbuwZz
	 aPYK8rbBwRMYgG/aLGc+sDK3xDHfrxz29DFHOSKvQHYyJrhrf0uO2RpwLaR6cjBn/NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713878;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UHCq+Q1Qg64dQBjI9+7Le+PpgR5lNI91wIHu/Y3QtVA=;
	b=MZQSp7RtKReDOGELj5+IZ++nzjTWm+ZQSW/oniGYE6326tWP702aH+X6EBiq7bN0CtpH
	 WxFlHETWBHIPpDAlJnqPeRFzO0eqtV0j6IPDM3x4y0BJA8lISXmyOMeVkU8y8UqoLvWPi
	 D9mwJmDru7HyNFeXLgJPF6pK9/0p3fn6RQ0gmMOvWywPOsVvPJS+Mut6aYz8H4m8moyvn
	 KmjAvx+ecIs517ZD18ICFr9nniBSnoNKd5SaQrF0cMTXHOvkHI+A5Gj6EyCSG/aHcxBwx
	 5ant3uGRmQGOc2yOpLGzTS9/oGr9qMqrfd2l5HMc5QlfQeP2NDlpbj1N1osImh/CSPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NYL6MiUK;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2D7606A33F
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C2D7606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NYL6MiUK
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a215e64962so38752855e9.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713876; x=1794318676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UHCq+Q1Qg64dQBjI9+7Le+PpgR5lNI91wIHu/Y3QtVA=;
        b=NYL6MiUKfqMZdn4QSOvcv3Ol6upIKY2W2CrqtN2kN2BH7h22cD2dtvKEQaVH4j4v4t
         BfKOBt8r3AZhthZZ4FV0kbw9lbV+9fBifOWowIXh6shFB0sM1lkkGYTtHxZjBm/f/2Rp
         Y4k5MnGfHs+xOWWz8NPmleVJlb8V+tKQ0CJwWrTKFJK3BNv9ZYk0J5ZLAO54LUV2Gzis
         XzBchQnOYAcYoGf5pma3gcXeT7nvUoSmscwRTfUgfNzndNjXoUfa8daAxMbooMfWlBSd
         AA5kjfrM0m7ipa5H/rF7tLISRV6J82quwP2u4fp3/0JzQHhgb9aD2DFqzvmwK5jkG/L+
         ERtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713876; x=1794318676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UHCq+Q1Qg64dQBjI9+7Le+PpgR5lNI91wIHu/Y3QtVA=;
        b=hQWroVwPy2knF+xG9KPdHtqp0YdugrOUtzJkBw/BUWsi7cEkbglJv/dhRqMGs0Fli2
         dhPTTHltFL2msoM9yPjawV/mzWcy0nMANh2lVUlGEvd+f4212CW6kfCwWjqjXcV8DrKs
         hqUnbXq6R0HLi7KghCQ7aXeQ52jT70V9q2BNW51kK8RdtXQ/lH3A84m4RomAYfrIukV2
         cQoDJVsKBV0rtX0c1Gnyn1xQlfhQi9njdey7Y+JO/3LhYpkFZw8FKx8Bp6Wqzp33fPFN
         0SMbftxuTDYQB7ecqcOd//9dHYRlEAp0jZcwUwSGH8IyBYwQ9hiWVQfWA/mPC+wNnonO
         RHpA==
X-Gm-Message-State: APuU4Z/xnTf/kBmedTGiUvYSov0g+EbUBzCix1084+gwWqtjpyhSK/E8
	XaGj3VAxdoULbO1i0h/llYhAz6EBjCBXgwKKNg7ZUXrg7uxT7SrUxBCv
X-Gm-Gg: AYBFou0E8uMu5CnEYcE4T2PGZweDsEtqvAUVXw3Q7tathaWtj5huipAzpQNu4HLzORU
	lUdkpxubk6JB1elVTHFXOtN8XoC9n8TM1wRT+qlRfhwHsd6lPEENuZUpwZ9T2p9lGOPgRpDMw8B
	hK4BsmFf7KBeSyaajzmJvAIQ9wXjz9/ZK0DsUM8M/dQnSLBGHdRacnZ9b0ro3zPethOa2HsEz26
	1D7nbUINq96aVM6B3Md8LAZPXdbwMdnj5nLbHBzI0DLu1fa5jig5tSCHzuE1Cp7WYOrY7J/T6Iu
	oTV6MpzCzNpnI9i28WrUVHxGcyosoLHX00ajSvG+5Xfeuu0TE26ECAPqS9VMgE2mjsweRia1Y7D
	Hvx67OUt4NqcTc/15ce3mXZEyk+TL/ak67/dv4Ix3y8IU/JsnMcCrx+R4KSe4NdMPnGhGeO7HyP
	CWgnWS/zHOC+St8uZBucOPl1aEdDsqaUCU+fyynLkZRs6K6oHuk+yyhF1PUNVANH0u//LTTH7s7
	2FVbUNelOfRuaDTcoFOOA11zengsHsnH0ogBBf+IkZa6swwbAvL2RC1n1PspWvMq0Ws4SlbnULd
	dHpDN6s0MAy9BWtGbicGxaGlQVom+Q7WWXGZulqxkxPd0bBckCS8XZpihBoA
X-Received: by 2002:a05:600c:3547:b0:4a1:e69d:90e8 with SMTP id 5b1f17b1804b1-4ac1889d442mr299842755e9.22.1793713876338;
        Tue, 03 Nov 2026 05:51:16 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a96fc87fsm55320335e9.12.2026.11.03.05.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:51:15 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v6 1/8] ext4: add common helper to check whether dirdata is applied
Date: Tue,  3 Nov 2026 13:50:57 +0000
Message-ID: <20261103135106.610169-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103135106.610169-1-ablagodarenko@thelustrecollective.com>
References: <20261103135106.610169-1-ablagodarenko@thelustrecollective.com>
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

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Add a helper that lists a directory with the -lD flags and checks
whether any dirdata fields exist.

This helper will be used by subsequent dirdata-related patches.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 common/ext4 | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/common/ext4 b/common/ext4
index a2ce456d..d36ae40a 100644
--- a/common/ext4
+++ b/common/ext4
@@ -242,3 +242,66 @@ _ext4_get_inum_iflags() {
 	debugfs -R "stat <${inumber}>" "${dev}" 2> /dev/null | \
 			sed -n 's/^.*Flags: \([0-9a-fx]*\).*$/\1/p'
 }
+
+# Helper to dump directory structure with hash info (requires dirdata feature)
+# This is useful for verifying that dirdata is storing hash information
+_dump_dir_structure()
+{
+	local dir=$1
+	local filename=$2
+	local dir_name=$(basename $dir)
+	local expected=$3
+
+	# Flush dirty filesystem buffers before reading the raw device via debugfs.
+	# ext4 with journaling writes directory-block changes to the journal first;
+	# the actual block in the backing file is not updated until checkpoint/sync.
+	# Without this sync, debugfs (which reads the loop device directly) may see
+	# stale pre-transaction data and show empty or missing dirdata fields.
+	sync
+
+	local debugfs_output=$({
+		echo "cd $dir_name"
+		echo "ls -lD ."
+		echo "quit"
+	} | debugfs $SCRATCH_DEV 2>/dev/null)
+
+	echo "  [DEBUG] debugfs output for $dir_name:" >>$seqres.full
+	echo "$debugfs_output" | grep -v "^debugfs:" | sed 's/^/    /' >>$seqres.full
+
+	# When a specific filename is given, restrict to that entry's line only.
+	# For encrypted directories the on-disk name is ciphertext, so match by
+	# inode number (first field in debugfs ls -lD output) instead of name.
+	local search_scope="$debugfs_output"
+	if [ -n "$filename" ]; then
+		local inum
+		inum=$(stat -c '%i' "$dir/$filename" 2>/dev/null)
+		if [ -n "$inum" ]; then
+			search_scope=$(echo "$debugfs_output" | awk -v n="$inum" '$1 == n')
+			# Plain-text fallback: if inode match is empty (old debugfs
+			# format or different column order) try by filename.
+			[ -z "$search_scope" ] && \
+				search_scope=$(echo "$debugfs_output" | grep -F " $filename")
+		else
+			search_scope=$(echo "$debugfs_output" | grep -F " $filename")
+		fi
+	fi
+
+	# Check if hash data is present (encryption+casefold+dirdata case)
+	# or if fid data is present (dirdata+encryption or dirdata only case)
+	if echo "$search_scope" | grep -q "fid="; then
+		local fid_value=$(echo "$search_scope" | grep -o "fid=[^ ]*" | head -1 | sed 's/^fid=//')
+		if [ "$fid_value" = "$expected" ]; then
+			echo "  Directory structure of $dir_name: OK (dirdata verified)"
+			return 0
+		else
+			echo "  Directory structure of $dir_name: FAILED (fid mismatch: got '$fid_value', expected '$expected')"
+			return 1
+		fi
+	elif echo "$search_scope" | grep -q "hash="; then
+		echo "  Directory structure of $dir_name: OK (dirdata verified)"
+		return 0
+	else
+		echo "  Directory structure of $dir_name: FAILED (no dirdata)"
+		return 1
+	fi
+}
-- 
2.52.0

