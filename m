Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BF13B6349
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309030; cv=none; b=RuUcBxexLL2XXbD1lc7EjVUhHl9awo2jegV8JSY8+cMSi9iJbaWKTKilk9/zpjtMRa/WDD8X1Uz7cO9GGHAja4D4/CwrscX2kog9hCUofomQTVbYLAQe3BJ51TlIrbd6C6z3VY2oc5xcCXG0DszKDdBIPXlOefcgv7fpj59Mv9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309030; c=relaxed/simple;
	bh=fcIVVjMTnsHrHPjWk+UW6TiRSJVHZWP/y4W4/70ixlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYRkhVqXHVd791StWvlqNXfq9DEpvtUH79VeawuIvEtqvw9/1n+cQYAd4tEQ2cx/mCdtpGcCFFNyehDABWbKUr3c/hx+8NYuwCB6tYZNNufKlw1FwxK4aRofLpUzauVuV5g7zNgwJsxpT69XigkRK2lwNk9E/u/0mVlOaJJ6QVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JAMFX607; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JAMFX607"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-462bb734793so709087f8f.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782309028; x=1782913828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMNfU7q4dd9MHwipiuthwvO8NxbdPRHZEOigHuhTmt4=;
        b=JAMFX607Gyuh0/phOaOp8ijSI3wmTiYj3qAS/q8euueKVvdRbSzm/A9jHYY/XJQSiE
         PVEWA2AEOJZp9A1fbwIm/o2BRuqd9nyu9K4tKLrkc8vQArJj+a6gJMgUZp1nKsD4aeAc
         L9lDje+47AJTaveUG/kcHgjIesveaSvenksRghC4D3S8xeM3oG7rFu+47WPik6dvSvGD
         Z/YVULd274FYi6How/fQEKa1Pyohhs3Fxy1xUZTBOVGTzR0nw66Vc4zvVZp7HikZHDgy
         QAfyZr52uxmeABijwTNd9OFQCgzyJ4PRIiLcjeEkM313aTuGFsw0wFvMeLMf0nDm88ii
         T32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782309028; x=1782913828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DMNfU7q4dd9MHwipiuthwvO8NxbdPRHZEOigHuhTmt4=;
        b=XWPRMGXrtberrodx5Z3jxaR9QNQmmw3v00yDJ5J+lBwSwj5iK33sEi8qbdhwNCPgR2
         +SkYtYGJ4KB+HGwjqORIgvHdKHotp+D6xXV43CMQvMzULvyywNWttGWTjHd1E+8aTSJn
         0OBqMNRKh3AEt4fZQSQLLDmdwtpYbkJU/MUQHT3mDuH/FueqIQR3+aoe/BJJX4+MWCbi
         be8iDvXHd/ZednQzX++SSEIImWGOOAZw3S0TpWKuX8qGw3Lq+HDg/pMJ7DXdy4k0gpqB
         dV2khNzE/M7Is33dlzqtG1lFcGBX1rNmCbyg28tUcBi4S6NYyu/f8T+rcnMWhJ33JEbe
         2afQ==
X-Gm-Message-State: AOJu0YycjQ/wrnoWrieBYfZcEjYlzq186WIy/SMMtDVuUVnD/xJ3fSxy
	tMoCH7y7IWmZe1WxLgxzCVPdfJWLBgNC6WCYXJ5sj17+/fPt/39HUb+i1T73NBmH6hU=
X-Gm-Gg: AfdE7cnZgITiZRAnW/oh1EX9Gu/if4rA+vhFUcVzF4tOANiOgI/X80n8Q4zqOiCuPEw
	Hjpxl31ioiuLxb9V0ssb+PIMhuCbJUi5xzgSAAMxtzs/25Gn0RJqktIcZ8W7Co6vor7vUAnRl4J
	84rcWmycdBNZU9bv2hxKQ3cnUXfPPElHjekkbl8c0HFVyN1RR4pe+QB6vwRQkwJadY3pet13GdU
	QOOgvRh4U9ucXS1lUbzfjzWhGBZo40rsYwyZbtrDJckjKDHUZ57L6An/l1yMfKyqf8gwLJiQU6d
	7T48tK6AfQ0eFEvQ8M0O3Zh3uC/qMjmj+Dl8sQYdJowCooi6UT0ZDLmQS0ejGCxO/+JRNIKb0R/
	1hSYA7kbiL0WsrLUj7M//n/ECcktpLU9G16J7KNS2z1ANgf08cyMl0WrHy3DBhsc0Z363dRpXta
	b6Y1nJxBmCAPqBgSTy1ny4LFPDOMDdSYATEme6gpDL1fkl
X-Received: by 2002:a05:6000:1885:b0:460:70d1:c77 with SMTP id ffacd0b85a97d-46660d0617amr30703226f8f.13.1782309027599;
        Wed, 24 Jun 2026 06:50:27 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1e840eefsm7791658f8f.1.2026.06.24.06.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:50:27 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v3 1/6] ext4: add common helper to check whether dirdata is applied
Date: Wed, 24 Jun 2026 09:49:52 -0400
Message-ID: <20260624134957.19209-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624134957.19209-1-ablagodarenko@thelustrecollective.com>
References: <20260624134957.19209-1-ablagodarenko@thelustrecollective.com>
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

