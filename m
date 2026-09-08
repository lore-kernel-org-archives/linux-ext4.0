Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazon11011071.outbound.protection.outlook.com [52.101.125.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E893E4F55C0;
	Tue,  8 Sep 2026 10:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.125.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862266; cv=fail; b=QBKgHgC3EXD99RqS/stZQUcuApk4VKgQuKn1KFy19H+49YjiPXhksbtbuTicuRUPRKQFp6srmac0cRj8hkk+D8669VmYBYUWpA9rehq3ore81ugIrVECenmD4fgkeCz1Jco0JSQ43bFWzzXNjWSS2cFrieVMFqJojCZV5qLOqKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862266; c=relaxed/simple;
	bh=veMMEp/O0Wl3Prl1d5lQd+ZWUoWFE8zev7T1WacvF1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cvhl++/DfQ+iDVk7XPuSpzSKm86IgPSxuK0WSXoWpB5dC9glbmJIVkh42HY5KZE5IgrwO5EzA9FeZGQYR9WJvb71m2rLtHZEIlClDZ7D+TwB/4BVxhMzyb6tJY3z/Domz0wjWaBcllqDsghW+jJJkHNANLIBu21IK/zClyLItlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com; spf=pass smtp.mailfrom=renesas.com; dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b=AcWYysdg; arc=fail smtp.client-ip=52.101.125.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="AcWYysdg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sQuqbDPxTYhRR8g9wL0q8drHI36xOfIb4fRoAtDFKCsYDpDiq1W39qwgYCpLnWAGOM+/R+A5JVzgEgmIrBKaGfbwOOVMUz9KgMfljf1EqxFYb8lm5XPIwS91V+2GSiKpgKQWnfH6ylNrvMGzMgrBrsHy/hj2oeC1bizfNkYfOVEKMG58z4AkCtaDEGZiSsMF/DLHI3H9L9V0LexViKdjAo7iNikO16c2ndiVUHRIHlV7uGrDutE2O604fNxWa3O8aZr5FfaR8zCYNB2ayv09RGByprONegjvs9MDBlLDomnt+gy4csJL+tYNKlRjXYqLoTvGspvH3oPhRl53tmJS3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThUJG7Y+yBXs+SEOuca+M2zPN4TdjWB4XN2asZWOT3k=;
 b=FIcF7uJVm62eM4NtLSdNOpSTe8T27NPH33ptafXmNHH7Ma4tpCFSX6JNq0C9OW65w9Udq2zxVyjST5gvYN/AEAGkioBSHO46JBhXVVavavtNkQFtsl/k8+E+xpb6Ji6ZTfBql+lO2YIJfiyNtXllhoPPiAVu4YJy5x716TyadNeX0C7DwsAVlQfU5TmiFwROolfPWLju1bm/SLZ5nPOJKqDiSojOKPC5wb49kH2SvOa5mUQ7qVr7K30aPbA6WH0EUc3lCn0iQOvQZ/aA9GeNCfNp2jI9bt2dNXZC9xN5SkohzYcs7mMCoQsPGolPvzJz4V6c+hkdK5srQT4z1oX8ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.62.32.50) smtp.rcpttodomain=amd.com smtp.mailfrom=renesas.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=renesas.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThUJG7Y+yBXs+SEOuca+M2zPN4TdjWB4XN2asZWOT3k=;
 b=AcWYysdgJznuwqO/yQNiAzKtcWGrVdZUGDir8M5I+fROuVBU6sMcrcNVHdTWuWnOZEHvFcekElFdyE90GM+kxqS2CwwWG/yV6JJ+SGOiGWcfnsyU/9jjMvrC9ZfR7ZfWnjuReWlXzD+20ddLKGaFnOgXUS8qD8rexL5T4cOGoL8=
Received: from TYCP286CA0126.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2b6::10)
 by TYWPR01MB8447.jpnprd01.prod.outlook.com (2603:1096:400:174::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 10:11:00 +0000
Received: from TY1PEPF0000BAD8.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6:cafe::90) by TYCP286CA0126.outlook.office365.com
 (2603:1096:400:2b6::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 10:11:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.62.32.50)
 smtp.mailfrom=renesas.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=renesas.com;
Received-SPF: Pass (protection.outlook.com: domain of renesas.com designates
 8.62.32.50 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.62.32.50; helo=ejcrelay005p.adwin.renesas.com; pr=E
Received: from ejcrelay005p.adwin.renesas.com (8.62.32.50) by
 TY1PEPF0000BAD8.mail.protection.outlook.com (10.167.240.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.5
 via Frontend Transport; Tue, 8 Sep 2026 10:11:00 +0000
Received: from unknown (unknown [10.24.0.46])
	by ejcrelay005p.adwin.renesas.com (Postfix) with SMTP id 7A80E300025C;
	Tue,  8 Sep 2026 19:10:57 +0900 (JST)
Date: Tue, 8 Sep 2026 11:10:55 +0100
From: Chris Paterson <chris.paterson2@renesas.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Srikanth Aithal <Srikanth.Aithal@amd.com>,
	Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>,
	". Chris Paterson" <chris.paterson2@renesas.com>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
Message-ID: <ap_fLx-HKX5vH3-x@ms-a2>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PEPF0000BAD8:EE_|TYWPR01MB8447:EE_
X-MS-Office365-Filtering-Correlation-Id: b9969c65-7b4b-4977-90eb-08df0d917b7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|23010399003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CzLIvukY/YiC+l8Oo+G2MVKJiiA6Z32nNXtVIyW8a2lnfms71ED++/YkLc3S/cCCzi05IfRsfzA1fFKxdlBrxxi+MKaw9eQsSBEWDc0wEoLIwU5Za8ggmwGFoXXshTgJNFGbDTxJNVfqFhrWM8yjL2Sr9/FwHQyW5Oyq5rmkAhVXbwNKS27AcYNzFsbGJwzGap9EOuRtbNPRGFh83lWXjKSRMcmMEROtDjzDOlDDxAMvCh/LVx1vwxOFOmJe0QNsK+REk/JCRyYrnAek2Ch63Awll8bwt7zD/Rp+9paZMPJoaKqXtZr9Kj8iU1o9pUfofRmWBobHHeftX2hgNmSZO9+T/synz15CoQN+dgNt9eiwI/MLoA5mNlgm7qxEn+5b3fsqC1Mfix3yFVqjEFzHN9lW140ID7Eun+OILBvBGfqfia8AlqNVqY6aHJ+tZ/hE1BTlmUdenjxhrTSBTrdtUyQnffYEaIL8kS+7NPmv82o0W/ysPUbfF3z7h6hFZptCxLXkjNpY3bT1DNwzhPTusLx18mfXsiazUOfFJ0s+onPwkD9aOtj3GdY2+5NUH9o6gOayRcPiBGTusnbaqp8u3PQ4axTAq5Qn65M0GjEq1dfjuzzCxMgiCgCqQu7AzBO6ubwWEAn4ybp8yp2bAgaKDwspMXZX0Kf/01CeqHJU/wiOltOA6koAtnIfpTii7LcAZBTcR+eQ8MoalflR7VvDTQ==
X-Forefront-Antispam-Report:
	CIP:8.62.32.50;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ejcrelay005p.adwin.renesas.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(23010399003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HerYUQCv+pVCKkOVlhlwftNdLpKCp7xFHQRMFHrksLsyXhF38ACwVfaidZ4BWCv6KF5bqYwfU2SjumpgJZOWhWOwAL6sgEczGowvLLTUwXRgsdqi/GTjN2EkDhi8zb7J7Tuwx2RrAIOlpH0T4qAIufOAl3POxeNdh7JE1mAK5ZxFCKK2hG+ONJbbOKDEX8CHNPhhJm3xMcSFYyWOz+t/Z05U0tV6FxU4bNhv8m5fDbFQOynFI08I8jyGChlsgGu16G2YnJLbyHlknBaaLE0mjZux+IIUxcS9d/69KQ2DNfLo7gJLPQjYZb1RLj+CezObu4Al4I8Bsss7J9+ALtKejVOpS+o3ZZ++p58+oewh7LwJFcwHvKl89iVn7QUBSXqtjO/AiPSUE8g2H/1R37s7Xnu8PL93a5mbsfR57JjIYAOAEMJN5miuNrBACnqdzkvR
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 10:11:00.2590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9969c65-7b4b-4977-90eb-08df0d917b7c
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=53d82571-da19-47e4-9cb4-625a166a4a2a;Ip=[8.62.32.50];Helo=[ejcrelay005p.adwin.renesas.com]
X-MS-Exchange-CrossTenant-AuthSource: TY1PEPF0000BAD8.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8447

On Wed, 2 Sep 2026 09:33:57 +0800, Joseph Qi wrote:
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.  Submitting such a buffer during journal commit oopses:
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>    jbd2_journal_commit_transaction+0x932/0x1b10
>    kjournald2+0xb2/0x250
>
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=writeback.
>
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
>
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

This patch fixes the same error we've been seeing on various Renesas RZ
platforms. Tested on RZ/V2H EVK, RZ/V2N EVK and SMARC RZ/G3E EVK.

Tested-by: Chris Paterson <chris.paterson2@renesas.com>

Thanks!
Chris
