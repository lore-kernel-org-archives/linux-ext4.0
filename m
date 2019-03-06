Return-Path: <SRS0=J2/x=RJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5F0C43381
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 17:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C756420661
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 17:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="ouljEZj/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbfCFRHA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Mar 2019 12:07:00 -0500
Received: from mail-eopbgr710129.outbound.protection.outlook.com ([40.107.71.129]:3552
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727415AbfCFRHA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 Mar 2019 12:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMmmSQ0E1xuf/EWAzdMhpjd/DLXVF/1h/j/eHTL8NO0=;
 b=ouljEZj/zX7nM72TnPRLu3CtoV5TFTakX79dvFtH4XdSYxt4u/9wU+4i33wPDmARrue/N3BwzQmO+atxd3ZKcyrwT/MnMA8ZdwY+Xv4qcmSznGrF5WKCssN7jfkOkh7RhJNEiXCmC59Vye4ot0bqSRge1uDicNja37vCd0l4c7I=
Received: from BYAPR01CA0070.prod.exchangelabs.com (2603:10b6:a03:94::47) by
 BN6PR01MB3281.prod.exchangelabs.com (2603:10b6:404:d8::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.19; Wed, 6 Mar 2019 17:06:54 +0000
Received: from BY2NAM03FT010.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::200) by BYAPR01CA0070.outlook.office365.com
 (2603:10b6:a03:94::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1686.18 via Frontend
 Transport; Wed, 6 Mar 2019 17:06:54 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT010.mail.protection.outlook.com (10.152.84.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Wed, 6 Mar 2019 17:06:51 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x26H6n5F009405
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 6 Mar 2019 12:06:50 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B553A7A3F4B; Wed,  6 Mar 2019 12:06:49 -0500 (EST)
Date:   Wed, 6 Mar 2019 12:06:49 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>
CC:     <linux-ext4@vger.kernel.org>, <adilger.kernel@dilger.ca>
Subject: Re: [PATCH v7 1/4] ext2fs: opening filesystem code refactoring
Message-ID: <20190306170649.GC3485@mit.edu>
References: <20190129175134.26652-1-c17828@cray.com>
 <20190129175134.26652-2-c17828@cray.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190129175134.26652-2-c17828@cray.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(376002)(346002)(2980300002)(199004)(189003)(33656002)(47776003)(86362001)(58126008)(786003)(316002)(42186006)(16586007)(478600001)(54906003)(2906002)(336012)(75432002)(50466002)(305945005)(6916009)(186003)(76176011)(106002)(106466001)(90966002)(46406003)(52956003)(246002)(88552002)(26826003)(1076003)(4744005)(97756001)(446003)(126002)(6246003)(26005)(5660300002)(11346002)(2616005)(4326008)(8676002)(23726003)(356004)(8936002)(476003)(36756003)(6266002)(229853002)(103686004)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR01MB3281;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60144008-8f7f-4026-e6b5-08d6a25621c6
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600127)(711020)(4605104)(4608103)(4709054)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:BN6PR01MB3281;
X-MS-TrafficTypeDiagnostic: BN6PR01MB3281:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3281;20:xwrerf2OHwdggJNaAo/m0CxuamJ56G39nCh1EGEGHxTYanPxsMT0mA4+EbXIaqEaLf1Sym8qb4ZmtzdIpit+SOqhd2Quw9MDIoujiDnFPD+/G22V7LXfUXD7YJ1f8ZPwHTLUPjac344sYwy69KkEIpvf8Bo9j6cP2HDw6ohzy2mMoizoiTF85e3evKsymkku6qNg4xSYdzOQOQdkt1ZxsntwSt3D1u0bbUn4MM8c1Ptz9WHkKi0TuSeuYgFWiW6W/ZUH3xN+eVAL+jyXeMgNvM3zUxcahnC5ng1CmRo762TQk14UDHRS7RhHReYDlqRhYgAIBiXeAmnnHLeO1YfdTRYdvaBtO6A/o3P2lYiTDjAQGDTBJO7O//YX12BoXfbmuA4VSSWBvwy7F+icxSaWBnhHvaffURUh7mKQ5A2oMP465yAq10L24+hj/HRf7VzxXT4YWaQbD2zt1IhG5XNIGkMweWuZi5SWOXuyxDAHg4lKjt6w6VewnODd8k4JAQPGPr+QIDFNJpBClD1OjBBc73atK1C7UMaCyBmyscaMM3cl29tj5ts5FYYymMitS44ZxciA1oDpwFoWh18lfK4kRlkIy2ubGOH3tr01LojPtu8=
X-Microsoft-Antispam-PRVS: <BN6PR01MB32810AEF7A00F7C47BF5DD1FB5730@BN6PR01MB3281.prod.exchangelabs.com>
X-Forefront-PRVS: 0968D37274
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN6PR01MB3281;23:2l0zoCsANZyqE1e4tWnaMSYh/JTaaJpAwYd2SgC3+?=
 =?us-ascii?Q?l0Q9QglUHLxRU+51kvmyfYXXKlMr34wSwiEaBXrOhWXn5KlojUScGNhLMbRi?=
 =?us-ascii?Q?jWPccVbtIWF2RzBQWU6job7LYO7+mAGE0mcwAn+u5ob2lDPerJt2HXVwG+38?=
 =?us-ascii?Q?LyCdIWVcymr69K/ZxEylmCxJ74SKIcuky92wY3n+4mP2p5CEm8JTdlY1q5vF?=
 =?us-ascii?Q?3iYz/DBE317nWSEJswhN+8BaAptKsaN9bUZWZXiIsxprPrWTCG/xLo1cDkm6?=
 =?us-ascii?Q?YnZGozWLxa3qNhgalDWhfolZ0jTMDBqk9NBpgoVc5Su02woUcUqlx+Mp/Bh5?=
 =?us-ascii?Q?f1AX2Pr2W3f6cPsBirPBF3ImMaEHLjdGAwF1xFcwEAf/OWk8Cefwwpd9H5s5?=
 =?us-ascii?Q?cfxD8WP7qWYGKfEDeYqxeFWDShEgd/ydS06cQprR4zNCmp1f+DvewYFrOZE9?=
 =?us-ascii?Q?CPdQtb671Gdp8w4I1ZNq4yHoNVRZVOmAaCWyA63rlmaI+LvRA4fC4vH0reSe?=
 =?us-ascii?Q?6AcuROVCcneiDCJQzxxMwE4npN1nSB2qr6FHvLXlwx7FajqlhspGbYUhycE/?=
 =?us-ascii?Q?t1x3s2Of/mnFz4vihEyeGdYt1sqVhjpk2bENChhd4e5Ks9oiEFtGcFpimzEU?=
 =?us-ascii?Q?4q/797bMuRRyDKGjgruschS5rgQJSsVj+0MpoSPFybl3ngQ/a47LrhLzKiMZ?=
 =?us-ascii?Q?9Q0ihGCOc1MKMQl2ObYT9RpSnQMH9lTLNLBPgiZVyEUUCZ1IRJwq2kDqHL10?=
 =?us-ascii?Q?RiI6+OLitskB5VnfrYfoiTMsBUjzYNpL92lLaKVFsz4FlRoQRVND+GLHkBPD?=
 =?us-ascii?Q?NqZEzM2hKeiJJfC+L8nibzYq8x669lVXZFx9ZX1AUXfm2UoqwP+yW1dczlEN?=
 =?us-ascii?Q?NzXdWpZMAeaL2R8AL9O9vQNHvAOzEpwdBVUXBKG5UcjD0Ya4arfkLtIxses/?=
 =?us-ascii?Q?hmfN+gQ2/ilI0hUbJUL+XPAIMNOCXbPikt6QE23rTglafVnWJxvIrtsuWuck?=
 =?us-ascii?Q?ZkJuHteD1onRL4/l1yW9+V//fQniYn0oQ5liaKAvHsnFpEYUTyS88K4B2yWU?=
 =?us-ascii?Q?d68xJJRa12+a6kGu1vvSPz8GcHtZs4u1h+B2P07hLDbzQY+RSKmn39qvWvKJ?=
 =?us-ascii?Q?iHrj60P9enZeafCMuAV+2gpgf78As/qqdhCDdYKnHEU1P7G0TJkN22FPpxrH?=
 =?us-ascii?Q?pC49ai56zGuNiyZGtcnagzh859vo8GHgBS+?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: eDoi6AZ+LWa0UWoSbBlplEorJiyNdisUZLB3r/S58SdXxvHAXOk3Cu6fBmJY+z6EDH9fTDgpCfpKqCT9kThSqQWllsXnAKcfUuHSSCIvewnoSOlgVVYGlvQNE+HE149HVjzSVraH88RHb7ygaDeAdWiI9s4vpuIK+/6CPqYbaWvgaeJrO/GrziOR1i5FX+TFn14G0Dj9flRqKYRFsbR7dcnpIy5gKu7AdPGHb14JTAPa9hmIguqs48yudw+B2yUtcoETZiVtfz2oGAjHrv5MOxyvHoM3k1WyNfA9RQPMNUNxHG/VCUP6m8VNmMfz+gknH1vwAlJWNpXsKGjWVD1CBQCQjlr0Ih3vN08bUZdjNFBQ8Ghoe0SCGuJWDHz2aJ57x6rQSXxXDNSlOFegomorfORdmI0IfcDh6IhLBnp9/Nk=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2019 17:06:51.9780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60144008-8f7f-4026-e6b5-08d6a25621c6
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3281
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 29, 2019 at 08:51:31PM +0300, Artem Blagodarenko wrote:
> There are similar opening filesystem code in different utilities.
> 
> The patch moves improved handling from try_open_fs()
> into ext2fs_open(). This function make one of the action
> based on parameters:
> 1) open filesystem with given superblock, superblock size
> 2) open filesystem with given superblock, but try to
> find right block size
> 
> Signed-off-by: Artem Blagodarenko <c17828@cray.com>

Thanks, applied.

					- Ted
