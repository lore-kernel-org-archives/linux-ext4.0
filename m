Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0279C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C60420836
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:18:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="OHLy/upM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfBUQS2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:18:28 -0500
Received: from mail-eopbgr780103.outbound.protection.outlook.com ([40.107.78.103]:18816
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbfBUQS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 11:18:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1oXjuAc2lE7FXCeSFDTt53f1XjkVjrXB2r3T07b7bA=;
 b=OHLy/upMY37T/y5ujAk6Sm+Tbz5GRVgOyoVo513KoW7xYVhpidpoOmj5WAtXa2skzlG4sAYBNY8UqMk1Q4B3calOJQiKQ2zoW3jMHFlPocOHM4c7762JgqPTNOiLD1g3lhid1K5c+dcRDB/X3PT7gzWr0DzkH/yKBlir1Cwn304=
Received: from BYAPR01CA0020.prod.exchangelabs.com (2603:10b6:a02:80::33) by
 BN6PR01MB3284.prod.exchangelabs.com (2603:10b6:404:d9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.19; Thu, 21 Feb 2019 16:18:24 +0000
Received: from DM3NAM03FT034.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::200) by BYAPR01CA0020.outlook.office365.com
 (2603:10b6:a02:80::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1622.16 via Frontend
 Transport; Thu, 21 Feb 2019 16:18:24 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT034.mail.protection.outlook.com (10.152.82.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Thu, 21 Feb 2019 16:18:23 +0000
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1LGIKDo003472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Feb 2019 11:18:22 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 538C97A3F79; Thu, 21 Feb 2019 11:18:20 -0500 (EST)
Date:   Thu, 21 Feb 2019 11:18:20 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] ext4: Fix some error pointer dereferences
Message-ID: <20190221161820.GA10245@mit.edu>
References: <20190103113811.GA13543@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190103113811.GA13543@kadam>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(136003)(39860400002)(2980300002)(199004)(189003)(478600001)(26005)(16586007)(4326008)(42186006)(88552002)(50466002)(558084003)(86362001)(246002)(54906003)(58126008)(106466001)(186003)(1076003)(6266002)(8936002)(8676002)(316002)(97756001)(786003)(26826003)(6246003)(36906005)(75432002)(36756003)(356004)(486006)(46406003)(23726003)(229853002)(33656002)(106002)(6916009)(103686004)(2906002)(336012)(47776003)(2616005)(11346002)(476003)(126002)(305945005)(90966002)(446003)(5660300002)(52956003)(76176011)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR01MB3284;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e32a2213-28d4-4697-9c8a-08d698183411
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BN6PR01MB3284;
X-MS-TrafficTypeDiagnostic: BN6PR01MB3284:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3284;20:JQrQ33y852e3bRQQcHyewB2uThWctcePqx6VDRjTtI+alR1IWJ8av0QYIKF585PsprnrU3MDgCiItJngccKdZZao9meigjS4H7aUU5yWWzkD8nmbzoO6tUbKtMLmYEYdHKiYrn1foiVmTCtOG5h/ogdJ9B3Jv/pXQvlAMsThYCKKuwyh96nyKcvUL2XkN2dEySK6NN8jq8aRgjV+6OdW4kCfd25SjtLpKI2bnq00q8LOmMgNBYjFOdxv9RPmspGr1vioFQvgsYCUr+fGLypevF7uVT2LU/6WNNaczlMxHuPdmBGirn0zK7Oh0sCIEwNa+IMtlsZD5Ixfys14q1d2BD1LVlrNJLrb56FgxE9FG0IoSyV6Pa9J5ycybVGbnhyc7E9HIU8BviMZ4UR6KnIujO/CAb0co3zfU8Ssq9VKw2oxj7FZfZ6UbGU3RFWWQCd+u0NjSA3/Fz256Q5dQi7ad/Yq+CyCCOM0y2C7TOFZDDbOcdlcvw7k2i8Hc35Pgp9CbRxb0Vw9ijn1z4fRZRmg6zfN5vF7MsxpfF3VhaGU9MXvNBxGXRHCAtgvLBdkoLlQqVxnacn4Wx0NSawMyeVPqtdBOn25toQCtKhLIzvW998=
X-Microsoft-Antispam-PRVS: <BN6PR01MB3284392EE3E56049066CB258B57E0@BN6PR01MB3284.prod.exchangelabs.com>
X-Forefront-PRVS: 09555FB1AD
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN6PR01MB3284;23:vvlQuI6NHkC0+ABHEtPErr15g8f/l9M0WgMLPg5z1?=
 =?us-ascii?Q?YOzisknXjZP6ljCe+1nnMt6ZohkhN+LGPiIYbaLaQrygxGxviramg+bAvfmN?=
 =?us-ascii?Q?4pN5IYGLaMIuQKuOLGI86eLXBKwUn2j8fHGisME+HH9tNo4jFhbtk1/ycUX3?=
 =?us-ascii?Q?Lwv3NvB6V5sQRJAh2sSTm905cLkJtKrxzISPXeX9nv1RdBHkNgf44Bv7AlYb?=
 =?us-ascii?Q?Vi4YV/tPrcYCHs9Budlkb/+sGBwVesQVwJkd3y7QS02kxHePJDbwr81Ofz4z?=
 =?us-ascii?Q?P16jfkacvti/vEUDKYP89eV8ZkdybbNMko3LTpgchiF6upa74GNTumtMbdv5?=
 =?us-ascii?Q?lCiT78r0IrxihIyOH8fXIj62kUAbGhOn8LD1z7ZFQPej41QrgXjasrLupG4Y?=
 =?us-ascii?Q?ZTSMLC+7Y/kv89EsNSZN90N/1hxBaQcI7cEjx82jqFMfDMR5rK0sIZCi8F3s?=
 =?us-ascii?Q?CNxBDOLlpjkvkaC8/sDcy9hhBcQSvefJLesEYe6bQLlxzgARrivXG9r4GsYY?=
 =?us-ascii?Q?LX3EARKaMEHLH0peWvnVs6+poaUbCRDcVc4HvQQfUO+Gwh+0ew/Ziuk/fBvs?=
 =?us-ascii?Q?sGG/XAntT3FuydbLaexEO53r6kBHLjQZ6wR8HjIwfYD9dpF7WqG7AtilvsoB?=
 =?us-ascii?Q?yuwFATuPwQL7wa5qHIuEwN6uPi0xqWj6LOfJun5xm8RRI1TirBHawnLyAoHT?=
 =?us-ascii?Q?ehus0MRJxNLZBc/wuygKdoHJFMc6/Op7VbM56Vt2aJPijkC9y5pmG6kKFQCK?=
 =?us-ascii?Q?xZ7Zq+N0DskMUILtL86bF35tBsRGRFHkTuURzn588EHJ9mEOFqoAANi4mMKW?=
 =?us-ascii?Q?8YI7U6Riy5wyt571aXxzg9Lha5euoryyH6wmaHUszWDKpiCmBHfjvnmN32HU?=
 =?us-ascii?Q?DfuGFnBS7/QGkRsACjD/eAKNUGDdojyaoebnf9+8qpxNX/MyYilmEP0ZRyqT?=
 =?us-ascii?Q?0SBskMYbRCbNBIcPHUJAhvVDQ/FJ8tdoZugxaM34AH/vawzzGzZi9vzaQ6vu?=
 =?us-ascii?Q?VLWuUZnUYWYgxc+S7ahIPMYwqsLlRVeqJcIyxz0WSVvkIbvwAd69+is2c9nT?=
 =?us-ascii?Q?rFQWMgComLogJ2RFZ2XpMHsH8xrH4a88DPrmDx0qru8MZ9gOYdGOqgRdratw?=
 =?us-ascii?Q?B6LHl6K1sO9PydW2fWcxq+JNRoF+sVmfe1sCRQ1MZjF7XCwegLJzCsbW7Ox3?=
 =?us-ascii?Q?ZU83Aa6eHBjPB7W6ep05g0stfvTOqQDNx6wTM7/2Coa5FjY/Zis/wh9gC0uK?=
 =?us-ascii?Q?1hSeE7CtqfGuGbYL+7ypyp6n//3od8eZxxHqJPGv0tvI7gSfmOLpDSpmFFlN?=
 =?us-ascii?B?UT09?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZVWFbYlWJxAshYmW28RnKHXFI8DLE8EcA3pnHGQ+nZJQKejMOT2RkUdxZca5EDpE+SElxXHQG+V/37LNAo9imMc9fznJaCYE/GRqgKixe2y6JZB0momsP5WMRVJyD5Jk+RRYojo320zEWBQzK453/1f48fgsfUSkIQ4Ho/j1UwIdXNZUm5qlbt7qVFoq1iLQU4Q+RIN0QiXGMoTFHIofAMKhRSfzrHshdAgH8VvgqYtFJsUMyG3k9BIHe7yRAIWdTAVJIkBf4bvg8zMZchpyyviJStWJ7Ljio1BKdJ5F5BfcU2yIQDPQg3H7bpzlRoIhoGbI5BSkAiZNdvCWIMM7C1nRRdI4TbzcQvxgdy0F5yartaXsH5neoavwYl+qOLIaQlCd7Z3v7EoUsa+OvasxKZlb8ud+K4Hy5n03Kwn14R0=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2019 16:18:23.4866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e32a2213-28d4-4697-9c8a-08d698183411
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3284
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 03, 2019 at 02:38:11PM +0300, Dan Carpenter wrote:
> We can't pass error pointers to brelse().
> 
> Fixes: fb265c9cb49e ("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.

						- Ted
