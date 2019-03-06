Return-Path: <SRS0=J2/x=RJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4BEC43381
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 23:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 052B320684
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 22:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=datadirectnetworks.onmicrosoft.com header.i=@datadirectnetworks.onmicrosoft.com header.b="SRr9pC6L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfCFW77 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Mar 2019 17:59:59 -0500
Received: from mail-eopbgr800071.outbound.protection.outlook.com ([40.107.80.71]:60064
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbfCFW77 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 Mar 2019 17:59:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=datadirectnetworks.onmicrosoft.com; s=selector1-ddn-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTNi7VuQJWocuYcE8cUMlkII7Fi76COKTNAYaBrM+oo=;
 b=SRr9pC6LyFwHYssEAKn3OFBaj48PZkPFPiFU7Nxc/O1Pa7T1Ia7zku1GeuZTBbcqPryk/bIz2Tg4qPgjD6TOBgD1Ai28oZoEIyajWsxr9khJXM1lOzfEE+rp7KgOZ437BAXCiyWrR2/AAyu4nRf7wh0kow5wQxD3YjsQZlSm1c4=
Received: from MN2PR19MB2592.namprd19.prod.outlook.com (20.179.82.160) by
 MN2PR19MB2830.namprd19.prod.outlook.com (20.178.253.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.18; Wed, 6 Mar 2019 22:59:55 +0000
Received: from MN2PR19MB2592.namprd19.prod.outlook.com
 ([fe80::c4fe:784d:706a:ebaf]) by MN2PR19MB2592.namprd19.prod.outlook.com
 ([fe80::c4fe:784d:706a:ebaf%3]) with mapi id 15.20.1686.018; Wed, 6 Mar 2019
 22:59:55 +0000
From:   Dongyang Li <dongyangli@ddn.com>
To:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: [PATCH] e2fsprogs: fix autoheader warnings
Thread-Topic: [PATCH] e2fsprogs: fix autoheader warnings
Thread-Index: AQHU1HBQ5R29jvt+UUaJcyCPsrdsGw==
Date:   Wed, 6 Mar 2019 22:59:55 +0000
Message-ID: <20190306225944.12993-1-dongyangli@ddn.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR18CA0031.namprd18.prod.outlook.com
 (2603:10b6:320:31::17) To MN2PR19MB2592.namprd19.prod.outlook.com
 (2603:10b6:208:102::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dongyangli@ddn.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [72.2.43.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dde345fb-4038-496a-f0a5-08d6a28772bc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:MN2PR19MB2830;
x-ms-traffictypediagnostic: MN2PR19MB2830:
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;MN2PR19MB2830;23:ytjg8Ma9nPfuRJA5ZXefoG8Aoy8BV58aX4mKM+g?=
 =?iso-8859-1?Q?shLovnXsrVv3lWxsr9GHVmfY/Ged1Gvv2LsWRNsFfvHFB+NaIyEKnYHxK9?=
 =?iso-8859-1?Q?kaDCJXVLTsD/XwqFPKIjuT1dxrHdZ0H6KepOzz3UYneH8DS1FXedEM8xX7?=
 =?iso-8859-1?Q?dCki9vyS2lQ+RcSuUnkKqLU+LKqS/m5Bapwk4FAAevEXRb9eSsIqa3B4wy?=
 =?iso-8859-1?Q?TepGfTxOWKKSzqjL1xI+8yOp+6TsJGOAFNmhexDFM9bzvsnKAg1gEG0TOR?=
 =?iso-8859-1?Q?EGbT8D6wAjKJ9W+ba0ptLP1gI1ILAvuEt2SaOD71MX6aP7+oS4g0yZbq0T?=
 =?iso-8859-1?Q?ykrMWfNNrmVo88FT02foHjtW8avcfvKAxTABufll5wWupHEHWHgrH8oic3?=
 =?iso-8859-1?Q?cx9jwKUpRpcXF51RxhVaXcD3o89Gw6PY/8B52K03D+c39dHCgyb5PS28cz?=
 =?iso-8859-1?Q?AC+fqQDsp3MbfJ35BQ/UMsnQc7lgVJtnPmkcOSzS67k1BxObu6AzcqYVZn?=
 =?iso-8859-1?Q?aBvwdPUo+rT/6verJvhiBZ7DpBltTERYtkotvlh29i4yCak6bB2ZtNtPnm?=
 =?iso-8859-1?Q?1rkmroHcAeOXMyRv7HUvjRYrMGp6nD3AgZmN7pmzjHC0IZ8C1E8+yv66Nm?=
 =?iso-8859-1?Q?T2Mow4BWTe+EaUPgRN3PAe5xQP1+ah+Z3b9in/8Om0I4OaxnqtAUftyNYc?=
 =?iso-8859-1?Q?Z1GfrSWCZDtbrHacGOMyxotrm74weO6OL5IQIsPsaRZRFSEmdOYH3id2Kl?=
 =?iso-8859-1?Q?Ww+oYbCEz2tdLaNX+1xlvEk18Z2gfr4g9vCooj59mMg2DaY/+NSsofXUL5?=
 =?iso-8859-1?Q?PQ5XtmZDOJUJw3BpTqNk4hCdW0BdZ9WahKaDsdvAiajUZ+iI4tchAau5Xc?=
 =?iso-8859-1?Q?pGbnARVUrvL+ICvUJtBocE2vI2BEFNuL5C/INv86yfKeghv4axPF/TxDlQ?=
 =?iso-8859-1?Q?B5hLVeayA+PQrkU9Vyr4paCcWk1Pfc9jHVCbL1SkNS/ZCvflZ31iyJasW7?=
 =?iso-8859-1?Q?zlILsExJQioRONuEz0MaIuSaaCSVmFxq7BZOY+RvALRA4YMIKQ/Zg8DPTx?=
 =?iso-8859-1?Q?apd3CN34gT6YAoRmvVJDAHrzXpu3nKGtn1NKMHmCYdU4CZx7dMHAbHZfKB?=
 =?iso-8859-1?Q?rD7Me5tM/LsXmGoj0UMd9+Af8Mb0uv1JBOTmPio2SzXi3Lnj6uLLpVMTNR?=
 =?iso-8859-1?Q?yL3e+yjdcYss+9PnOoBlMhDpnIatSPIb7jZaAmVDfqYXJpicceIyJw=3D?=
x-microsoft-antispam-prvs: <MN2PR19MB283062BE836A92D4B611C8A7CD730@MN2PR19MB2830.namprd19.prod.outlook.com>
x-forefront-prvs: 0968D37274
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(39850400004)(376002)(136003)(189003)(199004)(52116002)(186003)(81156014)(8676002)(386003)(105586002)(2351001)(1076003)(305945005)(476003)(7736002)(2906002)(53936002)(256004)(6506007)(102836004)(6116002)(14444005)(2616005)(26005)(97736004)(99286004)(316002)(3846002)(86362001)(68736007)(71190400001)(71200400001)(25786009)(50226002)(486006)(81166006)(2501003)(5660300002)(8936002)(478600001)(36756003)(6916009)(106356001)(6436002)(5640700003)(6486002)(66066001)(14454004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR19MB2830;H:MN2PR19MB2592.namprd19.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ddn.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kt17LTc7luaDfuewklcLAL1PtZruL4R3UTMXGo0J66rleuO5N5gjV9R8gCM6MMhMvUYVMq8LYCk36poMkQPyhUNY+qASiXqGTT1+nkI6Mty4grV01jZQ3B8mk4UU6k5tamq1E0QGy+XPcPW5snv6+HVFqE/grkM42aT3emRHd+u/wYOdOozVffRXNH/nD3A3G5GmIJ72diYsTabZcq4SoK+DFsOpRAaeeSySzxuIBMGNuQoO4piTEoBVpOs08QlDfOGzT1I3JC5xy3MK7uDFx/1dyEfvrZ6T1tWlCvF0xfBKwypBjVfarnv56kWG6FX9NWJJQ8JmeSlWobyScYbLjgDi6RmjNNNnk88butJqIC3k8NUI9QSt8HOKP2xF/dL4Sw5/Rqv1yo0LYwpVNqr04IMkp8RbII0hCdzFJveabos=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde345fb-4038-496a-f0a5-08d6a28772bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2019 22:59:55.1885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB2830
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

autoheader complains after 1.44.6 release:
autoheader: warning: missing template: HAVE_BLKID_PROBE_ENABLE_PARTITIONS
autoheader: Use AC_DEFINE([HAVE_BLKID_PROBE_ENABLE_PARTITIONS], [], [Descri=
ption])
autoheader: warning: missing template: HAVE_BLKID_PROBE_GET_TOPOLOGY

This could fail automatic rpm builds.
Fixes: 7154d97 ("Check for the newer blkid functions without adding blkid t=
o @LIBS@")

Signed-off-by: Li Dongyang <dongyangli@ddn.com>
---
 configure.ac    | 6 ++++--
 lib/config.h.in | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 248b291d..3b86c1a1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1119,9 +1119,11 @@ dnl the functions added after migrating that library=
 to util-linux
 dnl
 if test -n "$BLKID_CMT"; then
   AC_CHECK_LIB(blkid, blkid_probe_get_topology,
-		      AC_DEFINE(HAVE_BLKID_PROBE_GET_TOPOLOGY, 1))
+		      AC_DEFINE(HAVE_BLKID_PROBE_GET_TOPOLOGY, 1,
+				[Define to 1 if blkid has blkid_probe_get_topology]))
   AC_CHECK_LIB(blkid, blkid_probe_enable_partitions,
-		      AC_DEFINE(HAVE_BLKID_PROBE_ENABLE_PARTITIONS, 1))
+		      AC_DEFINE(HAVE_BLKID_PROBE_ENABLE_PARTITIONS, 1,
+				[Define to 1 if blkid has blkid_probe_enable_partitions]))
 fi
 dnl
 if test -n "$DLOPEN_LIB" ; then
diff --git a/lib/config.h.in b/lib/config.h.in
index caa3faee..407911ca 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -73,10 +73,10 @@
 /* Define to 1 if you have the `backtrace' function. */
 #undef HAVE_BACKTRACE
=20
-/* Define to 1 if you have the `blkid_probe_enable_partitions' function. *=
/
+/* Define to 1 if blkid has blkid_probe_enable_partitions */
 #undef HAVE_BLKID_PROBE_ENABLE_PARTITIONS
=20
-/* Define to 1 if you have the `blkid_probe_get_topology' function. */
+/* Define to 1 if blkid has blkid_probe_get_topology */
 #undef HAVE_BLKID_PROBE_GET_TOPOLOGY
=20
 /* Define to 1 if the compiler understands __builtin_expect. */
--=20
2.21.0

