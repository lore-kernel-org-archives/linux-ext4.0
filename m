Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9497F40A93F
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186843; cv=none; b=qOB9Lnu3By6dkx73tigx2gUMwv/PGW0Y1fkzSCFhrmfc4/0w75qkTkIV3zN81LjxO2JuF105r8y44wBQV1OtuW/pUfr+FfflfVgome70DTloGmUM58OHXao1o0a8iawasyTf14QGJaFJT4qgNWJYGWTBfgEZI0Gj+pLY1nsKemQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186843; c=relaxed/simple;
	bh=B4CXJ0aTJjc6ZByxRUNrZkpEsmwvksieJ+Zmu5orB5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I07IYYlukini2lEdGnUJDAfN6DfgH6APTXB3WQWpudBas70gbgDdyWxciH2VV+lZksJINsVSykFBLDD/ptzm/ruFWeqHiOF10grymLZLYPDr3lZoJ0GTinGqlvpGxSLqASGLsthU8Szn/dcyl5A0HkTwkQ1tv8DQK8NLpKwVxSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c+VwRJbh; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c+VwRJbh"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so3205997f8f.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186840; x=1785791640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7a+hRcf6JtdEgaXXU3DSmQd8qNwgWjcQziOvoCp4arU=;
        b=c+VwRJbh2/YKVinjtw0JVBSuDTc74UtMi5u0OO2Yob/g8zATWiusngTrMK0rwlM7Sk
         Pt8dCKEqUsX8ZI0Rd6yQ9101GrHjADDJFl/21hLPiMcZTKT9NP38uSjv38uRXG13wNXA
         89XGvQD8QOLBsiU5sU3Pas4b/IvFhvI/WFDKVdL8P/CJraalnacQr3f17NJvlG3n3c5v
         2SUJU2XcUlcP06wansSChZV193XKltLC+WK2b8M32Wpx1xdy6gsU2uhJXR1E9LGHFBR3
         Xd17hzeUMVuQqxuAA+Ioba3yHv9MEL0WjtZemQyQz5gL6xQ3yJ1qDHbmvzAcWLB/NBCT
         684A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186840; x=1785791640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7a+hRcf6JtdEgaXXU3DSmQd8qNwgWjcQziOvoCp4arU=;
        b=N8Z9p8NUjujzlh+ozTvjL8ZkJOe8ICuI1QvXXq52TVI6RSmZNHLyDMorCRI/ZYKZqV
         mJgNoUpvNZVt9rzqX4cI6lzabrZBqHcP6YgLEDYHGHsS4Hz3TBguH/Oht1baSKR+rB5G
         Sq/KDXsf5qu/YK5xKq/zfViCcHsSB6GlD7CSlDyOitPyrE+t+x21C9og8twphdquTtx4
         jVIQjdX/LjYB8aXMCgqMEimthQyKKoKBNktX1cqhaWmTTIVo7oGXyL5rTO8QjyXBWuLB
         FgbCSYp7B+/hj02xRRv80LyCk9jIYQXzidkzwZNWEuNHDDGSXeEmMy1+UQzVAtg94A73
         FPhw==
X-Gm-Message-State: AOJu0YwBFgzhip1IMDfMScV7M2bXvJrYAoIa0ns/kN2OAKVIweeSS3TE
	/btQo4ezN8i89KQQaeFxYbu0MfOF3cehhILE0HmJia2THnH2Ysdq5m6oLlRcE+ZL
X-Gm-Gg: AR+sD13aKItBOU4BgOtatPpL3ik/MIJmJQ5DUaP3dj8mTPYKP0GZW1Ge22wq6pFc+tQ
	q7/IYVAv7rCDad8TPovk/zB2ZT/CfeR3fRFumvuXP2n+aNsnF2xSH8a+vpWYs9kcgt3mmLC74hT
	1b/JJ3t9P83TxE+Xqu/hMrGy7ImZGG0tfrVhdircUewk3W+5oA9+7RfUKclJ7M/GcXicyAQEnwf
	m9uYknIJFNsLIuIv5FtFxoJ7w1LnUfXQAl67gdvJXI0CBGXUzWTXoYQj1xM5o9qSVlvyQwrsLGq
	YbCoDLUD13CqoIQlRTso1VQGVmqxeEfQuKHH79P3jub9HBfajIWE5MO6r2jHVqDUyFISMzyBPI+
	JADRP13bIMuSIepoMIxH/44xq9A0IXrwiAMAKA9OuJPF7HCz+nwBgHq11bKaKM/RNv1GfXam2m3
	QLVbr6nWB/kQP9BJTEEU7ccmpnCK5fHGBNbDvWjDpQfnLk
X-Received: by 2002:a05:6000:1ac9:b0:47f:928e:21f7 with SMTP id ffacd0b85a97d-47f9feaa467mr13121086f8f.55.1785186839852;
        Mon, 27 Jul 2026 14:13:59 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:59 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 1/8] ext4: add common helper to check whether dirdata is applied
Date: Mon, 27 Jul 2026 17:13:33 -0400
Message-ID: <20260727211353.19736-2-ablagodarenko@thelustrecollective.com>
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

