Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5215B3DD86F;
	Mon, 12 Oct 2026 23:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846782; cv=none; b=fN8UmGKL2Dtrt8yETH0BKAOn6JT2NoAdJIwFe6Up7ldJ2SC28q37I4Yh4hyVMqhZ5Nor8ffgyie1GSElQn+ZCX7AoKNHER56Jd22jmnIUfBs0RMhAZMPY/XMZZhxshYsQTSEqREXUUdA7g5o/yqx5bYWc67Gg2CgdDAyikCr5qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846782; c=relaxed/simple;
	bh=KBarmi3a08G4A5QTm2gVQJu5AbvjN3tnu+jv5niTBZg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F9TUyPejmWLYeMPup1NSb4mzTAfoULe6Sl+gdUk85NLqZ0zX/WkvcanavTBeiEfpHcbfWjlQODqDXHLDnpugwVWRvcU9wuDJV6pi+cs1EG1Kop+3WRk4CIQYHMJ7JxGt8u8ngD7VXsFTD9dSUEPXWfY9otGQp+OW18PS75iQkno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLU8ptYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLU8ptYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350C71F008A2;
	Mon, 12 Oct 2026 23:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846781;
	bh=r9w5xFEDeccQ47vP477trny12Pd+huBwgn1v7orpAsY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OLU8ptYhVNfohvxox2473eyA6jS8ELdzbiNoextu/5iNtFcGXZmF4emv7zM/IpCW+
	 IEDLbKfdq01Owux8vlojyxgZoAau4Uj17R+o9P/C/PHOetp31R8NHAQjlNP8ymY61t
	 W5/H0uSPS1RvbkmvMDzW4AFcW0W6amIyNPSDhyZOpkRByTl0weWc2nE5vdXWV/3IeB
	 XQYq6rLNjev2zH35VQzD5KpmCl/rQe/ttPZImU1dlstHnA6s1mcPwXqRJk98QpgY8p
	 j6IiwSpFo8eEgx5N2hfSU/4X6/eT23PKEPD9znNaX9pH/GEbCQlqf/Kms1WgZ0xjCv
	 +18NlP8JNk+FQ==
From: Mark <broonie@kernel.org>
Date: Tue, 13 Oct 2026 00:10:19 +0100
Subject: [PATCH 9/9] ASoC: wm_adsp: Give the firmware search order KUnit
 cases distinct names
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-kunit-param-names-v1-9-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
In-Reply-To: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
To: Simon Trimmer <simont@opensource.cirrus.com>, 
 Charles Keepax <ckeepax@opensource.cirrus.com>, 
 Richard Fitzgerald <rf@opensource.cirrus.com>, 
 Brendan Higgins <brendan.higgins@linux.dev>, David Gow <david@davidgow.net>, 
 Rae Moar <raemoar63@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, David Rhodes <david.rhodes@cirrus.com>, 
 Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
 Takashi Iwai <tiwai@suse.com>
Cc: patches@opensource.cirrus.com, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-sound@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2481; i=broonie@kernel.org;
 h=from:subject:message-id; bh=KBarmi3a08G4A5QTm2gVQJu5AbvjN3tnu+jv5niTBZg=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZlpv3iXAahQ+7VaXQcb2yrkavoG7T/SvD3I0OqB5m
 +eCav+1jlIWBjEuBlkxRZa4LO6X9SWv1/AdXNgGM4eVCWQIAxenAExkJgPD/zo2O265SE7/wxd3
 bXQ9qxhrsk/5UblIcqtMtKxQCtM9PYZ/dnt2GkrJT5k/Q7mrxf5u64Rd76temNzxsrU74F9T2q3
 MBwA=
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The wm-adsp-fw-find suite runs wm_adsp_fw_find_test_search_order()
against six different sets of parameters by listing it six times with
KUNIT_CASE_PARAM(), which names each case after the function. All six
cases are therefore called wm_adsp_fw_find_test_search_order, which
makes the results ambiguous.

Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
also named for the parameter generator it is run with, for example
wm_adsp_fw_find_test_search_order-wm_adsp_fw_find_full_search_gen_params.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/codecs/wm_adsp_fw_find_test.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp_fw_find_test.c b/sound/soc/codecs/wm_adsp_fw_find_test.c
index ae686dc4fa94..0b2b7db3f9f9 100644
--- a/sound/soc/codecs/wm_adsp_fw_find_test.c
+++ b/sound/soc/codecs/wm_adsp_fw_find_test.c
@@ -1219,23 +1219,23 @@ KUNIT_ARRAY_PARAM(wm_adsp_fw_find_pick,
 		  wm_adsp_fw_find_test_param_desc);
 
 static struct kunit_case wm_adsp_fw_find_test_cases[] = {
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_full_search_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_full_search_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_system_alsaname_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_system_alsaname_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_system_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_system_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_alsaname_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_alsaname_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_noqual_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_noqual_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_normalization_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_normalization_gen_params),
 
 	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_pick_file,
 			 wm_adsp_fw_find_pick_gen_params),

-- 
2.47.3

