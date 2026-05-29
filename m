Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BE43E63B6
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 14:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780065073; cv=fail; b=lWK7CcB2OR8LzrBAdHy5z1tyVSKZcJjnkHiR1zRgjqvN25i0Vv00wtO6DrcXh6fmBXbzjThaQbBkFMio9uPl9bYFCSOUBEC9Z78mjQjtci5Xi3PPPXrTj2e2e0X/BmaZtEhmccr+MBGUDnMrmiMPhlGUQWm3aKEsPmvMolTFgMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780065073; c=relaxed/simple;
	bh=izoYxFp7wQV6H0bLvfDp+u5VpsfvC9Q7Tt9QJj6K6QI=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=B3J7gRxL+g8SHBbwuIH1ck+ES0OXSF1Vmq7nNz8tTfp55l17fopD97IkCMILiszPzu3kX4D2wyiPZS+DNusAr02VJPF99MwEdBjRbA1OvP0dTNdfZnA/WRPKoUBZkw4/z/bNS+a72agwZqYxMPqLf2GevtNSAKP6Iea39V4zlJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=y/JWTmGY; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="y/JWTmGY"
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022093.outbound.protection.outlook.com [52.101.53.93]) by mx-outbound15-39.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 29 May 2026 14:31:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SqhVVIwGBYIYLycxhCOh81KRcnBfFjfHIMjgJb3CVJfc85e0o6EQo08mxyRdEmu3fkUAr5bOPowVaxD1GXIFvNYWM7Y1di2BJ/bliEpKSw1Edkkkar44DaSKy+Kh/15uD3EHfriofHGQO4rvNZek6yk1Gea6aAR+hgOGV550UDGW66sW1OCyHKxVeRlTsQi1Dx8NCj8HbclP9XYgjXjcn7foBwqK80qg1Jr9+NdTfjB/tWSVvTW5CP0XRBWg/g4Zx47IItT9HAIw9x92Qc6812zYPiVQ5acmUB2ubRQ7MTC1uMddXu9dDok8vBnRb5KWWuing7IJOTLEc0w2If4HIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHHLdWzJzuD0ZlCuMtTItUfjtdmW4wLja3Dv45iiJ+Y=;
 b=s44nzRLYY2dvG3u50MDMjC8h8PywcJrnGQ46LBSFtexpNmOOxakSnlM9km6VxUnpRaJSiWTmipjYTOe3aEigPUM7ZPFOYeWVsj9R/KWa3z5HQbriNkIifX1zzUA5mYwj1VMsOCVdUteKiQH5ibLXLJN6YiOIHRf10XUxQzZ31dYbk7iP8nxVXkDFgGER0P8s5lQpEX682M5QnaBWQKZ1R6uCOVCYyeX4vUdKFFXs7isX+fDBCHBc1Jo0VS66q9LB8b3n2IWqOLfDs7p1aoE90qm6tcaApU8rfENtXBm1gowg4UTYcfXVtFmXIvX1uE7yuWIFyx+qU6ccs6Lx/Pf7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHHLdWzJzuD0ZlCuMtTItUfjtdmW4wLja3Dv45iiJ+Y=;
 b=y/JWTmGYhQ+iaJcOZODKXpcx0iMpg0VtwoOTn9qqLCSUKGjC2Vmyla2gm34DJUACrycm+XUE6ylXiHhdG7L46DnkoUIhkwsKJpL2RIYD3zRuHUR7nt1UPOdQJGBre2QXWP2KAvZGLRgBkDLFVMFTKioxpUB5yEiHZYyfdfWbYI8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by PH8PR19MB6860.namprd19.prod.outlook.com (2603:10b6:510:1c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 11:58:44 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 11:58:44 +0000
Date: Fri, 29 May 2026 13:58:39 +0200
From: Etienne AUJAMES <eaujames@ddn.com>
To: linux-ext4@vger.kernel.org
Cc: adilger@thelustrecollective.com, dongyangli@ddn.com
Subject: [PATCH 4/4] libext2fs: add ext2fs_xattrs_release_all() helper
Message-ID: <ahl_bxT0I_ZuFomx@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: PA7P264CA0330.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:39a::24) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|PH8PR19MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f8e2616-ca2c-4dfd-aee1-08debd79a24d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|19092799006|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 JCli0LZ7P5qOGXgWRnXKhkILxaSCsJ0b0KX88WbWxPvxZZv9BM9TQA39yauK0a7yvlHqcAPuSieHcC3JP+ztJMHnElRDNfcBlzKTtsTeWDYo/oH0scboYpiFe/Pa5FCF7OBf2uAIvm7ljLi9fcl0pjm7/pzw5WD88k6M+rDji04Vt/RvuaHK7KU2wDIuWfomlLzNHClfCxRjv/ggcXmZZR1f72i0hiohaZ0A52hsWTWWevbX4/TREQlCg8e1OL5FkdjBfGPv0HQ2XDSxnkHhIH52N24cGYsrqN3FGRfZQKfZrQEpI807KnnthVvPPDlCoiMwCrH5PIAPUJ9CGmfD3d6eSqKzZPQ2dcBVlsD7WOxyQYJvH14bw1Ihg7em+iQ6hUox9CX1+I5Z+9mk6FkQYeLnXgWz6Kf2TyVMAfdYzlCkDfzO1wIo6XK0UnI4+h5bOjmK7eNCKutQjBeEKYXwabiTKcK8Ty5Y1WpS0zRdnKgt36rZEqC58dH4RGRa9TTzI43JfAu/dDdgCRJiuF0H28KIYQW6d7JkXqRCGcScdmC6Bvo+THkm2zvwqzhyHrjMXs0kCblVvPiNRAY0+uF01cDq/U8YofD5AtNcEwE7CCMXE+0OYzx5tBm1nXYaxJS3Vr8Tg0t9v9MDm0immMoG9dkSslBco179NFy7xsyqirrn57INgiY4DXTozMMr0u++
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(19092799006)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?vZgESsxI3JcBjD7f6TkVGPzEKDd+IwDyrhdEN9zrVvAcJmVTUFoKIkDp22Xu?=
 =?us-ascii?Q?iPnbonrdajBXvV/loUgg8Iiu0TDMvGBRzSpWwfa6plvW65ZRy4JLUc5tq53U?=
 =?us-ascii?Q?+Zwwf5ZBxEq4vlzmiHvDdNSbdvIZr62VGNUaSNv7KvXIZHJLt3022uCVhp5o?=
 =?us-ascii?Q?UjOnJ9n9Z8dRa3VJaiaFTOjWaS9a0nzPZcqHTWwSiOnCwaqu5FtXZlpr2cq+?=
 =?us-ascii?Q?XkYSinzVchjYmgR8dJvJShCoINwNijMFECQZ1J947tTWg+aizguprNPLKuPC?=
 =?us-ascii?Q?HBE1GA2umYwfiKv1KILFEpQcpz3DaBxmDA44qWBU66jyJIJsXkXdJxXl6eEL?=
 =?us-ascii?Q?RjFnE5L/sRgcWboL95QnmRj0AJ7tjSkWSd8fVm1uywtsb+FWkCPGLXybKVog?=
 =?us-ascii?Q?tdep93a6yt0a5dnSkCqR5yrp0I3uiRUOAuNuybGEW1hX1n1B2LbyAfO82EVo?=
 =?us-ascii?Q?FPhN0IjCJjaRlV3gRSoFvtgFTo+/j2q3Ny62T0Hg6weJ7oEnllWwqH1/FTjh?=
 =?us-ascii?Q?XoFl3Q78POwvUZ5ipNMjTqzHwvhy93AOCZdNYtlChdK7ib9SrqdnpF7R8KJ8?=
 =?us-ascii?Q?wQlZR33VV/usX8GoKEOcRb61y0H1nXc5ZnwlAeJEqOYHmY/HsfiG/mT0Q4NR?=
 =?us-ascii?Q?865Nt3LlRdxVeXyPSk1EvNPWS5yW/UDCI05z4K0GDlsoM/laeZhKf9cLcYpt?=
 =?us-ascii?Q?meudobvnWs3v7FRdupV7jLPmgorxOfBQbBaLaBG5MXIaiddtLcBKC//ipxgV?=
 =?us-ascii?Q?HE5Wi3iGi885qW+HdOB0t7R169Xh0C6gjWtftVF/A82Vs8PoiTMuoi0N1Ic0?=
 =?us-ascii?Q?3jyqLk+9wfhPeEuu/4jQuyCBAWu7D0zUoIDR1Hr4GSNtfUXwv9YgESNA7bTb?=
 =?us-ascii?Q?4XMppai5hPq6FovkS7V0RX+y7qECw3OJ+0M7tPNayQnq8wvKZ7HeUEChwYDr?=
 =?us-ascii?Q?SpPWA5qlDPb5Z7/TH7NjuUHLS/LquQT6Airt2m8KozicA1mIQlYyLlAiyBZH?=
 =?us-ascii?Q?cK9JPYGRRbWBlrbwBmJgfY6KveDdUueSAKIluTKujpZ0LoKXfuJLn1LspNaa?=
 =?us-ascii?Q?GI3c6uPviXj6Xu6N30PK/d+aXGbNYk2pVuJGpYg6+2CoFD8Vb0FJhDGIeaau?=
 =?us-ascii?Q?nJx/2yHuscR3fCApcw7XAdfN+vtYcvsNjzooSVt1RrxP71TbSImREHUBY6sG?=
 =?us-ascii?Q?TuO92ams+MVnFyfLJfbSFhLJvrV4BGJstian96SeOTmPv2Ue/rw6X9bvILC0?=
 =?us-ascii?Q?R6JbpUwblqw/Xbuk+78rRuE8TTKQmG7Fg+OVKJPPdnSPEPAlcnkMrh52ATcC?=
 =?us-ascii?Q?ygEfEkCqR/VoF+j5mlIggX6tekR2cAUz+jxw09JZaBf+Rc/UyVQw8yxhP8eh?=
 =?us-ascii?Q?UTaS54X5NBpVNjL4JE7c1agvEv4GjDXqYXIzJQUh/tfFrVk8G9BLtnpey7gD?=
 =?us-ascii?Q?YyuTeIh1ZOP6oDLdhS4LjpjfREcuViN1cGzP6VrfSNx2P0DNHpAL+w4Eo7iZ?=
 =?us-ascii?Q?Cdi8RvQgCwBnYFRLKvJKj5fyPZnLXQTEk+NSKBGdCjEOrG37ZDfjkFx7Td23?=
 =?us-ascii?Q?sGgnWXgG8hgJhv9BZrdQEOAbGc5cU20wDLGUz8QCTwbN5YbRqElxCcYIZ4r2?=
 =?us-ascii?Q?COC03NbSPXbiocSd8Rkl+TqlYK8RwCNmyasnYUn43QxuEPUkVEPFIvVjFF0X?=
 =?us-ascii?Q?ETw6PQv+DrkiZbX6WU47tlBkSMeY/iS45OmSBsm/2aSXP/wM/V50P1EpsGz7?=
 =?us-ascii?Q?wGMsha3kKnh+/Bhqz9WI4UGgX0X0Kkm5yXnmYIXOxyi7Z8Wg3Klw?=
X-Exchange-RoutingPolicyChecked:
 hsVE2UsNYJaq797+tO+8hrkuuy0EAn5mGaQ90Yg4VCC3vCORk8Z2L2U+uFFZIF02Yq3/8bPgMqDN2+l0zxUp6AxftVwSx91efdIheFxHLQllEhdZAVlegUDwr/BvZADDV+KKDI0S/1MToDWRJgn8UeDetwlhxH5fGliRM1FGFueeQIiFEQjpBieuvvTwcZJu1KqR19N0X9JypPXEV1/6Ciw80Q7Zc35SoI+H5Y9ufmSNo8ooYRcJTtXdl3EN4qOjUWCuyiamdhc86isfXdy6rL771pozavs4BClHQB3g182Vf03yoI7Yx9QEo/vYW7FVFPan5Q7zo0KsN+qf5ikeUA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 tmk5Wwp3dm+lme0o0FwrXJnOiQZ8YNvBma5oa6IlE+5Z6+V31DrAAt1FivZuSq4gQ36vsphQnKiyWUU6RsxyazInbVqiMOIiXc9iYLUf9ukFYNw7n40aWOo4h6EEXRZhogDXnIip6TQbhojUPqL+fDX7TFbJu2QCQQaGqxk6bgzn3M6/iX2XQBJ0aWXYICXIfx6nMB4JKfkIdUTh8D+7BqGpfT72/U2GWmQeYBripo0h6seAHp4y+6OAzgc4hf9xtPixL0nKTjs5aUNCElcgMsHfmaTJA1/erGMqgKA9fD+aP/8HUu6S2h4gV6X7QY21S2c4a3IU//RKAzMOx2NUUHmHfe8CZ/ufuSKUlgiTLqP989mZqhHNMQL8F24WYXwNQ9/nhMWatRrpbn+10RQk/ciVu39+Embc1KzZdUCzLsBdRguID4AOGuwrRwcpkxA7QuWcw/tOiNooQAOqPb7ZFmEbv7IzZeYg9mA0sp+fN9qm4emiCet0cdV3JkVl80G9AOC7JK0Rwbc1fKCknFoWDGNyoWUqHJY/u19u5u5vY/3M4htvelDm04F/4x1TbMXiCNhqm8wMvNsMPgs9e3FqcD7VzWCWoypJmRdMJQ08CYWnVsVUJMJvXCM6bgejK3Xfk0ug0Z8ed3kte7ahXgzqyA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8e2616-ca2c-4dfd-aee1-08debd79a24d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 11:58:44.7528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uih1+qYX+lk2Qbv8oLp9DwWAh/p+50JwVMoT+2X878GJgkgVprJ+OfdM24mPYef4tDvX0czzHUk8WgxEyq2kDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB6860
X-BESS-ID: 1780065066-103879-4799-978-1
X-BESS-VER: 2019.1_20260519.1529
X-BESS-Apparent-Source-IP: 52.101.53.93
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkamFuZGQGYGUNQyJSXZwCLRLM
	3cMtkk0djQ3CAtJckyySA1ydTMPMXQXKk2FgDH6VF6QgAAAA==
X-BESS-Outbound-Spam-Score: 0.68
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.273539 [from 
	cloudscan14-94.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 OBSCURED_EMAIL         BODY: Message seems to contain rot13ed address 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.68 OBSCURED_EMAIL_2       META: BODY: Message seems to contain rot13ed address 
X-BESS-Outbound-Spam-Status: SCORE=0.68 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=OBSCURED_EMAIL, BSF_BESS_OUTBOUND, OBSCURED_EMAIL_2
X-BESS-BRTS-Status:1

This patch adds a helper function ext2fs_xattrs_release_all() which
removes all extended attributes and updates the quota accordingly.

The main purpose of this is to handle ea_inode xattrs in e2fsck when
deleting orphan inodes:

 # e2fsck -yf /tmp/ext4
 e2fsck 1.47.3-wc2 (11-Nov-2025)
 Clearing orphaned inode 12 (uid=0, gid=0, mode=0100644, size=0)
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Regular filesystem inode 13 has EA_INODE flag set. Clear<y>? yes
 Unattached inode 13
 Connect to /lost+found<y>? yes
 Inode 13 ref count is 2, should be 1.  Fix<y>? yes

fuse2fs, debugfs and mke2fs are updated to use this function and
handle ea_inode on inode deletion.

Update d_xattr_ea_inode to check for the inode deletion case.
Add a regression test: f_orphan_ea_inode

Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Change-Id: I4a84a50d43b8b9aab2dfc352a92256c710a3659e
Lustre-bug-id: https://jira.whamcloud.com/browse/LU-20049
---
 debugfs/debugfs.c                |  33 +++++++--
 e2fsck/super.c                   |  67 +++++++++++-------
 lib/ext2fs/ext2fs.h              |   3 +
 lib/ext2fs/ext_attr.c            |  41 +++++++++++
 misc/create_inode_libarchive.c   |  35 ++++-----
 misc/fuse2fs.c                   | 117 +++++++++++--------------------
 tests/d_xattr_ea_inode/expect    |  51 ++++++++++++++
 tests/d_xattr_ea_inode/script    |  55 ++++++++++-----
 tests/f_orphan_ea_inode/expect.1 |   6 ++
 tests/f_orphan_ea_inode/expect.2 |   7 ++
 tests/f_orphan_ea_inode/image.gz | Bin 0 -> 2139 bytes
 tests/f_orphan_ea_inode/name     |   1 +
 tests/f_orphan_ea_inode/script   |   3 +
 13 files changed, 277 insertions(+), 142 deletions(-)
 create mode 100644 tests/f_orphan_ea_inode/expect.1
 create mode 100644 tests/f_orphan_ea_inode/expect.2
 create mode 100644 tests/f_orphan_ea_inode/image.gz
 create mode 100644 tests/f_orphan_ea_inode/name
 create mode 100644 tests/f_orphan_ea_inode/script

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index b9f248be2..d316293d2 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1861,21 +1861,40 @@ static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 
 static void kill_file_by_inode(ext2_ino_t inode)
 {
-	struct ext2_inode inode_buf;
+	struct ext2_inode_large *inode_buf;
+	size_t inode_size = EXT2_INODE_SIZE(current_fs->super);
+	errcode_t err;
 
-	if (debugfs_read_inode(inode, &inode_buf, 0))
-		return;
-	ext2fs_set_dtime(current_fs,  &inode_buf);
-	if (debugfs_write_inode(inode, &inode_buf, 0))
+	err = ext2fs_get_memzero(inode_size, &inode_buf);
+	if (err)
 		return;
-	if (ext2fs_inode_has_valid_blocks2(current_fs, &inode_buf)) {
+
+	err = ext2fs_read_inode_full(current_fs, inode, EXT2_INODE(inode_buf),
+				     inode_size);
+	if (err) {
+		com_err(__func__, err, "while reading inode %u", inode);
+		goto out;
+	}
+
+	ext2fs_set_dtime(current_fs,  EXT2_INODE(inode_buf));
+	ext2fs_xattrs_release_all(current_fs, inode, inode_buf, inode_size,
+				  NULL);
+	if (ext2fs_inode_has_valid_blocks2(current_fs, EXT2_INODE(inode_buf))) {
 		blk64_t last_cluster = 0;
 		ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY,
 				      NULL, release_blocks_proc, &last_cluster);
 	}
 	printf("\n");
 	ext2fs_inode_alloc_stats2(current_fs, inode, -1,
-				  LINUX_S_ISDIR(inode_buf.i_mode));
+				  LINUX_S_ISDIR(inode_buf->i_mode));
+
+	err = ext2fs_write_inode_full(current_fs, inode, EXT2_INODE(inode_buf),
+				     inode_size);
+	if (err)
+		com_err(__func__, err, "while writing inode %u", inode);
+
+out:
+	ext2fs_free_mem(&inode_buf);
 }
 
 
diff --git a/e2fsck/super.c b/e2fsck/super.c
index c2ccefd54..1a94ba567 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -156,13 +156,14 @@ static errcode_t truncate_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 	struct process_block_struct pb = { 0 };
 	e2_blkcnt_t truncate_block = 0;
 	__u32 truncate_offset = 0;
-	blk64_t blk;
+	blk64_t blk, iblks;
 	int ret_flags;
 	errcode_t retval = 0;
 
 	if (!ext2fs_inode_has_valid_blocks2(fs, EXT2_INODE(inode)))
 		return 0;
 
+	iblks = ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode));
 	if (inode->i_links_count) {
 		truncate_offset = inode->i_size % fs->blocksize;
 		truncate_block = (e2_blkcnt_t)
@@ -190,6 +191,10 @@ static errcode_t truncate_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 			"release_inode_blocks");
 
 	ext2fs_iblk_sub_blocks(fs, EXT2_INODE(inode), pb.truncated_blocks);
+	iblks -= ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode));
+	if (ctx->qctx)
+		quota_data_sub(ctx->qctx, inode, ino, iblks * 512);
+
 	if (!truncate_offset)
 		return 0;
 
@@ -217,17 +222,19 @@ static errcode_t truncate_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
  * not deleted.
  */
 static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
-				struct ext2_inode_large *inode, char *block_buf,
+				struct ext2_inode_large *inode,
+				size_t inode_size, char *block_buf,
 				struct problem_context *pctx)
 {
 	ext2_filsys			fs = ctx->fs;
-	blk64_t				free_blks, ino_blks;
+	blk64_t				free_blks;
+	__u32				free_inodes;
 	char				*buf;
 	errcode_t			err;
 	int				rc = 0;
 
+	free_inodes = fs->super->s_free_inodes_count;
 	free_blks = ext2fs_free_blocks_count(fs->super);
-	ino_blks = ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode));
 	buf = block_buf + 3 * ctx->fs->blocksize;
 	if (truncate_inode_blocks(ctx, ino, inode, buf, pctx)) {
 		rc = 1;
@@ -236,7 +243,7 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 	if (inode->i_links_count)
 		goto update_counts;
 
-	err = ext2fs_free_ext_attr(fs, ino, inode);
+	err = ext2fs_xattrs_release_all(fs, ino, inode, inode_size, ctx->qctx);
 	if (err) {
 		com_err(__func__, err,
 			_("while calling ext2fs_free_ext_attr for inode %u"),
@@ -249,9 +256,8 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 
 update_counts:
 	ctx->free_blocks += ext2fs_free_blocks_count(fs->super) - free_blks;
-	ino_blks -= ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode));
-	if (ctx->qctx)
-		quota_data_sub(ctx->qctx, inode, 0, ino_blks << 9);
+	free_inodes = fs->super->s_free_inodes_count - free_inodes;
+	ctx->free_inodes += free_inodes;
 
 	return rc;
 }
@@ -312,44 +318,55 @@ static int release_orphan_inode(e2fsck_t ctx, ext2_ino_t *ino, char *block_buf)
 {
 	ext2_filsys fs = ctx->fs;
 	struct problem_context pctx;
-	struct ext2_inode_large inode;
+	struct ext2_inode_large *inode;
+	size_t inode_size = EXT2_INODE_SIZE(fs->super);
 	ext2_ino_t next_ino;
+	int rc = 1;
+
+	if (ext2fs_get_memzero(inode_size, &inode))
+		return 1;
 
-	e2fsck_read_inode_full(ctx, *ino, EXT2_INODE(&inode),
-				sizeof(inode), "release_orphan_inode");
+	e2fsck_read_inode_full(ctx, *ino, EXT2_INODE(inode),
+				     inode_size, __func__);
 	clear_problem_context(&pctx);
 	pctx.ino = *ino;
-	pctx.inode = EXT2_INODE(&inode);
-	pctx.str = inode.i_links_count ? _("Truncating") : _("Clearing");
+	pctx.inode = EXT2_INODE(inode);
+	pctx.str = inode->i_links_count ? _("Truncating") : _("Clearing");
 
 	fix_problem(ctx, PR_0_ORPHAN_CLEAR_INODE, &pctx);
 
-	next_ino = inode.i_dtime;
+	next_ino = inode->i_dtime;
 	if (next_ino &&
 	    ((next_ino < EXT2_FIRST_INODE(fs->super)) ||
 	     (next_ino > fs->super->s_inodes_count))) {
 		pctx.ino = next_ino;
 		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_INODE, &pctx);
-		return 1;
+		goto out;
 	}
 
-	if (release_inode_blocks(ctx, *ino, &inode, block_buf, &pctx))
-		return 1;
+	if (release_inode_blocks(ctx, *ino, inode, inode_size, block_buf,
+				 &pctx))
+		goto out;
 
-	if (!inode.i_links_count) {
+	if (!inode->i_links_count) {
 		if (ctx->qctx)
-			quota_data_inodes(ctx->qctx, &inode, *ino, -1);
+			quota_data_inodes(ctx->qctx, inode, *ino, -1);
 		ext2fs_inode_alloc_stats2(fs, *ino, -1,
-					  LINUX_S_ISDIR(inode.i_mode));
+					  LINUX_S_ISDIR(inode->i_mode));
 		ctx->free_inodes++;
-		ext2fs_set_dtime(fs, EXT2_INODE(&inode));
+		ext2fs_set_dtime(fs, EXT2_INODE(inode));
 	} else {
-		inode.i_dtime = 0;
+		inode->i_dtime = 0;
 	}
-	e2fsck_write_inode_full(ctx, *ino, EXT2_INODE(&inode),
-				sizeof(inode), "delete_file");
+	e2fsck_write_inode_full(ctx, *ino, EXT2_INODE(inode),
+				      inode_size, __func__);
 	*ino = next_ino;
-	return 0;
+	rc = 0;
+
+out:
+	ext2fs_free_mem(&inode);
+
+	return rc;
 }
 
 struct process_orphan_block_data {
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 56de5ea50..cb3f1a3a1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1425,6 +1425,9 @@ errcode_t ext2fs_xattr_inode_max_size(ext2_filsys fs, ext2_ino_t ino,
 #define XATTR_HANDLE_FLAG_RAW	0x0001
 errcode_t ext2fs_xattrs_flags(struct ext2_xattr_handle *handle,
 			      unsigned int *new_flags, unsigned int *old_flags);
+errcode_t ext2fs_xattrs_release_all(ext2_filsys fs, ext2_ino_t ino,
+				    struct ext2_inode_large *inode,
+				    size_t inode_size, quota_ctx_t qctx);
 extern void ext2fs_ext_attr_block_rehash(struct ext2_ext_attr_header *header,
 					 struct ext2_ext_attr_entry *end);
 extern __u32 ext2fs_get_ea_inode_hash(struct ext2_inode *inode);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 3b90b70bb..2a2e79acd 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -1868,3 +1868,44 @@ errcode_t ext2fs_xattrs_flags(struct ext2_xattr_handle *handle,
 		handle->flags = *new_flags;
 	return 0;
 }
+
+errcode_t ext2fs_xattrs_release_all(ext2_filsys fs, ext2_ino_t ino,
+				    struct ext2_inode_large *inode,
+				    size_t inode_size, quota_ctx_t qctx)
+{
+	struct ext2_xattr_handle *h;
+	errcode_t err = 0;
+
+	if (!ext2fs_has_feature_ea_inode(fs->super)) {
+		blk64_t blk = ext2fs_file_acl_block(fs, EXT2_INODE(inode));
+
+		if (!blk)
+			return 0;
+
+		err = ext2fs_free_ext_attr(fs, ino, inode);
+		if (err || !qctx)
+			return err;
+
+		quota_data_sub(qctx, inode, ino,
+			       EXT2FS_C2B(fs, 1) * fs->blocksize);
+		return 0;
+	}
+
+	err = ext2fs_xattrs_open_inode(fs, ino, EXT2_INODE(inode), inode_size,
+				       qctx, &h);
+	if (err)
+		return err;
+
+	err = ext2fs_xattrs_read(h);
+	if (err)
+		goto out_close;
+
+	err = ext2fs_xattr_remove_all(h);
+	if (err)
+		goto out_close;
+
+out_close:
+	ext2fs_xattrs_close(&h);
+
+	return err;
+}
diff --git a/misc/create_inode_libarchive.c b/misc/create_inode_libarchive.c
index fadf0721f..4736e8c22 100644
--- a/misc/create_inode_libarchive.c
+++ b/misc/create_inode_libarchive.c
@@ -261,46 +261,49 @@ static inline unsigned int __round_up(unsigned int quantity, unsigned int size)
 static int remove_inode(ext2_filsys fs, ext2_ino_t ino)
 {
 	errcode_t ret = 0;
-	struct ext2_inode_large inode;
+	struct ext2_inode_large *inode;
+	size_t inode_size = EXT2_INODE_SIZE(fs->super);
 
-	memset(&inode, 0, sizeof(inode));
-	ret = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
-				     sizeof(inode));
+	ret = ext2fs_get_memzero(inode_size, &inode);
+	if (ret)
+		return ret;
+
+	ret = ext2fs_read_inode_full(fs, ino, EXT2_INODE(inode), inode_size);
 	if (ret)
 		goto out;
 
-	switch (inode.i_links_count) {
+	switch (inode->i_links_count) {
 	case 0:
 		return 0; /* XXX: already done? */
 	case 1:
-		inode.i_links_count--;
-		ext2fs_set_dtime(fs, EXT2_INODE(&inode));
+		inode->i_links_count--;
+		ext2fs_set_dtime(fs, EXT2_INODE(inode));
 		break;
 	default:
-		inode.i_links_count--;
+		inode->i_links_count--;
 	}
 
-	if (inode.i_links_count)
+	if (inode->i_links_count)
 		goto write_out;
 
 	/* Nobody holds this file; free its blocks! */
-	ret = ext2fs_free_ext_attr(fs, ino, &inode);
+	ret = ext2fs_xattrs_release_all(fs, ino, inode, inode_size, NULL);
 	if (ret)
 		goto write_out;
 
-	if (ext2fs_inode_has_valid_blocks2(fs, (struct ext2_inode *)&inode)) {
-		ret = ext2fs_punch(fs, ino, (struct ext2_inode *)&inode, NULL,
-				   0, ~0ULL);
+	if (ext2fs_inode_has_valid_blocks2(fs, EXT2_INODE(inode))) {
+		ret = ext2fs_punch(fs, ino, EXT2_INODE(inode), NULL, 0, ~0ULL);
 		if (ret)
 			goto write_out;
 	}
 
-	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
+	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode->i_mode));
 
 write_out:
-	ret = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
-				      sizeof(inode));
+	ret = ext2fs_write_inode_full(fs, ino, EXT2_INODE(inode), inode_size);
 out:
+	ext2fs_free_mem(&inode);
+
 	return ret;
 }
 
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 94e289fab..11141f645 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -2274,123 +2274,88 @@ static int fuse2fs_unlink(struct fuse2fs *ff, const char *path,
 	return 0;
 }
 
-static int remove_ea_inodes(struct fuse2fs *ff, ext2_ino_t ino,
-			    struct ext2_inode_large *inode)
+static int remove_inode(struct fuse2fs *ff, ext2_ino_t ino)
 {
 	ext2_filsys fs = ff->fs;
-	struct ext2_xattr_handle *h;
 	errcode_t err;
+	struct ext2_inode_large *inode;
+	size_t inode_size = EXT2_INODE_SIZE(fs->super);
 	int ret = 0;
 
-	/*
-	 * The xattr handle maintains its own private copy of the inode, so
-	 * write ours to disk so that we can read it.
-	 */
-	err = fuse2fs_write_inode(fs, ino, inode);
+	err = ext2fs_get_memzero(inode_size, &inode);
 	if (err)
 		return translate_error(fs, ino, err);
 
-	err = ext2fs_xattrs_open(fs, ino, &h);
-	if (err)
-		return translate_error(fs, ino, err);
-
-	err = ext2fs_xattrs_read(h);
+	err = ext2fs_read_inode_full(fs, ino, EXT2_INODE(inode), inode_size);
 	if (err) {
 		ret = translate_error(fs, ino, err);
-		goto out_close;
-	}
-
-	err = ext2fs_xattr_remove_all(h);
-	if (err) {
-		ret = translate_error(fs, ino, err);
-		goto out_close;
+		goto out;
 	}
-
-out_close:
-	ext2fs_xattrs_close(&h);
-	if (ret)
-		return ret;
-
-	/* Now read the inode back in. */
-	err = fuse2fs_read_inode(fs, ino, inode);
-	if (err)
-		return translate_error(fs, ino, err);
-
-	return 0;
-}
-
-static int remove_inode(struct fuse2fs *ff, ext2_ino_t ino)
-{
-	ext2_filsys fs = ff->fs;
-	errcode_t err;
-	struct ext2_inode_large inode;
-	int ret = 0;
-
-	err = fuse2fs_read_inode(fs, ino, &inode);
-	if (err)
-		return translate_error(fs, ino, err);
-
 	dbg_printf(ff, "%s: put ino=%d links=%d\n", __func__, ino,
-		   inode.i_links_count);
+		   inode->i_links_count);
 
-	if (S_ISDIR(inode.i_mode)) {
+	if (S_ISDIR(inode->i_mode)) {
 		/*
 		 * Caller should have checked that this is an empty directory
 		 * before starting the unlink process.  nlink is usually 2, but
 		 * it could be 1 if this dir ever had more than 65000 subdirs.
 		 * Zero the link count.
 		 */
-		if (!ext2fs_dir_link_empty(EXT2_INODE(&inode)))
-			return translate_error(fs, ino, EXT2_ET_INODE_CORRUPTED);
-		inode.i_links_count = 0;
-		ext2fs_set_dtime(fs, EXT2_INODE(&inode));
+		if (!ext2fs_dir_link_empty(EXT2_INODE(inode))) {
+			ret = translate_error(fs, ino, EXT2_ET_INODE_CORRUPTED);
+			goto out;
+		}
+		inode->i_links_count = 0;
+		ext2fs_set_dtime(fs, EXT2_INODE(inode));
 	} else {
 		/*
 		 * Any other file type can be hardlinked, so all we need to do
 		 * is decrement the nlink.
 		 */
-		if (inode.i_links_count == 0)
-			return translate_error(fs, ino, EXT2_ET_INODE_CORRUPTED);
-		inode.i_links_count--;
-		if (!inode.i_links_count)
-			ext2fs_set_dtime(fs, EXT2_INODE(&inode));
+		if (inode->i_links_count == 0) {
+			ret = translate_error(fs, ino, EXT2_ET_INODE_CORRUPTED);
+			goto out;
+		}
+		inode->i_links_count--;
+		if (!inode->i_links_count)
+			ext2fs_set_dtime(fs, EXT2_INODE(inode));
 	}
 
-	ret = update_ctime(fs, ino, &inode);
+	ret = update_ctime(fs, ino, inode);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Still linked?  Leave it be. */
-	if (inode.i_links_count)
+	if (inode->i_links_count)
 		goto write_out;
 
-	if (ext2fs_has_feature_ea_inode(fs->super)) {
-		ret = remove_ea_inodes(ff, ino, &inode);
-		if (ret)
-			return ret;
-	}
-
 	/* Nobody holds this file; free its blocks! */
-	err = ext2fs_free_ext_attr(fs, ino, &inode);
-	if (err)
-		return translate_error(fs, ino, err);
+	err = ext2fs_xattrs_release_all(fs, ino, inode, inode_size, NULL);
+	if (err) {
+		ret = translate_error(fs, ino, err);
+		goto out;
+	}
 
-	if (ext2fs_inode_has_valid_blocks2(fs, EXT2_INODE(&inode))) {
-		err = ext2fs_punch(fs, ino, EXT2_INODE(&inode), NULL,
+	if (ext2fs_inode_has_valid_blocks2(fs, EXT2_INODE(inode))) {
+		err = ext2fs_punch(fs, ino, EXT2_INODE(inode), NULL,
 				   0, ~0ULL);
-		if (err)
-			return translate_error(fs, ino, err);
+		if (err) {
+			ret = translate_error(fs, ino, err);
+			goto out;
+		}
 	}
 
 	ext2fs_inode_alloc_stats2(fs, ino, -1,
-				  LINUX_S_ISDIR(inode.i_mode));
+				  LINUX_S_ISDIR(inode->i_mode));
 
 write_out:
-	err = fuse2fs_write_inode(fs, ino, &inode);
+	err = ext2fs_write_inode_full(fs, ino, EXT2_INODE(inode), inode_size);
 	if (err)
-		return translate_error(fs, ino, err);
+		ret = translate_error(fs, ino, err);
+out:
+	ext2fs_free_mem(&inode);
 
-	return 0;
+	return ret;
 }
 
 static int __op_unlink(struct fuse2fs *ff, const char *path)
diff --git a/tests/d_xattr_ea_inode/expect b/tests/d_xattr_ea_inode/expect
index aaad9c5b3..e1878c3dc 100644
--- a/tests/d_xattr_ea_inode/expect
+++ b/tests/d_xattr_ea_inode/expect
@@ -135,3 +135,54 @@ Pass 5: Checking group summary information
 test_filesys: 11/128 files (0.0% non-contiguous), 18/256 blocks
 Exit status is 0
 
+write d_xattr_ea_inode.tmp test_file
+Allocated inode: 12
+Exit status is 0
+
+Generate xattr value (1024 bytes)
+ea_set -f d_xattr_ea_inode.tmp test_file user.test1
+Exit status is 0
+ea_get -f d_xattr_ea_inode.ver.tmp test_file user.test1
+Exit status is 0
+Compare xattr values (1024 bytes)
+stat test_file
+Blockcount: 16
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 20/256 blocks
+Exit status is 0
+
+Generate xattr value (16384 bytes)
+ea_set -f d_xattr_ea_inode.tmp test_file user.test2
+Exit status is 0
+ea_get -f d_xattr_ea_inode.ver.tmp test_file user.test2
+Exit status is 0
+Compare xattr values (16384 bytes)
+stat test_file
+Blockcount: 48
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 13/128 files (0.0% non-contiguous), 24/256 blocks
+Exit status is 0
+
+rm test_file
+
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/256 blocks
+Exit status is 0
diff --git a/tests/d_xattr_ea_inode/script b/tests/d_xattr_ea_inode/script
index 84104549c..c24eb6cd5 100644
--- a/tests/d_xattr_ea_inode/script
+++ b/tests/d_xattr_ea_inode/script
@@ -15,32 +15,33 @@ VERIFY_DATA=$test_name.ver.tmp
 echo "debugfs edit extended attributes with ea_inode feature" > $OUT.new
 
 d_xattr_ea_inode_check() {
-	local xattr_size=$1
-	local xattr_name=$2
-	local ea_rm=$3
+	local path=$1
+	local xattr_size=$2
+	local xattr_name=$3
+	local ea_rm=$4
 
 	echo "Generate xattr value ($xattr_size bytes)" >> $OUT.new
 	echo $xattr_size |
 		awk '{srand();for(i=0;i<$1;i++) printf("%c",97+int(rand()*26));}' > $TEST_DATA
 
-	echo "ea_set -f $TEST_DATA / $xattr_name" >> $OUT.new
-	$DEBUGFS -w -R "ea_set -f $TEST_DATA / $xattr_name" $TMPFILE >> $OUT.new 2>&1
+	echo "ea_set -f $TEST_DATA $path $xattr_name" >> $OUT.new
+	$DEBUGFS -w -R "ea_set -f $TEST_DATA $path $xattr_name" $TMPFILE >> $OUT.new 2>&1
 	echo Exit status is $? >> $OUT.new
 
-	echo "ea_get -f $VERIFY_DATA / $xattr_name" >> $OUT.new
-	$DEBUGFS -w -R "ea_get -f $VERIFY_DATA / $xattr_name" $TMPFILE >> $OUT.new 2>&1
+	echo "ea_get -f $VERIFY_DATA $path $xattr_name" >> $OUT.new
+	$DEBUGFS -w -R "ea_get -f $VERIFY_DATA $path $xattr_name" $TMPFILE >> $OUT.new 2>&1
 	echo Exit status is $? >> $OUT.new
 
 	echo "Compare xattr values ($xattr_size bytes)" >> $OUT.new
 	diff -u $TEST_DATA $VERIFY_DATA >> $OUT.new
 
-	echo "stat /" >> $OUT.new
-	($DEBUGFS -c -R "stat /" $TMPFILE | grep -Eo "Blockcount: [0-9]+") >> $OUT.new 2>&1
+	echo "stat $path" >> $OUT.new
+	($DEBUGFS -c -R "stat $path" $TMPFILE | grep -Eo "Blockcount: [0-9]+") >> $OUT.new 2>&1
 	echo Exit status is $? >> $OUT.new
 
 	if $ea_rm; then
-		echo "ea_rm / $xattr_name" >> $OUT.new
-		$DEBUGFS -w -R "ea_rm / $xattr_name" $TMPFILE >> $OUT.new 2>&1
+		echo "ea_rm $path $xattr_name" >> $OUT.new
+		$DEBUGFS -w -R "ea_rm $path $xattr_name" $TMPFILE >> $OUT.new 2>&1
 		echo Exit status is $? >> $OUT.new
 	fi
 
@@ -56,15 +57,33 @@ echo "mke2fs -Fq -b 4096 -O ea_inode test.img 1m" >> $OUT.new
 $MKE2FS -Fq -b 4096 -O ea_inode $TMPFILE 1m > /dev/null 2>&1
 echo Exit status is $? >> $OUT.new
 
-d_xattr_ea_inode_check 8292 user.test1 true
+d_xattr_ea_inode_check / 8292 user.test1 true
 
-d_xattr_ea_inode_check 4097 user.test1 false
-d_xattr_ea_inode_check 102  user.test2 false
-d_xattr_ea_inode_check 5005 user.test2 true
-d_xattr_ea_inode_check 512  user.test1 true
+d_xattr_ea_inode_check / 4097 user.test1 false
+d_xattr_ea_inode_check / 102  user.test2 false
+d_xattr_ea_inode_check / 5005 user.test2 true
+d_xattr_ea_inode_check / 512  user.test1 true
 
-d_xattr_ea_inode_check 1024 user.test1 false
-d_xattr_ea_inode_check 5000 user.test1 true
+d_xattr_ea_inode_check / 1024 user.test1 false
+d_xattr_ea_inode_check / 5000 user.test1 true
+
+# Create and remove a file with ea_inode
+echo "test_file_content" > $TEST_DATA
+echo "write $TEST_DATA test_file" >> $OUT.new
+$DEBUGFS -w -R "write $TEST_DATA test_file" $TMPFILE >> $OUT.new 2>&1
+echo Exit status is $? >> $OUT.new
+echo >> $OUT.new
+
+d_xattr_ea_inode_check test_file 1024  user.test1 false
+d_xattr_ea_inode_check test_file 16384 user.test2 false
+
+echo "rm test_file" >> $OUT.new
+$DEBUGFS -w -R "rm test_file" $TMPFILE >> $OUT.new 2>&1
+echo Exit status is $? >> $OUT.new
+
+echo e2fsck $VERIFY_FSCK_OPT -N test_filesys >> $OUT.new
+$FSCK $VERIFY_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
+echo Exit status is $? >> $OUT.new
 
 sed -f $cmd_dir/filter.sed $OUT.new > $OUT
 
diff --git a/tests/f_orphan_ea_inode/expect.1 b/tests/f_orphan_ea_inode/expect.1
new file mode 100644
index 000000000..3eba3d718
--- /dev/null
+++ b/tests/f_orphan_ea_inode/expect.1
@@ -0,0 +1,6 @@
+test_filesys: Clearing orphaned inode 12 (uid=0, gid=0, mode=0100644, size=0)
+test_filesys: Clearing orphaned inode 13 (uid=1000, gid=1000, mode=0100644, size=6)
+test_filesys: Clearing orphaned inode 14 (uid=1001, gid=1001, mode=0100644, size=0)
+test_filesys: Clearing orphaned inode 15 (uid=1002, gid=1002, mode=0100644, size=6)
+test_filesys: clean, 13/128 files, 23/256 blocks
+Exit status is 0
diff --git a/tests/f_orphan_ea_inode/expect.2 b/tests/f_orphan_ea_inode/expect.2
new file mode 100644
index 000000000..bf76a5c25
--- /dev/null
+++ b/tests/f_orphan_ea_inode/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 13/128 files (0.0% non-contiguous), 23/256 blocks
+Exit status is 0
diff --git a/tests/f_orphan_ea_inode/image.gz b/tests/f_orphan_ea_inode/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..95f0e53aebd45e041b4b1f53be7c374c8144c1b7
GIT binary patch
literal 2139
zcmeH`ZB){C6vzM8Hrp}7g@%~MtYvweYvyWYCGO-yK4OW}V<wpzXd)%L%m=7B52Z~^
zQ={e6O5&KqaG4HETqaXUP01LVmg2*F0G7z3!f&v>*_*xGyS^{(x%d9g@7#Mo=U!CN
zx^;`kZBo{(O(w?UlOWkxD8Vt(5&DxMNiEw;EPH7y+Ew~8s5^)kG8_|gs>t&FoaZqP
zhX^f4FF$nsWQ%V%)-Su+(l6Bj)v?|nzO6mdz3EPOer?uZ1ll)s&Ai{i%Nu890TO2K
zshf0{b{<Zv_<<poPxa+^D#yc4?<l;OGK`3u+<CLg<*w-W<I&Z&TQxBKQZK^k`xB!I
z(xSjWKVP%@5e;nGe!!u<P+^A{(m#3T?#y#3+&#B^K;w?n8!FVs+wQPuX=y9mv_BLa
z=6Qv2PmV?vhTVTy7c;X9{Xof3m)GR|oFiSpu)UCoih#ockGL374P)C>)fKnfhQuM3
ztE3o$LWqHZD0#-n3TAl<f}q;T^&2Retol@MQ}DTA*g>%tf_w_xidVV}P2DUekE)eD
zT(0*hq{s=2DLZ|=cfjpP$NK%@=c#ATI5bt|@jRbe)6n{i=2q(KOUp^UXH_U#Uun@v
zibGUrxGp$!c<IY}PVE{YCR5k~q_VDufa}qrdE~6*s9_O;x6eT`O1@ed`+(FRn2_dR
zy?yp+&_3XFs02d_6Stp^N{Bi#Yr8ZraBTIL_E9OTb@d@SI&nN#{_FNup8eKF^qsOO
zqmqFvSOVkM=-~sio=0EA9y8h{L<fM1e&apib)L>gIAYUPiAMJD3-(ra9L!`-503X&
zkE^6#8;v0xBSQ8}OeIL;lcoEH!L8Ob?!DL*>IBEr%AXAqYhC(lf<e&c!9rpa1t~yN
zROqvHMj-DAi1se&rBWj}t3|)vFRr%EM^&ByvH|gy4IU$Un2?-Mx~$FA^ip}&LeisK
zMvT5Alb4%Cyn)UP1b6qGr{*f{1-#`qLPf<rz=XvKHf=M{A^}#ihNMxl8`(<!IBOM7
z=?Vu{qUa390%0_(p($2JAJg$)p88HTI~3?`q@4qkMSSqK%?ZGaTsb#=nv};~c|3`S
z;tkGKjZz$r3up$s<cf@zu0*Io+u5{!G4)1V1%K%aHgejF{rVU<@yn7Td!-oe>@~D*
z0Vc{mZQ6tXP$#y`cS52**Q|e%QQ8=WpBK$J4K_}_l~<2P(lgK;5~jzBUMu8J=*SB{
zu6o87DJL#ukb`Hs$o89qW=2h^DO_^T0O|gm1q7WOdI3WMASpos)5bw|%t04(St-?I
zI<+XXZ&F+7Op7CM4HI=7$IonKxlbh#x3CCTLZL{v1h~&|gDaytp6nCp!M9BLOtX(e
z)ppMY*hgR0Ug#Q`KxpXdycinpU<q<si|6gN=q#7j;8mhaAKp)|TL9rd#RA&=v>uJ!
zB?fibNa<QO0K9aI&P3I~31I2szuSflXauk3xuJ7kIrh1K({`9b!eg3<AD9nik=amQ
z4A7F1hyxGu5`+1`8GRLqB}7xt%qp6>bru0;9?UEe*0yT@Se{ymzx_(1Yw1fztv6+{
z&4>Pe{l|1(NBH&nZ1g*N%U^UYwDJ`y93DU>!vnq1xwwn%W;V>4G3=h2i~ss#c00=v
i9Rno8r?2x(P~Yhtfp-M{Zvr7`V4?Up>pcjvf&Kz@_kh^|

literal 0
HcmV?d00001

diff --git a/tests/f_orphan_ea_inode/name b/tests/f_orphan_ea_inode/name
new file mode 100644
index 000000000..b892ff960
--- /dev/null
+++ b/tests/f_orphan_ea_inode/name
@@ -0,0 +1 @@
+clearing orphan inodes with ea_inode and quota features
diff --git a/tests/f_orphan_ea_inode/script b/tests/f_orphan_ea_inode/script
new file mode 100644
index 000000000..9650d07d0
--- /dev/null
+++ b/tests/f_orphan_ea_inode/script
@@ -0,0 +1,3 @@
+FSCK_OPT=-p
+SECOND_FSCK_OPT="-yf"
+. $cmd_dir/run_e2fsck
-- 
2.43.7

