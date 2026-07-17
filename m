Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021089.outbound.protection.outlook.com [52.101.57.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFEB7081F;
	Fri, 17 Jul 2026 02:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784253871; cv=fail; b=lMbT6sBoLlxa/dw8GQvwFEzXHKqgWJhJzsN+KUKYebS/MIZnM1PseAkM7ywwzKdHUCu+25QcgAAfz+mHFDHRD2hXD1OLhz9hssRSkxswRTsV/MT1afZr6mmhqXnQbrRdyi6Vd1fCIkNf9fqEmcbFGt/odQ9bVaCwUUi9I+dZW64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784253871; c=relaxed/simple;
	bh=WIB4O3hyZSe6YrCmey8aATDCbsV5Ohcn1wf0RvU1WrU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qgXr8H1LxYGQeCZ5WJbPHbHbVHEgtq18qcUnJOj3+TeqWqWa9lpTK166sDekPu9QGft+ZBzwRFHF9V9gt0mAeyjefc1UlqSnwMYLus+ulZs10Saa9FFzbC3AToMkbt3qOzHC5H7ca2VfcEe6H5+FtCYX7pJ9Y3a2ucmMy1oSDas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=IkqEXbVV; arc=fail smtp.client-ip=52.101.57.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="IkqEXbVV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mblaTtXHFeWMnEFxV1qW4JuTAOVnNBIi4auwRkGinnmNo/yuDWpKZvW18/EygrtvZLVdMQ7sgIrtMxLHimjKI2jpfdnO4tPpwzXN5mGE4I2C0pCynruSX9sR90dnp7+1dCqRNjCAA/ESlZ9KESOAYqGPJPtgB77AF+NwFW2znViA8s6gintBYqinuTtjEAFMVaU/b5fTTDuzKUHv4YkewUVsUes1EpK7PXFNKR7mek1Z6CDJKsKOhobtd+1rJ4WRqY6bllGpYTtBDR5OYv/wG8COWe9Xs/7I5q+GoqnoR9wx4WVsqGbCGVypLVfxOyN8nIKUXnXiUjdrrks2Fe0sPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzBGB9WT5BVVH/3rRi3p6u/i4kbeRzgaAR3o2f568ys=;
 b=b/6r06WY3T3SuLWeTajKwAotuk77gzTsg8tVqCLKaypDkFWthMYZ6mlFBIfrfjMPtcgXLalxFYaq7FAj1o5LXbWv/V5qfFkIjQIZowgPV1cVESB+dbBxqfx1VhHgRhQGTCQJY8k0awzSnPOSXRHY8UE4MDz0/azn3Gvt11fnbI8eCPB8YxhwK5670QgDHAg5wBZ1TwwzBhaW1olE0CpWSOWkPLeQZ1DDcblDIfOHAhhg7CavU0B5oegN+ORn75kByKMIh/zk5JtfFgEGjihQ2tySGG8ZK4U2Jsn/2UDTp0DzWzh+vcaZjp8fH5psND8N3oXI/2mpxDAr0k2CMBVBkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzBGB9WT5BVVH/3rRi3p6u/i4kbeRzgaAR3o2f568ys=;
 b=IkqEXbVV1TO61ZxBK7is+6bGPAeNchBwX6YlcpJYZNA7KOeFbNc+wg4mNVI7yqfRuFFJb+RKDzyn4vrfIuTBJpwv7UWN/a3IIABMy4VNsyqngFqOm63XNUypqVah+Cx3D24VKsgAwqf+uoByeMo2iEO23fhhFYFbc8eoHzMOlUPIgy06xIJ2TtuJl2V1Hbx0yWq0WlKLy4RbdUCEY1SQtU/9EMZzZxz0b2ohvicRAtjJFE053Hnkj2U9kODR/F21q0TiIwtSslvJ1qr9GI3q1Fu4n1LKp8ZYy4q2pBu1ZFCga/NdnHmqnEMsms4B4P/bEvsR6PVlO82pblZunMXwlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7535.namprd04.prod.outlook.com (2603:10b6:a03:32c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 02:04:26 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 02:04:26 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Timothy Day <timday@thelustrecollective.com>
Cc: linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/9] ext2: mark s_next_generation as guarded by s_next_gen_lock
Date: Thu, 16 Jul 2026 22:03:02 -0400
Message-Id: <20260717020302.180974-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260712165610.366474-3-timday@thelustrecollective.com>
References: <20260712165610.366474-1-timday@thelustrecollective.com> <20260712165610.366474-3-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::9) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|SJ0PR04MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ef6d80-a1f7-4ab0-2629-08dee3a7ba5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eWueuQmAwohcJC01dEANVkH7i576H8ApFaOuRIia6BFjRlCg238yo7cGmdmGXn8zZCGI0axgZssSlbA4bgFMktfoGSWwwE19SPlcVxMypCuH2dDsWdtbVy0gMPsnmLjfCGWZxnJA59eKyseFSJQarzfcnKcW4jvlffe29Y/YdPj6OJXwmE/oC78aep3NpRPLsVhFGaSY295DNVe2pN5EhUbh5pPgQ2POnW3Igav79UzT6GC3Ll58SS7pqcUzSFGk02q2rctDq1fnyYUhMVsbdbu5eQmsDZ780tA6J6Bie58tOJI2ujk0Bkpgx0PUAJJZVKCqbzKYI5FwQWs3s/MZJiIqYQJXFA5FQmp2XylnJO86CY4o3cxcfRT1Bae/rBXCc6pcFwJoaNXPkztl7SgK3A62PcmCg6QaB9RbTDQt9jOg267fe1hwsxxwgVqW7SD0AVELkCJouPN7x5C/jgaHYcD3MpyLXl1T68Kw5tcMI/gE0v5pnbYz9sY0z3Byuonby0JlCF9of1q/n5o0i2paDtQ7BNU2LE+kTrprrYLNqmhsp1RhhR9t8o/2FnFSSiMU0penM7aFM82KzsfyTjy8LTZiDbmH5RUljjhqxwZhlRhwM9OUzHuJhZVc/sH7P8gOF2Zdug63pxhzDJbe+PQbd6+osefiHgD+PKQIQ6DY/M0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?38vFiK6i4sMdkfqkgaM0jMPY9vxpfcLDaBPlgJAVOA7D8MtHHANQW0g4A85J?=
 =?us-ascii?Q?utpOnfx5MVRiyQjQndWGalp6gMr8jrh+iH3yvB5dP7VzIYO244qLgdj4CxoA?=
 =?us-ascii?Q?qFxH4W8LHnZlpi1SvHwQDc/poJO539k7Wm3ZXVXKzEGYLDRfnqveeQ+OQCB2?=
 =?us-ascii?Q?p3G1/SSoiPLVODH88K7o5doRfTgfdMcf/AKZKmyu6j1I14eknFhiLX1klZPY?=
 =?us-ascii?Q?O15+SKmi8vaaXNyqAciKCMi+k1ueKnp4cxUVaPoxnSvn0RQyMoqt24c5MgOf?=
 =?us-ascii?Q?p0eBeEV58Qfd4tkYOXnUYSX05IXKXX5mV8Y+kgTWDqlVzSuH7wlD0TYv8qJr?=
 =?us-ascii?Q?+rjd2cLJO4TrNLiwXyBttJMr3aUlimRroGzbj0dtn51fcb0ZiFhKcxeFBlYS?=
 =?us-ascii?Q?D1fo395RBwFLdqPiBNomeQ7GT2lGRf60k3x7KwQSppjDbF9Sy69vaGA4jOz3?=
 =?us-ascii?Q?XgfLDvQutgwNxnFsQwjncD8EcjLi+SwN6do5Q19jHnTzyDLoZ2pcUale6+w0?=
 =?us-ascii?Q?SYkQI8sbBq4GvDhM02xJHAViB1tYxF76j2Lt5tcpiDYmpSzf0ALZQRk9kWth?=
 =?us-ascii?Q?lJ3j+9mSNp4EM0A6yDzPr+0BzGQK2CYAew1rwAyVwjHd1xAB2RZqvyYFsM3Z?=
 =?us-ascii?Q?fAXbQD06wY9HW3GWOMdUz05rAE+wnmuYkleWE9GdtQNElmcPDm4MisEG3wQt?=
 =?us-ascii?Q?ks+dlMXLq309XOrRLizC4e5ngQNSaTnQQ3Qd44USaDEWa5RnXp9ftBeYGNIZ?=
 =?us-ascii?Q?XfAUy2xMJQESxhBu+mMSmzCF7JiqTg69068VRS829h3IQCseSltLzdBBgEEJ?=
 =?us-ascii?Q?EyZ3Y+VO15OFHFr8C+a86zfv14d267xoX2Vz8neSrBeMuVbVq/hDE7huhG0I?=
 =?us-ascii?Q?xKee9F0pIdrZ/FsEOkTqJ/+zrotoGY6KYfIaAhB3/mBDvLeBQoBFnEPudUQX?=
 =?us-ascii?Q?nLDsNEVay3daIi2cDcT1+Hnibcx18q9DLeU3xY6Rbye2TSgYCvfibhVypf2u?=
 =?us-ascii?Q?d7nSVjyUl+NgUMT8jJsXM/GxK81OB9nQMLG+aXDkKEQK6EWjCg8dgccLIu8c?=
 =?us-ascii?Q?MWgBuA5B36f3Z6lIDPYSQshHEd8eWfI9t/+4TQH2GyzQrOGa/ou0VNLhSSJJ?=
 =?us-ascii?Q?VeCGEZdW0RaYzF/eYLT+uuy6EM19z92kIzMaYmHWLAJaq74vRQlZ9ytghGYt?=
 =?us-ascii?Q?Foxvlj2xHXM47GOfeptiJLrhbe1m6ifmeaCC6ddKJjt4eMX2CskODvQeuieT?=
 =?us-ascii?Q?FnyG8eJiBRoFjYFLdzxd3p2vH6RhMArBYPoStX43tH4zyezM8vfESfxJ0xiX?=
 =?us-ascii?Q?q5qkEc3MhIj6e/9kiyXICIJAm/qTOU1eOidqoyHYz4sgVtcVmXQJv8/kDHOa?=
 =?us-ascii?Q?Wmh5bCM51XXip5gHRu+WGt8qo6A19UmH6qjSEkU92nrp+GKaSBJwNb4pXGt8?=
 =?us-ascii?Q?ij9ezPo+dViC2iQu5HM71E/6jcjbgsVuEyX/k7iI3MqXIcJS9wviTno+5zLa?=
 =?us-ascii?Q?CvBje8YAksOWOD4NhF/Bhv7pWRK3JW61DB316P1HSqOaKvMATDlkxeg7Sapf?=
 =?us-ascii?Q?gzN9d1kN3uRY+6gTyNkm7TkySRtfZPiWWoXCDt5SypSPiGRvTiCp1JQ6Dwzu?=
 =?us-ascii?Q?AupsVIPPbeXIRcUhU8NFdh1d9EPpcHBOzB916OZWOD4qsO/HRvx0gkzGKtXJ?=
 =?us-ascii?Q?1lPyCcqFEWDIdMy2z2jc7MBNvSzCz2InX3DakKHWl7Jm8UDkCnna41lihe9c?=
 =?us-ascii?Q?RVMC5dYRLkWcwQD08XGGrneCRh42EVQ=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ef6d80-a1f7-4ab0-2629-08dee3a7ba5b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 02:04:26.2259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTsu0AlWIh938N1HUVEC7My2GYBHbzg5KmPtLG7YqMTfJf6gBv6BnnoHvSX2biHHLDrdJiZj83Vepf10doo0GlPZsaMqG3urX/5m8A7MWYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7535

On Sun, 12 Jul 2026 12:56:03 -0400, Timothy Day wrote:
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 3999f8f3b156e..8c7f3772917bb 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1125,9 +1125,11 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
>  		goto failed_mount2;
>  	}
>  	sbi->s_gdb_count = db_count;
> -	sbi->s_next_generation = get_random_u32();
>  	spin_lock_init(&sbi->s_next_gen_lock);

If I change this to guard(spinlock_init)(&sbi->s_next_gen_lock), I should
be able to avoid the context_unsafe() line right after this. I'll fix
that in the next revision. There may be some other places in the series
where I can make the same fix.

>
> +	/* concurrent access is not possible before the mount completes */
> +	context_unsafe(sbi->s_next_generation = get_random_u32());
> +
>  	/* per filesystem reservation list head & lock */
>  	spin_lock_init(&sbi->s_rsv_window_lock);
>  	sbi->s_rsv_window_root = RB_ROOT;
> --
> 2.39.5

Tim Day
