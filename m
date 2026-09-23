Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A3148164E
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 10:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790158683; cv=none; b=sVUntrdAp1jDfUnyWItDrUXqQHmuT3bfY9MI9XXgSaEG2vB9llmGDYrCUyD9rJNjrYwUHwIXhsWdQ0sCFThEzwKOnDX6xocZDEkR80cjX0fU08dy/8yXFAgs61OJR+43MaupgYKNm8a7enhpahKnYdjXMB55YBNObZ3mzptZozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790158683; c=relaxed/simple;
	bh=j03sZsAiUvQIWf0jJkQ8lodG5xlqOi+mxICSn6nPAYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RYkiOcCZCKB0bRW2URjDJ33+Xy+2bNGFP00PzoeJrHstaZ5CA2FrIOOmkSfHjTqNqdiCpHZ97cIku7XtaeA3A3+Jz50w/rJJyEpJDBXPpcDS2ecIUhZAMPHyudwh3UECVPBWMt1YFDAOkUxC0slUNsF9EdK/uYkxHYVzJDz2cdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JBJB5WrC; arc=none smtp.client-ip=74.125.229.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBJB5WrC"
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-32ba4885063so469447eec.0
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 03:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790158673; x=1790763473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lGxDKD+CJZrAsT1dgSz2oPzw16PzysgXcSlu2MtEwHg=;
        b=JBJB5WrCRnU7oJhMvPxNQEBiJZZeJpBQTNU+M1MggBvNPmzeSzI187nV/mmRctuxs2
         9hDSk3Bpj3T2cdHhdp+swdhPkswPZcGmQ0JsHhy1L6Zfpuq+IVIDDwBPsDjRExLJXe4g
         rO1cNXx7Vrj4hAARpgou3t/G2znfUhwbekunfHVr/5G7jcB86Az5/zXtC4+7N0u+NWqr
         Vn1l21Q2kMtT56+I4lArjUJAMW88kdY9BMx/jO6lHdH2dCdUT1Au+VASgh5dM4c7nBhx
         UDFXyFoOF9TW5pJmT58DbEqRIHcOfqoQZCUlTVJHJ1xm0lZLwxPmPA+iZLxyKY4ffsyP
         wirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790158673; x=1790763473;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lGxDKD+CJZrAsT1dgSz2oPzw16PzysgXcSlu2MtEwHg=;
        b=AJkp64eZTh2ZcDLnd7C8F2vuFhafxBgOsID+isL0aXHK7wDiBqoOAS5X15DIXVKVOH
         hp6eXmssFzW2TbCmGEnY7jpXN6lrdS79G7TAiABeXnyCutwvstSAyhJYDCtT9S+N2QaW
         ag/b2Xf+gX40ZfG0nPswnktHvMw9/yvkE7Ke/HBwjpRLrRyCYF9vypj0UOrzpmqoIIsZ
         BRF1dHyPlKW7khjLTc9rxMnAO+WAen3BAX18+2JleeTieN2szPjOufx/LcTg0FhuR140
         PeHtMfn1zJmpoEQD/c2rLkylE+OuDB58gv5R/EtprMRyYdqHdoE+weCjigxhO/dT1PEr
         Jv0g==
X-Forwarded-Encrypted: i=1; AKwUvBz1YstPioE+h6FgoEuhlgg1AC7Yf1w4L/ZQSpG/bxD78X3+eISGqRO8wzYtYRqTAHOzITIsgH+Mb0Eu@vger.kernel.org
X-Gm-Message-State: AFuF++k4fkaSBNXZiF93UY5cEKo25KYVA1ZCRV/n/knkghCghRNn/k2X
	J20wIYMeAHW0M0LKu5od/kPzz10h2dELD75JqM8Fv6UhmZo2xqggf0os
X-Gm-Gg: AYBFou0EQpQ4zpj+gqevXXLt40gBoO8XGz5xhbFNSvsQLz0vffrTyVnjrtW1G1rOvaj
	jaywnhsdmXplokgti2282+G+pRmJs92JLVMrzd8PVfCBUir+UDYvB51qrzE5uFWsYSiSy3wGO9O
	EM2L0F4r3hTfxEbX5ZxXCrefmZI4SZy4n3a44Nveq9+CruT8r8fSh0CZaZSrQE77pTNFq5VGmBl
	2GZOk1dt75B4dMcR7UxE87f5tHUGN1O2SxW/SLBiDgwUqpV7PXezm9kTnyM5eYvxlD7cfQFsILd
	frZIpYbjCe/xXrH7IrEjUEBwROSY1+flheLdBKPruTHLcGkmDw0A6jwApxZlv9+kEwgw+Rb5Han
	AO1Tl6tavPvShQoL4cajX+SNDtbDIaenRNSL4RNz/dbYOkY4bNaOV18C3H+a6pkJOWuR0TmwocM
	uUBm2vnT9vmsotWHeyr5U0jjnV6FnrSZFJ4MesQrZ8wi4QbVvThcuCTGxcH/vh3sUepYRiLfBE5
	dj6BEeW9nkm/GsdN8eT9poI7LjXKh/HDfI/cQkp8N/eUk5836hd+oc2t6XrDT31tnMnk5UeQeLR
	uiwx2JvclLgRoprmHwqlTqWG87WLF6uWMN6QiXSKqF6EgWbOpLmNDCZfb7VGbPi4iqGBxGQA
X-Received: by 2002:a05:693c:6385:20b0:33b:d69b:370b with SMTP id 5a478bee46e88-33e8c057dc7mr1980290eec.11.1790158672907;
        Wed, 23 Sep 2026 03:17:52 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96e498f0sm5118459eec.27.2026.09.23.03.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 03:17:52 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	Matthias Goergens <matthias.goergens@gmail.com>
Subject: [PATCH] MAINTAINERS: name the ext4 dev branch
Date: Wed, 23 Sep 2026 18:17:49 +0800
Message-ID: <20260923101749.3505886-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ext4 T: entry names the repository without a branch, so tools that
default to the repository's HEAD select master, which still points at a
merge from October 2020 (96485e446260).  Development happens on dev,
which is also the branch linux-next merges.  Name it.

The Sashiko review bot, for one, falls back to HEAD this way and has
been reviewing ext4 patches against that tree.  Its review of an EA
inode refcount fix reported a Critical double decrement and an
undefined function after applying the patch to that stale baseline;
neither holds on dev.

Link: https://lore.kernel.org/all/20260916072420.316321F000FF@smtp.kernel.org/
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 806bd2d80d153..8ed6ae20c2523 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9791,7 +9791,7 @@ L:	linux-ext4@vger.kernel.org
 S:	Maintained
 W:	http://ext4.wiki.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
 F:	Documentation/filesystems/ext4/
 F:	fs/ext4/
 F:	include/trace/events/ext4.h

base-commit: 9091c97be34083587a75db174aab51551d8e8543
-- 
2.55.0

