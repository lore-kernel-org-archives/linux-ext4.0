Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71BE306746
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 03:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781149972; cv=fail; b=Y+ANWAZxVlIlZJw6J4koXuKH48hunFtGXRYPm/NKlireqbVOcPZgMApJnF/hmKJAJd8xDV5TuKAzAq34/Ixp4da7+KeOD2KSzAGq0LCxIx1SG1pYeXTub1oUPZk5kdBTSCSs60/tDasvEdwZ0Jlr252j3yHMy3hLFzTw6NTKaVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781149972; c=relaxed/simple;
	bh=aW4si3xwx6VWWxjvrvlpBzM7qz6xnkgyJPRrT+yNd0c=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=J9isZyXqOUaC3/Hg4XYzM1Vha4mmyqA+idlnso3fsVug6ro8zrZ1q0R0U/D6kp2K2BC3OFXopbAdbrBrBOx1MPHlhx1XqZfeJaoDjT/chfA9WE39atSDNiYQWDhwa/UFSJ22RnLyDusu5Dtfp1MajzcIw83H2Bfquoqkqj6hBRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=pi6wDx4R; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="pi6wDx4R"
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023101.outbound.protection.outlook.com [40.107.201.101]) by mx-outbound14-37.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 11 Jun 2026 03:52:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y1v4HdT+Mh4fDEtLtEfC6uW90mR7odAODMqOcMIS/USzyELC/rRTln/elGotu2irGkYrQVbx2+ir0WZa1JorSt/ow1G97/xiG8bifxRlcUm+kuAa0zMiQAqlvOin0pYvxBG/sFZ1MdELbViN0ZSR7YQBJ0KCrshKZUnt4DdzTK4fYSQ4n2r4JsMUO4yhk47njP7behd9Tqh32V85r8YJNFsYsnrCNrpzXTpP60S4sm7bx671ytM/z7tmZ7yxBv7P7ITBcTh8bpGEElL0Gm8MmKRaEAaQbkM1b5Evt9eqqqKBTG07aHVDgMlImp4bEKfv4m9ohiXao2f587Xnr81Yow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rNkD1MMnS7m0V5uHfcAiZX3wnstU9HVNIUo9gSdrns=;
 b=RHhmQjxZM5s9D5jEAebynpOhYl6O8zV4BDFUUVcIhg6oMgynjQ2pD0p9pJPALJjEWgBMe+DAmHY8MLhi0Rb2xHDB6gAgIFgKe7YMSOlvjfS465S+4mzxy22SFqtmpI1dLROJgRQXlN2e8P+/Z3nFqd4u/8fUoPM65y5kUya3Uz5TD/zF9NU2jLhPriAo/IUD3fdB5YEB7+Mvb7gAkI/tCuQ6zXjaridQs5xXH/OiM14A1Y6BJJ7pYWk0UlPbBBxzOVWm4E4TNdC5HRn28KzjiYik1pKnvB5v1Gbrx2lTSaIQvET0hUgmwl4yBDSNgJ+ggbGB68nLdFzX4p9oUYLedw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rNkD1MMnS7m0V5uHfcAiZX3wnstU9HVNIUo9gSdrns=;
 b=pi6wDx4Rpqmnl2KYiD3stuRQ8Wy5PUXg0/909OxSFwaTALkFOPcDCvxqPfW4jLGwrJ90d+AuJY6auhNs3Sd9Ao7jc1hexPFuLyDdSpUqTPcJtLGDp/N9tRxZPI9X2bCvZACU7pB6Tn5IqFGiemEdVkyJffag7zYa7CUAxW4bgqc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from IA0PPF371656EDC.namprd19.prod.outlook.com
 (2603:10b6:20f:fc04::c9b) by SN7PR19MB7522.namprd19.prod.outlook.com
 (2603:10b6:806:34b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Thu, 11 Jun
 2026 03:52:41 +0000
Received: from IA0PPF371656EDC.namprd19.prod.outlook.com
 ([fe80::3f20:60a7:54cc:4d11]) by IA0PPF371656EDC.namprd19.prod.outlook.com
 ([fe80::3f20:60a7:54cc:4d11%5]) with mapi id 15.21.0092.011; Thu, 11 Jun 2026
 03:52:41 +0000
From: Li Dongyang <dongyangli@ddn.com>
To: linux-ext4@vger.kernel.org
Cc: adilger@thelustrecollective.com
Subject: [PATCH][e2fsprogs] build: use correct subst variable
Date: Thu, 11 Jun 2026 13:52:36 +1000
Message-ID: <20260611035236.307622-1-dongyangli@ddn.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY0PR01CA0014.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::17) To IA0PPF371656EDC.namprd19.prod.outlook.com
 (2603:10b6:20f:fc04::c9b)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF371656EDC:EE_|SN7PR19MB7522:EE_
X-MS-Office365-Filtering-Correlation-Id: 05fd59d4-950d-44f3-187a-08dec76ce2ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|19092799006|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	qq5pxRh+brmXSaT9NXJ9td8g9Ii3jUUBpC5GaNW8K5aZ4/Cz5ovVsi/6PaZ8MnI3s8Z1xj6m+7BEm7IgSAOqhdEYgoUtdj3m/kcEmQB2NutwL3yi22s49qKDsak6cydVsiDKOa+bJOW6eb1rn9LicYq2n9DmLgJELefpTRprRIO9Kj0xVCWRN6xN9IT5AHWrT7erRHSYqgHgw+SrDsGn0TrwxE5NPSO9VK4Bfwkdl6VH4kylh868A6YkguHlBVnRHEooD+WLTi1CyUmHaTrcMM+T6+S8ksgmt9wqEuPVlRZK4qoNRzRepfQRFg9wNcuZA7/0WHryGCrQO1+vVQXSQYOiUt5xB+ND7vfw3lG6ItlUNKvA/Oi6L2UHciYA6nvYUejiNgRvwuRikNGm6m6C4NbkUixJVfBEmdqh2AQh+sRT47EvQUZYyynlblTXzXPWvONVv9vFBiXP8wNrU/SIT+zOk7uNA2td1MU+fHXPyHSyVt6VJY4a/iMyGPZMClasqeQFdoFhkn0UGHGMU+Y7AUt3hf25lAOU007kAU6wA1VFvUZyC17RnnVlrk9jNWoAnKxhToReimiYqHVNMRGWCZSAtY1q/bhyOSohYpckLGbCkd2e1mqCH92mMdA4db4TT+DAKq48VGvURrxmfUgBMW/+gPNUgJRpK6j9mPIWZXhmG3n/KiBVmuL+AolyKAPA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF371656EDC.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(19092799006)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S5ZZgg5ngvcTq0UMvKFMwD6Iell9aJm/Qb0E76ngCEKO9+qPlKrN4PnLib5F?=
 =?us-ascii?Q?QJyo4aSv9iPHlyiX3ZoIE6Ddwp1kcpnf36BoP93SMqTU8LMOJDHwP8I8/A7X?=
 =?us-ascii?Q?xFPJc6sAs7iSKn6go/fjT8koSW+DLCsLiQoyDhrgv81nIVO8kjP1ieMGbgh4?=
 =?us-ascii?Q?LyUMAKEYp6+TrOXAAahkrDxR0gu55iLAJQwXIpKAj3ibH4W9TuNuD4FmTdpx?=
 =?us-ascii?Q?fKxt6aBmvMZhm1F/nkCk0W+kFT88RE3Esn5mCPT6sF5AjQ3dWp4Q7tzMsRq7?=
 =?us-ascii?Q?7hWvy9zONz9JqSR8TRZjhaup3MAjRxk5ghB5FkgxS1wb+s4DTiJO4cv2lSqD?=
 =?us-ascii?Q?h9OmrMC3kJVnD1kqm9h9K6ppNvxjXBOEoTIHOvpMjj/pjINSm9n9D2EPuUUH?=
 =?us-ascii?Q?psLdmr92COVd30bh4gwVFchSQVYJpdrwQloi/4R5nfbv2tfMtrOeyILzGytv?=
 =?us-ascii?Q?Ls8Lhd1zavxf1MyTA7/S4ru0G6tx1ZnN1/jUzvFHs+TOr420//6QgWuL1SG4?=
 =?us-ascii?Q?GhW6GQSTQbF57RiUXMil8eq2FMMLdkr6g97Tm3Z6GztVqtaK+igULV2JZNFY?=
 =?us-ascii?Q?nxwtNKAIROU1LTeIipyiUMv0etDnUfYUJoCpCPty7nL9nVS24nI5kuRpbutD?=
 =?us-ascii?Q?gwItKQzUXZUrUgUH4fFWquWpKJSDlhqqwZ4T9Qvxg55VBTF0GQmVKnQuJQrd?=
 =?us-ascii?Q?U7uPwDwI2sc12GgeFOGtcbcXi41Eg2PAC1mFJQjRjXiZHHhwiLwaGxVY6/du?=
 =?us-ascii?Q?QfmRNHwEAxRu2+sAg981Qj7eRTp72TvXJg/dDoPUV1djAJjkYr3BMGLiNpSh?=
 =?us-ascii?Q?kuNaBNkO8uNkfD/gQbq8cHKP4n/VADSDmQWv8AxFKMQFn459vHU4PZL9C4hD?=
 =?us-ascii?Q?bzfVwmGi++qY0y9Z6sEQzNvg+iCrJD5iZByChBPgiS6OXiii6Ns8BCjJqxX1?=
 =?us-ascii?Q?rsfARRgme2Rb1eL3MRHMGEifxux3fmsE+sEtGNqtXYbN7UYZF4WoF6zhL9Er?=
 =?us-ascii?Q?YmUbPtB69tKneS7KT6CRzg6ZULyj1h7KT8A2IUs4yTzGhDiApgSvfvVOX+BE?=
 =?us-ascii?Q?JSxVYpD906ci5do+omJhKFDNBe+66fjvPsPLrfI+Dxp+mXMOb6OJQHUbHALr?=
 =?us-ascii?Q?HQqg7Ejqg1vlrUYLoHYq2CuRkFL1sOkVFDHUH2f62Q6/hGmxQbG2PAeJpMo5?=
 =?us-ascii?Q?1Zb2HahRshjCRWPkXfeKYXBlCUY5x+ZIQw+zZ8BKG1CglxS+dkXxDttqvRwh?=
 =?us-ascii?Q?Tr7PD4ekRBO9h+pEZ2ODKacyciJSDXF6+Ud1KxEX2yws2owskv1U+5ZduQ0q?=
 =?us-ascii?Q?4zBJ1MlK+/H/atWH89tbxWf2hksOp74yPc6/eEV5zqGicAd6OXKLPxY6JqGj?=
 =?us-ascii?Q?b7mvbhou2yBke24UpP5pVCJpwcvi6Yn3HpdqzqhCt+XadeIsU/CvMB20eBks?=
 =?us-ascii?Q?qd67Pn8Av5IjIFvLAwFoZt13prnAysqo3UhbzlrvIIzghRQwZHM3ztPWTfDB?=
 =?us-ascii?Q?6PqIX1IQOnIIV2BEO6hsBNw5mpJOHlTaMrpBnAQnootUuS8JIzh6i4R8IS4z?=
 =?us-ascii?Q?mMPItwCG+g84I1WSZF5/PZiOXXZgCnvfLR02C8vxQOFsKh2oKqSDE/WfW9ek?=
 =?us-ascii?Q?of+v44zDJ1X7UlriYI2raCS9rbHY+Jc1reeA3zziIiajaI5N+qVV2WSDlXXg?=
 =?us-ascii?Q?YXVVcT34eSuo6KKIqINoSPyCJarTijMRIsgigqqSIG4JD++P?=
X-Exchange-RoutingPolicyChecked:
	rKxCs/VFB18i5BGB5yfieudcRgR/INfLz64ogOtWhyO25Q92CsTwpuHGcquFZNBGlVRDFIkdxS/JpBz4GQSkPHyfsAtJ1wewQ8tJ3s4EyT/W27bsHzCWL6AmPrukF/+p8Y6KugL5MNbnffYJxoIFi/jLoEGOrhRQA1ahiGFJOp964sf7/23O55sQKSfoUJL8eOKBwjG0Y0mwbPWtzbKDPsqDUQAo6s5DrPLwrAF7wHMhzqcOPUg8x1G0B5KpAV65AN4Qnq1d7h3KbX/GzY4BYguKsd529JSpzjZVnyynVa4Jj879/z54t7KYX3iomzwzI2aqNJ8QRpQ2NaYwk9cPLw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s3LxophpuUE+2O3eTsLGfZhqAg8iiMdO0HM6fVf4KNH1xfj+trbFa2KTZHXpIrySAGxV0YHFJhuYwS1czN1w8iHmFzZ7UltYoJBJMItkNYH9cZAOKJbm+E7cMoPzou2nLiG/SQPU7Frg8gJKTTXZak8yp8bTyhFwYqXxBjVb7npiU1tWLj/5EFeAER/CL58nAEOSg9SSwX0pBcUNB5qyy15yzAYjMEMCjjOQYAJptrPUPy88XMXnxvXpddEqJBkDj9Igx5vNOnM2Q5dJIRwwyeS6DmjdFjySFCa5hMybYoxVx3QZYf6Pl0pXqQQpmRLKkRgfyM5LjJQMRNHAL4PDP6ssKY2faUiVAUkRBSC0xkf+KSJ3tGt56E8C22XQqd2IpA1CvsrfMy/erqBrFmEvN0Encs8FoAzw5kJdeVBPN5JRwHWlX2LibdsP3ZlD3rP2MwUkKIqCRXY70AiiwAxuLgC/SFc8YTujh1x+VQQxQfMP/0+wGyXofCyFy4hotLdUosgkPydiR9KwDo3KDP7/Dn6+iFG7WEvmPUeL+/X8HbQfu4BXPw8AHdlX12GbGr+aQ2wFGIU+l6emOpEQMIW61aONYK08+WYrgsoXnOY3+YoEaUbQgwXuTQFeVcRlw0AbLH9BeHo2hEQKOmhfS8NfAA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05fd59d4-950d-44f3-187a-08dec76ce2ff
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF371656EDC.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 03:52:41.5235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +YA4i306rDCu7w/vuWVc3FRUL6j36J0RIW6zhh8OhgWaCKyxUkWGygxKFpCDs4EO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB7522
X-BESS-ID: 1781149963-103621-32040-57333-1
X-BESS-VER: 2019.1_20260610.1855
X-BESS-Apparent-Source-IP: 40.107.201.101
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGphZAVgZQ0NQwJTXR2DAxJc
	0gJcnQxMggOTE1LRXESko2SkoxVqqNBQAI+52QQQAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.273840 [from 
	cloudscan13-23.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

ifNotGNUmake was changed to ifnGNUmake but test/Makefile.in still uses
the old variable name.
make fullcheck fails on some platforms:
make[2]: Entering directory `/var/lib/jenkins/workspace/e2fsprogs-reviews/arch/x86_64/distro/el7/_topdir/BUILD/e2fsprogs-1.47.4/tests'
Makefile:387: *** missing separator.  Stop.
make[2]: Leaving directory `/var/lib/jenkins/workspace/e2fsprogs-reviews/arch/x86_64/distro/el7/_topdir/BUILD/e2fsprogs-1.47.4/tests'
make[1]: *** [fullcheck-recursive] Error 1

Fixes: b7d1ab3376 "Update configure/configure.ac/aclocal.m4 to use autoconf 2.72"
Change-Id: Iec3cacfca7206bf785381664b7d7bded8c70113c
Signed-off-by: Li Dongyang <dongyangli@ddn.com>
---
 tests/Makefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/Makefile.in b/tests/Makefile.in
index 678cc3268c..8f7a072f45 100644
--- a/tests/Makefile.in
+++ b/tests/Makefile.in
@@ -48,7 +48,7 @@ test_data.tmp: $(srcdir)/scripts/gen-test-data
 always_run:
 
 @ifGNUmake@TESTS=$(wildcard $(srcdir)/[a-z]_*)
-@ifNotGNUmake@TESTS != echo $(srcdir)/[a-z]_*
+@ifnGNUmake@TESTS != echo $(srcdir)/[a-z]_*
 
 SKIP_SLOW_TESTS=--skip-slow-tests
 
-- 
2.52.0

