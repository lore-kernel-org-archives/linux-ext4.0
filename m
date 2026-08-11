Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021078.outbound.protection.outlook.com [40.93.194.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C973F3298;
	Tue, 11 Aug 2026 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464257; cv=fail; b=EZpwWoHJpYz82CMmnmqp41vQNcQMUr3Jw4aB6zhuzfkC7+C1ez3qX429b3+8KG24VZ79KDZfyOz9/NCmw7sfZYD5Ig7eA4Acb032m79q3LLnhUb3AOCr1C5Av0KsqKz5HqwuHkYanrHHdTjdsV6ia4LA1I9NLfgE4NPfr3wrVCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464257; c=relaxed/simple;
	bh=pUUN1emqpSj2jIgNa4CPYORAl9YB/DwagzNPfslkAyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z8L/eC/H471b18vS41xsf/Fm5fEKcJ+FhIY4NQhL4XnBG/QJ+N51gsKXhJszhfsd5XfnPjwxvC7/GzxmeUAfVDEbx/9BpC8PUwHvQqYE1urHFxvZsKyjiWVkAPUHND0MqGGtIaBFZYHSDvTPOxdMEX6Lnf/5GxUMB0mOycwgWCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=0w58TQ3e; arc=fail smtp.client-ip=40.93.194.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="0w58TQ3e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vKokQ3s36XaekJJwBOYAVFKadJVPOWRtuyKYfScpDLCZeC+0IYm/Td8LESd/mFcuBucqJB4Js3W4gBD/Ma8wwGVMg5OjmHnhWmmThWGIFGG8XnQC5/PdDcKiAYIWyUCFKgABj8/1VHdZ4VHTCj7U8hLodCCSErQmcaVeLgqhyeLlRo8GTb7oGFEbhLpk23a8rA8hcYqHG4eU2jdEJEW6a7hOt8TYTIKz5LoCBJzL1fCzoL5DmWItdq3khLHv/E8HM3KoSpXO3bB9093srgVlRU2BAlwGt2yHOD57xlo2EkqIrT0tMcNa9yW1PXWzgGK2Kg7ogOCVb/YSXhp3cvFHEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gc1QkaTTSOdggpBekQ5rG7UNXrdqGR3Pni+4c0KT1SU=;
 b=GZuMqtupInZCkipFes0+StwUXHF5GT5cfo8aG0IJn9jYURoushV98t9Sz1B+J9KcbARvIQ4Gx54ivcbimEjRivMqQICRgN4poZ/h0//UQOf0BEgxm5gxeQHu70lrTbgSHDieEiUwMEHlp2Hg4nwZWCEOzmqmOuAiRLTUB0HencQgyV+S6Hb2GY1m4h78yn0E2fIaCQSk3escvIISGKVdzGFHMpHgzC3VQFWkTXYg7PjML90AE+YawJWnD5vGKSi0QQR0zzO36kOFcBQiqDF6BO+FbMe9VA0sD0Zi6w8E/AHWSAWq77ssV53DFkr9hyE0oJI3ichbuXG+/SNprHy+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gc1QkaTTSOdggpBekQ5rG7UNXrdqGR3Pni+4c0KT1SU=;
 b=0w58TQ3eRZwt48e1cOHghhg0KFRRFbjeH6Evt+imVh8xUdbznikIqtXyFnzdsxZ8EKKvCrgj3pO4G7hsIstSpQU801gi0AKZsqhkfTQBN+aXmdUVdg6xow4F2vjtxq0h7aw5vhngEbOzS9IlPkCb1pbtPJRAh55ccUthDqSxZFvjHONj1sCH83B6azMzy+B9lxOqVekjYlSuMGHXABPV9gTr9WFcIgiaomSon/tFznB79qUyUuYHhjSvdAJXvxMzxrkFuieNRwZ3Ok3I0SDZzNNO98MQp3h/x3pzpPjpMGKrB/8v/bk+s9ulx4b4Ejcs97PscHdGH+ZSPR7z5le+ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 MN2PR04MB6336.namprd04.prod.outlook.com (2603:10b6:208:1a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Tue, 11 Aug 2026 16:04:04 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:04:03 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v2 4/8] ext2: mark s_mount_state as guarded by s_lock
Date: Tue, 11 Aug 2026 12:03:32 -0400
Message-ID: <20260811160336.782342-5-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: e6d82d17-7f30-4816-c1a4-08def7c229de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xulwwozNK+ubLD9eILxPA4S1bvLUBoq4EEFWAEqU5Xw52536uvuwznu0SJAsmAsNJFp5aGn+gtv4G2T5m+VbaTGqrnvGDUYVTkZ0V0ublIPUxuBsDNbGL0HfpGYTUA1gFv/hCMSnO2V0igEjTpV565G7NullqmbfGm4j0uQSoaYwTV1SA96JbtEfgGUrtUz0ob/toe87f42wAgULmWUZfh0tATQLmSpoJX+BUkdE+BDdOEOyDtnRzTRpJSIV9Nw4STb6nVjy2zigKAWtZeA9RzQye3GzfSO5K7XC161Hhj4JwXuggO/nugy3JUk4TLWZChmIIQyMwmE3S7zf+FyjOqme1EnxZ44XVKa3X1UnECg3ycJUEHlwYSQKSkgBavRBtratFlT/TTJtY1brrCeW2eo8TkenAYj1qxZb+Htl/IbergKf6WLndLh6rvVaKdFqUDxZn2SCarGaSmszkxgCwtOOK6lLXyJUdEQo43FsGefszRX8s7EyAXyxI1K1PK1a5BHC43z+RvkICyWN5GT8emnAfLE70DMY6Cquohh23KEJJfg9YXzt9spIfPtv2VxfgBYQcyBjmYHR5Fkf0KnTCtpvgwyuZHyF5DmfgPkkTIo0EZemsavOfrzjZNTp0TGkEk8ASM3k0+oJA+5qpOInwecFC2fzOi1J9Rhdg9U0cPw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IcbJOk40/bWvfCHu4GH1yPCgS9NGc34tporjHf05suIWVss8vhbjqGPVRcHp?=
 =?us-ascii?Q?1lFqiVE9Re0rNUL+WXAGAkmDFHpw265W3PpAgI2uaTduXHVrWfwVjPG+GPy+?=
 =?us-ascii?Q?Tez+xZdUgT5LXkwQBmbEnNX8Ww/Z+31Ri5CVrep0Ju49kMU7aFRQkBvEyHNg?=
 =?us-ascii?Q?Rn42/JbTOAden3z8qn/OvmklN8qTlSzyVh0fj54h8Abhu8dCeAMDAP2YSUpw?=
 =?us-ascii?Q?G9CqFr6bEO2ZaeNPMxKZz7AjW2tHhSBWPLqnspWdrUwhbjZyR0vztT6ps/X7?=
 =?us-ascii?Q?MEpVgSru2zVBt2STxyvwmZgyvZRUhKRgQ5YCSuz0Jlvp6rgexl4FnQri1AaV?=
 =?us-ascii?Q?02K9+HnDVkglhDXCr133biyNb2y9WmVSFVtoeFio7/hoq3zKNMZ8oQ2n67rM?=
 =?us-ascii?Q?MKuLnZq6GbeYMgI+2BfSeMFIp9+FH3vBdqGZdzeYZxPBnw/tKk1xLUqpT27d?=
 =?us-ascii?Q?bz1iCw4CtS2JKYQNjQ9obaf2Qc+e10l6omXF4iudMwdzfDxPFgbUQuNFaGYe?=
 =?us-ascii?Q?2uTb62u/N/Y3P8LHMhBAW8MKOoCU4yUr8iiyYsaC2ebsWWTmp3nUBPNbKBv6?=
 =?us-ascii?Q?KAEpmFS9gBhpmge471Dbu4lLkqr74kQ0xKU9j/1KBi20B6D3I2RZQ3CDs87u?=
 =?us-ascii?Q?candXXSj5RGoJhfdg/HWdfp3gr/j+5lnaAKGM3N5nR9ihB8v9UI+koUb1duv?=
 =?us-ascii?Q?CDlBzWwJKfE3pYHIzXKS/iURrxvvU8+7RnIMXQCOAFaBkbr3oYhllj9D2ZeI?=
 =?us-ascii?Q?lBQ3wtUwllCLPLPldoPr0A7/HWbfmf0yvbDQyDQrdxb1p6tiOBKAtUT+lfZI?=
 =?us-ascii?Q?909CtNWmk9c+lVbpxjTnf02vMJzRy3vcGAGttCUmVVrm7DTeeFp+QFSlf6Ly?=
 =?us-ascii?Q?4xw2qDW0qgBVX0YhMNa6bVhqfSIulQbraJgJAMWmMfgr3ceEm7aUPYDJSs/K?=
 =?us-ascii?Q?xUnof9ZV6C3EEN4hafh7kEywOEInXvgfIRUxpZ0WOI5mTULwWidf7JIgbwzA?=
 =?us-ascii?Q?cCDFdTO8cFarZ4qeBgaSw10EgGjBX502jlQvVfS/io6wdgcQGhT8JOZlKJFS?=
 =?us-ascii?Q?WvuRM+UtATxvrlprsljeq6nivlP7RYznB3ZyO/0Qwv8MLD0Y3T4phXBRghQ8?=
 =?us-ascii?Q?9klDDvuMzTiW4XufLs0kGCRwFkvBSWpWL/JdHmSUvbKxHi22562g8gAy3TRW?=
 =?us-ascii?Q?u4IMFWzZ/NxKc1d7mYL2JRA/aXp2RlYtbqAll8LpHRB3Goa+sG5+CRL59+lg?=
 =?us-ascii?Q?1UGZyS+QW7vbOkGIYgxmOqoSdhbFbohu0xeDh8GAPqzYgiXWrsSNOfk7wD9L?=
 =?us-ascii?Q?YoFJJIw3PHZ5ZFdKRYrpnLN2tx+rfF9YVy6tc3HTaMmMZrepjhmKmREOq4/d?=
 =?us-ascii?Q?8/OlRy+fpy+Yap8BfBl3baEVsxtiygSJP68KsgPivsV1HodglBXwpBdnan/V?=
 =?us-ascii?Q?q4TaR9E0Xon3DSgrcp2KDVP7XNvo/t8C4I8fZcQTMLKVE6pq20lbIabEel9E?=
 =?us-ascii?Q?USppWZybjYOcYRVZKpGEIMbf9FE96Xvqi38hjG8tFqvU7/T3iMXD8TiYROBR?=
 =?us-ascii?Q?mawKddvF5AU8T2uYY62hcTOwt1i8xZY3rJEaLDYOjQBBqP75IS/akO8GtiXf?=
 =?us-ascii?Q?BNrDyMknnAuOHFhVDcOJiS5BM7CHnaOf1OZdkT/WqVzLcYup0vKzTe5sMThl?=
 =?us-ascii?Q?ZHyKlnwzA/E4xJ0fPU7X5iUe7PpbkP7CO4v6ZZrUwwJJJT1PVTJE9WiiCCQG?=
 =?us-ascii?Q?/wVWIlCQor01psSL1FysEg8uFziqJLk=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d82d17-7f30-4816-c1a4-08def7c229de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:04:03.3035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADkjMjYYs5eF3uXtEHxkfTJDM5sbBQmdaiEbv+E4XxwjjsUnezyTiERAHs9xk7CJuBXX4t9g+wqYCe23Fp9S6nQMd4cuHVae4+in0Ooqd+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6336

s_mount_state tracks the filesystem's mount/error state and is protected
by s_lock everywhere it is accessed. Annotate it with __guarded_by() for
Clang's context analysis.

ext2_setup_super() reads s_mount_state and is called with s_lock held
from the remount path, so annotate it with __must_hold().

There are two accesses (the initial read in ext2_fill_super() and the
setup_super() call) in the mount flow. This is before the superblock
is live, so no concurrent access should be possible. Convert the
spinlock initialization to use guard(spinlock_init) to prevent
warnings on the writes later in initialization.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/ext2.h  | 2 +-
 fs/ext2/super.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index ecca898653eb..4c30d6f5c972 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -86,7 +86,7 @@ struct ext2_sb_info {
 	unsigned long s_sb_block;
 	kuid_t s_resuid;
 	kgid_t s_resgid;
-	unsigned short s_mount_state;
+	unsigned short s_mount_state __guarded_by(&s_lock);
 	unsigned short s_pad;
 	int s_addr_per_block_bits;
 	int s_desc_per_block_bits;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 5bf63943828b..0fa7914e5f04 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -633,6 +633,7 @@ static int ext2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 static int ext2_setup_super (struct super_block * sb,
 			      struct ext2_super_block * es,
 			      int read_only)
+	__must_hold(&EXT2_SB(sb)->s_lock)
 {
 	int res = 0;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
@@ -894,7 +895,7 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_fs_info = sbi;
 	sbi->s_sb_block = sb_block;
 
-	spin_lock_init(&sbi->s_lock);
+	guard(spinlock_init)(&EXT2_SB(sb)->s_lock);
 	ret = -EINVAL;
 
 	/*
-- 
2.43.0

