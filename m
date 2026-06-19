Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E810632B12F
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781898795; cv=none; b=Uh64bTqMtPJxHcV5dp5W1bd3ZGJPBcYqhmexDtvdJiMHTK58ntBl1c0uN7prG6deNrPvGyQmFAVJFvBYUguoocqj8kzhuI3Br3DcfogbdjTFPadeIDcbfJ3Isvrb6qwN3CTpRZLbwssDz4gJiJWs5oNuiOFijElx85TriUsjmHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781898795; c=relaxed/simple;
	bh=fcIVVjMTnsHrHPjWk+UW6TiRSJVHZWP/y4W4/70ixlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dELwKP7h1mbL8ffat62rvtphSYhEo/wFEiF4bbh3+rx71d+jmyPL+wMnF0v97Sn/fzNwiLWoElKnLrWuHQNX6YI67u+tkVNdGXd+gM6BiaOxKhtPNqnRO7NnpudAzSs+RYI6Q1lTVSxQ60L+f07I1VrIKzySLeFJEU7P9MfwSEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GXjs2lnU; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GXjs2lnU"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-460662fcb4eso1752779f8f.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781898792; x=1782503592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMNfU7q4dd9MHwipiuthwvO8NxbdPRHZEOigHuhTmt4=;
        b=GXjs2lnUTl7dm5g96w/eYbvG80M7t+b+exJjLdqGmsCH3f48e6AysMelwG2dOZ1JJK
         A8UGU/S/78FcgiGxEK1a6iU7dZFJKjQb0S5YqFYfoMJ1qIA1sHDG7ZtpQCgrGM7F06Vp
         Q/BBek92tOngUWAqNHRLdg51RMQLzJ5YcXw5ic9cqjSnMpc7JPJZSrkwdNffGG9WTvvN
         JqRR4n2mBzdgxPUHQxadTIR32usK5X7bfJK6DznKdm3fn0pENZQeyAKX1SRFTEX27o0L
         L7QzvtQFLhJ+BDw37R4LoP7FkSgrzqIRAcsqODALdexbxyLILk/Z7B9Gg8WCrZH5MSwU
         hBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781898792; x=1782503592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DMNfU7q4dd9MHwipiuthwvO8NxbdPRHZEOigHuhTmt4=;
        b=l62nAuAP3VluI4Suui7Q7Z50RPxjUChwuhx6mqdXFsTS/naWRfdAvXfuInrRR/ILsl
         P0yLxkVvGkYQkATslHf44uw+MIZpipGQuARX/q7EN3P1wbV2A93YtbYaPMwGpKoi4TMk
         66AtIlcp8MhG4QP1Mu4JmW9G68m+Q242hxkg/V53e8G2zGXxO1EvEIjZDcRddMacm+8r
         peehaLZSEw3/TD+9md0M8wi1GpIe1i0x3c/nfdB3R3kdfb5JoRLElWbIGz/7qMp0Rqp2
         Zlv+LCClgu3ZxesGaaXkCB56nBuoJPe5O8/ODF9RFRGtE8Bx6BlKvYxyIqRUjRDAYVnX
         Dn3g==
X-Gm-Message-State: AOJu0Yw4FIr1E553QgP8NFtKIF2whZF8w4YgZyrymdDAjXIIzsyTWKNm
	cBnmjjXhkDfu2GqgY3vThst6TYzxo0ZnJ55zjGU47QG+HsiAoU9/nB5d+hbrF/xLMas9yA==
X-Gm-Gg: AfdE7cmJVOulK/9FviPhN5FeTfrgfi9UndKRGuqzgVL/jMu33dELZU7klZRp7dWpRuG
	cIKStD+s2h1vWKCiXUimlgDx4vJVUfor8KC734hNfci2TvGvlgyC9CqX9OYsnbS6Z/76Af8GCfb
	fyUn/4+vh0uHeyNWAgZkv6H9JCzWa3Q1kolVmZbzOmUqTO4AcPlCw4+a940/S1QVXPakDe2W6wX
	4rmUPEkljvDWH9PuAlXKUtjwfhXk7PJOUUfhdPnLOYeETg/aJS/MyeZUM4vlZEC7z78dDMlAgW/
	BYK1K3IFEsspjb27yxwcU2A2soxHCH00b2S6KW9pFSXXbfFkO7BAtZtTaKfnvoX/hNuyK3VpWn+
	VDTkxGfSJfvy7GMRV8yGZb9q0HEdC0i4sftLJzi0Z/HH3NCkcbgAB0YQcaD3IjSAc+1sxcVbbuL
	4XN0EGokmf/ICF593Ar2X2t+qdr4QdslpPWr4xED65rQ==
X-Received: by 2002:a05:6000:41e2:b0:465:767a:3a15 with SMTP id ffacd0b85a97d-465767a3ad9mr6855375f8f.18.1781898792314;
        Fri, 19 Jun 2026 12:53:12 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e3esm1430822f8f.8.2026.06.19.12.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:53:12 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v2 1/6] ext4: add common helper to check whether dirdata is applied
Date: Fri, 19 Jun 2026 15:52:00 -0400
Message-ID: <20260619195205.29384-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260619195205.29384-1-ablagodarenko@thelustrecollective.com>
References: <20260619195205.29384-1-ablagodarenko@thelustrecollective.com>
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
 common/ext4 | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/common/ext4 b/common/ext4
index a2ce456d..47c31db9 100644
--- a/common/ext4
+++ b/common/ext4
@@ -242,3 +242,37 @@ _ext4_get_inum_iflags() {
 	debugfs -R "stat <${inumber}>" "${dev}" 2> /dev/null | \
 			sed -n 's/^.*Flags: \([0-9a-fx]*\).*$/\1/p'
 }
+
+# Helper to dump directory structure with hash info (requires dirdata feature)
+# This is useful for verifying that dirdata is storing hash information
+_dump_dir_structure()
+{
+	local dir=$1
+	local dir_name=$(basename $dir)
+	local expected=$3
+
+	local debugfs_output=$({
+		echo "cd $dir_name"
+		echo "ls -lD ."
+		echo "quit"
+	} | debugfs $SCRATCH_DEV 2>/dev/null)
+
+	# DEBUG: uncomment to see full debugfs output
+	# echo "  [DEBUG] debugfs output for $dir_name:"
+	# echo "$debugfs_output" | grep -v "^debugfs:" | sed 's/^/    /'
+
+	# Check if hash data is present (encryption+casefold+dirdata case)
+	# or if fid data is present (dirdata+encryption or dirdata only case)
+	if echo "$debugfs_output" | grep -q "fid="; then
+		local fid_value=$(echo "$debugfs_output" | grep -o "fid=[^ ]*" | head -1 | sed 's/^fid=//')
+		if [ "$fid_value" = "$expected" ]; then
+			echo "  Directory structure of $dir_name: OK (dirdata verified)"
+		else
+			echo "  Directory structure of $dir_name: FAILED (fid mismatch: got '$fid_value', expected '$expected')"
+		fi
+	elif echo "$debugfs_output" | grep -q "hash="; then
+		echo "  Directory structure of $dir_name: OK (dirdata verified)"
+	else
+		echo "  Directory structure of $dir_name: FAILED (no dirdata)"
+	fi
+}
-- 
2.43.7

