Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021103.outbound.protection.outlook.com [40.107.208.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E8F18AE2;
	Sun, 12 Jul 2026 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875443; cv=fail; b=lpc5jb2sxbhZ6QcBXu/t7vr8fAvHDCaTsJGjQBv5jcjWfrVhpnjg8X4lmI6YSc71PxIcpmi+UXclRcd88ySlpq+xBljeZ/gYWi+4+PdilFtqwTkwMg79HMYnConWHyX+3A7oWtwD77e4sPFbkK+bGsTbVqrKHvTEhEuMjiKEg68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875443; c=relaxed/simple;
	bh=RWnPQT9xHpxitKmu1JwJBgRek/+Coc1XZa31GwuY3ks=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Y2M6ornhkSA6bZIayVJnLTSNq9xuXGjyXqLkdymjn+WXv25bfrKHnRK2dT5qVR3/dnkP7juQK9b3ZMmqPYVrMz5ZKj2s6PUyBmZvpUdZ/85Xn5+5+3QBPByqEWfd2E71mS9df0SVbqAvoEIls4yUvw/DIQOZ8boCKfAz399KjCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=U7A2C0CG; arc=fail smtp.client-ip=40.107.208.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="U7A2C0CG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTTYu2h8BbC11Y0SwJG//HRkLxSGrAJGqr7cP+QFWd7EP18QAYPeR0onvknvYO/TVNeMrf/iJPGLow949sGUVJz5Iu4WEskLVvsas2VnI6xCk6Wu3FbX0yL6e0TBO+RbP42wcRyzcRaSOX3bEvuLDBxHpP+L9K4hVxH+rBR088Xy9dNxCojgOi54RWdyPv7W6spLYG0LcKGULD4224xddgMZzB5hSQAHu0Qnf8SlWfHP/TJpgE/A/eBgelungTnWXzS6ZdW0ESJ36Q3AFYhWlwgye0Nd3yO/0FmBra/cCW+yvjFOz5UPPV3PSvh7TS7ptgxIwkrhIMPfj8iQOE21Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7ZSR9Pie1QSRe7egGrrikvvi+PtT4oZsC1GLW9BlQc=;
 b=hIPQNJjpB9pm4xFox4CosyiOQnwX+JGSXN8+YfffaGQYtCa6NhThtRlas4WKNWje7u5vVK7VW3CEfgUh3/fGt5iUZMj9wvxaNFHGMmPlt6jaTMJ3pCeiW/vndetfOKF7C/NLsvzE2nzGZu3FSKEnLDhOoZNTUqdOc0pQVf1h+sHQYHX/NGT+8jeycxOLCB/nXAEn6LuEprqgWcJHIE8vgjO14DSjtHw4klBTL4uWaNewcY/sXreWccUxy72ALMGmQaduCO7OFIOvLAnt+aYMLOfP9rST2alPGDoNWs3JAw6dT1+f54Cy38TgKhvWGAYgiFbbNhIIcxUlfnAqXJoHFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7ZSR9Pie1QSRe7egGrrikvvi+PtT4oZsC1GLW9BlQc=;
 b=U7A2C0CGloZHVcYzLfS/wc4y7YkbuIley/Mes8R7A3N19ve9iUO/qLcR3bIfCJKT4VPLeI+f2+JjFs4ECqTZQX662+ISasVdYhH6QoMl7PIlUFOhFvkjAuBDlINd8RskofcrzhuhuSXf32NeWM3oT4tfMjSH0CyshTFgOc3pS07ZwIzp9HsYW9sNsPNrFUl+nnqqIsRuGDmzrqnd6VUAhfyH/TAZYkPiRnoi+wgCzAIfrX1DD5pMYRX4JBnm9EbmIQAqIrjwEByP8VHOy5EjRu1SNiKID1/8qqdSY4mCBpI5Y3fivg59f0NAt1kcgCR2Hp1FJGhmdhuf6MK0r/LLQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7488.namprd04.prod.outlook.com (2603:10b6:a03:329::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 16:57:18 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 16:57:18 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 0/9] Support Clang context analysis for ext2
Date: Sun, 12 Jul 2026 12:56:01 -0400
Message-Id: <20260712165610.366474-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
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
X-MS-Office365-Filtering-Correlation-Id: e2a2bb31-9e89-4575-64ad-08dee036a204
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	tXBcWMf7EmqZtgKrzNS0GvE/HMNTkuAw1cJ0qyaZ8vHMQ9NHVBY/CcM3C8mpFFw/S5/HN4DNhFe8CPdA5lSegJOGbbrh5O6mbkvDf9khD0dGCQ9yxSwyKKGDGm5gZ8nHEfZV32WZkirNXtKPHtSha43AUt7Mu/lfGs3Z91axlMVwl6Cyas1LCrq5CRTN+HDXaHueWdAbYV4a2jf1tBn9xy/MSuePcMlDgzB8YQIlsO8dQHfPyr6/G9NXqAIllcUEswlYY80fQDB9kVvhRFzegzuTOXi3UiD4iccgk60RKjxLbJOULFMyocU2u0EBZH6NWFHgQl+C+jF9umFXx5qFanAl+Lk7LGvW8sKj/HaWGWJ7vB7d3mbxL5jNeUGhlVSTi85THceH3UT0Jnnn9iHXRSdRJbxdRcUwFpVWGSsgK8T9gOCFoVxph2KoF3mLTCwaSWKWRpeVfgEUZoe98CeMdE/qfyb0CVYy5ukvyxzUSbhZU7NZYm4AHSmLiIPu2tazT3RnbAKWOCAgtaPgBefBfXUHta49ixEL2Vgjq9Prnqj9878bf6yRlQOZ0PKHPiqCt4UD3n0xMF5qOYNvWEtXvNyE38iijlXf/abtqXdg/cVJYuxZdmxG3rlHrG7RYjOZ/5voFyCSmsZZQY63EVpku2X1ZbwCBWVH+j+/Wi/FvxA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+X0Vk7qNRShwtu5q61xW2xwaPq0tBEUlFdTBpzlc183CuMekfU+xrDgU+voy?=
 =?us-ascii?Q?t4+9QOM09nZwySahlH5k4EqKKMSIXAoOHnv76bTvQHxoiQlg4ioVQZ2gvajY?=
 =?us-ascii?Q?NHBQundiDuKgIZl7KTHw9LFWbjqYoDxLP10mZ7cAUfgsJWQE4Xu+ocuwiKKG?=
 =?us-ascii?Q?LQkQiKS1oQggXJrGh9v5+BVsj1sjtu59EUqTKBsdNm6Ki/nXI9ZZQsmQlXpQ?=
 =?us-ascii?Q?XRwxHQ0cZmVAK/RyFL8nouafyFm+Ivfcb8AH/G3vtwk47laSEEiT5T2Yr2iu?=
 =?us-ascii?Q?ohRuSjvHLhy0hVnpg70Ks1VU0YHSKy+JVVavq3VcJqAQwcG0WMYXzpbEMd9l?=
 =?us-ascii?Q?CTXkbBivOWPvThDGpJlhaVQDDEcuOo8qmZPNcAY73r6GvJRTVvbwXZGtWrVt?=
 =?us-ascii?Q?b6XNoJ1lnxk3oGz1+yp+mNhyTmksyjn27NNQT2KwbJ2pdc9IdQGZbMgRKBCb?=
 =?us-ascii?Q?3AzbDvQeZLgElPvXjEK0vZAWYCrX1Hz60k1u5OGWaynUPGS/tjfW5/mkVT6w?=
 =?us-ascii?Q?8WZtauLjSK/e82x8Pe3BKc/wHxeYz2gsHrrLljUlRP4bvCvIxBkCrB1bw62U?=
 =?us-ascii?Q?9HHZVx56h7p3eC+37or2GrPkOJ7yDEpHvWsTd90OpJ2CSyWHUwBOCySxbBpD?=
 =?us-ascii?Q?G1zZrmNEPD628bRX2GBTnRjN8dxEpvB7MxZ0vYH/W9t15GDw0tnnkK+GEnOK?=
 =?us-ascii?Q?T6wkpM0l1xrVMq8MA/AkjMz/1oIrErTX8qsh7Jcs4xBD4jXZYsMRsfV87v8m?=
 =?us-ascii?Q?yC46bPLsVLUSlRlS3Krfdzpx6FEvs/Qom2LXRVoJaNH2BsLhUfxb4uZyvfJY?=
 =?us-ascii?Q?QVoyg27Rn/2s+M3butONGXzxRRhNkg4DT5Ogz8diDPAgRJciqfW34PaStJfZ?=
 =?us-ascii?Q?xVPpHiEJFh+RtSYR/HaSBvbnjB8h9mxJ++O01MXdp/DFLvvw3Si8sF9FYIql?=
 =?us-ascii?Q?jXVklMDzo27E5Zvt+Ml21R3lB83Yw1I+wgm0GEB+RmSd5V6QUH4DPj2E2cJk?=
 =?us-ascii?Q?aEy7iLngYtzG7L4jqNSqkh/H3l9w45JAVzXovKDbnwRfp5Gig7/v71orjfVF?=
 =?us-ascii?Q?2h41sGBYxtHaHgmQm/6xXoQjYGRw6U3AUTvLSw5ifKNjST02fioPsgSCPONl?=
 =?us-ascii?Q?Achw6hJk3t7P/egV9aDwmbpeypOiyLstIs2WQ3Op5jIME5jW1sK7iOLV2/eW?=
 =?us-ascii?Q?WzfYCeACU2gIMKMgGPhMEla5Nzbrs0NoeIUHq+QW2xGy3HLMfrscREhh5vdl?=
 =?us-ascii?Q?CWLlOKcUQK3PolCkmDkGuMTvIdM5jSPoDWkM5nshzfMoVoN4kxvYKAT3F7im?=
 =?us-ascii?Q?stg/wotrefxTlZQf1B9AIm3ENvZ/Lu+NZNlCqNdUoNNny9HAnuqPyWCqaaEU?=
 =?us-ascii?Q?2uOua8lDFQZbdew4uRZeSzg7XgNZsuYG/zBhvepn9Dr2FBWByPUcnYoUGEXz?=
 =?us-ascii?Q?9mPPphcb5+wnmXN0EAc+ltHqud7k4l7ReaxTgNvahgz24EOF8uMIpo31I47B?=
 =?us-ascii?Q?JgaAQZ/O1G08wNr6UWOVxsLjHuOBYVwK28RdMGhV7xLnduye6lZkVmohvSvW?=
 =?us-ascii?Q?gy8fEPoe+lt8VpsByYKg5labruX43pI8hBnMN07YNZuEH/+Q6ouW7P1Nnp3A?=
 =?us-ascii?Q?xzCFisFRAfhEzhhTRKnP4NaB3tXGx4U3Y18gDba+5UxktVsHXWxo0vYmJJPZ?=
 =?us-ascii?Q?H92nTE4B+F5mQ76oBXlaDoa2BOQI7fT7Hc557dD+sl1E8C3pITIShVt0k9K8?=
 =?us-ascii?Q?d0uCefoUEpWUbyCokckikvR4R3859/g=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a2bb31-9e89-4575-64ad-08dee036a204
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:18.5380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EqN0ptCjMr0413NkN8YXLiBJxk6igO6lO2Ipjwhvu1Ae1Uqa9SiCGd6nU1MHq7rKxnzEpDxSQfvGmMGalnh8mKJD9MXZZokD2tCVdKlEDsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

This series adds annotations for Clang's context analysis to ext2.
Clang context analysis was recently added in a series by Marco
Elver [1]. This allows the compiler to validate different
locking patterns at compile time.

This series enables context analysis, fixes pre-existing warnings,
and adds new annotations. It is inspired by similar series in the
block layer (NVMe host driver, for example [2]).

I'm starting with ext2 since it's smaller and simpler compared to
ext4/btrfs/etc. After ext2, I'd be interested in converting the
other filesystems and infrastructure code in fs/. I think the ultimate
goal would be to enable this by default across all of fs/.

The series was built and tested with Clang 23 with
CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based on 7.2-rc2 (since the
minimum Clang version was recently bumped to 23 in 7.2+ [3]).

I'd appreciate reviews and suggestions. I'm especially interested in
suggestions on how we can make this easier to enable for other
filesystems.

Thanks!

[1] https://lore.kernel.org/lkml/20251219154418.3592607-1-elver@google.com/
[2] https://lore.kernel.org/all/20260706141452.3008233-1-nilay@linux.ibm.com/
[3] https://lore.kernel.org/all/20260515124426.2227783-1-elver@google.com/

Timothy Day (9):
  ext2: fix ext2_xattr_delete_inode() context analysis warning
  ext2: mark s_next_generation as guarded by s_next_gen_lock
  ext2: annotate ext2_update_dynamic_rev() as requiring s_lock
  ext2: mark statfs overhead cache as guarded by s_lock
  ext2: mark s_mount_state as guarded by s_lock
  ext2: annotate ext2_init_block_alloc_info() as requiring
    truncate_mutex
  ext2: annotate block-mapping helpers as requiring truncate_mutex
  ext2: annotate s_rsv_window_root as requiring s_rsv_window_lock
  ext2: enabled context analysis support for ext2 filesystem

 fs/ext2/Makefile |  2 ++
 fs/ext2/balloc.c |  4 ++++
 fs/ext2/ext2.h   | 19 +++++++++++--------
 fs/ext2/inode.c  |  7 +++++++
 fs/ext2/super.c  | 18 +++++++++++++-----
 fs/ext2/xattr.c  |  4 +++-
 6 files changed, 40 insertions(+), 14 deletions(-)

-- 
2.39.5

