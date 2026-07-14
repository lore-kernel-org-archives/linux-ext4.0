Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022122.outbound.protection.outlook.com [40.107.200.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C8A3CBE6D;
	Tue, 14 Jul 2026 18:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784052694; cv=fail; b=gP3zuL325m+0uQty7oKF6Efy2mt66vA1e08fw99OVRv4NZVuafWm+BAbaJ42ZLZ/9E5+Q6a9ai90gVoafg8O5tEV4f1vXuOxr2utxnvobieLcSMUHTmdE0ckduO0Fsao0DFn+B6JIS4pnjsAROtw2HIble59UGmv/8fBSw6W1dE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784052694; c=relaxed/simple;
	bh=XYprGXvIOhbMVFDRlebfqTIWVcyRsScsW8ZbTWODFIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uezTUEZh+QjDvqmpU3ayzaX02TTNj200nl98TZ9KF/myZ8JVCfxF1nEGVX6xGC2ll4bH+45c7nC74zKb8u+djo9Am0sfD73Fw26dIF7zLmoeOBbKntZeLN2rP3ng73VDR+e7Rqi8OvYqB2LqNzRb1GeWZpUcKwMpWw0jpQE0IK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=5Z4M3YkX; arc=fail smtp.client-ip=40.107.200.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="5Z4M3YkX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=duTwAdSQn/LkXCfIo9eYQFBFT205CFNA9rSuYZLGuOaLrn7oZ2lbOLuIBdksuvrXK9g8wl0GrpXJWHzLFS8LP2CGTfK8Apjv4FDQNpkzWxGx/F7/dwEdXioDxM+yP7ewssYwDBEgoJ+NyWAzRFbzk1x8EzMB61kjcKItfraTyPfa0EGRL0H6QnMlzknv6qYY94hPmg8HrlhPer3ZNfT/vONYbZKEKNhI7SmPwCfEYcGh0zZVaws/cCCVm0uJRQ0pqmtRUel4BSB4YTf73dVCaorSasHyivHRo9Z8xfUpMR34ElRXVsmjbgQq5MGxkPdG1cgfL8wnYB1W8rmO4swdQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A/VeR1Xm5aQ+Hlol/ONWtVL6Zwnar3sT0hdK4zKyFn8=;
 b=i9KwE5hPdzKo/glNpsNhucpNwFXoTDwg9lw6o2GvQpSYPrGtEi7EFtuW49IG3rs86QHK0uIy+wHHiMczkDKv6p+Aff53NVrskmhHp6aNtYfZuzGuWh0ejqCemMZ6A27rigk3iFGVuMuF7wPV4OrJXCslHfqvtbkkJemPcXtMqf8TFrAz6IDIPJ8QQKAcORWsToh4tY3Ba2Rl57Zwh/u5LbdfLOhag2vmOp5ye+fK3vTslyMVkVd6syA8hxQvVskAOG/5O9JW1S7PA3wZoi8TN4gOt2BIto16iAb3TwDkXW+gNMQJ66kNOSBQOucpfJ8A/P1umbB1jUey+21fRhD3Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/VeR1Xm5aQ+Hlol/ONWtVL6Zwnar3sT0hdK4zKyFn8=;
 b=5Z4M3YkX8By4PDKOrFFYOc8uw1+OyQelXjBqc47NLy0h09Jywc4ppcn4Otp6nmTWHK1B+/3TJ1mrGT55WheGpHruk+jpVfGTdaAzQXp6CKqTULcAL+4fWYlcyLrpl2NPGK/Y/1+Wxm9/gMXufsSMM9OLPtR146/PqA0A7A5v3HBao9JyRZb6RVSNWKU67/fjWZYSbHhJgbDLq3tXMl5qg8IrcnwhYIrP7nEhVFpXUIMCJNrWVnti7iTrQ0mcRagdkw5aCS5gh01PgsSZ9R6iTb6bFWncpEaZQrvVFskzDWPJ/VFf7EkoZ/YP5OMbMULSuNc6FDBuQ+9c0rYvm0q65A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 CH2PR04MB6523.namprd04.prod.outlook.com (2603:10b6:610:6b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.10; Tue, 14 Jul 2026 18:11:28 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 18:11:27 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Jan Kara <jack@suse.cz>
Cc: Timothy Day <timday@thelustrecollective.com>,
	linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/9] Support Clang context analysis for ext2
Date: Tue, 14 Jul 2026 14:10:57 -0400
Message-Id: <20260714181057.667977-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <2mnivydbfh5h44gf7h2it4wmn6pbhbjyb23w24l7zh4tw6ytsu@wyvwrz4yxapu>
References: <20260712165610.366474-1-timday@thelustrecollective.com> <2mnivydbfh5h44gf7h2it4wmn6pbhbjyb23w24l7zh4tw6ytsu@wyvwrz4yxapu>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:208:335::23) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|CH2PR04MB6523:EE_
X-MS-Office365-Filtering-Correlation-Id: 1619baee-efcf-424c-ea53-08dee1d352df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9FuMHSdZuJl8buMyizH+X182ywtMHSKgRkL+qfd7e+79tcMFbDtwi6JLPyVWiv1MB2lA0eiaiiye0ALM29D5nBLHWwd3BXbJrExzmZomsZYz5YsJ73B7v2Bws5NVq0f6J37/zE1sxPHulIO+vfU4ntM+73Yk7g+YZoMVjixEPPRA7h7x3rIQTScAcCpfo3JwBcoXYtxbEf2L6YNS5vm3qaZbqVnwJ387gDibCeZ/BWFiB25BxEf4BpJTlrNd4sIGOT0OEcDQ2kIwq0QvgRDZ7pZjbOiqgkqJ4lsUXHC6wx/15je7d9Z1W2I1z6Mjz6xBw6aFmvGcrhH1Rk33+8vcpz6Z2gpLY9eOhlX3JFg1DwtL8iXyDCY9vDZRQ0XbtvDBR4obFjAh86JH0mmHf0b16sZbZQu6rZor6WdDFjUy6G2Ozv3sGgKxmH2Nepnfh4KbJzSUdRVMNTJw2SRqldBLPGpulHJQuG8aaY1TApINx7R2Q9/Me9lgtzq3myOx0qQqHwqfAtLOE1T+5Z7ZJLPEklW79/S/sfBG+wpBU40TpvggtAx0ApeoRX5R0z7oy8PvdQLOi9V0FAqP432tRnt9VEOaqH4CrtkLP/nwQFw+NwcvJ3YDWxDC0cmswAekphN40w59AcrFWVxfDjZD4HXgVpwG1b22apFsVAurkUDLHmw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?reqgyEee3OCCj3VQRvM4tcU68iZEEh75ovxJ6TDQA8T8fg858jKLJ0xD90LV?=
 =?us-ascii?Q?yu9WZ8xTX6M/iKoSTeB13GV2U++Jp9FHrkzTWxDIJePqgb+lAbpLBb8hRH3y?=
 =?us-ascii?Q?VqqZRwPbuIO8OVcY+Ckpq1bchhGTuS5xFD6y6dpM9KMJXtneyFfVuHMtKirk?=
 =?us-ascii?Q?s1Nn7HEyS4Ttl4osS0mU7PLRf1FHzKkg0ObPGYeuh8QZ3tDW7HBVAKwKEepF?=
 =?us-ascii?Q?uN7in6kQWWE/Oh31w0ymVPLtms8gu8xpkrgxZt4ItX9jqc+u1MGPhDwyCZrH?=
 =?us-ascii?Q?zqss3Mku8xZaWI/K6DqSz+nBR3AQgggr5QklPo9zlNjE19iNkgrP7L2InOwO?=
 =?us-ascii?Q?rAZTFBr+IDd92JRAdW9sAolOmlo/HqDOPw6rMs4vIVL1mvY87+ngrQxZCVEo?=
 =?us-ascii?Q?P2aSfiMC437Yctz/n9urE6aTt92dpnT2SwzurIiUypmfCdWNZTeTHEDkuz28?=
 =?us-ascii?Q?bgR7/PW2j3U7or5gmPzDeyqXUcbOUEy+S1TOgR/UgXNe2ITCIZIztOJFoEDy?=
 =?us-ascii?Q?XSqDvXsgLHueo2YbNwVOxA6hZg3grRbO/pF0raz6X7pCyn0UXwOYA9V7AL5+?=
 =?us-ascii?Q?7ansCGizDw4LDPvwmh4MqW5hr9FwCEcdaJGws7nwHwyDDroGAkYapsyc3CsW?=
 =?us-ascii?Q?jA2jP8J8e0JQKsY9v9Hn0f4fvyCNj0820s4z8B6Ruc6pMrFXoSv9fge79EJ4?=
 =?us-ascii?Q?QqlNYaKDmPULgI2jiUeymRsN4m4rHcg0tRaJXqHj17f6wywshrcCNZo5gj48?=
 =?us-ascii?Q?kLR51TpQVF1/I0jt7lhokaQwHcxrRCmojMYSH2++OXqF+rlCoXTRxxVX8xfS?=
 =?us-ascii?Q?fG7qcRG4iJzEYfsUL/qrqvA2n/yTC+L+4Bz8gbyST75hXLJKE8kozsP2GeQE?=
 =?us-ascii?Q?DERxfAOOT/kNK1iinkpRA34BI9Ymji9DIDYG1Kmwq9gHcOaawoIa2+KxmiZJ?=
 =?us-ascii?Q?TfCPWExL9c+1ebA8W77FYFlFLZqHjJak+4uWMyeMN2HWKcUwaxWOtYv2vFCx?=
 =?us-ascii?Q?RkISQispi2opXsZoTT6TgD0zBPVPmXgbn7agMTsmnTav8MiEhub1PGU7yYq8?=
 =?us-ascii?Q?lTATiNPvLI8ZjpYguPanR+ahGaDoAmir9caHGDi4oUJHOkgVDgE81jA8lfQ4?=
 =?us-ascii?Q?LmvLkcN0KTuisV5voYZcZkFUgbG6HPI38qLOfM55/2a0dV2MoWwicSZpV3A+?=
 =?us-ascii?Q?7IjSQrqcKYGBhJPduZXlV0Pjj45cfjWrcfY8Chl++mOWT0eJANThUkwbyQx7?=
 =?us-ascii?Q?yo4eYMtIh8jMO/tCkI0xvoDJ8XfSgaVATgmazHeqOXvflaeEdtgluAfaLgE4?=
 =?us-ascii?Q?x8BbvuFbMZEa5KAY3jEO6J4IkQcZ+J4zmjhuCu2KowB35CwxyEpEgsv++HDl?=
 =?us-ascii?Q?QZaHKpJWo6pD3plYqxECwo4uXJAuhimjr9i47FT8lE1j/QvTuGZkryYzDfy0?=
 =?us-ascii?Q?F7Ad3w8kbyjZ1WpRoajyYKWKVPq/353CsfkfQl1F0Oi1rUfyi24mPKy+n92V?=
 =?us-ascii?Q?UMeunXQLrBV9/uMU1d6TA0opZZLqyEE8Gakgg673Ve4LzgWfZLsy3DkJnhfW?=
 =?us-ascii?Q?TRMhPX1OZ6KdYQNX3u8U2BsRid06qfDBqHWKRU7qp16bBxBhZYRAyMaEQN2k?=
 =?us-ascii?Q?SOjohLZ/a7zSVY5vBOalCMt8rgWoI4WpTGXklPIqDAXiYaLKryWa7DVDxn3E?=
 =?us-ascii?Q?YsLPvF/ldiaw1siU3fPbxDcL82gb/V0mcfXqZoZKydktxAxdKVm3VzqWm1FY?=
 =?us-ascii?Q?n8buzZAelWN6qKUPMAI0ahTGhW+EAQ8=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1619baee-efcf-424c-ea53-08dee1d352df
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:11:27.9513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yyS2SoJyMFqI0ECiMqo8vCeU0Imoj+1RbdeIAYfFos9Hu16Ij7zUDEO/8ix4VJncO2H0MRcJxMRWjNTRNmxX8HdN9W7pgEqL3rWykNzRMmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6523

On Tue, 14 Jul 2026 19:27:38 +0200, Jan Kara wrote:
> On Sun 12-07-26 12:56:01, Timothy Day wrote:
> > This series adds annotations for Clang's context analysis to ext2.
> > Clang context analysis was recently added in a series by Marco
> > Elver [1]. This allows the compiler to validate different
> > locking patterns at compile time.
> >
> > This series enables context analysis, fixes pre-existing warnings,
> > and adds new annotations. It is inspired by similar series in the
> > block layer (NVMe host driver, for example [2]).
> >
> > I'm starting with ext2 since it's smaller and simpler compared to
> > ext4/btrfs/etc. After ext2, I'd be interested in converting the
> > other filesystems and infrastructure code in fs/. I think the ultimate
> > goal would be to enable this by default across all of fs/.
> >
> > The series was built and tested with Clang 23 with
> > CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based on 7.2-rc2 (since the
> > minimum Clang version was recently bumped to 23 in 7.2+ [3]).
> >
> > I'd appreciate reviews and suggestions. I'm especially interested in
> > suggestions on how we can make this easier to enable for other
> > filesystems.
> >
> > Thanks!
>
> Overall this looks sane to me and I kind of like the documentation value of
> __guarded_by and __must_hold annotations. The context_unsafe annotations
> are a bit annoying but I can live with that for now. Just one question: do
> I understand right that the compiler verifies whether the lock is held when
> entering the function marked with __must_hold? So if we get the annotation
> wrong, the compiler will tell us?

Yeah, the compiler will tell us if we got it wrong (so long as you have
CONFIG_WARN_CONTEXT_ANALYSIS=y and Clang 23+). Here's some examples of fake
or wrong mutexes:

PATCH:

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index f0be5236d04e0..66bcb0c63887f 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -329,7 +329,7 @@ static ext2_fsblk_t ext2_find_near(struct inode *inode, Indirect *ind)
 
 static inline ext2_fsblk_t ext2_find_goal(struct inode *inode, long block,
                                          Indirect *partial)
-       __must_hold(&EXT2_I(inode)->truncate_mutex)
+       __must_hold(&EXT2_I(inode)->veryrealmutex)
 {
        struct ext2_block_alloc_info *block_i;

ERROR:

linux/fs/ext2/inode.c:332:30: error: no member named 'veryrealmutex' in 'struct ext2_inode_info'
  332 |         __must_hold(&EXT2_I(inode)->veryrealmutex)
      |                      ~~~~~~~~~~~~~  ^

PATCH:

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 404f4223a6bdc..dc1f17709aaf6 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -667,6 +667,7 @@ struct ext2_inode_info {
         * ext2_reserve_window_node.
         */
        struct mutex truncate_mutex;
+       struct mutex real_truncate_mutex;
        struct inode    vfs_inode;
        struct list_head i_orphan;      /* unlinked but open inodes */
 #ifdef CONFIG_QUOTA
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index f0be5236d04e0..d530fbe50d274 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -329,7 +329,7 @@ static ext2_fsblk_t ext2_find_near(struct inode *inode, Indirect *ind)
 
 static inline ext2_fsblk_t ext2_find_goal(struct inode *inode, long block,
                                          Indirect *partial)
-       __must_hold(&EXT2_I(inode)->truncate_mutex)
+       __must_hold(&EXT2_I(inode)->real_truncate_mutex)
 {
        struct ext2_block_alloc_info *block_i;

ERROR:

linux/fs/ext2/inode.c:726:9: error: calling function 'ext2_find_goal' requires holding \
  mutex 'EXT2_I(inode).real_truncate_mutex' exclusively [-Werror,-Wthread-safety-analysis]
  726 |         goal = ext2_find_goal(inode, iblock, partial);
      |                ^


Tim Day
