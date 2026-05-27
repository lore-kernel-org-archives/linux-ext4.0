Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013045.outbound.protection.outlook.com [52.101.127.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F30B30569E;
	Wed, 27 May 2026 06:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779864679; cv=fail; b=iKFzBR9DTDIXtUUZzrlXcPKzSky7El/iEMHNc5q2FL8Y0CFfGcWCmXld9D9LVglfKGRRJHhOkEtaHtfHW14zwJKW0KWW7Fzoef3cPLzvYfTw4M/e3UY10hlEe9qAmo9pSiKexE+a2CXstqrlF+xVO+Unntu5UOLTW4Z4+Ty85dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779864679; c=relaxed/simple;
	bh=l5BKPiWrNiJKiRdjv8WHiBbH6gDVUK1P0vmOdf1P7pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uYZKasxFaAcQy39ShouclAN5Q+mEnYjOjcEnyjwiKxwomNkHIYI0R03QDqJLPMBeFbkE0tOLM9nFzdSI0qJh33dP/C6zQCM6+y3QHwjYvq/fKohpY/HJw8r9SPGh+frSxc7XYeGgGw3EyThvVmYlLmbC1HDRdX1BPdT9W2ptcOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=WMWpzdLZ; arc=fail smtp.client-ip=52.101.127.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="WMWpzdLZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADqSITFhtA8V3eb/bSu2jkIW+LXNBm/Yc59u6dup0lWV+nzJs8PDb6D5MonjaPBpEc+KpSqjaNZ39tmiK1UIPbYAnkgTvNGr5zK52xkzUWu019mfRv79G+g3QXxr4u2UJmQKy+ZJ2UROs3sx64QxIhEaRoH8M37NRaqkhT1jiQ3hkXA77UVY0QVL9aurt0SxF+Q2rDY+GKV7nNRgR3pUGpyeawllpJAZ4LK5waUtJ5afeRYFJHP9uC2C+95wy/RdQuPlHl2bMvd+PUcvh4MmPMbdA94cUx0lphMT+cWZetKiZBGC56KkVfMD2Dawh7hpQ3HSbBs55+cNIVhUmNtPcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDx4pTVpFP6yAGM1ePvRv1kZXv9B8P/3z4LIUvLJmYo=;
 b=NXNsPxkO2TDiVksdO/Qnd3zsrA79sUn+jH52Kp0mT3q+wTKbEuNM/BXFYED+FUCUNL+kZ+1XD990yKuHfy450TXI/m7a8is9TWFovqtKbrbOk+SMfV0FwSuPCi8vl2zhzPQ0rnBbpwc+yzysN1BeWoAtuZ+qi53UB7p78E9i7jpAP+uN4MNjg5B/nwUKQ+Y4R6X2ima7O6yD/Z7MM+yDOv7howtaZOYDqjqhIwiaDfmbTtjnbX5YH76xSq4JxLGrvZ2eCTomQMhRMdlV4e2I070+Fbj9vocdHGdUAZXAgnV1USV0GH4CCHesWROG3mwMzMXkABP9LfWnpQ+90D95cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDx4pTVpFP6yAGM1ePvRv1kZXv9B8P/3z4LIUvLJmYo=;
 b=WMWpzdLZ4szMR/UG7ok557LLokbcKULyZUe4zCXUJli1hcTBbY29MhEf0a2u4Xzdami9OGJQb85yV524D4QVnQBLMsp9ukZnYrYbpOpLBHp2JTfS0wqo/4rKHFCgspJinQQhSJetCC9TpHCl+YZAZ/LlTQZ9sfabcB/vp+urtVAHYXCxif4KJN70teuttOat/UdaztEic+YKRL31F/WBUMUIn4ff6o8XPYYRv4O4wCU0+l54Bo2d5XMDU70lcmT5GSbv5XSvBjCn+6GpM/I13UJSOMqKxstZXK6mPHBFHM/OMVeSJhduFaNZh3Mv98uKSbrngHE5K8nrvHuWDypslQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com (2603:1096:400:468::6)
 by KUYPR06MB8650.apcprd06.prod.outlook.com (2603:1096:d10:94::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Wed, 27 May
 2026 06:51:15 +0000
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e]) by TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 06:51:15 +0000
From: Dai Junbing <daijunbing@vivo.com>
To: linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	tytso@mit.edu,
	jack@suse.com,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz,
	linux-kernel@vger.kernel.org,
	Dai Junbing <daijunbing@vivo.com>
Subject: [PATCH 2/4] jbd2: make kjournald2 commit wait freezable
Date: Wed, 27 May 2026 14:49:10 +0800
Message-Id: <20260527064912.1038-3-daijunbing@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260527064912.1038-1-daijunbing@vivo.com>
References: <20260527064912.1038-1-daijunbing@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0014.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::17) To TYSPR06MB6921.apcprd06.prod.outlook.com
 (2603:1096:400:468::6)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6921:EE_|KUYPR06MB8650:EE_
X-MS-Office365-Filtering-Correlation-Id: 2df32647-f555-4db4-f9f8-08debbbc58ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XfiC3UZO2vC+nGKieYLr8mRQdVGmIusfVO1mWXoMI5iNc+Vl4Yrzj5e6hwPNiv2rYg+zQqM5yrhjstFoAXz8crd4uKtZVppFUb40jzZw94jqewViqSVOSM6/eGLXNFIYl3NeH06JDTzuhZFzpkL7/6yn4/7kkGcoDQQcVq6d5pRe3iLuMC9LeQLP24DAHbTOs8IK8ocrMi6SCQLHT2cTHACkC2hPy3/Nde+XSpz8YmA3cxPMPqNeNagmN5j+zn2AR7HWp7UGAvlooRvNe+TUS5QP2QXXqOruBxKqKo3TO1NB6sDX9qKdmTl7EWZIZ4kth7AIbLJHomMEvxAZkL6+Gr8codl82B7Y6eKCFuoXYS4XB+iuKCmKI3Bt6CcRXfSLSRI0S3O6/gp9o4eGi8YaSub0/5L2HpDZPejuKnO5yBkXFKHtb8LIvUbmOaMIOqzEUXgAxhzPhW+Bs+vvhSK+OgKSwtSZJbe6MFDNkE7lUeKFymKb3pmpGP4VBjK7mLcEs2QKSO1GyV5cgEFBEIE7f4a7nb19q0jNUMja+dTVuO9EDuUp6SkJKz8/xRY/N4Vhu2nJmpO5rXuhpdpvDEcIaUueMSrlMpkVFMWe0wUWQN9TtEbrnKF2w8W8snBRvc0D9aaxkxiqEKNoRyZp1nmjkW5Qyp93JkW0TaBQuWakikWKU4N17gqpA+aiA9Z2lwHizUJYSsJm/N3SQ+mhBt8vkQElT3JTeV/oPFvrenG2aTkdWbE50KeOATyY3cDtrAtL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6921.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6/hWY7WDLoT+9oXRIi4RAm0FkSNGzLCWkXLFRS9ipF0+iXLymX5hVxprtp0B?=
 =?us-ascii?Q?8eHKB4WN90Za1jhYmqFt6HRDq8XMQxUzQ2dZUunDL/Uin9QkmgcyhC2+fFE0?=
 =?us-ascii?Q?L6OkO1v1TyqnpgbKG7RzhyezmdDi0+99H5u4DL5QMDVeOlohSnyHRCYApAjq?=
 =?us-ascii?Q?KoZcT+H04+whG/B0+1kw3Ns9ueXxANK81T5Wncv2oq4zxkdA2w7VvXjWom54?=
 =?us-ascii?Q?gR/gKct3hBMOTKRjYYs/FRu/IDjK9OcW0GYNWgKsjl6dLFxsBjfrrBPx2LnJ?=
 =?us-ascii?Q?keans0RcLe1A2BJTSwx/fJQCcNvlb73Ldpfp4ZvP5n1i7HXhZp2gb/fpz615?=
 =?us-ascii?Q?CoGleBc35uA/eGCO9WTsDGWQ4/g1CNt/dNeDhTire3crvxy07TQGcxY5qkeQ?=
 =?us-ascii?Q?yZt6jWv5lGHZDnhunDPDiRWN5l6dxPcXSuryMft2aObaWTTZrFPAdYDhowGy?=
 =?us-ascii?Q?YptnRavho9wYWQNf0Yh5DSWDRFVpgWzsD5/tLBUtRzVHd+AVIWEzXYHHHUHQ?=
 =?us-ascii?Q?5Ee9Qb4KIj6FAY8xPs0oDETUu1Cmysh4cEx4+Y2JG8t/lVIOsDcrxdjzs5Qn?=
 =?us-ascii?Q?lfs7qjDsWHIAFMnp31uEO7zEvIJdH734pATQY5TNEcH3k44VtolGWxVt3mQh?=
 =?us-ascii?Q?y2LNv/AjCGCEocfnBy9Sk5C49WCaWTBwW/4JpreJNqe39sLQO218Tb/2kl+H?=
 =?us-ascii?Q?e0uFw0wr8BwvpQmfeMyIWwwgbYPGE05IFKB29R0WGW/CuaoA7LYj1MKHeNu5?=
 =?us-ascii?Q?fPG9h2j20sCnJXUA6E+THFN3y1Ex0aXq8PjBzd74beHujLzk/aifDILlDWo0?=
 =?us-ascii?Q?wJtcfgGRX1sMtpnyGHlCTWz/Pfdx5LZLbBLzWXXIFVS4ETXF76AYspkD1lde?=
 =?us-ascii?Q?G/DQsTokFjPbmFhzuNsr3vc55Ql8ZKqyqLutoHx4CsWUGf0zpDzvKu/Njz3O?=
 =?us-ascii?Q?PeaLnnXJyTNpc9cMbyYei6yGbKktX3HfEc6YOUCJQL0N07GVNrxuNv4ztezj?=
 =?us-ascii?Q?QnMAQpT4h8Twb+vceR6gNkeNDry6TUAVtq/1wviVwaJU512qy0DDTLq4K9Ol?=
 =?us-ascii?Q?mduhkJQU0sNaMz38UxOWD8wH33NGvDx1bQaQUdIo+nsq5KozcrYvZbLszvp9?=
 =?us-ascii?Q?hz+QO+SYqKkOPPfo7JzyFxmwY8xTh+PCA7cXyzicXfCGG7QMQO52w0woez5C?=
 =?us-ascii?Q?ur/QIsFjQZJCWpI6VoXRNwfKLHzdNdqDJh7bAdzZ5O7IYFlnlhe4wayFMjyg?=
 =?us-ascii?Q?+B9uPXS1vape2oFHV7ZTlsB69JNuVMo8+T8kAaTLz9s2nbyVhQZzEFJrmAt+?=
 =?us-ascii?Q?2JnteD2AaDsL1VbFrF05pU9Z0bbJB8X/qt6n0Sg5YBgP/m2oVk5Wcv2Xml1V?=
 =?us-ascii?Q?0fnYV2Epp0BNCuxwlF6QFazaAzdd3F/ggpVBM88f0vRXkRVQTXdhKzSO7rjL?=
 =?us-ascii?Q?5rmeCNDyzgo5IqSAQ556Bn6W+A8ebJevo84Kf+ZEfQGlaRyNMt2tv+3/Ttnh?=
 =?us-ascii?Q?CmMXqsn57kY17cWnjNehwB0TIfJmXT02Lc/dKstz621cdi1czeJ/4ILGlCLO?=
 =?us-ascii?Q?IyhbCxcRd2a7Z6F4GTQ69q1jVwj3628P5vKRcqc340wkfR2/imcQVQaCWdP6?=
 =?us-ascii?Q?qLIi5XvMu3jjEdaCQwp7mxD7/RbKMyAsfvQEVNoba0HkUnDgz1i/ewLLkW1e?=
 =?us-ascii?Q?jon+tQ9rhsKfcVnnHg9gFArh84ls1HpTwH7/BFJvUy5sDgKHjueGa9bMDAli?=
 =?us-ascii?Q?YUbvn9qv/g=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df32647-f555-4db4-f9f8-08debbbc58ee
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6921.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 06:51:15.5839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mVCm1wEBFYKKt90U5oxNxhFxIwf1eeHxSF1PLYaXiubLSvAcyAtyMbG+PMrgiUHnDOWtX9EBvxvTQ4Z4nJg5zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR06MB8650

While waiting for commit work, kjournald2 may be woken during suspend
and resume due to freezer state transitions. This causes avoidable CPU
activity in the suspend/resume path and adds unnecessary power overhead.

Make the commit wait freezable so the thread is not unnecessarily woken
by the freezer during suspend/resume.

Signed-off-by: Dai Junbing <daijunbing@vivo.com>
---
 fs/jbd2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4f397fcdb13c..d7ffe60c8793 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -222,7 +222,7 @@ static int kjournald2(void *arg)
 		DEFINE_WAIT(wait);
 
 		prepare_to_wait(&journal->j_wait_commit, &wait,
-				TASK_INTERRUPTIBLE);
+				TASK_INTERRUPTIBLE|TASK_FREEZABLE);
 		transaction = journal->j_running_transaction;
 		if (transaction == NULL ||
 		    time_before(jiffies, transaction->t_expires)) {
-- 
2.25.1

