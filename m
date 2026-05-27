Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013035.outbound.protection.outlook.com [40.107.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF663B5847;
	Wed, 27 May 2026 06:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779864687; cv=fail; b=TR39JRlgzXzlGVnlEalZ/s+JhhI/K4P1LTGWryp14WlbZMkTi7QDQuciheOzu9s/ohAOtoBhHWtqB9OG3qZGj/2RtCl+c8vbZRI90kJbi4sSJ744uvjFYzh3S6h93KuBY/i35LIT9odRyCE0ehQIhijvBz8LxU1qVetbwwon//o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779864687; c=relaxed/simple;
	bh=MS9o8mKqrzoeCWd76HpQWZL769+uFvIcRFa4Jdqb8Rc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uG/ngdVp+cWxmeIRkif7hGrY4Z0e4WEDUfaQdaozgXkHi0aXVJfTI5PUaS6Pgg5cB2c01C6EiXw2uqzPJCmAZFpBlVsyL+TnmWV5DZR+IogXKomESsn3HaRN1vM2Xn6QGQVN1cd4Pp4q5RjtbxjGHqZ6oYqyQWV1UrP+GMjQo6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=PrqPdoET; arc=fail smtp.client-ip=40.107.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="PrqPdoET"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rW4aSPlJSHdRrFLQuNmrCmcIeg2u51FiuDYlSk6D1cAQWUZNLb0Bds37h/cCxSE490fUpjtCqpRSfWGzgLwA6bvhtYVjUtrjnwyppQIFusyCMN4hjF7uOPwN2zMktt3htSu0TNBSd3w1IfWWJ3c+3Asw1DBvDQ5zYDFPsfnk56P9Yxp2E6zQ3KjRlKNPa09rz6b7bdcnjo7Pxlx1jCalzQXnf0Yw7hVhGhbkwLVH387aPvSn92P1xgBYJTzaewKZ4DgzmKD5P7S3cntdMMjdEHaJvdAgUDzhtHDswBLE3j2oYU/HNHVhvAVebkzXtPvaD0FJ2FQwKM0lwvYgeFhiLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RRMWAAfpolngd6+rdMSMtZj7lkvSVVXT/zFplYNfYg=;
 b=c6t/HDh7bf/DCKjgAnC0y7zORqYeVbOw6i6UGfXtKeKztUDCz5/XLzSMSLZFZr7crTxqYw7UVowmRqcqHnY/sOj4petzDGPoGeP5KXWjobTHi4CiRNKmHXNrxvxPdQ0zuRJNh8VHEnP/ThacZEJx+EFdCvPx4TgwW5VunutUe3vQ6xlDuOtQ/Q9APtJTkOx7KQHcJ4OhkBz3SL4KJx95aYfKCUwXEfzaMpcy8yWPxpU+Mq7JssjJMKWpim2960dNYprOIhnaTRdUs9wyfEkAc0/ym4IUz/fjnKdAEzuwmfmgDCN8P8bRr9KtuWD0SYDs/O48uNXiO0KqURYrmrltDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RRMWAAfpolngd6+rdMSMtZj7lkvSVVXT/zFplYNfYg=;
 b=PrqPdoETZfgNP3JxwxfcMjvQscUbtAH9sycR2Rr9yTQ1GE8dnvX+fslCGoGja/kpWNZ5kiBUYrz5rqtnv3Nx8Rny04+YwFGIz1LBSSpMZADP9a8eSPY9neLVoNNlGrsULK12uI+njw1qpMXRovAoygczw/dT/jZlGHM9c3bEoWiII00z42UrOoJmkHMlogDP05v4A8iSG7rXg3VAIN0avo8IXiJ6eTaD6y7CZ1Wx/X/uh40nWslclTHyfOG355YKKh8xrAy+1iYLqH5G4wa26cmiAsvtYsEnCGCEMVWVZA6VybdptACC2ZNVuFlLrXquplILdMKJtlcjJwnpXADaxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com (2603:1096:400:468::6)
 by KUYPR06MB8650.apcprd06.prod.outlook.com (2603:1096:d10:94::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Wed, 27 May
 2026 06:51:23 +0000
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e]) by TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 06:51:23 +0000
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
Subject: [PATCH 4/4] select: make select() and poll() waits freezable
Date: Wed, 27 May 2026 14:49:12 +0800
Message-Id: <20260527064912.1038-5-daijunbing@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 45f992d1-5a56-48b9-ae06-08debbbc5d6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	M3rBHC7rCpRwpBD5fL7vFo1IZ3XBhBjgdBEUolVV7p+KD0C6pcFOIyIpeipgr6oA7lLZvB5Bmx1B1NxlyJCKtGMI/bcHve8JTpCr86OCyGzvkJlP+8HStv9g/d2rqu1KsfnPwpUlHSwUsuRPfjvSeBV7Huzm6p88XzZ1b+7fkj5HMHpIEYK6fZUkDFm0UfJ5/g1umwVkMxAAKRaO/a8KccoMjCzff/RjDXNXa1vEcvb0THlC88HvHvq9iQuYWxpg4lsc+/Yj15RUm6vmoRrJyTTRQWDFQgXc/KR1xkz3d0Xmvcn/jAhPWt9ppBcxSOHp7QaxUXATq/GP1oOsT81ChDuzifKPmxTJ0bpd3Nnwk609KToIEEx8uJ+jSZL2oXe82FQCFY0CjX4paUPmJ8xMTp+XTd/w/IvUWTYilXE96OidlqsgWAcnq9NJut9o/9biCHeH0xnh16VRhYD7CQCACqnllN/zivAyNNEbBxYFniD7t0phBaS0e/2bhIl61EZdE9+o85UKCcAAgA9Vnwy+85moRCYN9e2AeUKnAjfvxbw4iC4/tx0Gcd9TKjrTIUD8JIFwRoggjC4iXuq2Tx4Oi5NyKrpb2OcvZE1ua1RfMYIKVeqfe3+trwK9hnVsu+BvurniWm+9iZTb/nC8c0BvMwz8vM57Uy5LB92qVlWlZoyirmXs84+ZxurD5vVPBN7Di6Qqgi57gy44EbJmwaWDpIzPUZH1qnJMT06Cp5a28glsxiicb1bwoGIDs8uHgMnl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6921.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r4m53Br+aVzDe4d3bRYx/TqSlbug46VxfUcMCKb3QhV5h5HEzaOoYy3djQ7M?=
 =?us-ascii?Q?KEbzKNjRLqJI7OQUG+NTdXxYFA0CZqGCEFXHj4VGkwdBeAh3ovSjEiEsScUV?=
 =?us-ascii?Q?CJX7mUSjseHHNSasg48DBsHnzgOY29TmbCxRCOSBIUXH1vgupSAqpue97CkS?=
 =?us-ascii?Q?qetkDJDmt1X8x/vYFwp/PZUB7DoM+puWPgrp/XkQZGLNFTaxFcOBZgHoa+bT?=
 =?us-ascii?Q?80JVr0H+8CaITEnvgLgG+TiMqjA5JNDF6j8kgaq3JJHF67qnvb/1DPIXRmXT?=
 =?us-ascii?Q?ZNO6KPlyVv1HP+IpP6gkd7EDRyKegeKpIqm6NkfQgGXY7vKBWUteB0Wjafpq?=
 =?us-ascii?Q?M6/p8ySw+tobX7yjvAgLV1TqxUaeLyvkIelSAaTAq1e1vsE8wmwHgLgji8hB?=
 =?us-ascii?Q?fnZvf3Ki8HZVGDaoKJhLuD+r2c0So4qzER5p5EvRg0vNbAXJzwSsav5SBzdL?=
 =?us-ascii?Q?31op0UJx5c7QNFZ+HwCMXRNj+9W4MiuyB9vtq25zL15xyshx3/2XOysZjGwu?=
 =?us-ascii?Q?yIinPufpGhTpPu2iRR9EDM2wh7HoI0dimlGbtIyFZJmuKMATzuhhXigu4a7g?=
 =?us-ascii?Q?uT34Xv5Cwl9DcBChQWuHZprVbLXruwL8OGxnV3fzjvfoRc/aVaHGl8rT/MrY?=
 =?us-ascii?Q?PDD9+cPn9kp+W1k0pfIOGqxKJ39q+j0TkdIWPmuEZ3pf7tYG06GETUGDB5xr?=
 =?us-ascii?Q?y5J1v+e48IEy69MG4YBRdYP2Uc+o6bFJ9RTSPrAUTVCDXPXNoZlVASIL27da?=
 =?us-ascii?Q?blfWOcs0et1gFVx75zPNsLOC/ZIuPaRa8RyOqkhWO948CBo2vEY9afTQZer9?=
 =?us-ascii?Q?b4BgvpkUJTTM1QdRiz1THjvUcJ/B/4ljOXwF8kCjiyGpxtY06EpXJXA/2xM+?=
 =?us-ascii?Q?rrO/3VKpV69tbA/Eloe6aiw1gEIm+VM++XMxZHCdF9ugWVhFj1X42DuoWSK8?=
 =?us-ascii?Q?lzNozrFkybYuhVFLQc07y6fqQokfIPzbHC/x73zDbsDXLy4/wugIrGX1NOtK?=
 =?us-ascii?Q?UnLtaaS0LSqq6WrujYWAFVrt0vPiqn8OSLDDujWaYSxyFTupsMd48izKzWLV?=
 =?us-ascii?Q?2o312Bu1gHNANFxOaOx17Ka09/Hm6FFjtztDNEUynAidIbjzhWritPYx7u5+?=
 =?us-ascii?Q?sbwHTEblxSB7enxGPkq4UXyG4GxnaFAuUB0aHfC+FImSvf2getiPFkRP7/uf?=
 =?us-ascii?Q?PN7bAfu3Iy3b14uvArokivY0KT3gj7KbrvGpBZV3iyvozc+mbDqMYsR0iWUV?=
 =?us-ascii?Q?hmXeQZGX6nWSahP0lDxD0VFc10+7l38WXVuaLX7XfJ3x596ZIuhEnMIj4iAN?=
 =?us-ascii?Q?sWzuZ0hL2o1IWOM2lz5W7WesoRHWctzlrA3CPl5+goxp+1aTeMHPLvDN8bXM?=
 =?us-ascii?Q?vs4YXHL6kPjX77zHGSQzr+tHh7Zfw/vPzGdaUk3hxvrU993nFJbJpEY9tsiQ?=
 =?us-ascii?Q?BaaN3hdIruL2n+2+Jh7sKYgZ5vhXQ3OSEshIgwDRE5MbkkDe4wZw+tIj9LDG?=
 =?us-ascii?Q?MjJ2ZL5W7/gHQ/WM/KdmKMy63Qw04R8jEX89fw3eiBAt6O37bnu76ICHraf5?=
 =?us-ascii?Q?zsOqOR6BUgEth1effcRnyKmqH08BT3fcv0WhTp7DrgLuUfxaks6D+IFE9CA3?=
 =?us-ascii?Q?QJFvvqPkMkaHD7xTAiHaS3wLd5pNd12ZB+F3fGnNj7IASvW3Y81DJZMk3C9s?=
 =?us-ascii?Q?Yimg3WChaYUDZM96k/81EifvaN7U4AVpY7C+nQPhDguryMem8SBTrQmCktQe?=
 =?us-ascii?Q?9N0SP973gw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f992d1-5a56-48b9-ae06-08debbbc5d6e
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6921.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 06:51:23.1563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2sdfyzlyPyJhrDvKneI5+CzUBtkN/wGVq9seYaPTC16uqkBbNt5blNdoF91W+debB8ljLC4jeDa2Fc1NPhj/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR06MB8650

Tasks blocked in select() or poll() may be woken during suspend and
resume due to freezer state transitions. This can cause avoidable
activity in the suspend/resume path and add unnecessary overhead.

Mark the waits in do_select() and do_poll() as freezable so these tasks
are not unnecessarily woken by the freezer.

Both functions are only used from their respective system call paths,
where the task sleeps without holding locks that would make freezing
unsafe.

Signed-off-by: Dai Junbing <daijunbing@vivo.com>
---
 fs/select.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index bf71c9838dfe..b0b279748355 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -600,7 +600,7 @@ static noinline_for_stack int do_select(int n, fd_set_bits *fds, struct timespec
 			to = &expire;
 		}
 
-		if (!poll_schedule_timeout(&table, TASK_INTERRUPTIBLE,
+		if (!poll_schedule_timeout(&table, TASK_INTERRUPTIBLE|TASK_FREEZABLE,
 					   to, slack))
 			timed_out = 1;
 	}
@@ -962,7 +962,7 @@ static int do_poll(struct poll_list *list, struct poll_wqueues *wait,
 			to = &expire;
 		}
 
-		if (!poll_schedule_timeout(wait, TASK_INTERRUPTIBLE, to, slack))
+		if (!poll_schedule_timeout(wait, TASK_INTERRUPTIBLE|TASK_FREEZABLE, to, slack))
 			timed_out = 1;
 	}
 	return count;
-- 
2.25.1

