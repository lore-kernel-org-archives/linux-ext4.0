Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800FCC282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 04:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 091BD20863
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 04:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="YjrqNL5r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfBAEme (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 23:42:34 -0500
Received: from mail-eopbgr690102.outbound.protection.outlook.com ([40.107.69.102]:63584
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727366AbfBAEme (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 31 Jan 2019 23:42:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/x32RV/Bc8Uy2W6esHnXsRPjK2rsF0Hgxju2xJcOVw=;
 b=YjrqNL5rRbYqQjWL7SYKiGXccru1hfM+yCdbJQxU7HSVVIgGHqyjN0h2soAn7KgUpYd0hFFkm9DS//tfwfWtpPg/AoGEEPZtPdJY9g49Sbt+YDFastsRmHpyF756ESq1llqzn6SPx9FZkmfKfQ9JD3nzfHr5M7ttTWJTgzkiAtY=
Received: from DM5PR0102CA0024.prod.exchangelabs.com (2603:10b6:4:9c::37) by
 SN6PR01MB4496.prod.exchangelabs.com (2603:10b6:805:e1::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.17; Fri, 1 Feb 2019 04:42:28 +0000
Received: from DM3NAM03FT039.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::201) by DM5PR0102CA0024.outlook.office365.com
 (2603:10b6:4:9c::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1558.17 via Frontend
 Transport; Fri, 1 Feb 2019 04:42:28 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT039.mail.protection.outlook.com (10.152.83.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Fri, 1 Feb 2019 04:42:28 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x114gQ55011391
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Jan 2019 23:42:27 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 771437A4C59; Thu, 31 Jan 2019 23:42:26 -0500 (EST)
From:   Theodore Ts'o <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
CC:     <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Revert "ext4: use ext4_write_inode() when fsyncing w/o a journal"
Date:   Thu, 31 Jan 2019 23:42:19 -0500
Message-ID: <20190201044219.12802-1-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(346002)(396003)(2980300002)(52314003)(189003)(199004)(14444005)(47776003)(6666004)(476003)(356004)(1076003)(2616005)(478600001)(126002)(336012)(486006)(90966002)(8936002)(36756003)(6306002)(50226002)(48376002)(106466001)(52956003)(50466002)(106002)(305945005)(246002)(8676002)(2870700001)(75432002)(316002)(786003)(2906002)(88552002)(6916009)(54906003)(42186006)(36906005)(51416003)(966005)(6266002)(26826003)(4326008)(103686004)(52396003)(86362001)(186003)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB4496;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT039;1:1t3kG1b2eOgXCWQmtyeINxeuAJsBdpRJYlzq35UCqHm5zHUbIFC3vzOsTLfz7jKG7bBFESNmuOnlfo3kHukmWh8yfgwpYiJ3c7N2AmIOLGcSMG60wLhcw2BK+nT4tU2LPY8rl6r5PXFcQKNjSeFOJw==
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 459685f6-bc99-4537-ca68-08d687ffabb9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN6PR01MB4496;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4496;3:MUSTCJM3vNrLsg3JIbaGHx+UNov1RtsR5T5C2niAP/o1AmeSC9D57ZbAT0TJmzn3lwvN/w1Np2/W+fHyad8CKD+ihZBIqsnzdARKxdqpORLY7VQiIArJdjnCKFfTjMgs1a01jIgNWD0kRFJHTbtGmXtyB/h8IeULG8wplxFsXsgHk8o58KUhVA/BlXkOwj1kOXrqHFl/vdgWp0hg8g3YHfnhF2Ic1XzkXxwTJs8H0vjc+n7uapIY+tTvvCxut1szpWP3hCdDR9NVeQW2K5Kj48dxRjwOCB9eVbg5CB3Ho+TpvlDgWCbG1/JSk/R+J+OXWTLXQjOEiqKnjipNfnH6Ja+WSR6kGmeniJ2Org3HAwfeH7mfLKmRJUGdQHN5PUVA;25:vHabl7G+PVnc2WdJWH2dHV7z13rGHbMEHjWLNe0EexuDvcIG3EYyu3rYAQoxzl9tWciawdQzZf0nHA4AcuN6eEUwYSASlpPnqIWsNWmg8QV4vxeGw5LSBhWsFj8vawt/Oj3F6pFcqDgl3W7WDqyweujqtVgFCnaEYWXmgA2ccTXWnIq83hd8O9K5Y6BSCQr7J8GcMz+Vo8F6m4nRlaBeyLH5cG4yrz52b1YGonVa4W5lv8kh9cldZ/dSW9zH4BTWH0frqobf9Mfw7WecPX4NNtsF4phwCOv3F22PAJZqk8LfmBhhs0we5C+/HwSqXiVO5ap0KkJkhLUfOgpz5Ta1lg==
X-MS-TrafficTypeDiagnostic: SN6PR01MB4496:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4496;31:InRk3gOndzmlElYICKnYOn/5FiJf9YrStQMDK94CXzjRwgwYiOSOTvZql8zTasIeDenYX48PBmBaR96RBV+zSbDXGn1Dz4uYU7oGBz9/RCwD6LmNQmVSI6ZM0t2Yj1POg9Zu+WExAuEgkzk5wBgHatNqvMm5DD6pF8SC6PcmZA2fmKU/zahbdT3J00PpzdBYk+mQ3OBx5DkuNhcmIzeMh9d6svypyMWCgJDgvzoaCdM=;20:aepKswoJ+OEklWq22ATCs7J7P8OzbWIqjVwXPx2PiyzltfpY6OuelNNWFY/9VbyauCO6cf2L/b5FeoPMMsYMTmFzFnRqdKrntvJc2CRNeeiowYCQfXX9158AGb6DuvZIQgbrPhrtpj44CTLfhaErIVK+1jRW864uWMPYbLej/3C2eVOUKcCEPfSKdlHupaPny+HPPik1D1tJGBwQwE1Vj1SBHoxWTUceEHj7E+fZbDeh5Mmqla7muHdyZi9faDKsy1F/V9tldcPzjcdUsWhJmTaVUEWmdhRxt/mScYEbj32oEWWEu+E5aZFsuXSQC2thhAZm7oqsMTq+sJyM7PmjbfTzgVRbHzaOnhOSU/dIm4OHTGicGwc1rb++F7Q4XAZiAfK0oArpBsZCmKHwfhmYFhZN8qOy8WRaQISMNf7/6NiDknkUWY3txknOJCn+hh9TeazCS5KjlSIRrIWeFb1y1iisfqUNXxlCzl5ETeRNCb4ZRV2hdHxct/aT/1ofrNEK289VGFV7sOODr4+DFoIXkeHyhPC7gAHwXsFNtiM6MKyF2W4WMt9LZTpNPODFeWq2//oBwbXaA/G2/EiisS3aDfGrZWKXoSWp4smf8/fjAmc=
X-Microsoft-Antispam-PRVS: <SN6PR01MB4496EABC7F567A3518835F66B5920@SN6PR01MB4496.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4496;4:8WxYgjChtjqaLbr6JEPmkat7pcrnWlX3FeRHgeNtPyD3xIN1LcTCPU7sDcEoVxgTCgU2qS5fbfFeAWIFRLYUNG0YpvwZMoL3/qrjEJK3pXer6kGkxgzR3s3a+CtYEb3QYJurVDlvSfXq6riOpiyb9KA7UThEMkBtdoSWq4COsYp43JBm9ATt+LsBEdPtl1w1XjjrrzYh8APuemvtso0UaYHas6stzbvC58pIDXw8ku3WhCIVCZxN3qvZJ5Q5gWbvJd5g5rcZ40ZM0Xcy3aRUBCaVs8sLd1P0B+s3L5aPipI=
X-Forefront-PRVS: 09352FD734
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB4496;23:WxvLJYcp08m5K+DP35M+QjxFuVRgO61Zx68wwoRIu?=
 =?us-ascii?Q?WBBWPgvU2TIYlSnGOCKqARv6OFcKLhClY1N2lSZjyEOu5H4IC5rCwXurRaQ2?=
 =?us-ascii?Q?gY9IG68jjLumA9GypmJ6EqrlXMBfI7uGb7DzoTu8gorxwE6BVuiiWl4TYkBS?=
 =?us-ascii?Q?XWTHB0o6QkqQMZMzCb/UmhmeFvInTquOteg/BqZSbawzMBJH7Wn9esj62og/?=
 =?us-ascii?Q?VIRj6JN5UhAlIDn1PtYR7wKeVjpE1Bb4VAUxCGEzsqbD45KnfgMuwiEh2dUi?=
 =?us-ascii?Q?qELrYV7szJSzkyfCl4eIIWZ5EvMfR6BsTM6jZLK70G3Rn+MMKT14IRyT8KK1?=
 =?us-ascii?Q?PpyreNHm0lhEN3D3ZL3ErLsIe/8jKXrN0lmpopd3vLso5ocGwswQCqhK0S+j?=
 =?us-ascii?Q?dkCxbRsjHwlwoFvx8opM+3LFLnitlVX8PtNdhAVJMRX3qs6FD+fn4ekGqwWH?=
 =?us-ascii?Q?F5SukOfjm/at2Z6YLYMO227OYDwJZxiBcWRtLQjntLSzG1O802qiVFVeKDoj?=
 =?us-ascii?Q?h4TgyPH38kEhvQSEid6bBRnk6CfaZW5BCM0zF7SLIS8Q8HpD8DTsGJDlenAc?=
 =?us-ascii?Q?T/WccYOC1D7HaqTcN7aRQxG9HbyeeiBun3GzktolGQxfACwvSWMdVGf2l4cb?=
 =?us-ascii?Q?aPDfReeDodn41M8p9YoxwqDyUmfvwDb45bRV1guBvnpYvRkHr6WYW7nTi93t?=
 =?us-ascii?Q?Zi2GPlbr77MjKNhmKrmggxU7PafdMrEohC0WyTK6DkT7bsY8NtwdPvYS8P2m?=
 =?us-ascii?Q?S5UKTNcCRh1eAQr/pZUBOwa3qGeQJQ4jgASZUIe1UelN36G9edYMw31ARiED?=
 =?us-ascii?Q?g2VbfLbqKcY5uzHkg9wR0Rn+7MM3yIlAIs6SpaMisiN6n9ITj5alqr8T54DP?=
 =?us-ascii?Q?Oyk5vVciaF0ZpVh46qPP2ekT/bevfx+OOP4NUg7pi8nuB9QP9OF7V+/wBd+H?=
 =?us-ascii?Q?Yt4EkO198k/1cxV9ypVLzGfdqOER5hh04b6EtxYYIrQs3J3yc+cFkhEivu9w?=
 =?us-ascii?Q?JKFe93Uc0gCTH3LVSWdoWL3tDc5C1WLe0Reqzdxts3Tp9D2nF7OadRD+K6Wl?=
 =?us-ascii?Q?DTHVIvySB78rr9Lkjhg3hO4dNlNMBXYxtmjujG5TMd/ijQzbXtOphrWiwdjm?=
 =?us-ascii?Q?Hqpmp4EVvGmQhgSnoxlKlZV7fBwb3F7jn1CgEclwTnLMnOlbYSNcg=3D=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 806eO8C8d71WPu6eEZnxYwTLoMp42uI7/LPJbkDyqE875U4agkV7e4OWVeSDPpHHgarwmqE33b0gxEZJu3fiZdpk42IdPHcn6En17raERAkIAmg11PkkXwzamNDsVK3o+TAA1AySHMq36qv7GhfLUsqevOcAXyhfm8C2pQLdBeFlAkkP9gA9FtsCVe7k3xtWB989PYxc+/4nSf8nPlkkrixemGN+GXFGzLLYHjQ+0zVgOlWo2oA6CA8olXdMfSAyTTnn98Zy6zOonDy35ntZrGWpO7xasHehW7RaI705TL83HNUU+AXvDZ0RmjUSG19HnRj1bXr294HWHhFPjm4ickBbbN1ztWORsSHAyApMA4DI7bVHx68cBNiT7b5w/6/tUtkxJZyoBSHIdy+52wy323nKqjyapVQenUB/Q553OqI=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4496;6:zEuZe5CQHw9xHuH594f30grzh3ZlDADQAWukCdXCslOsSDm2pbCjzNiazsPrkZqI9IqBXWqC4TPEc3B1dvz7rGZqbMykIKYH+WS1O+NNITi/ceHyIdMGEneI20ulED0aZpL6xm9W0/nLm9FoS9ZFWteEThqFSiKy0DZrQdqmtHFtxQQ/fBdnihbjaXsZq1Gs/Wd63HbIPJAWDadAMBcpQPhKx286R9gX0uDRm+50R1piGU2nfgUchc8M17Nxj+0/s9gBFe3b3BbgCfnxdjA90ysAuq8OqS7Xv86X8hQTG2rKnE/ySyxdLr4pFdjvZ8NS53Kvh7gy4tVEvuuQnLGEyG1hElGA8mjrjZureaNoA83MUlWltPlvl5T/DEJuX/Qs8rExbbBJNb1TX4KOvDNMpamFVBC7D0qnpEitEpTifpEZXx2VAsM7seicCiiGZ876a2Zarm/Z/HWDAr5WQXK+fg==;5:eKUhuDJ1wP9/oYXX4jxZ3z0Fbxcbrp9nh7amf8NW/zaKd7fxLwjYyVOApfxKqL9oF8n0sdv6WrrqyZQi5WaxAWGUPKb9vLzolRkRO1lkr80gb+UkksxpFpEln17CohJbc5yMaReJOB0eszuXqJJHN5vNzvK70NTFBTNzAAAAN1wwYMaRkKD1lSbyeWs71MuMpEL72+Mc/FW4mIyUD2BxZQ==;7:YGA9+Yl5tTGbWsTnwlmP+Sm7NfM1UyYW8yf2SKTtai+23Y43fv1l1bokhnB3NFyYl9tCKRXBpl/iSALI9QhQIQK6RM7h2SDnjQAqimz8Lot34PBOoRqLd9O9elpgNwOD9K0JsOsE0XFB1hV9f9saYQ==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2019 04:42:28.4445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 459685f6-bc99-4537-ca68-08d687ffabb9
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4496
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This reverts commit ad211f3e94b314a910d4af03178a0b52a7d1ee0a.

As Jan Kara pointed out, this change was unsafe since it means we lose
the call to sync_mapping_buffers() in the nojournal case.  The
original point of the commit was avoid taking the inode mutex (since
it causes a lockdep warning in generic/113); but we need the mutex in
order to call sync_mapping_buffers().

The real fix to this problem was discussed here:

https://lore.kernel.org/lkml/20181025150540.259281-4-bvanassche@acm.org

The proposed patch was to fix a syzbot complaint, but the problem can
also demonstrated via "kvm-xfstests -c nojournal generic/113".
Multiple solutions were discused in the e-mail thread, but none have
landed in the kernel as of this writing.  Anyway, commit
ad211f3e94b314 is absolutely the wrong way to suppress the lockdep, so
revert it.

Fixes: ad211f3e94b314a910d4af03178a0b52a7d1ee0a ("ext4: use ext4_write_inode() when fsyncing w/o a journal")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported: Jan Kara <jack@suse.cz>
---
 fs/ext4/fsync.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 712f00995390..5508baa11bb6 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -116,16 +116,8 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
-	ret = file_write_and_wait_range(file, start, end);
-	if (ret)
-		return ret;
-
 	if (!journal) {
-		struct writeback_control wbc = {
-			.sync_mode = WB_SYNC_ALL
-		};
-
-		ret = ext4_write_inode(inode, &wbc);
+		ret = __generic_file_fsync(file, start, end, datasync);
 		if (!ret)
 			ret = ext4_sync_parent(inode);
 		if (test_opt(inode->i_sb, BARRIER))
@@ -133,6 +125,9 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 	}
 
+	ret = file_write_and_wait_range(file, start, end);
+	if (ret)
+		return ret;
 	/*
 	 * data=writeback,ordered:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
-- 
2.19.1

