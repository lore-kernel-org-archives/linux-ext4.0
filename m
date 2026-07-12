Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021103.outbound.protection.outlook.com [40.107.208.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC363655D4;
	Sun, 12 Jul 2026 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875447; cv=fail; b=rkNejG+wTm0MybFErH0l/qB/L9ObC0rKgKVL5wzNfL+yjeLnIVyjB81aGRdQBJKQhTvOfeAhc81BWFGZTYio/H8TVu5tEp/ULHmchR8PcJodVsOzqUNpOyPrPpg+UOuIC04iV8oo25jeiaZqSfr4kxis3M8XM5dki/CogvAjuBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875447; c=relaxed/simple;
	bh=fC7/UjpUBETYpcNwgSUH/OIoKeGj5zNm5XGDJIx7sFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cgy3YXmGUAI7bjc2k7b1WSavBqhk+9HuHNJ30qjYnPBvdTIYVYqR8kSpB6/FnMP7YZhl8gnFL9oxPuuXUP03zuFtQn35OsAQiFnj5OGmyt8BCsYyE7AmrMXTIy4QiFbHzYPHKdgMrFV7NP9WzZugSBm5B5KjTybzCUoPz87s7b8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=gnVM8ZEM; arc=fail smtp.client-ip=40.107.208.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="gnVM8ZEM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ys/PFojuK3IcvHYxic/i1aC2nqZP9b5ucF2ivanqCjH0EvOMRIbYSFuT9BrwDgXhEVToUqzKqjDI6nJudiUifEDbP4FthBzx+mz5epZ4qDaLpsFikAUvfj6ie9rDEtqrnsnY7JfyJnSUlvPuEvJMLPXFpndUrQl5U11OpMRN2ZiMTdT0UNdlpnpcy6JyTM51OQOp9Aa54tPWliZTXmR0kyUg1hn9Yg4hO6dFYDPYGZ1QpwrZNoXvGxBtZ158uH1JG0Jl7n2V3swsVKY4yozQjpRYkD+75/9yTHw+upe68xVbB9yW4Oq4MTa9idINGRj9xswtVzjy/pcvPvnPO484bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXYZbtylJ0maHI/y3r5JjLHzVcaXwYFwSUY9PbIPyFs=;
 b=Jdd+Bpgu8eN2vU32jahocMYiWIX4kX+XoLFjR5tlgIR7BIoHleGf5xpJosTBLctnqsDaXBUjM0pTCjY2s5e6cEuAXtosptG9skh5g288JV8puTQcTNmaFwiMZBPg4dCpofttu92kP1ZeWu77nfVqAq57yxfTVhMdwaZ2kVkH6NXoZ62zODxM6YRUVuAVxXhDx9ors3H072J84tDdhPSW1vCqFOlZam//gIjJPOfAGS7S+S5c+eVQwfMoP1f1AHfWABJ61MoroE3pQtZoYktMH8+l3C7uugtwaffWEIhbgW8HoFIzeMTfGqRG1mLSEc9hQRBE2qQpVAg6gPmQuS+2Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXYZbtylJ0maHI/y3r5JjLHzVcaXwYFwSUY9PbIPyFs=;
 b=gnVM8ZEMmh2+CLZwa9ZhfHEWZ+7ODFQC6pn1Bkj1+BPzaaq3CR2zk+KPXMYDSjTBsCxAPKoEKH4Jrnym8tNTji+Vc/7SMcYC5qIPsVAATZ2aIIm47f1aiEaFsQFyfJy06DTw6OzPlgsidfZ+UFYl1wDDOo1xvOGy3G+nwIrseAPCs+EU1NewMmQ6F9A7AKxWdfadhxwFW/P64Qzh+Psx7uzU//4eC3Wf2Ap+IRBMc6aHmJZ/HPhtWiT6JHP2KYzLrTqxIWDzwKMmodBjOKKiwKW+UZBJhUABx4DSofQmqHPx2tf7H7En9umkMfWGBwF/tqp9wlcg4Gd7DUTaUiLavg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7488.namprd04.prod.outlook.com (2603:10b6:a03:329::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 16:57:19 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 16:57:19 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context analysis warning
Date: Sun, 12 Jul 2026 12:56:02 -0400
Message-Id: <20260712165610.366474-2-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260712165610.366474-1-timday@thelustrecollective.com>
References: <20260712165610.366474-1-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:208:237::31) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|SJ0PR04MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b5d7773-4dcd-413d-c27d-08dee036a293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JWILGKLJ1YuvyUJZyp1mk2aGy2NWPSdX27ZAPsy+vZMGjbbg0mdpDzSeuideBpzf31xw1SJDvw1Xvim2FcQxlyE0twclHn+wc5pc9OsxpF3xtaGbu0f6zmGYXXGK6BufUSBjricofyNpQsRnzV9KtB0pqvdfCb/m+lOMMshaDmZbETQYC29rcQa89FfemJAhRhJJ6T7V2PnFhB9cgXR1Wt/F8PKcVcFI7nCocK8AxUuN2HFFrAHexfEMBg445gYjpF7LDOntqdUNvXiYAatyM7Y+HFeiyHUFoqMuksJTx+2o+0JAyUj636BLxEICopOzi4n94p4GaT/p3PIBlRNrToHJrs0pJ2jHt3Q0zRY/d9kTZT/SVHurXM4Ad0LWmDGWWKAwmZFRLGnSpwT89n2k46YxZUprrIM6Z6yEFpcyaRZ7r+1qlhaD9+6mwk73u3wh/NbvehttDxYN24EYovGHof6Rd4vTWhl9WVg/h9/YXP9lX4g+Gkr3UDT7lmcnt7EpjxjFNoJT1kxsKsi4J/2tgXfJt0qz6qb8aEHlNWoL1UjWpnajb5JKIHcpMscfM8DndC8qU/8SSXO57b1vC1MK/mu/T+7AdU5eD4tQAtW9PfHBzIWUsJvSduieKU/DpR3AgIlCFnxKOIPtzYZ7DqDRn4CirSIsX6QkTIn7+OH2/Dc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O6AVV1RFk4f5WGcXIcmu3tMOc0OPi9Ysp8JnseDlTt4TPejSwiFHLbdgBNiP?=
 =?us-ascii?Q?J4/RAilvxhSDO+SmKHT6P2ICCyzlu7QQdhlVCfjSDbwJdafk7NAUeb4INM8L?=
 =?us-ascii?Q?jghGdUe1wIm/iVa3iNUoyE2c+UMX+Y6lMldfnd1QgOzQFtSSvZoWawDYUlz0?=
 =?us-ascii?Q?5xLbZbMSyr5yZKznyVkN/1wT/RpcGVM6oUY7UPZmHMipYb1jzTg8hJEeEaTr?=
 =?us-ascii?Q?vQOyQeenq1/qN8kF7+uzrE9iZ+z4OsBv0PoIQcCuFHLRxRxaa2diEYgxicIr?=
 =?us-ascii?Q?XeoUc0lNf6HqI7tQGKohnBOHFvJZh3t7U+n/VtAQM89cag7hyEqM6beX6s4k?=
 =?us-ascii?Q?a4MI8OT4RCem1DPwU6r+tN273imSoBDvKawk4pxC/ZIfofTzfBbKJKTFRiWT?=
 =?us-ascii?Q?xPjKy4uI1Vvq+g8tYykNY0yEVc3n7v9v61Ur20mKamjkPoG3XcQOntsFB+5K?=
 =?us-ascii?Q?IOJ0yiE+l+hUeu/Chp2uoSwCps+Ws/uX1VZfKoekqsXXDErvgSmK2G1EEsK9?=
 =?us-ascii?Q?ZiagJEsReJkaWdfl+7qckZ3Lcez/G3rI7grBUh9LTSVVB1O3qucB79smTuzl?=
 =?us-ascii?Q?dW+h+k2DOHjjG8SELZIrf/tcIA2KlCD2yFpBWQZvhjXNuuJdyAF1e2+7vaQn?=
 =?us-ascii?Q?7x41Che+rhZ41DMeWN1mFxZI3C4aYxf9OfImKNYh0lRE8DQpc5xNz0kNMhI8?=
 =?us-ascii?Q?Hm4I73gxlf52VIHL7BLLAJhH9LGfO4Yh+SfU6S+rVhxPv4hpqfpTSlrsyFAB?=
 =?us-ascii?Q?kIY7yXaC1gJ2dwj39XhhhPYuYiRB3XDzfFsfY9fgBvd6FF49lFqvlCKOqaDX?=
 =?us-ascii?Q?eX+Ur/nES/aZkn04Mlrt11F2XmOdU6fKxGGuLB86CYthHqBmxPcrvoDqcd00?=
 =?us-ascii?Q?KYzB0mNMAtpBZ3U232YzHe8Zw9/7RbL7l2dXZUn1IhS9r3ZdYq47U12l3mT2?=
 =?us-ascii?Q?Ab+F7saNZzMoi6aU52BVxLOae7IkOdR7cgQ7Pi02nUasNyXqQoDA7K6z3mUH?=
 =?us-ascii?Q?T17SuQE0STcLTNiRBGmWg9syiyQ71ouXgyrTIJMVuB3pkBDpwaXr1Lll6WtA?=
 =?us-ascii?Q?VNI7gdXey3xXJEooVTpyEER9PeWfbZWVolgZ7oNvaQYyr8o2UVPJYtuNlPpA?=
 =?us-ascii?Q?rKwCXuw+gV+oeQln6sfp4ivePnM1ZzQoQy2aVcqaKcq5ZqEB/ikEaiyuNPI4?=
 =?us-ascii?Q?Jt2AjOOAjAGYmmhsLhqEmN4mgzXYfAHwt+7DlxYn+VMC98HQDaOgwvlu4rbG?=
 =?us-ascii?Q?IzcSzlaH/wP+6t0KUa4XSyzc1G52LGOH0bE4NN93hflxRIwxq3IZkFlvQ1Rx?=
 =?us-ascii?Q?kn+gPcMcg7WuO19nXjEmYa4J2+AQ81kNi9h3jqg7gsqx89MZdh3zo3Sg8fbv?=
 =?us-ascii?Q?8XJcaygPe3weghcJL3KNRLjzatMz40TecIWd77Sdrv0918Tn2Ol8xJvzBbnL?=
 =?us-ascii?Q?frTkJsXC0oB52BKuuwTt/U+ieJlUqOsekvBcBNtLvKxYUMY4tdaM8WQ0Ki0a?=
 =?us-ascii?Q?EqUIwt2ZS/mKU13uXbtBUhrJQ8oPVOuWqcm3gtnN9QXrmIs3dlKvdJc3wPbN?=
 =?us-ascii?Q?+RZ+EBEJLVV9z5GJxTTdGCeCNVORJtQY81tm3z2M7KorTiuJ0dWlt9o63vVb?=
 =?us-ascii?Q?oA0x8RvKcVFhtEjOmXJKELZPpq9K7Vq724j8VEzhs9zyUldxygGuB5YHdsKl?=
 =?us-ascii?Q?VJj2RTs8VSWXeaSaEy6IFEO59EfiIzVxajaAFJIYLEyiA3Fc6xKv/6nv40NM?=
 =?us-ascii?Q?vjb7s1QRTnzRecTJm4cG2z9ULz2rt2E=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5d7773-4dcd-413d-c27d-08dee036a293
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:19.6598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XvMBoY3fvpGCYVaaNvCZm9CPxhFaET4+pIaE7VXszcE8QEpX2PCzi6Ij/7rSSd2/tnZ+3H4dPbx6Izwcm6eucwRAChOgldbJFQs/5HURhR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

Clang reports the following warning when context analysis is enabled:

fs/ext2/xattr.c:829:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not \
  held on every path through here [-Werror,-Wthread-safety-analysis]
  829 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
      |             ^

When WARN_ON_ONCE() wraps down_write_trylock(), it adds an unlikely()
annotation which hides the conditional acquire annotation from Clang's
context analysis. This triggers a false positive. Pull the trylock out
of the macro to silence this warning.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/xattr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index e55d16abf422f..e5ed27f2ae733 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -826,8 +826,10 @@ ext2_xattr_delete_inode(struct inode *inode)
 	 * here to avoid false-positive warning from lockdep about reclaim
 	 * circular dependency.
 	 */
-	if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
+	if (!down_write_trylock(&EXT2_I(inode)->xattr_sem)) {
+		WARN_ON_ONCE(1);
 		return;
+	}
 	if (!EXT2_I(inode)->i_file_acl)
 		goto cleanup;
 
-- 
2.39.5

