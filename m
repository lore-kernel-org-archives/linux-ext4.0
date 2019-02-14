Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D862C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 21:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26AE92089F
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 21:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="Ad9ofMvM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391825AbfBNVE4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 16:04:56 -0500
Received: from mail-eopbgr690129.outbound.protection.outlook.com ([40.107.69.129]:45509
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387417AbfBNVE4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Feb 2019 16:04:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3id78EfZvHUMdmihpR078qW5Xg2q0a0qDyq0tvXq/+I=;
 b=Ad9ofMvMpCEZmj+nZToxUdI/Ltft8+5GhEmFvLnid6fkhXAiXQnLBMF4FX0NMjCQHxXr+ugAMxECO6wRzG8k8c+uEO2ottvqq7+rMmAPJVF9YcKWmsdlooFH7RrMPyBdku3lrCE6dj8AqJOlRol4ZZSKOlfn/Jo35Zj0TkA0yGI=
Received: from BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) by
 BN7PR01MB3988.prod.exchangelabs.com (2603:10b6:406:92::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.16; Thu, 14 Feb 2019 21:04:52 +0000
Received: from BY2NAM03FT060.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::206) by BYAPR01CA0016.outlook.office365.com
 (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1622.16 via Frontend
 Transport; Thu, 14 Feb 2019 21:04:52 +0000
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT060.mail.protection.outlook.com (10.152.85.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Thu, 14 Feb 2019 21:04:52 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1EL4nDH008760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:04:50 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E55CF7A4F16; Thu, 14 Feb 2019 16:04:48 -0500 (EST)
Date:   Thu, 14 Feb 2019 16:04:48 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] libext2fs: revert "try to always use PUNCH_HOLE for
 unix_discard"
Message-ID: <20190214210448.GE7387@mit.edu>
References: <20190114233708.GA20465@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190114233708.GA20465@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(376002)(136003)(2980300002)(199004)(189003)(36756003)(4744005)(26826003)(8676002)(1076003)(786003)(316002)(6246003)(36906005)(23726003)(14444005)(16586007)(478600001)(6916009)(58126008)(336012)(90966002)(11346002)(446003)(2906002)(42186006)(86362001)(46406003)(106466001)(47776003)(52956003)(476003)(186003)(97756001)(88552002)(2616005)(50466002)(229853002)(75432002)(6346003)(76176011)(6266002)(33656002)(126002)(246002)(356004)(103686004)(305945005)(26005)(106002)(8936002)(486006)(4326008)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN7PR01MB3988;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT060;1:/EVYNgh8ujISxxMx1BWvEUxYH9V5i8JS6mWx3OHmbB6XA+THE5/Q8hO+xo6XubZsUsq2JU9wyI8hgOY7L8pcRUFCEHMK2tLh/h3n6YAWn9PSD/8BxAW1xOg1XafedAtoyWrRhbSKgUuQisMu/GqU3g68L+I9yLFHKTlXL2tk7dU=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a456514-d424-4c8a-670c-08d692c01072
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:BN7PR01MB3988;
X-MS-TrafficTypeDiagnostic: BN7PR01MB3988:
X-Microsoft-Exchange-Diagnostics: 1;BN7PR01MB3988;20:CA0uIehmA37aJSY74YUqhd9bySmiQksVXs+3q751l+VIPmT1JSIQje1Za/qKrbFgVOiDagvR61lZXyLBDFI9Y4tJZk2XXFh6esez3Ohfh4pl6WJDBNQ4p21S7ilxl3UMxAgrqdZ9bDfWcGIr4iH6U0Xpp+vUEb87J73Ti+5/Mrtaqv9mK0Mhayx3U3MoF4e2LQwMGwViORiakWnFvjYqULHYFNRWEw1zP/QY2PrE7pl+exYKt5nXLCZq/3AsQm03U6XM/q6cS3DhWUfAphVZqx5bmv6bGH33V4DuPNVNHGCmgFt8IXY3FsrIUAu2MAA0JduuM/zQw+hAboGfc5LIgTY79bM2PDPratiYYXTl70EGei1C6d9i7BjC7CTOQpmgbBapOgzmsSgCM0N5fxZP6VMEUYY18FTH34Qll7e51ly0z2BGuEUqgEGVMJMlRj7EFHO/gXo9stEAllHXq5CaX1MVoZlGzK/hX8s+xP5ytjhW0fPJt7NBMBptRt6tRpAevKXF02x2H0Pz3i5s4GYfoTlF8HA+/I7hOVmWcMfsucy1ZtFjJi5xfFcybzTFym3Nz9Kp1obiIlejAk47fJAXux49djaWcLSqADbmf+Zdw84=
X-Microsoft-Antispam-PRVS: <BN7PR01MB398808A68CC60D6C28753F2BB5670@BN7PR01MB3988.prod.exchangelabs.com>
X-Forefront-PRVS: 09480768F8
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN7PR01MB3988;23:5bY9BxfTwVq0I1P0B+jmk92tfn6+eZfBYUtRs2Yhl?=
 =?us-ascii?Q?0miBJbMkm8ttkiEBw3eIwlJrh749o4udblmZH3/WuXoi/u5W3Sw0xzVRah9J?=
 =?us-ascii?Q?LZndfz+KaUY4jxcCYAK5CmVXXlMXR8nCL9BGWMOHjk42Yz6bKZ+Lap1kiM/x?=
 =?us-ascii?Q?Co6hYC5pJg0q1BPX3df03uRiFkiqDsUkAbyt0AnIM7MhhJv2xpXbd+IdMpbM?=
 =?us-ascii?Q?JAd365r3zv7I85AoBdiCersViFQkQMnRwTTMdPmqURv6uPCg6ZBsUL1btghg?=
 =?us-ascii?Q?FINVCCbZ5Oinq66fNC27DLK45gmVNQO5uOa1KjjKMhVKhG29wjwxOFXKKrTA?=
 =?us-ascii?Q?zQOwqKbWAHEFh5/0yKIyc6S4hMbQ4QuzbsLjTB4GsuZto/JPzT1L5ZTAUmKx?=
 =?us-ascii?Q?e8W+Uxio9jzksndPUGO8vknrRViFcr9R8eJ4C2D15FG0TWvXo9ZJnkjHWEdv?=
 =?us-ascii?Q?d3a18mixnkBsojnMSXas5TcLlPAp/wTmxKNMg4j1vbHcXSSSObaZHI/N3Anq?=
 =?us-ascii?Q?llbTt3zJ7aYLA4QUg+kpcrztoRqpmmham1kTyeS1jjSTxRh/sGsg9OcmmsYi?=
 =?us-ascii?Q?/a0GgsjeVBa7LHnxtk2ySzQ7bOjZt4WocXsnrHJCjMeBAwN1mbTFQ15IF8/p?=
 =?us-ascii?Q?ap23cdie30sGfdiwQZ/FA3LteXVjCjenX3PE1+/l87BOYMWv9EURP72Xtv6e?=
 =?us-ascii?Q?kdrpjteEAICBwVAolQ8SW82KATviUA9dvIvzCvwK38xY2amOna7bYrgtPtFu?=
 =?us-ascii?Q?QS+AAPTM1js/JKrSNzyJcF/dmd1fHBHSJFuMHbt2Kl8P1hO68JSHUoDV9rcr?=
 =?us-ascii?Q?qceqp68nnlJxGVzP7Uy2STpXHbKnLpVDJCfH7BOGhqbjU31zaSOUvyY2JsDI?=
 =?us-ascii?Q?36OSP/jV26oKqkZF+w7rKd3iF7L4kKyAhRTqAu80qBwcT0KFxsx43XMZzvLX?=
 =?us-ascii?Q?1wgh4+jGjAgBy+Ofv601SlIJx8JDO+RzlavyJakxlDbupm7CmE0IpCK4wzlI?=
 =?us-ascii?Q?XPZ5egJd0gEV8wmdCFCPTJ0qLFPGa14Wka5jnQQYZbwTsEHpWRXs+XffM9w+?=
 =?us-ascii?Q?whkAFAcC4xDOztGbyPW/kHxBk25Vx63m3U79RWi23+pb2tSAo4eaQAhYKeoX?=
 =?us-ascii?Q?CM6SeEF16slPtCYOworAD2VYJz5pRNpyMNGrV7VsbI2ghNp6QjwYUgUMQvh4?=
 =?us-ascii?Q?ZpDYSySsyH77c3LTziff+KiC/ZV/qASJlMT/3v4O6/XOh3ymumBS9HQUn1/U?=
 =?us-ascii?Q?3srcVhmgg34w7zxHm9W9BonSrHa/cVdxdjbv+CL?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: UHP/umAoD0q56o7ZjAvbidQkxViUbKOyTtozRSzzNCW08sqO1GyYKwpxELxwzMPmTuZh1CHLrURS4hsQLdIkwH8rJ+CIMebEDqAAMz0Pe+BrZ7yhhiwdkJwM+KJsg9gLWLHFIpcd2tPCNi/8fgSJdsRokO5CXvH04ssvEt/KSLgxgxn2EFV8q+J460AXEU3tCJBX7JIA63hGt3J1knzuXA4K+HVmhpK7RSty3WxL9iEh3QDdPAv9525GXXMr3guS+yDrtKJlfER6jKEcadThp5i55ZQ50K4SsqBaRiy50HvdbD7njsXhE9CxnPK/3146hRk5zlueRhUNHGiI0UTJkxA/bQ/HZFEAoBIxP6av19tHKxcmpvw2HTAU5Ei2vMuPlf2HsmmYx+yyqntK5bJnGncpm3/2shAge1qfdGhvmcg=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2019 21:04:52.3430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a456514-d424-4c8a-670c-08d692c01072
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR01MB3988
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 14, 2019 at 03:37:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Revert bcca9876a3428c10417c660b78933e6e70e8a5f5, because
> fallocate(PUNCH_HOLE) on block devices was changed to use zeroout
> instead of discard shortly after block device fallocate was merged.
> zeroout isn't necessarily a "drop storage" operation like discard is,
> so we prefer to use that on block devices.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
