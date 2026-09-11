Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020072.outbound.protection.outlook.com [40.93.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF83C42C50B;
	Fri, 11 Sep 2026 20:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789156944; cv=fail; b=HnkNgNjnKdtt5qztT0MdLdB4ytYgEsfe5/ZpIsS+rGMtqfz7sIE3StlGn+swbmhUpX5fdmIlyXD0A20nZ8W5EBzIO/o8h5yL3wvbwAITUPR/spdyYjBvQXrjCTBvvk+bPx/7dRIghqbt4X5kAoe67btru37Vy6W7OBWEvxPmL2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789156944; c=relaxed/simple;
	bh=jiL8sKzP7KDMOpDwW8hFnws94s5AwWkbc+sggjJ7NcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rBn2AoQgVjbY80scL+ICFE8n3jcMnBMSINBn1Xiw41M/XxyAdXhPDxkCpmnxPEqmdWJy695l9ZAXsqH1Woq+Q5DbW49562SkPF0oNvYhvktPjx0rDipbhnp042lecWP+6m2LktEWgvOCaP1VIWPrA72v4AZV+hdu+FRBgAlorJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=wb9t5tBo; arc=fail smtp.client-ip=40.93.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="wb9t5tBo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ukJLNSQZGA/4tm+qWIpmNqv+MuV5jmgDzFaKvcLFHtlQd/3v5WRxr2D9Fomals+ot779fEVK6xU4RjlQDSoI2q/pA9VjWcrRBda7VXv7TzRMC9Ml/3R67/El5BomdZvK+pqRpu2yYa40C+GD8qnrJZfTUmB00JOXTql9vyib0vwN6EhYDKl+ZC40S0XWrNcpGBFvwio2u4s2FF7xMIAWxMXKs+1eAYVkjF0NV56OLCXtXENukxHeofRD8rD7FPpOZCkJmX7fxywRj2MOMEj2AJYBS3opV7CFHEg9KynbN7Pa4sYdS6IrdoZaP04q4Q5PI1fLltAhbWafhK6HNrSvRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sbJ+OAP7gWrfuBsYmIdI4DqpwuTVn9BYnjqs97TgeZk=;
 b=d5BEnHijZg9xYK/oNJK4CquOATxkKK4Ec3MWDqiAF2HqMnPXEDZCToJBSVXJKia3i+Ia6rIEC9BO27cvYDI8ACkyKbZidcXBAd1ws3ocwGCo90QbtZLr0Yr1DDvTt0e0BFSd8DW9N4ol1OOrVLDDlKAJEFfBMZvXMEB8NliuPqT6i4oF74rMZL6aSvQM6/DiHqn4WWZO+A3EgzuBqIN5ajrg7G5r+RurITITPnaLSA1wYv2pOCkJc2Sv8cVrUd+v3O8JkI4He5lD+pJA11lbglKMh3m1pvzoack819lJf3EoNIlKxBMjFhZU9q7VfYpf8WiNZT4Mgp05uSnPs3Ww2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbJ+OAP7gWrfuBsYmIdI4DqpwuTVn9BYnjqs97TgeZk=;
 b=wb9t5tBoY0zphEYFJ7CxuSStu9IGXxyoo9qhiHlBRGK5er46CR3I7D1PcRvsfLv16R0KiTX9sJq/gE8VrOAIuWPD6VhO+iCTP2sJJa5uElENiSgAlUhxBVbK5+zIfZJtFQ10paVYsSNBHycuK9Yjbn1VkEMvjf57mY3yUClR67kWs/IqGwIJoC3f8VmRf542sYQeM6a328F2JuNzOG+z9CJYJfPb1bA+ZsWn6RgzvR9CM/FmbJelyzpv61ltxaYhXd89fr2lMte98NmcFuSYm8/TtQDN/wBzp6vh+IJ+qf3/ejPQ0lWPygmsJwG7/XxD1qDRN4hAIJ2kRBcNTxgIvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 CY5PR04MB994403.namprd04.prod.outlook.com (2603:10b6:930:12a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 20:02:02 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0406.005; Fri, 11 Sep 2026
 20:02:01 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Jan Kara <jack@suse.cz>
Cc: Timothy Day <timday@thelustrecollective.com>,
	Marco Elver <elver@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Support Clang context analysis for ext2
Date: Fri, 11 Sep 2026 16:01:51 -0400
Message-ID: <20260911200152.1588568-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <46mgpyanbjl7eiln3nodqtpbubrwsc5blcjqd6r5pfokmssrce@k5qgaws7b2l7>
References: <20260811160336.782342-1-timday@thelustrecollective.com> <xiymqvu5la6h63umrp6upnzbl3xjjcacuyxg76xp4labnrioyj@xowfpjlhfrzh> <20260903072759.GA1750084@ax162> <CANpmjNNWiX51UU064+P823sDX42=O6ChSHrUux1aNqLj60mfUg@mail.gmail.com> <hnmqtyjazturtmhrw5xh445q4vrwv2mldhhspl6sf4hj6yzvqn@vzje2tuhtzdq> <CANpmjNPBxfgbuyK1VWsCukurEzhR5nFg1ydwEP9Gt0sGm9p5GQ@mail.gmail.com> <46mgpyanbjl7eiln3nodqtpbubrwsc5blcjqd6r5pfokmssrce@k5qgaws7b2l7>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0125.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::27) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|CY5PR04MB994403:EE_
X-MS-Office365-Filtering-Correlation-Id: 94aa69fe-74ef-4bba-c0f3-08df103f8b2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|56012099006|6133799003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GIKW2bFRhO0Wsb8VHLcJwFMgEz02yxq5t4Na/fForH0l2Zq0cfTL20Pr7Xb2ccAYjgk7clsQOwFhXxD7Na7yTeRlXBOPkfPyfO9bjFqEwu60BtmIZy6DFiOUtuWl67sd/6fWIepThXuvh8DuDF29K8dSN6Ppq2l0XnSDwwjuZA0nZLGlNS94UAdnk+REurMTyxuRNwrtZ8P9QCjjAbVumUbP70PX1w1BkRmFmwUPrqjWXeDnIQKukQH7tonVXVANy3mhQCE5b8S6Nhmzbc8DCNXTpNXwNLJuHBCDDzEfXn2K9abIZ0AfvThclzUtrMXRbtChNlMiVgOI+E2nNUMJfuPCT9kA+iOZy9nwtG8pgri74zzIWg/nlB2Pjc/cuPLif7ZMmA54Vu6v17hFnKI7MYSW27AL312Od2Zq5sY01TU5K+WpJddcTDlFg9ZYAmd7jUkNXA1HNXuKki95nZu+ReEYvFIG7Htv++2Ps57u4BkPd09NVjXy8Oesm1ZY54Zg8WnTPW4O+PQJbfmtcXVeqoGDE5bxSxxgBhMICbglqv9qnwYpQiYf+URk3MtKU3VklP/qmU6GJd+/M+hREwA2lyydd4mbSBRUhvWTHtYWBVKEymDXeTCTbTPMQBCf25TWfv5GZjKMJSte0WGAbj58ejGslKXNif5V2SfGOp8TcYs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(6133799003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hSAcoAxE5zRlGLMH8c6KKcZpyTmfyCKF0Tp4VhaIK2mb75WuAx6JUfWQkrf5?=
 =?us-ascii?Q?qhHANQzIYw3A/qkpoFJh0GGr+BRNTNWNhBnY6/eCGihIqNcTZy5YrnJWiXnV?=
 =?us-ascii?Q?m9Zubl/ZsG9H2U05jdC0cILR6pZwF9Rnl/GBtvFA+P4RVvl4sCuJC4zy0Fw8?=
 =?us-ascii?Q?N3UcFh7cm7FJWOK564aihmXLk9g+ehdsO6EFE9XxUQQNSM+hHBkeysIOP36N?=
 =?us-ascii?Q?IKmPz2IaTGfcDEU1xdWjlGSLjYUCMYOvuFNB/XPYXeeuKFaQ5IGOfr0b9kys?=
 =?us-ascii?Q?QIYWY3n7A7Yc/bMmOUxt026FckedXI/duGItY5bTVUeSVeT6Mlk/9DWcXaHK?=
 =?us-ascii?Q?IQbwt8qtFydYV4IzuFaVjUcNNuQTA9b+XAKDDE5jiQ+mK6f4vBbV+xD3dEBF?=
 =?us-ascii?Q?pLPoMC5E1h5op8gGlJt6RqTdobV9cXCpW98hN4L8j76BUUBayeKHtqPsOy2m?=
 =?us-ascii?Q?MImWihGlOZ8zYj4qlPURn+RYOlCb8zlIOQnKTZwhVZZ0Dq1KnKAG7/VdXpIV?=
 =?us-ascii?Q?+PctxglHFonvJ277AeQg+2TSIwc27Sir666CiPsHmnB9fTps36pI2gt8Daf2?=
 =?us-ascii?Q?DQfWGmcBzUJtJS9C2WrAK+MD49oMIgAuQ6fokk6prv6uSBmqshu4+VCTYXDm?=
 =?us-ascii?Q?1SpIqjDgo5k7xng2zU/cDhx3aMQLQgVJuHlamBgC/eEJIbZxyeVj1myz9n0F?=
 =?us-ascii?Q?3RTnFbG5p6jTfkc/y6jHTUrc8mQuDpJHIyer/uybGxagYCZQwhohsHOpwjxo?=
 =?us-ascii?Q?7cKG3kGZrUkwBxuO+XMZ0fUuegBRlWTeGjZNC+5dog6jl+MJTCJAQupetPvm?=
 =?us-ascii?Q?PTbi6aS+m6guxcxhM1GNwTczXzNp9lQR/nBg6mUDnHSLtoJr2DrcU2Ex0gjE?=
 =?us-ascii?Q?vr60EVca1d3wpK3amtkUsDLzqpAy14ZhMuSq5h68wW10JBm8UtwnzDvdiUTc?=
 =?us-ascii?Q?ckQDqIH6MvNJPOfbMDXEgMYHV818Y00nMm/OQhk7wpHeI3CWEZrIt/aWFrWJ?=
 =?us-ascii?Q?7Dy9YYRj6hYNUdSfBvgYBGHgg9+L4nUakUDj8XFDI+IHd08Vr6vwb86CSlWe?=
 =?us-ascii?Q?g6hJqOYl0RdKNXCMuoKgEb2EDnVDyXMkjfXKC8/zCVOnGiVKcEx87UxXg3OS?=
 =?us-ascii?Q?mdulvy1wjsnbdfYQvGi1Lyl4vqr4yh7Np32NfQdwmlAjQrYAv2u51egmnqxN?=
 =?us-ascii?Q?HGOMYK4flp68szYvnSJEGCIhhucPBzIFlxmxhKZ0nkmoWUZyVOwvzVDyNVcd?=
 =?us-ascii?Q?GJJPD+tHKWXHl2mqyAfCA3RFg4FJYW16GWVSUh5INSnNlXpPjoQ2eehY+4bj?=
 =?us-ascii?Q?zIRAor3lXa4zT6g+NEkYyHhVfWDifk6m4mJZy2QBCl84gZu1/gbkC+vUG+uv?=
 =?us-ascii?Q?q1WlcwJZFB4sUKTKiHvTTQiUBSOH9/LTo1WT/uhVE5UAg9ZY+7JdA5XJ9MwN?=
 =?us-ascii?Q?dVhYFQhPXUDF6z+duRFN/YcMazsZvNPihnI5lgUzYnfJToQdCm+QCSzCt6rN?=
 =?us-ascii?Q?kExMBc4rPhAKz0/uNPJfUwF/an2ah6VKfZ935wuT1JCCsloVXP/QCAfTYkm4?=
 =?us-ascii?Q?erHc2A9UItIywGhm1d4u6H8oLJEAx/WRClJM5kRURYq5K+7bd62T598/MGD/?=
 =?us-ascii?Q?0pjyoSK/90Ic+l6fo9GmW36FQEfKcl+XMhUtbBo2w7SfY2ItUXeVNkrxlW0f?=
 =?us-ascii?Q?PBuXTZeKhN/hDB2c1z2YdP4OEuZgEOJxd4z4Fox0Vt5eLxTfCq9Zr+XjsAoh?=
 =?us-ascii?Q?3HH8VLPIRbMAhBJv4PBVsYKNL9dVUcw=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94aa69fe-74ef-4bba-c0f3-08df103f8b2d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 20:02:01.6057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: znP6JmfJfmKwLRdJevq2IwuGpP4Otse/1Ak6+dZe4zjyN3bNLKRkdWqPuArN4H8ilsdCRQAmImKyVfvTqxiI70/U8eJgOpAbVplIknPZjPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR04MB994403

On Thu, 03 Sep 2026 14:43:03 +0200, Jan Kara wrote:
> On Thu 03-09-26 14:06:22, Marco Elver wrote:
> > On Thu, 3 Sept 2026 at 13:06, Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Thu 03-09-26 12:34:34, Marco Elver wrote:
> > > > On Thu, 3 Sept 2026 at 09:28, Nathan Chancellor <nathan@kernel.org> wrote:
> > > > >   fs/ext2/super.c:1149:3: error: calling function 'ext2_rsv_window_add' requires holding spinlock 'EXT2_SB(sb).s_rsv_window_lock' exclusively [-Werror,-Wthread-safety-precise]
> > > > >    1149 |                 ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
> > > > >         |                 ^
> > > > >   fs/ext2/super.c:1149:3: note: found near match '_res->s_rsv_window_lock'
> > > >
> > > > sbi was just allocated, and EXT2_SB(sb) and sbi are pointing to the
> > > > same object (unless I misread the code), but the compiler can't tell
> > > > since aliases can't be tracked through non-local objects. So that
> > > > scoped_guard could just become:
> > > >
> > > >   scoped_guard(spinlock, &EXT2_SB(sb)->s_rsv_window_lock) {
> > > >   ...
> > > >
> > > > But I'll leave that to Jan and Tim.
> > >
> > > Yes, at the beginning of ext4_fill_super() we do:
> > >
> > >         sbi = kzalloc_obj(*sbi);
> > >         ...
> > >         sb->s_fs_info = sbi;
> > >
> > > and EXT2_SB(sb) is just sb->s_fs_info. Are you saying that clang is not
> > > able to infer that sb->s_fs_info and sbi are still pointing to the same
> > > memory later in the function where we do scoped_guard()?
> >
> > Yes - alias tracking is only done through local aliases. sb is
> > non-local, along with additional member indirection; unfortunately,
> > the C language doesn't give us the guarantees that it wasn't modified
> > somewhere in between, say after a function call (this rule is applied
> > also for local aliases if clang sees that they "escape" their local
> > scope via non-const pointer to pointer).
>
> Hrm, ok, understood (but still it's annoying ;)). I've pushed out the patch
> with the suggested fixup.

Sorry for the late reply. I was out last month due to lung trouble
(spontaneous pneumothorax corrected via surgery). Thanks Jan for
pulling the series. I took a look at your branch [2] and everything
seems fine. I agree the scoped guards can be peculiar. If you
wanted to make some minor changes, I have no objection.

Thanks Marco for the compilation fix in the other thread [1]. It seems
like a reasonable fix. If there is anything else needed from me, let
me know.

Now that I'm back, I'm hoping to resume work on some more context
analysis patches. I have a few that were close to done that I
hope to share soon.

Tim Day

[1] https://lore.kernel.org/all/20260903101843.3462767-1-elver@google.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git/log/?h=for_next
