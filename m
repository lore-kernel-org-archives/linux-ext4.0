Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021078.outbound.protection.outlook.com [40.93.194.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8C244A40F;
	Tue, 11 Aug 2026 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464261; cv=fail; b=TKDMrn+TbEj/ZjxNPgolvYMpoR/vuBmTTwTejySx0cbKVFTDjXqJAzd9I28nRw4hu4xiE6LiCcqYUQgshKGDrEjQKHaf3W0pcAKasSxwobIum5DAeKEIYr2z8LshUXGHKh8KJMWatvCtsw4LEHAfauJWRq9sxwj6q98kQVeD6AU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464261; c=relaxed/simple;
	bh=4mr2nUk4XoBd+EY5/Xfg+Ltz+IHeBCBUkgV6s4kj2UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ljU2+gsYpruu9EikV7QWfcPigNbErW1XgrwYDQ++ooOQlAnnbv8JEbqU0PXpnaZIqKMfEJnq4qEsIRo3dF8GCDqcobYaGif60gMMKOCSxvYjuwZRK7UeBDB4lnOW2/Zee77/GyYqxAi7dvP2+mj22khy5fi9wIOYmqq9O8+ED34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=4I5zo/Xm; arc=fail smtp.client-ip=40.93.194.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="4I5zo/Xm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTJX9KdiknoVkIcY8GxZNMYSo7pwqTx9Qlk6Bt10KyvLZcSq+9/Oz/XiFVwBagZ2A79eh2yYbkhZrWb/KjqogQM55fDhBSWJ8bgqXtBi95FnTlJhlmhXmcrBsFhE30eVoVxZZ4axwxSt9MluVYDdlIKFuMwetxVb7vo7IKgQgfKExRRLtx63AGiJ55/54vUfy/n2+cmOnOPzj71/gBwNLEBd0XZ8tjt7fCUGluQ8evPY4Jo73XXnKSJivlUw1oelpLgPDPvdKnERcSrgU0sNGSh700Em2GvKiVFbcfK2YQTauLUAwVqv5O9y6cynuVMh+452SRj0yRDPdGmQLFrmbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Ca/Zz2AQXOi3zM+5fms2/74GRcK7dXBnTuOTVb3Yxs=;
 b=TNIRXx5WtHtMVWzVIWBeHashjm0t65/WIg9Y+eRYnQ3XLAxmw/tBIl8mn+Cv1PYnYK4927XUEAiGeN9wFUoIecygk0nhbnP+1Hl/Uk47BterxSQ5XdajDJpFzjUpQwOh+D+MFreX/5av8shYPw/PymyTrW8lSUVPBaqFPoako31mdmTQHMAsZh9PJLwzwo1Fdz1sakyx53YF4292eiz/KpHsAuSMSdprjGhU0qxfVwviUkYY9WaDfOZp/4kTQ7jUbjF5f3N3pS5MxWUQm1Q17M2wsHIMKuWIVvSn6OCVomjXyAEeQWfWWresZunAU33AE7cvyZMPQxw0Mpah6tcXIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Ca/Zz2AQXOi3zM+5fms2/74GRcK7dXBnTuOTVb3Yxs=;
 b=4I5zo/XmFRG2Re05rOiZFe0eMpzEOFqZ79VO+leiND7qepjbluWOrHyxYIGrdL+MbevBdl2bUBKcjX0oK8mhTL9s+8D1NxmSFwGWEZiDgKF8WaMX8lfGRld0TMJycNYPgbdDiVhIRCBJ/zglTo8+ioo1FVIOEkr+dcHnocdaJ6psjxdzCKI3Slv+eL5CwhqqBHXCJa8iV/a7OXqid9YMLRdecqaBFQpnOi0LPS/bb9uTayB0Cz8FKd9SQm/u5iMjvlJrvfWD5ZSsZwVTEzOspnCIau4letli8nNlLLAbFOjPIlq5w2btFXXKmWuqqt85obzGxTeng7yBrBdeo0DLkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 MN2PR04MB6336.namprd04.prod.outlook.com (2603:10b6:208:1a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Tue, 11 Aug 2026 16:04:06 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:04:06 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v2 6/8] ext2: annotate block-mapping helpers as requiring truncate_mutex
Date: Tue, 11 Aug 2026 12:03:34 -0400
Message-ID: <20260811160336.782342-7-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811160336.782342-1-timday@thelustrecollective.com>
References: <20260811160336.782342-1-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::19) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|MN2PR04MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e5eb580-9c9a-443e-a233-08def7c22ada
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SF60dxMNvyqxTk1OY1nG9PVtkpT0xrN2nDzMfj4S/izZ+M2xtc9ORPE9FV01xm/YW8zTVDX9DasWx8D8NKGZyUN27eiamihkL/jA9yZJ3F44TOzJKUNPYDu2ACYPCKudjZkF/egB1ZdMgp2g4MJn9aFEiUf7Kk44ipwE+3r7u5Q+T9ELru6qmitjr/4TGzU9aHaKC2X07aDckMk+6nENCkTwzV/bv8apSagikWj5yBJxpbe+YVwcwmSbb1C8CIjJgu0g47PyHrJWHhZI/1219N2sTyvCXojJkELjSb4vQvjydLriKej1ytc2fqGfMKLmgIxMryQhwVWRCpJTt2bn01ULLrl+ojC+R0oYPz98SYXxQx/qDu1sP+Pp6nyKMTNbRyxIlV2gfYpPALMLEKA5VslT5wayU5M/r8PhvVk4UdHYOvcwFd4skQlyeniZDdytV0/txt9cezAiUYR8/14qyine+PvSJKrlz4QYglUwUxY1Cd/bFHMRi+WL6vsDqwqCxWNZS6z9oeTYfcCpiJGQSF2Dp+1VtlhfF6wNpVolj1mFGYieifjtyrzytGCSyS75HT8Wie8609N6iWw9RkBnSPqg/OzCPocteb5Yb5vtXiAIFOxmxP5Dla18F9erdv5hPkoG7sszy6HbiR80eVl7P2M8vpVk+sw/YCZPmjNzYuc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zLxWrwfQKCpi/Lv13Q5LbEXUk+uWppwSn3bKu/c33UzPSJmgU8iHSwCSgYV/?=
 =?us-ascii?Q?S/dAotA1KeVSFG4QpTJo6g45kck/65V1oK5tJmhY6AuQuI/wefVxmyRncyzu?=
 =?us-ascii?Q?F/SKgvQNAKzaJzXxG4E55GpiYPLeahnYGEvyWVxb9uvM8A5dJ5bjVI6T6HtU?=
 =?us-ascii?Q?mWkAss9AcHoaNMITk9eh+rpgS++wHZpaKu1vbxrVSQxD0DwTl5KHL780Whhn?=
 =?us-ascii?Q?K/azRCuS26NMVmjeQ5JGZ1z8z5MWY/zGGLCqLLplzgvL2NFY/gdBbdSMfHGV?=
 =?us-ascii?Q?capoqdzVRmT7zHki8KJ/isX8NB/c/wW1TDKxKbqtRoA8HAgDoHZNswEDwPem?=
 =?us-ascii?Q?mlXLiMuiP6Sr/P1zpqQ1+w5qqTi6nx/HlFqbMh96SsQuKwRQ40t5R5Fod2Bj?=
 =?us-ascii?Q?6yYqK0QIMjzisy5BG1ySWLuy6j1403bD5bqwKocVN/qHU6eruJ/SX7XPRGWA?=
 =?us-ascii?Q?Zqi/0W+QoY3mZAfUuEqdCz5A+6Gf5e4fnua0c+Cg0DHnZF6FQrN2GrYwm0II?=
 =?us-ascii?Q?QGLHeQzxf1MtkbNc1b8cl75V8gU231T/akC0hMIJVXbzm4d4wMYhxXr8nAon?=
 =?us-ascii?Q?KhLz85mh6Q6CpfXvNPriCEHEnoBRBVk1U5dKuGU1f/4AI5BGGeBq2AZaoY4Q?=
 =?us-ascii?Q?lNLnGkInLypwiycPBwI6qWp4mzsNdmiLFgYmdFQ/IZmWtUhFeiFoLLn4pGUC?=
 =?us-ascii?Q?FSLBA3GuPyQezt3PKb1dl6+8yTKI8+oTeI98JTtcYcSa/xt67eycqftPDRdx?=
 =?us-ascii?Q?MbJGrGfDqbk6qE5SFJKf9HbPMvSxdEj/rRlcTMUNuEFcwNy8llBxOakoOoLp?=
 =?us-ascii?Q?asGFLy4iw/vjcscD+ExxtnONYrTO20zJ+5A95QHaKgIFWPMkZUqJOi0mPrsU?=
 =?us-ascii?Q?qGzNLkC/HcQeihc+EQDy2ZDczL9HhqUCU+15PiigTqAY1LedtY5RAQ3KVeio?=
 =?us-ascii?Q?Tp3wL39d7o90AvFeyjvnmFf5J61GuwALTI77lOdzYyf4V8f76n/sSzISbAOo?=
 =?us-ascii?Q?jMLLiGYmZiWo/t6e+CJAaWIViG6qIUe69WK5Ez8FTb4JVIJUgYTZEqmVFR6T?=
 =?us-ascii?Q?yttOffS7Ber3vp5iJ7suGQ1+lIwgDT228ZQnkqDD0AxPIXdWVOhbueSH/Nwd?=
 =?us-ascii?Q?VVyqcTTAjZBos/lZVe39dnPXzwgzdJA9GRtrmANhgBIs2KsgBBDL1ofjKsVJ?=
 =?us-ascii?Q?G8neSxgTFoHD6VyMpoBHcjsA2AY9N65ds3zgK+3pnYXWt8t8NMWA1ylB26CP?=
 =?us-ascii?Q?qQjXg04q3FWu6LIO+nkkJwjLJxetjbIkEG1idSwcs8BLxbkbl9CjnwnPzwpW?=
 =?us-ascii?Q?8EWLTiJg93ofA4yFIgyZOv5MZSCmtEYC/pQoVQ6jgbAXfqonzxdA5wcY2E/6?=
 =?us-ascii?Q?swsDXSpgGKkZ21Zzb95qVdRFCveHevrUcB+9OFyR2De3xzOz2E5inxgIYGEY?=
 =?us-ascii?Q?nPtPjh1u0sIe3RS9uYqIFCHBeaYrzqldAlJ1Ec4mWs8e2PgACRDooVXdaFHF?=
 =?us-ascii?Q?b+aMQORbQRc+EWoGozU9805LYzLZRuJ4ILQTZMfRRNT5tslSK5YhOh9HqqtD?=
 =?us-ascii?Q?6dvF5O0VJbyLN1laWRL62f/brYuz6UyM/hJEKwbrr/HHgj85mEqaOpsqrNFS?=
 =?us-ascii?Q?okk37x7rKJ+1FPGM6S4ydMuw+XbMBiyvLgshbdZIoqENzxQUIWwbLMOcZ9cP?=
 =?us-ascii?Q?iyNGYbXy9VZKorEJD8/XpoTkkqrrSZoIHIfrA1rqba0+PSCiFXw4uyiVYPCm?=
 =?us-ascii?Q?AWP4DYZA2Ms/u8IfkHfItdWDRsxOFvo=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5eb580-9c9a-443e-a233-08def7c22ada
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:04:04.9849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Spr61M9AMKm8WXW8k9ITKp9FOf5Q5iIA/dOMqjsD0svTEKJ5aHV2Hm5TC0BCqPPqaLhr3q9607q2T0v4A+eOchyLfnLhX0esaXj7gusfX80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6336

The indirect-block mapping helpers in inode.c all run under the
inode's truncate_mutex.

ext2_find_goal(), ext2_alloc_blocks(), ext2_alloc_branch() and
ext2_splice_branch() are reached only from ext2_get_blocks() while
it holds the mutex. ext2_find_shared(), ext2_free_data() and
ext2_free_branches() are called from __ext2_truncate_blocks() while
it holds the mutex.

Add __must_hold() annotations for the Clang's context analysis to reflect
this.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 29808629cce5..f0be5236d04e 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -329,6 +329,7 @@ static ext2_fsblk_t ext2_find_near(struct inode *inode, Indirect *ind)
 
 static inline ext2_fsblk_t ext2_find_goal(struct inode *inode, long block,
 					  Indirect *partial)
+	__must_hold(&EXT2_I(inode)->truncate_mutex)
 {
 	struct ext2_block_alloc_info *block_i;
 
@@ -399,6 +400,7 @@ ext2_blks_to_allocate(Indirect * branch, int k, unsigned long blks,
 static int ext2_alloc_blocks(struct inode *inode,
 			ext2_fsblk_t goal, int indirect_blks, int blks,
 			ext2_fsblk_t new_blocks[4], int *err)
+	__must_hold(&EXT2_I(inode)->truncate_mutex)
 {
 	int target, i;
 	unsigned long count = 0;
@@ -479,6 +481,7 @@ static int ext2_alloc_blocks(struct inode *inode,
 static int ext2_alloc_branch(struct inode *inode,
 			int indirect_blks, int *blks, ext2_fsblk_t goal,
 			int *offsets, Indirect *branch)
+	__must_hold(&EXT2_I(inode)->truncate_mutex)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -560,6 +563,7 @@ static int ext2_alloc_branch(struct inode *inode,
  */
 static void ext2_splice_branch(struct inode *inode,
 			long block, Indirect *where, int num, int blks)
+	__must_hold(&EXT2_I(inode)->truncate_mutex)
 {
 	int i;
 	struct ext2_block_alloc_info *block_i;
@@ -1002,6 +1006,7 @@ static Indirect *ext2_find_shared(struct inode *inode,
 				int offsets[4],
 				Indirect chain[4],
 				__le32 *top)
+	__must_hold(&EXT2_I(inode)->truncate_mutex)
 {
 	Indirect *partial, *p;
 	int k, err;
@@ -1057,6 +1062,7 @@ static Indirect *ext2_find_shared(struct inode *inode,
  *	appropriately.
  */
 static inline void ext2_free_data(struct inode *inode, __le32 *p, __le32 *q)
+	__must_hold(&EXT2_I(inode)->truncate_mutex)
 {
 	ext2_fsblk_t block_to_free = 0, count = 0;
 	ext2_fsblk_t nr;
@@ -1097,6 +1103,7 @@ static inline void ext2_free_data(struct inode *inode, __le32 *p, __le32 *q)
  *	appropriately.
  */
 static void ext2_free_branches(struct inode *inode, __le32 *p, __le32 *q, int depth)
+	__must_hold(&EXT2_I(inode)->truncate_mutex)
 {
 	struct buffer_head * bh;
 	ext2_fsblk_t nr;
-- 
2.43.0

