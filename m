Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4C37B3FD
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781892443; cv=fail; b=Yr7nxjc907e3LlmvddyDUXIF1PMq7Qgmb7Yas4pMSafIUZFiiFaPD5pO+gf0NRESRjSoyZ0JWPHPfTS/SpbZg/HVGHGtXy4DodVIUrxAY0Y5w5NXAkSGjITZO7rjCchigtEyPZdtK7MuOcxeg/g6coKx3zFKfIneFEMhorPpaZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781892443; c=relaxed/simple;
	bh=izoYxFp7wQV6H0bLvfDp+u5VpsfvC9Q7Tt9QJj6K6QI=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XOK9G8INHAeOtmbhANFkN0UDSjptV2WmjvlNFAWfTzzFbBAtMuOu2WtF8ffhIYCuDO5A7VmOqzWTC/Ivqw/ZzXnS3bMbQezJPf5Nm1mwNcTh1LdDG9bPMWOLLNJPARlAl3YdtV4Xih7XevBkwSpbRxn1Md+VPjtoHxR0WFGMDZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=yBUHie/z; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="yBUHie/z"
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022111.outbound.protection.outlook.com [52.101.43.111]) by mx-outbound40-102.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 19 Jun 2026 18:07:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qor/K9bxk8pTUz/xzyndsRzWFkbO9mJf98BP7MdaJLEqq9hvb3ENn0cvXP6ri1ppsDlojpsV73oekNUZJ65V8jWtW/VBm/+cv/5W68Lg/2nqteuLYl97bb3jvICXANOwTwd2+THpR5fU3gRJkhXp1Yq8n9HFcd97o6HA4CC31k2RNU6rvVBn1pBg2VLCidktKy1gNhSr38/7aLOOolkGK0L3PGsaJxqkX8ndWpUkuoXAvJ8vNYT26FVz1sk/n05V2WpjX4YQAwyWnZ+j3G6rY7lqwfzFaNO0UhpgE2GqkrgPCdssOgSGMR4gTRm6TtvOIZ8Qd17vDGtJ1I+vRYovAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHHLdWzJzuD0ZlCuMtTItUfjtdmW4wLja3Dv45iiJ+Y=;
 b=jmEFpjyiVvZnSDctDdxvyk/rGFwS7ZVfhPeiwptZVFhXCRHGxt7OXZjbUSJPS5s54oJubl1SyvIKh/NcDv71fQprNA/63VJm/uEDU97nJdWgrDVm0ZfqjBODIxAtE+ocEikDismAWeuES31D6GmmRZhE61nRExKxFa1uU54NyjjBJk9/7/bfYk97zMYcLBj5UkhX1jYejG014NBVvceBRkxHhgFwhSZo2xI0lwDU0CwXlphDLPicCLIDuykbfNkdW3m4APt1VOIq2tvJdX5x/+QePP+zX0u0saXWNBz0qyMOrHP7iyFPRP+PG5UseMT+YIR9ci6Sqs3CjiD4Wz4bEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHHLdWzJzuD0ZlCuMtTItUfjtdmW4wLja3Dv45iiJ+Y=;
 b=yBUHie/zIl5Y1k0jvm9WGaH1tTgE7qpXETk3SGNO4O3Wl7/qXMCmJZRtzuKvc1djSA9+676pnu0X7jggWrZUZ44lB89LKyXjH6Rbl/dXOHsZIUDGIl32O03TTILEeTfity5HMMip6IZJ70/IxguVNemw+B37W31HhYK3Gx4plac=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by SA3PR19MB7816.namprd19.prod.outlook.com (2603:10b6:806:300::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 15:33:22 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0113.015; Fri, 19 Jun 2026
 15:33:22 +0000
Date: Fri, 19 Jun 2026 17:33:17 +0200
From: Etienne AUJAMES <eaujames@ddn.com>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@thelustrecollective.com>,
	Li Dongyang <dongyangli@ddn.com>
Subject: [PATCH RESEND 4/4] libext2fs: add ext2fs_xattrs_release_all() helper
Message-ID: <ajVhPVDjGvTExQVW@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajVdnQUu9tSrKldW@eaujamesFR0130>
X-ClientProxiedBy: PA7P264CA0027.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2df::19) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|SA3PR19MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 3031374c-c027-4415-d59b-08dece181873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|19092799006|23010399003|1800799024|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 Cuup+W4U3Bbm5K2KdfdMfZqvPrlyrw+quX/pnYzct2Erws4tHYy3xCTDFtd0DF2qR4ih3h2Vw9q8YZ/CltpNFqbiunoZAVbpY3RFOP+W6FaTS4+AuF1oLXnY5w1Cp68rzgQfzmnY31z6ToNAy9LFQUQPTn9roWDxZT9ROFjvKhmCE2EiQrPBNMM0m+GMiA13dSH9YDJh3+rP/GbK5g9IyTOp0yX01byx21kdT5vqy3zwfAMpZKOWsnN3NxV8CpuveTMbOHdOzz97GzKOJ8DFxl3JE0bRPfxYmTF8LCW2GvUfB1/vPpc4mYdBrmqEOmXVH5+oMlja436vtUsNeJzKo17Wp5H1Brn+W4MGdOqjsu1yt6PnsibX4erCcvZTS0eqV52XQj5WnGYsXcDrRkq6ccQPw0HtcvwrIK0CAch65a6b4AwEjoIHPX55aX9DIkY771cP2b5gs50Pkvf6NPSXLqneJcEv8wA/NKry2OFZYXempetSn61woa7tkDEQiDcQBxi/W58yntcr7peT1JffBEejU5JlHpBoOCC6rKNVIN4aoNlVWk7UMCZ9fXatLn5ST0CeEAsqEgVh/nXoDyBAdi4zuAXkeE5KuAiOYLJvaEe/6PmthP1xxo18z9bYV8fe18c0q+RnYBXAz0xGuyxmu3pFRdzOA8cqSCXhaY1ULwk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(19092799006)(23010399003)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?nYMz5BjpSKW0FZq0KsG301MXGODSLww34gFWePGkv6HrG/p2+P0befQW6fX+?=
 =?us-ascii?Q?Dbit8ZJmr+VqQudKLLpnP8R25WBHEHkDZ19a+3TYiDwTL2fWMhe2SaRfy+25?=
 =?us-ascii?Q?ksMvGL3NaAM1z2RsWYc3Rg9vkw9bjzs4EB6zasx/YKyAXqqgu7JQm91tnr7P?=
 =?us-ascii?Q?zAiZpjq/fyKqhfT+aVG09HsiFqTYJaelFt/n0OinrKV7RXcMRPC+VRJeDRjw?=
 =?us-ascii?Q?9OKZrQEi6Y3Qzgk917mSp+4YyC/8XMVaQEjklWxAYm4ZnjdNPsNemE4YCLc5?=
 =?us-ascii?Q?bza9QbIyMv8I64reeW233IHPquiTRW4L1Eyd0lvSBlfJee68A+WiqVKQ7g0U?=
 =?us-ascii?Q?fRJcwg7xo15ftOF95ak0oHWxRhrGLs8P3wAXzAKXsZQq5fDwYIZBjNGzjC0/?=
 =?us-ascii?Q?xkXiS4F8hLfBm9sYdcWBg1gd5IjSawwsKis5ZsOpaSLyyPT62cExIyC2GbQ5?=
 =?us-ascii?Q?2RZ/RF/nDjjrcjArlgzWfkmiXelHB3GliGf5AZVGOKyW6U5Zd92HtlAyi7Wk?=
 =?us-ascii?Q?zP3+r/aQR0le/A2MrspC/YdBUi9bcdZe20Q6m9MOwY10BgPxuOVJJJR6jdT9?=
 =?us-ascii?Q?UegEIXT3aEZh9CKJ5PuQZ0ZKSwDGhUCRY4oznIJJ4acyEz069ySo5bPHkRdF?=
 =?us-ascii?Q?FY5uInNcfpxH2NOq8lVp0uvnLSEI+qvMXwsGuSz1LB+dSZD6jlVXxbvEzw4t?=
 =?us-ascii?Q?n/9j6d3Ahfbs/AS20cj+TIVmH48hseizeXwBVaKzDOws3ODvzuPTOopI1d7t?=
 =?us-ascii?Q?YQY2tjY3s1+7JBvf2Ay2Ykc1AuFrfCMvxHZvmbLTgl3py6PI4hmQT7Ydhmnw?=
 =?us-ascii?Q?oO6DQBJ820kIzaH7Hyre/JbNqT3Dv1q2cP2c+RFZRurTl2cOF3uyK2VdM454?=
 =?us-ascii?Q?vuYTlnsjbTQDRbUYlNCPWtdYsFcm9xwNmVaagiMi9lkOaAaTRLosHX9IJvxU?=
 =?us-ascii?Q?UhfP44MuDaeaDnek2KY4Jyk9DmYsiJ0o9HD6ojDbLgxxZYeZ/9dzcOWC0yoM?=
 =?us-ascii?Q?4804f8yJwJsaDHoDyoqet4+EN0EdgxK0jlQHdYK8z+Fr0F5a4EUe/tCZzjY9?=
 =?us-ascii?Q?sUsSUSnVlIcri0OXwjlOIO913WxWcFK8tiF10DxnMdcorOlJKCFxYIrQIJ0z?=
 =?us-ascii?Q?y5zJCdwZSwnkvyRqF9I45asrDQ+mahPAKDefqOUMw2WI9TVGGMbJ0g2tPw48?=
 =?us-ascii?Q?1yCWbETar7HGvIW75GO3bmg2fHYGzzQDE5d2KaUgjmmGlKX8p5T6O3UxToXd?=
 =?us-ascii?Q?GwPHHWoHhvKG+YvjgLDAN/3XVQ4bC4r/ekpUXQjupgmpswdxRQOZtx2o5rk7?=
 =?us-ascii?Q?v7W0vAEk/RORur3+v8P49FtM3qWkwSCasAaLedI9DJNUdAIc1i8Aj47O1xky?=
 =?us-ascii?Q?kx8TADgPlarOIVvs5SLK7gbuKX0KbjWg5Aoq8d1ZsnXq/qTCDbC+Wfp5E5LO?=
 =?us-ascii?Q?ZcbOa6kLPraJ93tOsDmYJ9f3BGlOedBV7BzG4ACz2FnYCqjPjZXfJrwTDNKc?=
 =?us-ascii?Q?Y3gtEwKeEPHRfwXfY+vnYiKaGAffrUUhdbpcc7zKgS0D9qspxVdza/hclMwE?=
 =?us-ascii?Q?vEQk+jwWacT71cPKsBn/Abmb7E3IvZBr+pmbTaGPWoTcUrrsAkpF+c2pAV7f?=
 =?us-ascii?Q?PrJ/f08KQjyPg9tkYmmbXG+CAjXxUSzv3SpI98BSGNuC7aboYCSRYlzJ7jAQ?=
 =?us-ascii?Q?w3aPyBlsQM/IdmZ0SwHCX0mMXmwi36x1CRFTDT6RJQN7904hPnu4uOuMKtZx?=
 =?us-ascii?Q?WvEymd9dNL2LSAzIBh/Vr4pvC2mveeeYpeA1pAq4wEwhteke6uAx?=
X-Exchange-RoutingPolicyChecked:
 k6zqm0XLUhR/c7SSxmNaqfbQ5O7nXS5mJgiQfG2xMWpSiBylJApvttcLWQBsCv57IuVUPe9+akIvapsTRUzpGuv1Wu9NYaQA/ROsAVRG1nEXka3IQ3qce7kyLGp1bxpUED0xXAbC4UNTicmfsgYruTMkuzGtRXUbraO8sHoP5/bu2TX5L1F27QsR4MGpm7xLmDr4k+Ak6lNuBSJAuOwzm7swZXTjBRIrVDXFFzo+Z9++p8rCN53wxI3dcEvuY9O2FruQMsBzmYEYRbmaCzm5zE99FiZg7LAgdMievHmiGtxJ4tKcn4d9YfAlASJD7fh77xoWYUGI4tjybwFEVKGlyA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 JLxmDB19Qgh/nFmCXNbshElGB3eKc02UG02qKB+jemRBMsi/LFnWPRm/FqJsseI21QyZooHC+92qgbaRZBy3BCC81re6M2XeQwGKs9vbPKK0Z+uaWxIr0tidsJu/+J4qhz6qZq/BCpcvytLjtPtEjvvDBhOi86hgW7sHLRKT49wN7pAJBk85i8UcOX3Sd/AabOSLQCqQRUJ0C42S+AB+VL02BFoYNVAU1Io2U0ZHLqxdMK8PxIMqxaaL8f51peOfKSjnVhGbzhCLd0O3uiEmCpCc08vHct9jX5Z6zQco15XyithVQ78N5ffUCIT4MR5JsnV7Cq5OcRkBUP4FNnQUI21UErI+JcA6Gob9aB59S/Ak+kbC6OMMycyrLQUz9a8EF3z9SFtzyNmkENkJDMBdxZHN5tRjwRoS8qBmHgaV1Q1i3MmAabINMr/n3xrmtWNw/j7nxX23w1iWKpkOTPxlWNX/ibzE/+FeFdt3DoxGPSNIdR00H4QdKtz8NTQxLvqZMdYeXbcTOY/0vJNUUU63BPqYLH+YCFcp/N6mHExwjmNMhN8OD36pIDVUl/rryNjknyTX7vKCU+peVyLBRV/GCXrWlxEqJMDneefW8bmjJWfXRpNGkJJ66o6GDDCxHHHvmGGMR3uRcRZSSJwqiIUiYw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3031374c-c027-4415-d59b-08dece181873
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 15:33:22.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/8+cmolMFLO3lWRjbg+6oiEn+8/3tUs2hOKCIYJ4EwdtwddBoi5fch+/FLJtPgN464YpwGHajUl9lsM2vSFhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR19MB7816
X-BESS-ID: 1781892437-110342-7734-6636-1
X-BESS-VER: 2019.1_20260610.2305
X-BESS-Apparent-Source-IP: 52.101.43.111
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkamFuZGQGYGUNQyJSXZwCLRLM
	3cMtkk0djQ3CAtJckyySA1ydTMPMXQXKk2FgDH6VF6QgAAAA==
X-BESS-Outbound-Spam-Score: 0.68
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.274043 [from 
	cloudscan13-223.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 OBSCURED_EMAIL         BODY: Message seems to contain rot13ed address 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.68 OBSCURED_EMAIL_2       META: BODY: Message seems to contain rot13ed address 
X-BESS-Outbound-Spam-Status: SCORE=0.68 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=OBSCURED_EMAIL, BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND, OBSCURED_EMAIL_2
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

