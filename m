Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627043EDAA8
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186848; cv=none; b=uq8mgK7jsDOey/o35ljDFhG9x0wi1/Q8CrpVXKeLichfv0nrs1npkn28tt1qasJbMsPRlpz6Y/kqnJDwY3BKqTKoVDyT01QmhqTOoqbu30rlPFv9n5Bghr274dhb5TS2Ad2pWrDVt13moA8LGyjyYuNupcDaYUuGwE2PX0SwQUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186848; c=relaxed/simple;
	bh=B4CXJ0aTJjc6ZByxRUNrZkpEsmwvksieJ+Zmu5orB5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNQON3ehXBfINtWfcReubKSlPsrMeHXBPk1F/Yuwh7nOOvxgmk2+q74+yFpgiBuTg7iquI290tbWlMDlN7N1wGc6ApMF5oVnwQcQlsqauTY7UE9CEybqqLJ21JQrKh4m1W3KRKGoWgY9Ork3J+22sDnrq1u9t+bCbgnIJrSVMeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b0JiK3pD; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b0JiK3pD"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso1728863f8f.3
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186846; x=1785791646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7a+hRcf6JtdEgaXXU3DSmQd8qNwgWjcQziOvoCp4arU=;
        b=b0JiK3pDSNwKcozEAgIg2eZQRurkR4295ad6Jf5hBLDBhwxukeJO8pfq5EDOV2i5Nn
         ZGFsOiysrBk9khA9EZbcPf+KFdh16/j9XD533nK5lBUwRjGSvcS/fT/fp4bPKYUaviJb
         vL12NbsBs1qWukijFXSrzzgq+POpoSHDH4TAsGfoSvuya7QS8GciFbNudy93pK6ElbFa
         C0losVqIrdo3T8129A08uQnn7qV1G1C8K60fFBiR5TBM0IwWPzQV6+Rvl5yo3buUl+/4
         5G2UUhP2SxwXLLbvWxJv/8ufQK8WvQGzWWo1ER1SoLmYHNnv3NPU4BOE0tcGSyMz082s
         /TuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186846; x=1785791646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7a+hRcf6JtdEgaXXU3DSmQd8qNwgWjcQziOvoCp4arU=;
        b=qtJaEcQucOrhabBvXCQUKe1qJGIBmWgVz3hAmnJFSKqkDdXmFwvJ2X+qQ1sVfIUu51
         6tXjcd8oaP8fx8C55i/rQtjzM4FaWkvA1nqQYuRhmR5qMc0adYdRuvZSGJhuYVKnxk+k
         ZOqTsxV5fzY0vW+hPSrgRlmX+MW+9lHzFwJGQjsC1hp6e0XPsCd91GNbBg4np4Bl+J59
         Cumcnaad/MC0/fiCcqE4QUmgn3i2ykxgcx2kV91IcYIv2u2FfL3vzGF51drO1KxYx2Ul
         AWWwbWnsG1E4HGcMnwe9VHrt9+c7mp45tz9EZ9d8cIUn2CnfbkCWxInUniK6OnEMdHSw
         xgfQ==
X-Gm-Message-State: AOJu0YxGLeM8nWjT7X/xg+WxsLyFvftsGGnCYs/iXDnxbPlyKTWgo5Z7
	aQMg3b+sbpwRJnZwxilo4a4qPaXMyvj/JNB9BPiYW32MElUwnv0CzIdAAhRdQa+f
X-Gm-Gg: AR+sD11ryd5iHYfTrSuCMeSnzmZD1m+R0eEMIQGXvFCbD+a5bGj1k6TxPiyv9fQIHfH
	mIPnntz3wWiQZSbWFELek1mdrBT0/rU0ZiXwWkPMuLKm3SzMX2H7FyKXWfIoosE3Km/BXdvZ9Tu
	60PsHvhAEPraSV5r9Pi1jknIdk/Y5YS8UE3tTbZ+nYDfAHcBcYf0MmLU6Mpfi/C8rHVI5h2MwDP
	FcERfFxYXDxhTLSTEtfiRLFk5Hf3UcTm1OkivtkMc4444/HNAqinPERmPsgeb+blnSiTNQbKwcv
	0LqI5ho6Ekj46wEwG9bdxUkdGKXu+vmKTQg7iTWjjJuHq+NEdC9VZauGuZxetJX/YrqOQQYMilr
	Hin96gScJNdVLtbEuDwk1S5d/NyhNCmQx7jTNLNcF40K4uJcc0vu6ObSnQHD5qBpTqGziOLcu0q
	OzqKWwUxrFkM48ZQPtIevyozFGvXVPzkw0kWHeNZjx/Zt+
X-Received: by 2002:a5d:5d13:0:b0:475:f0f0:9ef6 with SMTP id ffacd0b85a97d-47fafa9d904mr704741f8f.59.1785186845611;
        Mon, 27 Jul 2026 14:14:05 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:04 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 04/11] ext4: add common helper to check whether dirdata is applied
Date: Mon, 27 Jul 2026 17:13:39 -0400
Message-ID: <20260727211353.19736-8-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
References: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
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
2.43.7

