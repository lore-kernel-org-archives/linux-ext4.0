Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F72C169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 01:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BBFF214DA
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 01:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="LpdFAlzp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfBLBTa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 20:19:30 -0500
Received: from mail-eopbgr820097.outbound.protection.outlook.com ([40.107.82.97]:35424
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726107AbfBLBTa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 20:19:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahmUh3AvJtzxwlpNgziCkLF8hzhwHmGXgPcnjttZQiM=;
 b=LpdFAlzp7V3DdrBd9WbiDr6EsMiaPvXHJB57dvwK9+9mb5rVgR1I4wwznzIPJSt+bX9xfiIFA3jadvpfp+6rKRBeRNjvt7DJpwhdNawmRXKh9mPetcT8xe5ahDV2CCgf3lQ4PRlqwsYAiF3AFCTLst9wD7NAbc6z9ZEJK/JEo/g=
Received: from BYAPR01CA0009.prod.exchangelabs.com (2603:10b6:a02:80::22) by
 BYAPR01MB3750.prod.exchangelabs.com (2603:10b6:a02:81::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Tue, 12 Feb 2019 01:19:27 +0000
Received: from BY2NAM03FT027.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::209) by BYAPR01CA0009.outlook.office365.com
 (2603:10b6:a02:80::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.19 via Frontend
 Transport; Tue, 12 Feb 2019 01:19:26 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT027.mail.protection.outlook.com (10.152.84.237) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Tue, 12 Feb 2019 01:19:26 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1C1JOCO025274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 20:19:24 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id BE03D7A4EAE; Mon, 11 Feb 2019 20:19:23 -0500 (EST)
From:   Theodore Ts'o <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <adilger.kernel@dilger.ca>,
        <miaoxie@huawei.com>, <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] jbd2: fix race when writing superblock
Date:   Mon, 11 Feb 2019 20:19:17 -0500
Message-ID: <20190212011917.9326-1-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190211195841.GO23000@mit.edu>
References: <20190211195841.GO23000@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(136003)(346002)(2980300002)(189003)(199004)(106466001)(52956003)(336012)(14444005)(103686004)(51416003)(4326008)(50466002)(48376002)(26005)(36756003)(356004)(90966002)(86362001)(6666004)(75432002)(186003)(36906005)(786003)(47776003)(486006)(478600001)(11346002)(476003)(6266002)(26826003)(2616005)(54906003)(316002)(126002)(246002)(8676002)(2906002)(305945005)(88552002)(50226002)(42186006)(446003)(1076003)(2870700001)(106002)(76176011)(6916009)(8936002)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB3750;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT027;1:5S72pa0UQTGELMs43qIBaQHdvdw0eS7XI4kg23moN+7dHAZ0s0Lhayb95+hOBsYOHau1blB5ellbRFCE+p0F+IPxNFoY48HaTVTHLzBqvwk/NYTys2YOVsGtcUgsVvmTHAZ5M+F+XFeVsB0F0dQ0wQ==
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e38bfc2-47b5-4008-7877-08d690882157
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:BYAPR01MB3750;
X-MS-TrafficTypeDiagnostic: BYAPR01MB3750:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB3750;20:6sjofrbdusNUK0jsW4dMV+togD5AhPC3Ni6p4YEZCx1MsfvL5P25C+2CeBYvSak30Vh9i7fMHrPqk++CH//HJ1X5kPfbnKjzu8xbsCvnNrKMCmFbwiJNH3nz4WJJ6lrXJDpBEa63NyU0QIrRpi3UTA498GA8Wlb1FSxQ3azoR5TInsRYrllWFWo1rSVdk8Pwva76UN/V845xdt/XefyQNtHpOxl5E/NQjW6gBxx/0cpjXBUo9N7ok7OJHAsGNLO0sWUS6Y2zTGYddLgU4vaTfN6CrP1okWsOWFlnsLIgsVJrzyEg7wDYotDw1FVNenbVhmyKpa2CGHPNSlSU4aIjShA0McSHFWt2eV2RXCdZCptje81BbahQgk0XD5HzSRKCCekIRhdnRpwjYe3Vtnv24MJ6hq2ItCPui+cyuAApzlIS1TOUWabrNyu/d/JHZx9eFxFwqfkIat3iwro1K2eD4X6nJNnmZsA1FHKkoJwIICXgZQ+IiIz1pUiot0+OkrllOiXqbOIKMP4ruxL9dFtwRUS+V2/dbEOT4GRpdohILFnLMc/Qoaqpgv/igpRqMALzO1pD5bdXiN+km0fgdYQRUnwTrw+Ck6/uUzUAj9eZiFU=
X-Microsoft-Antispam-PRVS: <BYAPR01MB375075EF51EF0D30C03D943FB5650@BYAPR01MB3750.prod.exchangelabs.com>
X-Forefront-PRVS: 0946DC87A1
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB3750;23:kmsyFihr4V0ScHpKxSBR5P7EwOxzPScVVoFP5V3Wb?=
 =?us-ascii?Q?ya5dEaUJPj1LxZyjdBluP44QusikDGYC2HvKQyRnQJV0LmWo/1bDTk4U6Nii?=
 =?us-ascii?Q?IhDJCNAeRcuCoOeB1v3oh9c/REGjwO1Kb5zzy8s+usLLzpQdt+HyUXi1TLjy?=
 =?us-ascii?Q?du2UlqevI097kzvir1v1JuMpY1sGW7HnZTUMXqW9YDVbj/PT4gqj9Zptw/YS?=
 =?us-ascii?Q?yLutcqJcUo5SJmwLRNA72l4oB/HpH1/m7vKL2gtbOdl2b2QPLUMMhOVT/+rM?=
 =?us-ascii?Q?vs5TAgE6aqbIErrdM+pfdAxvBEqhgKbrDDVRWlTMruzNd7sophItebSkzbwO?=
 =?us-ascii?Q?6UHqeH73owygcfTR6EQA7nemO11z0GZE0Uf7GEg4R7Xct7R9me0ytmBPUvXr?=
 =?us-ascii?Q?G2UMhXrq/sh6lp3CjjTahpZg6cU9NX3lf5llD6X3B04UsdIV8lJzEdFvTsCQ?=
 =?us-ascii?Q?vJZg7o3Xju5HSZTckAI5Ok9KS0gkw1dmxJS76NuwxGOFFllw2O1m/pZbPa8u?=
 =?us-ascii?Q?hJwBcQmHvk123oIDIMnGPPp5mPqGSFIjanImgTfQaDueJXUO46FfPov0+cIb?=
 =?us-ascii?Q?Esik7BPjoPi57VOvcp6nzvBxQvv6UXCWEqTf17lUblHqqz33XALfnoshyhse?=
 =?us-ascii?Q?v7Dss8asik/kA8rPktxSr9UU7qGVGfI+3qK8yIYPzKWt3VZavtyZpKATcAE2?=
 =?us-ascii?Q?w1Fvu/Q9X8GE4wBBUio4bKTdmWp5sSd+iMpldoost1nx+RngTjGPQttsDo3T?=
 =?us-ascii?Q?4xK6jJkX2rjUlnimc/7fRBraoBzrxZJLV77MOuveWLLjVVCG3Vuc5cwO6f/O?=
 =?us-ascii?Q?8f1C+t5eroeQjDDcUqBcnI+67ek3JaUxpqh0SFDilD8elcsZxXYxWXIV8TNw?=
 =?us-ascii?Q?UGtwEvK9eIM2+5/Cv5HC6onBfm/m255iOaZ62U+pFdOfIy1WYzmmnzh3tjXw?=
 =?us-ascii?Q?NozI+KxqqIgiGOQaPgvjHMTt2aA0zFit5Ux8h6FaLFD3Vx0ohEyPG3Wra9mX?=
 =?us-ascii?Q?WR3ZCovtJSEBmndHWitzRJfiznmmgUtWFzzEvf4lupBumRpPfaloBtZiYWDz?=
 =?us-ascii?Q?L+cgc5iT1JHUvaFMu4j2KFgaIjBI1rmI91qf9hd2CqEPM5SkueT0vTxO8PpK?=
 =?us-ascii?Q?zsP7R3r+42uCGknda5Bn6lAQ8hOz5rb4Y1kDlX6mPtH0L5wCjT6bw=3D=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: aR/byy6cn+xmPJ4L1HVLvUHyXVsyzU6L65AHscZPV0QMNxCl2si2cmvYLG7bZFv6dKJp+QVv6voVxRjW6C6FE4xgKo1k3BoLSmCDootF+MJMWNgEAfeyG1HZR+tnETAgH2Eu3oeLHlIM7RIKIIrtjfJ00lWJOSbxcOB0Whccw/N/bkvcTyo5xPp036VdXSAKfxrG4x+5lKtxfIL12utqRQxwvn2I8E1JXGl4gwhzWRYdpC/H47a2IgVtWIkRv545Imwlrc6KjpYsthpllQoUrQRPTt1crCaF7HFxegrif/XMjPvWatyvS1V2WukpptlAhxLpa+oiLWZXMZyP5vbneZs3el6AgK9X1xpRnEYVOq4V1s48XbiLl6Fz4RDLbxdmsKT9pI4vjerKSD0j4eiBHAdPD5IQXvLLsBC8G+u2peE=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2019 01:19:26.4693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e38bfc2-47b5-4008-7877-08d690882157
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB3750
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The jbd2 superblock is lockless now, so there is probably a race
condition between writing it so disk and modifing contents of it, which
may lead to checksum error. The following race is the one case that we
have captured.

jbd2                                fsstress
jbd2_journal_commit_transaction
 jbd2_journal_update_sb_log_tail
  jbd2_write_superblock
   jbd2_superblock_csum_set         jbd2_journal_revoke
                                     jbd2_journal_set_features(revork)
                                     modify superblock
   submit_bh(checksum incorrect)

Fix this by locking the buffer head before modifing it.  We always
write the jbd2 superblock after we modify it, so this just means
calling the lock_buffer() a little earlier.

This checksum corruption problem can be reproduced by xfstests
generic/475.

Reported-by: zhangyi (F) <yi.zhang@huawei.com>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---

v1->v2:
  - Fix missing unlock when jbd2_mark_journal_empty() doesn't need to
    do anything

 fs/jbd2/journal.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 88d8f22d2cba..a8082c86d569 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1356,6 +1356,10 @@ static int journal_reset(journal_t *journal)
 	return jbd2_journal_start_thread(journal);
 }
 
+/*
+ * This function expects that the caller will have locked the journal
+ * buffer head, and will return with it unlocked
+ */
 static int jbd2_write_superblock(journal_t *journal, int write_flags)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
@@ -1365,7 +1369,6 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
-	lock_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		/*
 		 * Oh, dear.  A previous attempt to write the journal
@@ -1424,6 +1427,7 @@ int jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
 	jbd_debug(1, "JBD2: updating superblock (start %lu, seq %u)\n",
 		  tail_block, tail_tid);
 
+	lock_buffer(journal->j_sb_buffer);
 	sb->s_sequence = cpu_to_be32(tail_tid);
 	sb->s_start    = cpu_to_be32(tail_block);
 
@@ -1454,18 +1458,17 @@ static void jbd2_mark_journal_empty(journal_t *journal, int write_op)
 	journal_superblock_t *sb = journal->j_superblock;
 
 	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
-	read_lock(&journal->j_state_lock);
-	/* Is it already empty? */
-	if (sb->s_start == 0) {
-		read_unlock(&journal->j_state_lock);
+	lock_buffer(journal->j_sb_buffer);
+	if (sb->s_start == 0) {		/* Is it already empty? */
+		unlock_buffer(journal->j_sb_buffer);
 		return;
 	}
+
 	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
 		  journal->j_tail_sequence);
 
 	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
 	sb->s_start    = cpu_to_be32(0);
-	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, write_op);
 
@@ -1488,9 +1491,8 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	journal_superblock_t *sb = journal->j_superblock;
 	int errcode;
 
-	read_lock(&journal->j_state_lock);
+	lock_buffer(journal->j_sb_buffer);
 	errcode = journal->j_errno;
-	read_unlock(&journal->j_state_lock);
 	if (errcode == -ESHUTDOWN)
 		errcode = 0;
 	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n", errcode);
-- 
2.19.1

