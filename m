Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012071.outbound.protection.outlook.com [52.101.126.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D193B52F5;
	Wed, 27 May 2026 06:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779864683; cv=fail; b=KgmXGnHOv6937qs5BGZKzQi1KIqaogGDh8Q1Hh5IZuGpDC80GmzXkbYP3zmWBPDw/VkMgWM2L829aYJONU8gxym1/KMw3+Tynn9KxGTV0boFy8GggyVLtvuoGwhjIyCbRpQ8rpiMOV7ANk/u6HJ//J0j3JON8PhJsCwCSb9u55g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779864683; c=relaxed/simple;
	bh=vp+/QLv2S6gzA7vVGNFGcX83vGOlvOoqfzj9HxG4/hA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ewi7cdNQh4tGSoql7ggnnHspclEJZcWJZooV1vLvVMc8v9qv6x978JUUj+XBaRMr47equb6wyf8zqb9NDLA2n3IIBJYuHNAQryyeFDTZw4bwCFLXYZeI4zUnevsaFOBK8er5PPXEMAZzIc+yIT79C/13NXj9CTqBvo5JCQ4RtwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=GklJ09qR; arc=fail smtp.client-ip=52.101.126.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="GklJ09qR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zI0vfdNxxseHBH1FOpkT0AwepgC1QKux1EKbxXezJgd2AJ8Q0myN640XtaXTSYWKz16N8zoLKygrefVWIKUfkHnqICRZHBn0Hos/3ctxP8A4nz1/IZF6VIViKk5xEVNvLqqchBabJmVrnTK59MFfbYj8cgOnI7+xSSa1gK7SWordhWRIwsQomOJ/PYk6DH5CuGqZAoisfsLb7UC+jKdZzMYm0B2CkOWJVFaXG2Juow9qmAGeVIlnAcQQy0GjK5vK2I7NkyOpWla4TRTBpVkmvd3yiRZfeU73oLhxfcXjMMhbyeq+2B2s3O1Dqs8B1hmSBNqYLX6Qb3KN85BCm3GoVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAlUTGDButY5sViKyVH0uIlLYs9VN/oYy0iMIpzkDfA=;
 b=mfVQb5MvTB0kraixLkRbjbJn6IRkPkTfSL9fnVHJJhWwS/it9M89NNeBdqGhsDsjp0dgfqeFgDBSVWF1HaeGaapD73QquFdEjms2vWzo0WyNeNYp07vcE/PN2mzRbtTwZ/yPWgw+rbP/CeJboY7oFQBC58wQxA2FVVFIHHfmRwM+kPjMgDliY+Q469ZA/1NggZdJFySEuYpN+YEN4VmUOs+tt1JufJv/dRrhQnWbfoMAwqEBqpXBCVdE9e7Gr1sCG1DM/E0IOV5t/+TfsFtQC/GxAmpqKD/klNtTBcICpZ/qyIfN8iXNhDAFIzCNSp3bO2c+xIUjCIn2d0sj3AexlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAlUTGDButY5sViKyVH0uIlLYs9VN/oYy0iMIpzkDfA=;
 b=GklJ09qR2iNM5y/vWQ4A14/rbwlve72WfbczSVeezGX0GwDZnFRy/4YObct2x5tkn1Ll0jMiSrMwixZ2eshvq3XcTt6OCT3sAyPUxhzjCZt4NffD35WD/beHfovj16cTReCUow0FPruee00z0yFL7ASH8Awe+vaUbSwBpJfhE+JlFA3RR1p5fMdoBZCqqddlYijhBxga5sQlv8ilNqQtfKST6ZYolILndVPbFfoaOrwwy/AUtweZ6XlidJEF2nsSU3gGtTFVAemBeK7LoLHiXF5CcpmpX3W7RTid+7LoFeX38RL2IrfBQKM7Y2rlKUx3uYAhxD/RWzS7atsV6XK1Fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com (2603:1096:400:468::6)
 by KUYPR06MB8650.apcprd06.prod.outlook.com (2603:1096:d10:94::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Wed, 27 May
 2026 06:51:19 +0000
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e]) by TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 06:51:19 +0000
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
Subject: [PATCH 3/4] pipe: mark blocking pipe read and FIFO open sleeps as freezable
Date: Wed, 27 May 2026 14:49:11 +0800
Message-Id: <20260527064912.1038-4-daijunbing@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7e7e0c8c-6654-4ee1-9db4-08debbbc5b4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bkRS0Rzg7dZmQyCYTfH5AvDzyRaEm90Ow80gR8IuKI8AtzLjEpBc3SOBcKJl7kuRWeQApbjDPzycvnj7TjpAqBXws59GbrzDVUQ2P2A9Atv4Fdh00zA5ry3adnTD1D+ZHnSLsPpNIyJSH8+rQ7sGIL35JzxFx6K43MU+4wkhR0s37Z15iOC1gg3JzBWOy73yAcJlCLuvCxpaJ55GRADzQNVZKzEYgWLuyg5YWSgiNdb9SyEVN9ho31JIsc8LUWZQFCx3Sp/kQdNnAAz9IUModyYiDqstBIby5kRFixJWBuOZ3dQwKMnAa6ZbZp4YSSyyLtLtKDxBfwJO77dfoj3a4sKEM7jI4eORiyohGsHpOEnxREO+aRBHbdsOY6htTLocdY/0k1nCJ8m299d/8thOo+D6SFWfYS00I1JAUVzn+pnhdwhuzKTlbYPy+rdYqaJW4Kf17CeH+8jjDnr4Oe+zjL6Uc2U630YWCG/oSt9djgmtAiKRgW8MZRRoCjBdEkMpAaWsP2PPYUW/R3O2inTTx0L2oRegZlQsvmLhL4O1CRNmBGM76ZyFXwEbOuhtR+6PJ+Ca35Hf1Hem8uHAzzhgBNeFVz9RVvCQ3BHAGxRxAJkLPQp54Y8WCXTjsWETyuy/KRGpLnAGUFGm/cNuTaaIDVxFzYBwwuRr8CWf8bD46cHGaaCyFO0sfQWxdneog5C062fX2DpHj8Sidn6cuO9ZJCVa7DCEiaxCX9gMpErdUmNo7qTXk78SX8YxuB7yjVwe
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6921.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WVf0nchtv3SdAQjAJucI8swCXw7vrRie66/y+c/lCFXHmIDlADXDMe5eYHeJ?=
 =?us-ascii?Q?3+NfTuwRIhci/L+4gFf+vNQbmln6uGbMDm36y8W4XVW+eVyKc6UnlrCWGzIi?=
 =?us-ascii?Q?l19u+HnSL+FyTXh2n2Y6dXqa8vPC1GOMWGTb9cLt0RjEdLi45ldb0jTjz0OM?=
 =?us-ascii?Q?aDskrvPVnAP8GJPqbYwk3yomgEK5M5sd4v2ikaFnn8UpM36RCTqxWFcwT3gm?=
 =?us-ascii?Q?8j3gKipyQLLYF5Fkx1VQCXGMElJXXwr8GBMF21GIaJWEUEntX4euo6tr9Wtd?=
 =?us-ascii?Q?yxJ6OXFFrBm2w37q8FgDQihhUzVZT+pNIFNpSy9QLQeCVPgQvkVIp+5VA+sR?=
 =?us-ascii?Q?AFe+kNpIyFANEB/WVssp2/i+OgxUjJhPCA+62YRzO1ufr1/03K+5W9a4mpoU?=
 =?us-ascii?Q?G9i81exeotqwp/VUq5oMvCeWvHWaRurPyGPmlzK8T+uAzZJR3XeW0rtJ9boF?=
 =?us-ascii?Q?XNp7XJV4dFw0X2lQTIB6YMg69USkjDYjcGLfa/qw644Bk/5WbzrWzG6uimr+?=
 =?us-ascii?Q?24mK2PKWttlt/8PzBxIJ6NgrUo5R8gvttnDqTSZFVQB1KiCf3Jz2zihoNTsq?=
 =?us-ascii?Q?tJUlVUXdDhZtP8BDsezA0jvNZQALebDmiznukT1EW21itXhhE7V4dKOVm4La?=
 =?us-ascii?Q?mN6EEbL8Vr8tUETwELp4TULYNqg1A6WZ6S2r3fsyZR2VhJpUvW3kZjehHLfO?=
 =?us-ascii?Q?svckXIZKPw1DCPCMtDyLVKPP2oQOfqs7/dHWseDhPJmZqF4eUbY7NLSMqGSa?=
 =?us-ascii?Q?zqupTBQxQZaxGWCGb2O4KcfMg3MVwRLML4++Kpf1k4jFVTGSVwFEVJC2KDkr?=
 =?us-ascii?Q?QXSJB7GUGB/wwfH4mVjHzIZLxJdQIsFzBqbWyz1I5bICzwHOLvHoFgpyn57K?=
 =?us-ascii?Q?TqY0UkmogqJjFraohyufJ84vzHTq3ol4Yb/xjSVvddg2f1WfElOk56875Di8?=
 =?us-ascii?Q?y42Ej40xRNFqP9JDh3OQJAmbmhwma+V7uS+Ti8Lg7Hv1WoeaipBRF4RAd9wX?=
 =?us-ascii?Q?qUBVsuVbWhbY5asCuYKQzxnUIdIJCn1mzSHXh7/FhKKTUyvTHB3hLd+KY/zV?=
 =?us-ascii?Q?eQDNWDc86aO9lu1xQJCZxTMHMGmwEegKhz8azngWqfVvW/zXkmpBUiXL6jmH?=
 =?us-ascii?Q?fCC7ti5Ij/U1ZcYkdY3/S7Y+PiAX1D7G8Wh4XK/k0/r3yb33r9iCe5B/5ISI?=
 =?us-ascii?Q?7mUXcCVloGFt2K57o4h1mZqC3UYycZXLo8Aqi6CFAQEGmKLEkx6IXFVflflf?=
 =?us-ascii?Q?VcQt+k4s6mBbyZk6jjoe4gT0+zOFf/CmVHBaZbM7htizFpGaaiPY7sTcS5gJ?=
 =?us-ascii?Q?Y7Jd4TwogcNMIJKf1aTYhn2mtqAKX0efoXGBlrarTLcLAR3cO42ZD0rsPl1b?=
 =?us-ascii?Q?zQ9tb9gV13ex6dx5lJZ+VM1E4MLHyPYkZhJPQHOx2Dbk7sOa0HVC6th0cUyw?=
 =?us-ascii?Q?ydM6G/X1/EU7qeMnUV9cDYJ07T93Knme7NoyA6bvJanorpgBZevk3rzW4wS3?=
 =?us-ascii?Q?MRH4CZL1bQmDRkal9gDgAuL7EicXM+YCrXw18EHoXShKV68hY6g5fPFaNaXf?=
 =?us-ascii?Q?z/LGZ613WVLZVVYmbw2dCATTb5OunVodXp5o0BeKblyfn0c6zMyzTg2exOxt?=
 =?us-ascii?Q?nfcdffQ5kGR0T33zGHcJP7GvdJWAn7gMSOIDst9ZUWb2/cRhc3cMa7LTZ/Uv?=
 =?us-ascii?Q?2W9L+OGUTmyykfK8uyKiqx88TxTwOFSRdCg1UKENCt/YPQPiimcH6xF2TOCR?=
 =?us-ascii?Q?SSDPT+/7ig=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e7e0c8c-6654-4ee1-9db4-08debbbc5b4c
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6921.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 06:51:19.5291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snurn0WL/EYC/z1gCWZEOc/MKlCKMZo+m+otr6QBqj2dNUd5Z78XyTREQHmDstF9qlwdpC4gk/h3sevGGhlqNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR06MB8650

Tasks blocked in pipe read or FIFO open may be woken during suspend and
resume due to freezer state transitions. This can cause avoidable
activity in the suspend/resume path and add unnecessary overhead.

Mark these sleeps as freezable so they are not unnecessarily woken by
the freezer.

Signed-off-by: Dai Junbing <daijunbing@vivo.com>
---
 fs/pipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 9841648c9cf3..594726a7e542 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -385,7 +385,7 @@ anon_pipe_read(struct kiocb *iocb, struct iov_iter *to)
 		 * since we've done any required wakeups and there's no need
 		 * to mark anything accessed. And we've dropped the lock.
 		 */
-		if (wait_event_interruptible_exclusive(pipe->rd_wait, pipe_readable(pipe)) < 0)
+		if (wait_event_freezable_exclusive(pipe->rd_wait, pipe_readable(pipe)) < 0)
 			return -ERESTARTSYS;
 
 		wake_next_reader = true;
@@ -1102,7 +1102,7 @@ static int wait_for_partner(struct pipe_inode_info *pipe, unsigned int *cnt)
 	int cur = *cnt;
 
 	while (cur == *cnt) {
-		prepare_to_wait(&pipe->rd_wait, &rdwait, TASK_INTERRUPTIBLE);
+		prepare_to_wait(&pipe->rd_wait, &rdwait, TASK_INTERRUPTIBLE|TASK_FREEZABLE);
 		pipe_unlock(pipe);
 		schedule();
 		finish_wait(&pipe->rd_wait, &rdwait);
-- 
2.25.1

