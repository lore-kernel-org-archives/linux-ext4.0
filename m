Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6E340A93F
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186845; cv=none; b=L3XmoIpDdOKRpQOUg27Mj4nIa4w/GDjVrBHg2LIbqgfSMX9iUZRUt66qF4Na2evFbB9UwVBqVLzjsX3kX0pSY//4EUmO8Y+NwWvd4/J+HmEcDxndVSWtShRjTCW/EIw5o4om9TVpYqQlkiWQ4zhI7hnbWm3AGYPwlZtQYwsXzpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186845; c=relaxed/simple;
	bh=om686Qd4SVJ4uxRlElYPEoO1pg0LcfH3+rY/L0XnpQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkZZCM2wT1t6N1BOa6UZ78c+7dq1s8nqHptlYhc1LavA+sbrUD8nEXCniJeHozHQ+jjUp+kRW0G0DHsOkj5lT+AXe6baDVjEm1ouvLvVhb5pQU8yLPRXhQqOde1xlh8MhcjGupZ62K9ZvVnxJ7Rsbs+cnjDFfIox5d+OPWGrgSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kssThlM+; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kssThlM+"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so2643794f8f.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186842; x=1785791642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qtc08OGsKKfkIfJvIYhjbrRfCYsN81Fo4TbUiHaNBRY=;
        b=kssThlM+ttnt1hylFYIIjNakJR+YKigFZF7ShQTZodnQdiG/FY/3Yt52xr6xP8FJu2
         aW/xftr6xf3NWdDvR+VouW78IP25UfsOuVZqIWOta0rnERMDaJQznqks/l0alngWPrPB
         NAzI2V6hcH+4fkPgkNchwxTVXDXNfGe3tJNvc/0pnLvBkfz17gC1Znkrl9z4pZL1LwdC
         l08E2DZ08SpJPUrJAaIq5BNhe0qgqjyRXfuar3SB8wTW1Wee4/1ddoyDCFg8wxbgJv8H
         Wm5+vuMua3n6FTRRohHv0IhfVdPPlmLuxI15F6pm6YIwnb9WKSa1ooSJUeUioBp8S63w
         NdlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186842; x=1785791642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qtc08OGsKKfkIfJvIYhjbrRfCYsN81Fo4TbUiHaNBRY=;
        b=Cmk0+NqIgscubkX3EP9PIAa+QfewoBIVIU3Q8VM/GzjbcnFPvlecXYeMQzh0oA+4nS
         LCJulGXkJsez7ep+8z1C7KQXusJ/BbToj1CVCvzhYt1pDg1e1NudCGervx2zCgm9wKmG
         vQwiJInvTVmfmUDT3vzp+uXFZQGZXeyNu8UG961qdhXHsWtAugVzurlAji4xO6dot6gi
         AUJExJkcKSsBALjvXqei9oDg9kpHA2Q5yWS31C8mE62t5W5H9m7TeMTZMYZpC32suWe8
         gDTP/xzCUjzSYaTX5+0McykCZ/ZIegiCBrDaQ61gqgViO3Q23ltpeTI5lxY6AbXuxJZP
         KthA==
X-Gm-Message-State: AOJu0YzZmuRG81mHppAjCxHYWQfXIWWNM9V7yG2kp1F8o0grsocwMD85
	LEnUxEm7/JaG1WCKkNQH0NDvaD6CyI2VoeLQ0RurZ9/7OJBj1RvHBcrf4QeN4AXZ
X-Gm-Gg: AR+sD13VJ6xcGpNTsUWDKuJIZl6aQJoU6inm/hbGUCzmwuCEmRDPIRhfXljtGnBHRN0
	lCug1wUQLnI5ttBUkvDrsKT0bhk+M4KpHnpOctMq+Wq9GUvGHge303MYNycWNFNwG2Uys3xtNLE
	NSD4i5rg0Qc+chkvvR2O7WdInYiIzJXz0WEVRt2ZgKuHtNgzik7iaZ9UBOrMLb6Kgtim9xke6DM
	g+duuyZGcZ452ZVyFQxJqbbkqV9sbSe/pCNCAZ1kVHUUoT0N7XlBgUAzu/H4YXhpG8clJm5WGq+
	Ee8oxi0nh0PVGJPQzOVWPfAS3gINhrXmNRA6yLhoGwhkwBm4Y22h70F067u6l1x1v1s1E7fqe9w
	YCm5jOw6dr0750rB7Zg+rCRlq7pmp+LNg0ObeM5D0N6XffOaAPHTuKW9Hu/Ecfg3y+zUaU/TzBM
	lw6I5gJEXVkhAv6UVeq2do1T+tTFAzk1/sUiPZMVyUAlh4
X-Received: by 2002:a05:6000:2410:b0:47f:6d57:5a93 with SMTP id ffacd0b85a97d-47f9fe9b292mr13086027f8f.38.1785186842302;
        Mon, 27 Jul 2026 14:14:02 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:01 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Joanne Chang <joannechien@google.com>,
	Zorro Lang <zlang@kernel.org>
Subject: [RFC PATCH v4 02/11] generic/63{4,5}: Modify criteria for passing test
Date: Mon, 27 Jul 2026 17:13:36 -0400
Message-ID: <20260727211353.19736-5-ablagodarenko@thelustrecollective.com>
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

From: Joanne Chang <joannechien@google.com>

The two tests pass when a timestamp is not preserved after the remount,
because "cmp -s" does not print to the output file, and status is set to
0 regardless of the return value of cmp. So, use "diff" instead to
correctly fail the test and flag the error case in the output file.

Also, as the tests are focused on timestamps, don't print file contents
so the tests can still pass if only the file contents differ.

Signed-off-by: Joanne Chang <joannechien@google.com>
Reviewed-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 tests/generic/634 | 4 ++--
 tests/generic/635 | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/generic/634 b/tests/generic/634
index 8a4210a3..d7dd9dd8 100755
--- a/tests/generic/634
+++ b/tests/generic/634
@@ -52,7 +52,7 @@ touchme() {
 report() {
 	local files=($SCRATCH_MNT/t_*)
 	for file in "${files[@]}"; do
-		echo "${file}: $(cat "${file}")"
+		echo "${file}:"
 		TZ=UTC stat -c '%y %Y %n' "${file}"
 		test $test_statx -gt 0 && \
 			$XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
@@ -98,7 +98,7 @@ report > $tmp.after_remount
 cat $tmp.after_remount >> $seqres.full
 
 # Did they match?
-cmp -s $tmp.before_remount $tmp.after_remount
+diff $tmp.before_remount $tmp.after_remount
 
 # success, all done
 echo Silence is golden.
diff --git a/tests/generic/635 b/tests/generic/635
index 018b868c..f74d0cd7 100755
--- a/tests/generic/635
+++ b/tests/generic/635
@@ -55,7 +55,7 @@ touchme() {
 report() {
 	local files=($SCRATCH_MNT/t_*)
 	for file in "${files[@]}"; do
-		echo "${file}: $(cat "${file}")"
+		echo "${file}:"
 		TZ=UTC stat -c '%y %Y %n' "${file}"
 		test $test_statx -gt 0 && \
 			$XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
@@ -102,7 +102,7 @@ report > $tmp.after_crash
 cat $tmp.after_crash >> $seqres.full
 
 # Did they match?
-cmp -s $tmp.before_crash $tmp.after_crash
+diff $tmp.before_crash $tmp.after_crash
 
 # success, all done
 status=0
-- 
2.43.7

