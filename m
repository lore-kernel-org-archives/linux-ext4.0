Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22385C43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 05:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A917E20842
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 05:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="KAUudKFH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfCAFAR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 00:00:17 -0500
Received: from mail-eopbgr810094.outbound.protection.outlook.com ([40.107.81.94]:28913
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725287AbfCAFAQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 1 Mar 2019 00:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9mu8QYEfBqZhP5nlMriuQA55cC8+XqkKxNMIQ/5DWI=;
 b=KAUudKFHTuX3GQuMH/duzu+SXCA3tRneVj8ALbw9DCII90ADU02Zz6lx83P4oG9LUgAKLPbHyOWYfnuI62lxJ8uewNEthw9QFMe9EnwT+zFUS7d3NHId/B4JoaAKs8eaNASKuf/kFiA7wOYccIo0w45kcV4701kruUXwLTvdP7c=
Received: from CY4PR0101CA0009.prod.exchangelabs.com (2603:10b6:910:3c::22) by
 BYAPR01MB4854.prod.exchangelabs.com (2603:10b6:a03:91::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.21; Fri, 1 Mar 2019 05:00:12 +0000
Received: from CO1NAM03FT045.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::202) by CY4PR0101CA0009.outlook.office365.com
 (2603:10b6:910:3c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1665.16 via Frontend
 Transport; Fri, 1 Mar 2019 05:00:12 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT045.mail.protection.outlook.com (10.152.81.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.13 via Frontend Transport; Fri, 1 Mar 2019 05:00:11 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2150ABe020397
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 1 Mar 2019 00:00:10 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id BD6CF7A36C8; Fri,  1 Mar 2019 00:00:09 -0500 (EST)
Date:   Fri, 1 Mar 2019 00:00:09 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Whitney <enwlinux@gmail.com>
CC:     <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: fix bigalloc cluster freeing when hole punching
 under load
Message-ID: <20190301050009.GA8234@mit.edu>
References: <20190227220204.31804-1-enwlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190227220204.31804-1-enwlinux@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(346002)(396003)(136003)(376002)(2980300002)(189003)(199004)(14444005)(88552002)(2616005)(2906002)(26005)(356004)(305945005)(4326008)(8936002)(50466002)(6916009)(486006)(5660300002)(58126008)(103686004)(42186006)(126002)(106002)(186003)(476003)(786003)(106466001)(33656002)(36906005)(26826003)(446003)(23726003)(316002)(478600001)(11346002)(1076003)(6246003)(336012)(6266002)(1411001)(36756003)(46406003)(90966002)(8676002)(86362001)(246002)(16586007)(52956003)(75432002)(76176011)(229853002)(47776003)(97756001)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB4854;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab576506-5bf6-4957-6485-08d69e02c91b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BYAPR01MB4854;
X-MS-TrafficTypeDiagnostic: BYAPR01MB4854:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4854;20:YOrF/jmewRTKY0IrBKPrWxlFt/aMDoDxMAuHvwzomu9pXtsWHTA1dAGteKcBJd33AP+Odik4eQ0fXiYoh5xOPAKoAYn8XXPxT8I4wOSa1ouAuNT9fSTzzypCo0yhB/1ZyvD3+7WtlOImBIaMbpD8M+RsP+H/nFoRBxH7HfUXTXYohxJ0aEAX4pYv33qacu38S9WQa8Fm/N0qETSfsMpcvBtkPz5ZNAbRjrudQAuV/wlMXbxJQCj/8S5MUWy9vcRzOFW4RJaS4iIXEv8E7o3hh4/d22GdeFDGicSEuDZLs2QW8sU28W/TFsV+9BBCptd2yKf7kDMvVuZyLgcf15pALlto54MXvbAMppQlQlIEWU0sUp/bTwkPDdmpjYMVQt3pB1s/Qmv/mVLJH9IfDX/2bbkNPMhKeeEBVWPzz/uol/5Zi8ReD4b2WiRe6CBb9Jo7l2o4/mYojRreBj4aqGGsn/NbOtoJde6SSRq2IvFkaz1D/27RgctpbjHaXnbycOR3UmXr0LYSwWkUpladb2riD8EELRplnI55uX9AzL3utsFhhDi+V0LIiYivJZPT97QQ/hvRYI8kF8Q7mLs2n2bauLWdeAOqzerSPRtFsFnC5XU=
X-Microsoft-Antispam-PRVS: <BYAPR01MB4854E5425B9EBB43F1378DE3B5760@BYAPR01MB4854.prod.exchangelabs.com>
X-Forefront-PRVS: 09634B1196
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB4854;23:birO9zow8iGaNd4DeiNbHjco/PoYcGijEEQ0PT3aS?=
 =?us-ascii?Q?SsL6PwF7DOYAeYZhfg7dNpAm/wecVX8xHvh+In32a4xjA31TLe9yY/zOCQ6B?=
 =?us-ascii?Q?iZXX5hYZnXTGZHHrndO73JNZPJm7KTGcaaKb9lL47hHwFqP/M2zeEXM2n646?=
 =?us-ascii?Q?9x5OW+k7UYvHGvhlObw4D7wRGrQMY52fvA2DbuUnnqJFCxaGs0eTQdCznAj7?=
 =?us-ascii?Q?zZAjLqc7dzD8/kqLK6FZ1IW1obHy90x7UyrbPTKiD97gG+pSVC4KI+ld6Imi?=
 =?us-ascii?Q?EzV0KDN5kdBy3SXrXjJejTFdsrQq+QQmpFv+Zm4ubjLe0qkqMy1LAD5shZ8a?=
 =?us-ascii?Q?KI62zc4aaSJo94fWfU/9EJa2HuSNKglgh+bCDE8IAPu6MpzLpAkCfdgBVeQD?=
 =?us-ascii?Q?ho8dJQ6w1c8g9bSwkzMno5DX8FyFGDELIaFevir7N85su9qKWG9mp8eci4DD?=
 =?us-ascii?Q?DDJz3h6j/HLeSM9tQ7hQqoSjtN2bxfhM+SRMNsS3oMRqP6CfQ7eay0INYf6T?=
 =?us-ascii?Q?WHhJihZgzzmzcTayWNMQo0Vo9vwBV9O7WSFMgULT8rHS1wLk13wJX2P3rg9W?=
 =?us-ascii?Q?WpuSAKCPk+j2WePiJj/TRPKN9EXOfvB6EBjSK3FU6YWM1kPNwJP++vBC902D?=
 =?us-ascii?Q?oVsI5kpof+OPLo2f+Zu3ucS6Wco6YG1we/QvwxA2SXyRZy8UNksXztb9KcPQ?=
 =?us-ascii?Q?LAiDAG9Ev6M2uFyrmY/qbcn0WR8KY639gEtYnlfs7f4Ytf0CZx90ZePQccoj?=
 =?us-ascii?Q?VCxTBAmDIkWfC/0eOqPjI1895T/XjLEVpCT0DSSSHsMAeEN5Qn6eCrIkXrFR?=
 =?us-ascii?Q?Jf0HDQJoMjL/Ulk0q94ngivLzkGZljATgHOv6q0Iw8m1IzdYOI/A8+0FD3N5?=
 =?us-ascii?Q?EceMA/6NBNMBHyMoaB8iMaO05/kdEnsYpGaRTFVjomYQX1l0kfbJvcApgipK?=
 =?us-ascii?Q?58AUPZeRsG5BM1wlc8l0fxz7j8F1u9rt4ee4YlRn3fy0oeQ0GWe0jr5Pa+wb?=
 =?us-ascii?Q?n4rM9eu3C5rdc+3TStnJirk1R3EGCXTNW5kbPPa6cmUBCMV5BmByqcusbymK?=
 =?us-ascii?Q?H/GubML9WX0VtPha6TI82pYggls8/kZCYRBF4yqdoOH0S7HGW3twyBZmQslX?=
 =?us-ascii?Q?M6hFhnCCzqrds6s3LcdRN8qcauNK5p8MzfWsBpNmDo5+evw8Dnqoq8jsHRsW?=
 =?us-ascii?Q?FAEVXllbj3KgU21TOo/WraqHCSjJskHf+QZQAU4/ex4NYm2sVdaZE5CbF4Vb?=
 =?us-ascii?Q?EyHtc1znUnzumsFVyw=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: mVuk8mZmQrv0Zp/fWHCa2dmpYtaJ3eBIZoGgVqygy6t1sUfEiXGUEbT9elObqnwRgJV8vZKWpj+qKR2xNxTj7DDpQ/iScP2TU9Ayebvwtrq9F4F4tVa0ybLxdvmWX1mjihvNM3y2rnhyfzQP6QlzlFcbdcww8PqN+oZQapJDaM1kVIrVO9Y5XYFhAdTP5rknIHmG6LRcdIyNmwIdfKc5ppVcWBt+ez+iMK5QYreIxIbta5TQJSkHAI7rHKwtX90ad8iTbsAXWuBhJt3RabWhYyM9PKYKeEvAWoSABj/748xFoQZ9DQ8LMtBiFBAO8nVYJEPyZNZHYKLAh8g3xh3NEmcnevUQTxOKtA17hy/ROJ2KlSyfwCBDo5F+wKh6//HhnopHgWtEsVZQQVThhwluDiw5+Q+qWCvpy3ei6VbXnYo=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2019 05:00:11.7400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab576506-5bf6-4957-6485-08d69e02c91b
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4854
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Feb 27, 2019 at 05:02:04PM -0500, Eric Whitney wrote:
> Ext4 may not free clusters correctly when punching holes in bigalloc
> file systems under high load conditions.  If it's not possible to
> extend and restart the journal in ext4_ext_rm_leaf() when preparing to
> remove blocks from a punched region, a retry of the entire punch
> operation is triggered in ext4_ext_remove_space().  This causes a
> partial cluster to be set to the first cluster in the extent found to
> the right of the punched region.  However, if the punch operation
> prior to the retry had made enough progress to delete one or more
> extents and a partial cluster candidate for freeing had already been
> recorded, the retry would overwrite the partial cluster.  The loss of
> this information makes it impossible to correctly free the original
> partial cluster in all cases.
> 
> This bug can cause generic/476 to fail when run as part of
> xfstests-bld's bigalloc and bigalloc_1k test cases.  The failure is
> reported when e2fsck detects bad iblocks counts greater than expected
> in units of whole clusters and also detects a number of negative block
> bitmap differences equal to the iblocks discrepancy in cluster units.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

							- Ted
