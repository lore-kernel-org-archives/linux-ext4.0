Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021103.outbound.protection.outlook.com [40.107.208.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644D5368D51;
	Sun, 12 Jul 2026 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875455; cv=fail; b=dIW8GUhjScBKjTyw3R5tZ4z3a9JZpUVloP6kKNdQWAKv4Xk0ycMM1C9+gKPJ5wuYIOjK7efKqhTDk5b/W/yF5MrLc37GMFwk0ajn8+qQBHa6+HvBiT48OJ/cyR94Fe++E77oZ0Vzw++MePXAkJ20Q6BkLTb6+aC7vE0q0y+6HuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875455; c=relaxed/simple;
	bh=w0WXIFHjaF5tdnQ5MjqhMOCeYPge39pH45IqWVDkAU0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UveU0vHY/0vB/FBNSuiySt4hAArIHdNQkAETlYB8J0guwUeZcXOZ5AuRZ7/JLTEDHd/SybquZSV01HG0HPrE83RPXSs/xKYSMvogSS4MPa/jwHXz1HEIObfHvmvYnHhDWB6ESf/Z4+EDbcrfrLMgnG+PJHp+aOLqNAAuH0qbJRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=lGimLSQI; arc=fail smtp.client-ip=40.107.208.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="lGimLSQI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y53q0vegzgv9Wj58R9nrrP+MyIKCucV6CYANfkAG91BYDvc6q5HustPxa3PNP1hCgtiPCq78WoSdLhY3TCZx1GhTnj39LfWw0fFt/D+e6I+nPoPBwmPp8K6R+tEgs3FX8bK6Avr45oZjc6cGnJxXd+YRXRWo8yaIHfMGDBOhaTB3/IznA1MddVknZ8u86FqBlvl/gWUTMrsPU+VtX9H4M+9KickgVDWrtbyVtGYBZfin6k8oAIhurxPxy705sACHUM8ozApsCIuj0CJgh1NwEQYYsmoCHufWQlaQ2V/DP/Y+HgIC6BcjMnq7481qnyKPt/P5tKio75kwLuZE/dAqkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5D0pAm9auicgv0VLWRxtPfQybwrgBaGrwIwsNCT7DE=;
 b=cQ3RjQ1AZYUjAkVy/0tuOFvPlHA+g7rx3SybPRRawHbOTPzP3LNrXB9nQqt/j5oeUlcgYHcrt4PW7JBE9x7sSmjtIq8lJwe8blkRDLv2pT1oYRNyu6PAuXgA5KXzYw8ujp0TrYfYrMMHdplnE3zILXQfRVdvL2Z92HkyhzlnvC8nKvZ8piriauz/TO1SCLbOV0uHm96svZeBLOLnKGgNBwhEMG08GCHb10KVePTuU8v/VAjDIffEdJUoJxpU38zgC689N2eqBDleA41zneMlMOPDqijP/FiP/GyrLiuxPRrkNx+2PSk+miMWV640E8tci1i0D68RtNWX0jfripgElw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5D0pAm9auicgv0VLWRxtPfQybwrgBaGrwIwsNCT7DE=;
 b=lGimLSQI2NGtjF6u+dOzudzvsHvH+CBf6C4bXPMwxKZTYyC7QxJ65Uj6YJf18MzEvBoCBiiuJrWoE97n50LfslSs7QAbTxNEQtHfLk//FiH3YUPHqYdoYEiDnVChQiT9X0hwMgNLkzCd2r27EM7TQn/P3eGNGAmFpxhVV4x9Rw+wH7DrreClhmtlZECsIgBXo/AQxKGpZFo3bYi3DZprzyq5f5imQTGDE4yuWwXnXbu0l84xy92PhEXr7GHZVOFd3/OZgloYbVVlbbhbwCP7j4efekNcDwPhwpCw4ib/gqPhY1prFk/L30ue+zh+3yeb0V+PuxAB6tHFnWzIajfMug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7488.namprd04.prod.outlook.com (2603:10b6:a03:329::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 16:57:24 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 16:57:23 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 7/9] ext2: annotate block-mapping helpers as requiring truncate_mutex
Date: Sun, 12 Jul 2026 12:56:08 -0400
Message-Id: <20260712165610.366474-8-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: a2872367-302f-40ce-242c-08dee036a53f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sn3jekJP/5fARNLblA4tqwxQy6pBzv7XUcsxcxgLQ7487SIYpsS1kJ/mlnMlcLQT1eV+vI6kcPJr+5rzi+mgmF74a6MNqvSgODQRBk4j3mZqE0yLUSzGL/QR8RPVA+N2KkttvrjfGXzgoiLmxBIcHZGjO9ZGLNgzs1O5d3xtJXjTEauOKnBKz9VacX2pO9zV43mmgUJWVkI1zVcwTh5H/CZn3RjIV0PgHZiEL+XydfJdZYQrAc8v5LFa2b2SCGTvfmeOV2DWVH1eLkfxccy6gsa4ua4UCIhkF46gJeMncPnKHtrmYDHlfAWH/r8d0T7x+WKtCVFZOx1OVFCUhcqr5fBrla4NITlI4Th7Xu0zBzL4y/jPw3LfREno81tqedzoUWtQEkPAIBzv3JbcAMWvuBlDQT+rT4H1HIeWD/SyaOyhdOorMRpYpM95hAo8WOqDsWh/T5I77Eyo2yhgoXmJX8GSULqxARfwOZ5q9SmF1RTVkZ4ZopXyAXXaEE4x8qOiuu7aUrq27Cv0H/fIeFG+Z9Uw4Ua6pxG8FpUuQLiGk8932shSucy7fhke+HwAqoY2mr/BxWa9+/OKkPYLqNDp+g0i5HuROszsp+AN5t0zUCS5kOcHGn/H3GZ4UkcR+GD5tmZEcTAxHKILWxndjVbnLikgFXgL6yiSjUWYE6sNLmI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FecHa6YPjen6cnzT7HuFc2gX/0BuL09LuuzRzp63ZQMFWszOja3yMXCKVpHn?=
 =?us-ascii?Q?hG27yL+axTfFMktSp19sZncy+Hf1ELLl17qssjLZHNdkCzR2sMifJoXIKfjD?=
 =?us-ascii?Q?LjB5ckqkTb0LRxOLSGwd9pz53UMsZlqt01hSucg3+WwCBhqv3wvSihBjOsVV?=
 =?us-ascii?Q?a3QLml1PbkIKf0Y0mLJrE5Z/kCh+ZJ3qv5MrQrxKPnnO0QjrUGjZ8LAL4PmO?=
 =?us-ascii?Q?KdhGpozhSwIZ4hzbiGwD8HgCR9LxDWYse+rmuCbo3Ra2WIB9PaLdbFS8t6SB?=
 =?us-ascii?Q?+m4LAfGUhUs9CmZCIMD1F5GNopbO7d2e+Vr7gNSZvOLiWhWuygkTQrOVOfu0?=
 =?us-ascii?Q?t6wMchk0ovCmNI1ABNLTjxXaF5tz5o8BIznAb6N13X4ozf6WLMMHAlbPI6nC?=
 =?us-ascii?Q?fODxzs1Vn23CyptH5J06+FQgkiyXaFccEmNa/Wji9+Od3DpVhdMIPdB8URJv?=
 =?us-ascii?Q?aZ1bcjv9fKFnHl4LRdTuTxAf+cFPl0btzAGTrgrcbxwIfZepXfKp/LRhGbQz?=
 =?us-ascii?Q?uYEvBFq1Pv8YJT/SsOApVQl96atwqUgvQpZRkiBqz4UuNpkF+939iNSryIjl?=
 =?us-ascii?Q?JX/WUWTkHVtZm0UqAEhT5wVuFtWrAUDB+hDkpUZpgO358Rb1+ewy7NAy4kVI?=
 =?us-ascii?Q?YaZIjArKl53smUtojZ5/et3XP+okE/Jq4qeF3174lgPYzIt68+DRkNsnYMpv?=
 =?us-ascii?Q?QJ+jAhv5htRDoztwjlXJf23V2eeOSkyHNKj4fEemRJ/0MKvu68RgPOl9MRUp?=
 =?us-ascii?Q?eKbafJJbB0WdtqNTtL7bPH21McmZRlofb7f+7QWnSbZ02JtYWjTMUvK463ZL?=
 =?us-ascii?Q?5QjNVhhLuRBtNeQzSpPTJzGIgDL0e467i6sny15vfRTkDPvQVxBhrtoYc7fd?=
 =?us-ascii?Q?Q0Zox96tiAD0O5F1Q3d1eGyYrjyvGGl3QnmVBdaHo4HWXDVUwbVqPbbbCoVn?=
 =?us-ascii?Q?byw55XOp/KYGOnUVCr1/hokHawYc+qfQL/OEfSGDSqzQ83HjfBYSmYyDqz9o?=
 =?us-ascii?Q?Sui+R8bWwU9Y+TPUVQJFL+lmq9gX+Bbt+k5lCrTZZjgP/bHP1Ryh6G1MDoEG?=
 =?us-ascii?Q?EclP9q/BMwjE5K6AekgfFi8pzSdwG8mvppa3drvrmyJNlyWVbBNzqP6XzQ1l?=
 =?us-ascii?Q?EBNI3WMguDosIJwRH24sqkXoMbio36zyeRicNAK0dinzvE22JgdTkwMcpDhn?=
 =?us-ascii?Q?vBrU7pzBJLXw37yr9zISS+XLXBCjOBIn9H6r65ze0Xq/5Eu4T9H0oUdJd0yP?=
 =?us-ascii?Q?K8ROEoBOaxFTkjfCCc9p+q3mX85urB8N1ptjiLd0BUVCwHzOs+AreEJFqU0R?=
 =?us-ascii?Q?wiQPI6gjOII5M7S1bpWoaDvUBbJ2mEcmI/ctuR6yV1ZH7IkS+PzTdvuc3sS8?=
 =?us-ascii?Q?bkLDBWhIav1GYA6wU3ovD9r0tKWvvm5seoYQ9oV8dHEYJoZONf3w+0Ayn2EX?=
 =?us-ascii?Q?qYX65QprlefeP0dVm2DyIPhMVb94+XS/oKOBXOldzWcOeqmdv3sYlUV2iADf?=
 =?us-ascii?Q?HfD5cqytE4H7mC+KBYTNjvM6NJvdzeyT7Y8r/y+7O6MG1hiDtscYofUt6EaI?=
 =?us-ascii?Q?d945NfFfIhpCRE8MR2fOcEVnluPMHLakwvh1//AfAwOHOtfx5c9oaIhIS3cP?=
 =?us-ascii?Q?13IMelUD3CyLe3DJAbU8Miz+i9uy2dxlt2H6sjGrCPNuAoqcaTPHMm0wNQEi?=
 =?us-ascii?Q?t/cyRaZRp3tcUk3nT5eG3vwuSG7nPetU5ciVxqleFXZJwgZGKuasbE4cgDS4?=
 =?us-ascii?Q?WqVy5iKwS0Rbb1W6Q2PdAiJQPYHWuQk=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2872367-302f-40ce-242c-08dee036a53f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:23.9412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bWBYyxmuGQV1utkPMhRI01Mt8me0Ephs4XNvZQbp/ymc6mPBfrhFRT3ovoTsRJL8/bvVXpRWRjme2HtnHRNR/708J3mPep3INNfpJ/QPgKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

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
index 29808629cce56..f0be5236d04e0 100644
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
2.39.5

