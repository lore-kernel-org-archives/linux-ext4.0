Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012004.outbound.protection.outlook.com [52.101.126.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3B13B5851;
	Wed, 27 May 2026 06:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779864665; cv=fail; b=TBCJbZ8GpU1K7PWpmiXv/s0HIzOBsS8XkGAJbWdQeCx5AYTB0X84hFKNgWu7VbN/o/hseGNM8nwe8vet2QBUyfiZvEmFr1pvMpLqaDs2FC8bVhZwtPW7ghp8HZ9i1koHJJ/1X+JXoCO6yS0G0F07Uc8jH+5Aw4JQrRq32AYxFd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779864665; c=relaxed/simple;
	bh=xrJ9uhJMCUiGX7taKF4MCaVKgvcVavImNrVxgpJTukI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RHAHWGM7ScwdFmi7Af8O/heumC2v3VOjiEiyKLaQ6AFmBEymTGxuOcb/kC7w007/Ent3pPvNi8j5OYZoFRNhEItAM/M1xZeHyLjVPgtBjS3IVJWfGMMal2ljzKCjIx7hvDkhpr4SV/Y72EY3xtTh7JiaetqifnZ72cmEqrFm8ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=j7+uoOE0; arc=fail smtp.client-ip=52.101.126.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="j7+uoOE0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R6bdu709STHHFjKyWvFowTnzW7fRWsqon1dEo7QJui34k+PgLOncFv/JLx8XGOwofCwPuTYrheMi35w4wFLCTzWYwo8jvlu+M1VIuXBqtTanU1tuUklJw59KbN7dtj9boTajDu7Eb55x18lp+bijnZut6dQR4Z6w3F5IANYS/lsIre50OQBf6ZAWLiz5J1K2/r8X3GPmaNN0dKGOeeK4NO0nfqt8M5604O5lYCqITCLEP6IJJaY4R/77jBvci+CruPnVzsvUjHrIVm59jAhpRtka79biO40lcE0GT8JBXiaFcFaLglzRyQBx9hDUJYq1Y4xBYJ2PVHcPW+PvKimqNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDh8j95W8ajnKk1otdBiOD18GWehQjzSiz1ceZSDgHg=;
 b=njzp3pLpiP0wZaDWS7dmhbVAJq3Z9udukKD8i2UaQwmRZIZrhr/X3ya83DN/RGoJq/nDUOpMhK4mMJOM7f7qYrczpLm3g84UNc5y05Pxekai6jqW+QRYEe767SGjAoCSNw/yeteP6Y3bdd6DVmicIvWAZwkdKITJINem4pFI7tgHO1dDY6F0UbxmffEiaekiZWbKLN4IOpCKgdFe+tPOl9DEjc2dQARyyRTN1yVpo7drUtnW5IEAHZZt5pxGq0MqFi0A4bAfSrHVMKDPQJUP/NbrQFYcZagrJNy3qEeoNdi3cTqTJ2RgK3Ue1Bikc5OdBiNCfgt/L81kL/Y95lH7+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDh8j95W8ajnKk1otdBiOD18GWehQjzSiz1ceZSDgHg=;
 b=j7+uoOE0J76+BAthsu01HTBrrP6df8wM4dd68eMoGpAgHeqtD3BS9hp9t5NZNXORUTfSFIH3X+k4vAfYOfWBnjq0Ag8ONBp2X9bN6aEwIrWhhGkbZJMFFgAUHYpPYTZ/LdBOSYmxOlr04jL/khXJ8lnu1bLUvK1lmxuGd4hRK3aSinlZLNATHlIX37A7jnuu6YO1KVEQE8dK6yiD5BiKOomrhZXFXqvrXesqbxZRPEuTqlHlSrbpuHGI8Oh++e+n7WXQCZ4/7pzwkkNgh/eptoEc4yaaHTjd/y7GOabJdV2zBA0MWdzO6oGQDVBYzSgxNLNNHwX+3+vxEakVj5L5Kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com (2603:1096:400:468::6)
 by KUYPR06MB8650.apcprd06.prod.outlook.com (2603:1096:d10:94::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Wed, 27 May
 2026 06:51:00 +0000
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e]) by TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 06:51:00 +0000
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
Subject: [PATCH 1/4] eventpoll: mark ep_poll() sleep as freezable
Date: Wed, 27 May 2026 14:49:09 +0800
Message-Id: <20260527064912.1038-2-daijunbing@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0c8301e4-d9a4-445f-d8ad-08debbbc5002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IXk5/p54E1BhKdqFBob+jCmMyowrQvKLp+UBv6Bk0cWKDonTUj/ZBShSWQKhwSUunnuH1/Dm53upVf92qgrrNuynUXyBb7j4qhZIVF86jcihK4DNqSkAHCUNJoJiJv1qn9dij1P+SuuMRHkMzlOQ6tK6PPYvmEC5mUAY778kcdqtooP7oSYgDFDL4Y6iG8s1yO3NmT+pdZcJNkQ55NjbEp6GTrrAUx3w8/k4zuFlwNl0HjrEjFArW3IiPp92UsfYIuNDkSXRQc5sgDT+/I+atDLUyd438ypZMxd202l6uDaQjlwXUEsHIIHik0BF9gqgaZ0r6HmIjz2EyOqUBuIzxgeFl8OokmROkLuOB0qLb5fTd/MjrWz/beaYM5LNtCC8wYVu2yKl1Zl4IRyHxoGUK6CpM5oAfHvS7toYnoN2bme7u4FCNpkYbxxJ/4z1P7OkRM2527vBTCTMOPHbRgUv+Ol5CP8yPNEUOO4GqHnuJwR4H1mLEdarScWDReSP4URrUyPlP15a5FvwR/dtzROw8bDRyNM+2ZvBpaR9JFRzhVu3Rrp7UgCAQN7HCA6fH/IL1RZqDcS0pG1a3M5JjxXaYRLrVg9XHPR5QruQV01t31keAHPbSCYYFtEqFUjb+mCtiuyiJzepJFLTlO2bCx1Qe1HW588hsoDnY8Tj2OANj+0MwO0il1qJ0/psqhPu7YoxnnhPBYqtEFiyHuA+IzXFUwKyqGvKfav8B9K0IKrIwxsLTqzGLjWqcOe28HlbGUXS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6921.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hQAPSl4wT+ztM8iUIaz9k5ylN9taPtZIBtllPiRj/0IKHYhCbmm6cMX3PFB5?=
 =?us-ascii?Q?QOSqt+JaRsWmzKiVfXIWAQSn9bTyDHnXsTnrG76WFJGBkERVhWtZXYeVd8z0?=
 =?us-ascii?Q?5MyV687BXuHx/obc4NOOSz71O9zhJ1hqqRvtkEBRSTYoxiIOShnqQQXKR0EI?=
 =?us-ascii?Q?/w8FVcVH3Pwcksw9jiPjUGD2aQCd9VaBbimZqmrMHZ/8wwh8WtrjhPq8BXHy?=
 =?us-ascii?Q?F4givQuNA6QNIgOy0CT2hQi395DsMZ3GVkkp6+JDc3PnPrsdVtmReCnC0fv/?=
 =?us-ascii?Q?kFIqFO4LLtlrPiPLLvXFwvksJZ6eUBaVHIG98+2IpojRkYeaFzsF+V/469MM?=
 =?us-ascii?Q?7bxmQOKSTPJIgxKmbxeXc75ISc7mDpvO9oFZk+3VuSu2vwceXrkfLWEXtTPJ?=
 =?us-ascii?Q?Xs/4A8VFcypBnXNQK1tFHtcgEzvO6CTLcxPprFdUZVZiBbOa/wZsX2t8pB7C?=
 =?us-ascii?Q?FWNIH3lZf+VjCqePs4+aTfpcxAlUMKbRoCFtNT5TotLVVV88L2ftOaUjyLfO?=
 =?us-ascii?Q?RcYnXYILGOUGaehh1mPOm8H2PdKZPHzPNZrLTVqHZQki/dMUAlzzIEiD5s9F?=
 =?us-ascii?Q?SN+Dmyx2cQmFpXQ18uDCoMoisFdHLCRYwUkjopiP2Ak+3zsaW2r40wH9T7tK?=
 =?us-ascii?Q?5iYHFIQY1L68oLl/8O7Pa5Xz2O1MukRkZMlhKbgsK0zAO40NyXdgz8oq503Q?=
 =?us-ascii?Q?7UWFu9MucTK7SQ+82lfwGVTyv8RZa8BLOPmW1v/tchUQZYQio0LWw24IN7E8?=
 =?us-ascii?Q?9xfG05Z6au3NBXCBgpZGbdGkr+dgmHe+/4tviwyz7ng04m9XTzf1cFfnvp1M?=
 =?us-ascii?Q?PO62kQ1G6DzzDMRPyX67Iar33F02D+aFfSGdZt9mricK6vbzc9Ogj4sT9iz6?=
 =?us-ascii?Q?Xiqwd/j3lQ56xPRkpXZpOlWLSsoRDj2uGj9CTR0Ein8FQLjO8abK0lUPdur7?=
 =?us-ascii?Q?SwSuCNerR/XYLJamV6Qwtdr2InTRreLQGakgd7dtBaLN7QXRpKaUzBFOKY45?=
 =?us-ascii?Q?x/jsgAvyhCHsQREjHLLkvwctlKEgC8WZK1WVafFdt8E6Saep0WIEf/Qdwwmw?=
 =?us-ascii?Q?xmH2J+dk/aTzawW8TIE1X+hOPwJvLjNwFuGQwMGJ3mf9qwKO7FQ2HGgewHbz?=
 =?us-ascii?Q?LF9HMV2QxdMqTdGl/IgsSASApC52XVICN5/LqccrxAopnYQX1cDYyfwjvoZT?=
 =?us-ascii?Q?G8w8WnDL30SEn1Nq9dh2VZnW3PS+0CspLpgiqPYdd/CdMzszpc5W0/1npOYa?=
 =?us-ascii?Q?xYSgAvU8IvKSQYtaQF6kK9LvV0DNUmyQvGJqiwOUg4CbhxKPYnJCK7GUa2zX?=
 =?us-ascii?Q?+urwll/6NXQri2MFEn0Huxs0TQadTZ/Tji/w+OtnE6lI/NGbZT0XTRBoNwRP?=
 =?us-ascii?Q?vDcc/w/SevzwVzBkJvhSxVWZ8sihfMTRTvNTbN7FVXit5KwZUlPSmKAOFYPl?=
 =?us-ascii?Q?q5yN2RC1/xZYUfzAxUpVoXyrRnZDFaz1I/bnKAEOTEDt5LHVjDmro2n9ccg1?=
 =?us-ascii?Q?sGoN/FYIUn6dbJWD+eXyJb7oAoQ09pHWlbU9oJ9vyLjFewg7bzUivygkILQj?=
 =?us-ascii?Q?rjbdp+EfjIuyyHjCZfjmhGVd+3YwU1glFCM7tjAXTfgow00LZFmmgLMOXxf4?=
 =?us-ascii?Q?iPvBYNp+LgnWsZCCIJw/WfIeoR0RACQmQFMc46QHV5vcW4ljzbzR32OsXOJn?=
 =?us-ascii?Q?x47Mkc5rUg7U6ebMYqjAnGogbZlR3RywlLHRcb+h4VxrqJ7LX2YfjXYzZ/Th?=
 =?us-ascii?Q?jHqWgEW8fg=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c8301e4-d9a4-445f-d8ad-08debbbc5002
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6921.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 06:51:00.6601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2/sS102ijEBFtP0VhCtcvFjO0I3Z4OV6uvi/6qNbs5b2KKEujUMNQDjs6UF/ZpWTc85faVTMQ7QuNC8QcFABQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR06MB8650

Tasks blocked in epoll_wait() may be woken during suspend and resume due
to freezer state transitions. This can cause avoidable activity in the
suspend/resume path and add unnecessary power overhead.

Mark the sleep in ep_poll() as freezable so tasks waiting in
epoll_wait()-related paths are not unnecessarily woken by the freezer.

ep_poll() is only used from epoll_wait()-related system call paths, and
the task does not sleep while holding locks that would make freezing
unsafe. This makes the wait state safe to mark as freezable.

Signed-off-by: Dai Junbing <daijunbing@vivo.com>
---
 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a3090b446af1..64987b64d72b 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2010,7 +2010,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 * the same lock on wakeup ep_poll_callback() side, so it
 		 * is safe to avoid an explicit barrier.
 		 */
-		__set_current_state(TASK_INTERRUPTIBLE);
+		__set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE);
 
 		/*
 		 * Do the final check under the lock. ep_start/done_scan()
-- 
2.25.1

