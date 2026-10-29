Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276936;
	b=KzgxohCl6xqaKoZvQvKcnsuy2HlPDS1hkZwVvbR2E380ZXW4qqjRzNWZrbeylb2Hfhoo
	 crc+X/Z9+jz3LBhRWdLoDKJhcOL3VblqmN4MIbr2ftglUsvpqwyivNDYZdR0i5cEbtq7e
	 INw/OTL+Tn2x0lWlTVY7YSt+fJfM0dZRgIII1J+bde5XTpf+oBH8QniIoboygfNeoC5Rm
	 OohKAqEOMpFtHWYEHasyP/3jVjXKsdOWH8GsX24wIz+IUd8VTHlEZef6APKG+8k77qywo
	 /pNaFuqiPYsAZcVw2WavDeODW+zJKNySEcSamh6ecy40npF/KMvZM/lWDU0YIxs6+0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276936;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UHCq+Q1Qg64dQBjI9+7Le+PpgR5lNI91wIHu/Y3QtVA=;
	b=HBsrKgAIR+d9XQT8n+2+6jMKAniFXv0fxD9SzALK6zJyARBQT4lg7u5fCqLT6DV73rQ0
	 0x4OFstMv/6IEom9uhfWJGYkjqqRB1VUe22DTFhNqKX7FLiaun4QNvx2XeYyfEzpghl1K
	 ucsUIkl3ZmiYvD2l9WWO36ClhOm3OGrRuGBuoYbUr/0mE3229xp171OPkP0mEywtQNUfp
	 R6JWM2yV/3cLxAVdKvVUIbohXP8R5uuuDojnRf1vIJVa6QlXN0FGKpu9DYCSXIpzVUVUd
	 nTpkHW3ntzy4g/wrsrosAASOyaNTao9REp/UkRpyanCL08oqv1Zc1t9AMPPupuEamhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z5RCd+i7;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43035606A32D
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43035606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z5RCd+i7
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso18435855e9.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276935; x=1793881735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UHCq+Q1Qg64dQBjI9+7Le+PpgR5lNI91wIHu/Y3QtVA=;
        b=Z5RCd+i7LZ17IOuPvuX+4AT5T1xY4bX7VuSPS4UR84I3Zs12qn+na1YP41zj4oMarN
         JxCg0G5Mkf5ZqOuJDU1jZuczvmehXFYnNDJc4ZneE2Fmf3VkQbQ6p8G6+PioLqLPbdIC
         3Grp/82RqOqxeXCE1XqH2Gq7M7nFnDX+PdeNbx+eChJ27YMphq3Wk9lKVGAE23i/Bz4b
         sPS9BpRNjKSEsn+PhfTje6vVGbVQuN7hu35RHpOLgvn1r8xT5q5h5lPnLPrV3aVJTsy0
         pnV2gr3812y+ioe5OvVVRkL0cavx8bJV6dOcVMFWUcxP3BBfNyGhxPqHuEzNyHL8qslq
         Z9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276935; x=1793881735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UHCq+Q1Qg64dQBjI9+7Le+PpgR5lNI91wIHu/Y3QtVA=;
        b=pONO3GVMnW3n/Rr3QnA4ZM6uhkoLJqhoCi9wYdyzcX8Zm50QmYmQG5qpNskgGBacTp
         dsGFF3LzSDNFUdZ1YzAxy/HdvNJX7EHJ/1V0xEH/N4OPCPetcD4ZRlHWdbaevqCdSrzG
         P6lxwP0uSjay/ftNe2Ko6nurIHrXvLhVpOjCsU90cxqBFNNp28Pj23d+tKit2jPF4eSf
         KD1X8pK9UEBHQnN7FKozrTymGCkMZ+cseccMkLypE4/9qPejxL5AANM0+Ddds8VofwI1
         hJ2/rerdMCn7l6g5ey/BXE4RuFbnp2YWwHUfoMsg2zC+eZ9vA7rVHm9G+1Q8KSzBpu0g
         SxfQ==
X-Gm-Message-State: AFq9FYKYYueCwfvTDY59hHzwy6/7tpitvvUd70q6h+7XoNbXDCCHp373
	j78HkhFx6eAOX8suylWek/WkKFl5PSkCkXhzBlV+3alE+LOmb4nZ1Iin0/ZbFgAp
X-Gm-Gg: AYBFou1Irt/xPdp8QIjS8sQtJ1Xx98ZKG7c8LQW8dtUjcny6EUE+ke8WV6ztESYIj3i
	4zrR/wMnOsOOHTkxIgdBd7MQ5nVbepyfL0cwMEZtdHsInAAtat2w8biDsdE7QY+1KYfM8A7tr2O
	9oYYk5pVhWgv/YyLJQU5JtCbrZd7TdEXXSQdq7RApChRKMzGn6O8gIWmoQzmdam+GReAXougwzu
	0ZnCWzjjIq6cZcQwZRVnXx6Gt5dH1e/TE7gD+XXvAsWhG15WzINmz1XczSoI1hVC0wpvT1AEL9g
	u70VmcnVHh9xAnZOrxSYtVvnB7ZvpXAu+3GfYGfOt8Xjtp0sMSZAsvM4j6BjZT0GVdOTiS4l7RA
	odjggFMhPM0131zqpbqb3g2zB5oHI2dahUjsvR0il97QSaevxF10FHH++QHNK/DuR29ZTnH5qcp
	ZOhM53xGZejkqnOV9fLsK5jPjSTbTu5yHixIWLcC/fxujDL2OOmMeQO0fEoCnhfIsMus9N8FH5y
	VLpKKtcTY+BEY1ZZrGXxiWqqB9BNTBk1pFUkqawW8M4R2GqyjpMj8JbovNGW72uDDIzIr33jwlW
	8xjzH0pdOfrXmaj600v0nGyq/SaAzg8/FeGldq8tjagSAf2JGCtIhXiIcqyJAPQHMn6J6ViTsMq
	Hzb7wgw==
X-Received: by 2002:a05:600c:4454:b0:4a3:5a7b:6002 with SMTP id 5b1f17b1804b1-4a96720213bmr122180355e9.28.1793276934603;
        Thu, 29 Oct 2026 05:28:54 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f7f50d3sm92477915e9.8.2026.10.29.05.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:54 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v5 1/8] ext4: add common helper to check whether dirdata is applied
Date: Thu, 29 Oct 2026 12:28:32 +0000
Message-ID: <20261029122842.230704-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122842.230704-1-ablagodarenko@thelustrecollective.com>
References: <20261029122842.230704-1-ablagodarenko@thelustrecollective.com>
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

