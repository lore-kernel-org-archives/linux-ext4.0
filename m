Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021140.outbound.protection.outlook.com [40.107.208.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E7A41C2FE;
	Tue, 14 Jul 2026 21:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784063661; cv=fail; b=NcfhioDkLzexNpipnGcJf3Y27IAKfzmhe91ZZ29fuB0GGmvC7bCDTKZWBfokO2rEOO9/EbsDRi5t6gMPB6dbLVV8zNB8svG1stWVMaib5cDMB09G9aoO6XFnGKhscIL4TFuq2UxUdCReuWfja4sOSYhM67IMikp5izMD5uwkQ98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784063661; c=relaxed/simple;
	bh=52p2/YifR5+Q08orb35x6Ceq+Oo6xOMLzETotA5Himc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KOv3eAxvL5jfRJsRzaDBddeM+ppWoZegf9RjZrzNN/gOzPoswMK+7cPUDxsvNIv/DZ6RHz89l81EEGoMeLl8AczEVYZUgr2ZNXYcdGaJjUMttnIYLpbvgIw5JHVvFVOIYUCXPb0vs0eosRzWShGUk6FTluhtXdoheMsv8nrSHsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=iTKP4vTO; arc=fail smtp.client-ip=40.107.208.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="iTKP4vTO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCCTWaj30nWP6iwKTe/CBBgXYECjKJtzc96UmlPrqZukwurpfmGnzwnpiseX5dcwEEKwVnGVdyLsxleUoAOpvS3p4Z+Xs2Ee1SD+ylM4UmqGEf/lFYiIfzqWjyu1X/QCNUM+6sKPHFA35Akb+ARCOZWgI+QILbjHnMfLItt7v6QMXjdBWRwLmW0cnR+m89hp8y+d9la8hnaYJM+GtMc7eLdlQRZsku9Uak+DGFwJ5rl7BrYetli7O50Gn8GoDJCmLPmmE01ZMmYPy/R9s5sVe34qZuZ3vGYq18Xi61EVBjF6Gc0h6JW0DLKapNpSG1YDGPZ9XCKiRTxhUjtzNxedDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/qD1WDmFGLG2f1NfFsGjGXz8ATc7NXHsrC6YBRoW9iw=;
 b=Av362fldt4LJSJP5W/zo+THd4p5VP6l1ivpu7sGEQGhbg8MN1UvgxhYGQEpXGc7lqpOVrPVJ25s7Y4lI8vo398k2h/7YfIGovvdMshCdLvu1G9GlIk0IdH1hW48ZOIxE/nTzRX+r1/BvePTCCHVK9x32MRIW49AKS10OHAFnMAgSUJEpD0+Yd4v42meTV1zlJTU8uohom2RkBBlQVFTg7oxhuEgqnYwt9xWNxd+92A/vB2NKwHg8wkIYBnfm4ul6BvMlcaJK1AeWGTS7/0w0SJ2Kqap+MiGy9VBoNE7KQWgqJePKnAhIznQ8+HTBLwksok+cE+RekTkjbifqB7rZRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qD1WDmFGLG2f1NfFsGjGXz8ATc7NXHsrC6YBRoW9iw=;
 b=iTKP4vTOlGJbv4d0YUziLZ3OY44LgrnWhw6/5tev/T5/9iwvY0EmbGEiIQmDxDCQ7bw/7IztHLdjLroQsGxM7t6kj57LO/QZtMI255E1bzNwq3LkKtSh0XfRc2FMVcuKDRfLm49rBf7BmU7cwDlyFSJMo+kYudK/lRUV79eUY3PgiQSOh4tdp8dOjZwTKbhlNjR0Q0/3LpzsHGYzpPxOzeMkZ64RCh2LPfEgxLKOaxNKH+Z4zcZzxfPbRhSKSEyYZkBnOZs2GYGGZ0QjUW9HV/KbVvKSGJgq/DrF7t+wBxzn3vMnhGkDaZEc8uFGCYWgWzodRMyf3SqQHdMP0a9+aA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 BN8PR04MB6388.namprd04.prod.outlook.com (2603:10b6:408:dd::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Tue, 14 Jul 2026 21:14:15 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 21:14:13 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Marco Elver <elver@google.com>
Cc: Timothy Day <timday@thelustrecollective.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context analysis warning
Date: Tue, 14 Jul 2026 17:12:46 -0400
Message-Id: <20260714211246.1046948-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CANpmjNM5CmQc_YG_5=zhdLCr7gGL3QYPcd4R4=m2NzwNY03d3Q@mail.gmail.com>
References: <20260712165610.366474-1-timday@thelustrecollective.com> <20260712165610.366474-2-timday@thelustrecollective.com> <alT2yHlfzhTZ9n4T@mit.edu> <20260713164417.350710-1-timday@thelustrecollective.com> <CANpmjNMfQT6Z9ke4x49sp6z8+pt_5ZLUoSh0da-99bwos5-8Lw@mail.gmail.com> <CANpmjNM5CmQc_YG_5=zhdLCr7gGL3QYPcd4R4=m2NzwNY03d3Q@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::33) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|BN8PR04MB6388:EE_
X-MS-Office365-Filtering-Correlation-Id: 788658cf-59ec-4f9b-9aaa-08dee1ecdaf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|4143699003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	X2M9fkf1MTXUTyfBqwgF/OLkeEIo5JfwghYvh9GT/LAZMRPyeiWBb2AePYv6M0wKd+AoVEMyz0/M/u8IprFMC1wmHwz7cX8DmCejlP7kmDehqvcDYn/tbeTq3QzgexaMymaP3PGvG8Qqk7Iw7YrO794e1AixtZB5eMlym9MW3SLYgZufDWZNjfli8wFv39vMhoUtokBShO+z2P6diKK9t1QIJXtsHCYXyHBA+jaFMqRYHuNR/ErcpOUYfpZmclM/dmhjdcBFocy8z716HkwMYdPRF5S1CdUKebvSQ8WbsQNANfsv0NKbYtiuIntKrs/ctyAVI1NRnbGTjuq+h91ZKPIlINbqvkDkgRvA79jsr0Byz47y+OCIvjKiuAwdXlv2VlkgfunUxALjeNdKcaYE1y6Y4oSWuU/Wt0wma6MHELFyxZzFjMcPGPePTj0fcJkxs758dZpMAO2cg0qlj0EUVAsSX4meMPuGfkJe2kHvfOJA9DSxMqdk3Fw0w2oxV0jONjeb6vrnJ1if7E1LV6Zt8UfN2Nl4MhaVzBhdiAJVRAHPZxzMtyaW8DRWI8/akqBSIEbt+VXnAv8ey/+FW9qI+zjI7zF6oINNKdG6TjSoXVv7w83GItKdYrKntircdi7QiERj4JuALh9XRxsyZKPsaYSZHWUbpvkng7irtdEYccI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dgUgCZ09FoFrh+UWlYF82b+IkgKT/sGrREIGI5De935At9125JX9MAv+wemg?=
 =?us-ascii?Q?wSlGNBpcOkpEJoLkQR823ElAj+hORvPPGKKvjrxeOieosm70Yq+fyofZsM+4?=
 =?us-ascii?Q?NlzpWvRFCCX8F/4/6rQcy0wmk9UldoV1XbmoNiiXolovaWLNajqi8g3MhSot?=
 =?us-ascii?Q?8xRZ+wIDqMWZniDPAwqTsiDkg9maYpTWzePY5EAok/6FRdn17z5Y5Up5hIsM?=
 =?us-ascii?Q?VGUMy3hMSD/Qx55FR3JulmChGESFetk1VgvKCDqi/13A/v5wo3ie8zS9RuzM?=
 =?us-ascii?Q?SlsHolOPB2ruVPR0qNa061+KlKf4aB+xp1lov+1G0XFCsFmlxKAjXCsqI2l7?=
 =?us-ascii?Q?QpHSDVT17eV7NTdgyIOTWKTzQObpFF9Qaw+wl6bzLXntvNtK0li50BxWeM9R?=
 =?us-ascii?Q?geEHrOW9YFVyD2ifN+8U292f6Wy6eYe4yUn3eZ6pIysQaQ/y09EigyghAhRZ?=
 =?us-ascii?Q?8u3GBMr4tYzsGIyqQ/6N3iCLHceHoOgDjx04HQBZV9UHAVGgeeHaSaXTVjRe?=
 =?us-ascii?Q?kkGtJ2pCAOP6s6Ej6LHBKahFdUA/2TFCg3ImkmYMwLA3uIVpHmee+LdVc8G6?=
 =?us-ascii?Q?i6szMaPp4ddTLPPcMtjbG50o5ETxVnvD80fVWQ3z/MjAfHfxr+oknJrHaTB9?=
 =?us-ascii?Q?AqgsNmyJyHB3HAHEoFU/hFkOqAHxASQN/5wjxzRTv2HFfZocfxAXEZkTltS4?=
 =?us-ascii?Q?AO9xm/6iBb+pSdgKQkzt5QXj4AbRyDQGXsJxk6QfTDHDgrVwr7hCepc5QEkV?=
 =?us-ascii?Q?Vq5qwnCh0/tW6zkQ4bWt99CgEPv/UokjCu8LqiJCGE+3orx7+gw1mX7L1jRm?=
 =?us-ascii?Q?SW5Zs2nK7TcBHzDQ1QV+SoglAsMA21f+EA3BOC3VWRhCbjdp74Xq+z4Gyo1Y?=
 =?us-ascii?Q?1c84mCoASPLvZlmy/5GaPr/Ic4+u75+j766p96gbVVYKRyaxkf0cUN9NHgjA?=
 =?us-ascii?Q?zncQZfEsMP3VD+I6L2YVs4oLjuHYQ6CtKSojulU72NYYAZmSYC842g3lRdvF?=
 =?us-ascii?Q?wcezVjeJeGBncyzwEJW0YO0Ukm0ZiEJfD6TY9tSA1cfa0at94NG6Gx6qanln?=
 =?us-ascii?Q?MeZtLLhQ9LluDZBiwDCaJiYCbVnMsNfSQoQpV6/4kumbzXd/zjEkfRutBOZR?=
 =?us-ascii?Q?NOfVcW0sG46duJANaucnH1osBLdmRJfbaLi3FMpcrGGo6p7VDC6uZNF3JC8O?=
 =?us-ascii?Q?bJxmjoU94xzizoDJYYpiDiIFhcHwunhazJanOqfWPUPDNlHXkJYOuJsgQNRW?=
 =?us-ascii?Q?7wRPrInVlb4g+iELudTGKOb/H/5Xx3frz98e+PKGb5zll1ePsaulsRQJiZMp?=
 =?us-ascii?Q?jfCgA1Iu0IPwchq8ip6XoZ5xCAwRwBi/ealUwcy+4se0J70hmRdIygD13+FO?=
 =?us-ascii?Q?/ThX9jEzU8Vqp88VitAFEl3lxXhMd/C5GLoSB8cUUiUbUaGn/OsWys9SEpCM?=
 =?us-ascii?Q?tzcmS2nByaK4bRuTwkuAwcT64Ve9p6KspyxFGk+IS2uozm2BY8UcrVdRwSUe?=
 =?us-ascii?Q?KZXgiS3nGqLVu0NKRJyCsTsWF/PPD2m7Z/asvm8JXkesil1AZzNq+vcUHEi+?=
 =?us-ascii?Q?JY7OF0uHbF6AsuFxl3BIjpR+M5XZXKFrUnDd2Z4PKeTXNqJQ65HZP6RBqQq5?=
 =?us-ascii?Q?zCy/mr/FOw8+8U3LlCSCCFPP7NDSVyfDTAQsy0+exEksw3G2SFN6fOL42cFm?=
 =?us-ascii?Q?l9AXstktYb5b5H5CHSFN8X+gsujsNCuCCF3ORetL3NWQ6++aShd1u3+crOHr?=
 =?us-ascii?Q?bn63HAnryyIYUHWYQQgfVkCQBE3fAwQ=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 788658cf-59ec-4f9b-9aaa-08dee1ecdaf8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 21:14:13.8954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNlJ41TZy4g7O4Pur3xo5cvL4nODOH9ribzrt6jtItgDiAtn1EjH0fMxET/wI8xodophbBVgWx0kDJE/npoTCwqwCbyqaiUn8TTiNhsdUcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6388

On Tue, 14 Jul 2026 00:56:56 +0200, Marco Elver wrote:
> Relatively certain statement expressions were once again the problem -
> this should fix it: https://github.com/llvm/llvm-project/pull/209330
>
> I haven't had time to test the Clang fix on  fs/ext2/xattr.c with
> context analysis enabled  (please do so if you already build Clang
> yourself, otherwise I might get to it in ~week).

The fix wasn't enough. The commit message on patch 1/9 omitted another
warning. On vanilla Clang 23, I see:

linux/fs/ext2/xattr.c:829:6: error: rw_semaphore 'EXT2_I().xattr_sem' is \
  not held on every path through here [-Werror,-Wthread-safety-analysis]
  829 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
      |             ^

and:

linux/fs/ext2/xattr.c:860:2: error: releasing rw_semaphore \
  'EXT2_I().xattr_sem' that was not held [-Werror,-Wthread-safety-analysis]
  860 |         up_write(&EXT2_I(inode)->xattr_sem);
      |         ^

If I apply your patch, it resolves the second warning but not the first.
I tried to generate a fix [1]. That branch has both your patch and my
fix applied. Those two changes combined fix both warnings. My fix
tries to add some special casing for tracking contexts acquired by
trylocks. It works, but I'm not very confident on the correctness.

About next steps, it seems like everyone is happy with the rest of the
series. But the first patch should be dropped in favor of a fix to Clang.

Should I submit a v2 with 1/9 omitted? When would we be safe to merge
the series? Once the fix is merged to Clang? Is there some kind of
periodic LLVM release we ought to wait for?

Tim Day

[1] https://github.com/tim-day-387/llvm-project/commits/thread-safety-trylock-rebranch/
