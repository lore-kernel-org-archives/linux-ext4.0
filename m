Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CBDC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69D3D2083B
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="q5FdnGcs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfBUQiX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:38:23 -0500
Received: from mail-eopbgr770101.outbound.protection.outlook.com ([40.107.77.101]:62982
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbfBUQiW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 11:38:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQHleSiFHldOsDcmvcK3/Wz7eoPlUBBoXPa0tkHfzhs=;
 b=q5FdnGcs++dPVyYMdHTa+TRfH+ex6JW1KKDMNS6hqvSP05rZpkD5llH9sLQRBpu6ZCWT4AOeWgEZefKZ29Gm3E/AkimnQHEHWSFhHB9zcZ9xYMTwaN8KX951/AsQ9TUCJN4MZbCv7V5xGlP6iETBiiFZ73QqAwVMcgKA1gTA/Uw=
Received: from DM5PR0101CA0023.prod.exchangelabs.com (2603:10b6:4:28::36) by
 SN2PR01MB2095.prod.exchangelabs.com (2603:10b6:804:a::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.16; Thu, 21 Feb 2019 16:38:19 +0000
Received: from DM3NAM03FT061.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::201) by DM5PR0101CA0023.outlook.office365.com
 (2603:10b6:4:28::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1643.14 via Frontend
 Transport; Thu, 21 Feb 2019 16:38:19 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT061.mail.protection.outlook.com (10.152.83.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Thu, 21 Feb 2019 16:38:18 +0000
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1LGcGTu001800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Feb 2019 11:38:17 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CEDE47A3F7D; Thu, 21 Feb 2019 11:38:15 -0500 (EST)
Date:   Thu, 21 Feb 2019 11:38:15 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Change debugging support help prefix from EXT4 to
 Ext4
Message-ID: <20190221163815.GD10245@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190114110045.10013-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190114110045.10013-1-geert+renesas@glider.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(136003)(376002)(2980300002)(189003)(199004)(4326008)(103686004)(97756001)(229853002)(6246003)(4744005)(106466001)(90966002)(6266002)(36756003)(76176011)(46406003)(33656002)(2906002)(8936002)(1076003)(26826003)(246002)(478600001)(8676002)(50466002)(305945005)(75432002)(476003)(126002)(486006)(2616005)(336012)(106002)(356004)(446003)(11346002)(47776003)(23726003)(186003)(86362001)(5660300002)(88552002)(36906005)(58126008)(16586007)(54906003)(786003)(316002)(42186006)(52956003)(26005)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN2PR01MB2095;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12508fbc-26a4-4ccb-6fd1-08d6981afc8b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4608103)(4709054)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:SN2PR01MB2095;
X-MS-TrafficTypeDiagnostic: SN2PR01MB2095:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN2PR01MB2095;20:mO+/rd0MV4mC4F1GF+WB4ORkCt3mH95dRxg2A00h8lVwVFJ0RpMgbyqEjFWGQ4XQCRHeSETXo6fYesLtaoxT3Vppqkm2JiGMUSz8tx5XV+/pjwJhK8QcN3hWuoRXjNZg+LxKcLc1rrlB7La7VGgczxHoXwLFqyUE592Ve1EwP2LSS37E55smSEJNRt8AJoxoPQkcD03FYuaUGxs75wMHQtBNt6hcWHEB8pA0DL5q3pNJKhCkBFosc8JqOClp58uq7vKObQD2Ce9n5NBcDKJRGo7WLRPXFZU2MR7HVMWDc2MoG1srmM5clFDuL36RJLGHG1hyfF/uW2+aySJBVsce4nTc4QXkd2wn2iBg3JAY/vQsw/Na9KNmvu+Cm4+kaG0ZwBIi6eJ9iFbIjvgnmRdx863wn/Pi1dWsI1Ogx6ORGPrgLppx8naGc6yYIlClaEjnpsUC3/BugLoc9gUr09LhuE+/68prCts9m9g4UgcrmQB3fOFkrKmPoFe3dCemrzxch11Pp1fTLIO7pTQJ5SWE53P/avhgYw+THeVsPIaogLGE/IK0zOUEBQmqkIXfNqMZMIPdCJd49+Uc+INOE7bgdt7eYK0SWqdm4ZixoRx0oCU=
X-Microsoft-Antispam-PRVS: <SN2PR01MB209546D609755D311E1439A4B57E0@SN2PR01MB2095.prod.exchangelabs.com>
X-Forefront-PRVS: 09555FB1AD
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN2PR01MB2095;23:5h+Z4dmFjt9u3EZbGWQo2nzesnyPM5jhLP7Vdbhty?=
 =?us-ascii?Q?rObRd4hUEn9bASHdZUNZvIqCPUMZYCHuS6YfMOaRHdSnGHRv/he3S3O2+KwO?=
 =?us-ascii?Q?jqH4S8or5giS5Uu3NiIPh86WDa9r36xban8GshJDByej0QPPUM/Kut+ts7pZ?=
 =?us-ascii?Q?4T3+b4jyrHrq1A33vsTSG/HBjkgZYmpEJPjaoKEAGdh7AWSp+vHudzEhOt2y?=
 =?us-ascii?Q?vGRzszuB2GB/7LjSvlT/DjMjYUQ5YSurC7F0rfzZ3+t46oj1qYh6oi5doIem?=
 =?us-ascii?Q?80Vp44fVVaWk3ycPAq9x9uSi+qy8V/WJQs3JrsGkD7o0bx9LgO99NCKDRvGh?=
 =?us-ascii?Q?sA0gHwbfRd5W+pN9Ihdfre22MKz2h+7T1duAuFVIU4yXgs5EJCZEiZj7cpdV?=
 =?us-ascii?Q?RfnfXsIW5BZ4UEOZgZZgNyOh+CiN5L9aArA3dunhk58QQqnrdv264D/UqIq6?=
 =?us-ascii?Q?UAG0slheTtitkA7DpY8NSaq3buMiTLySxRrCuL2k9OdDAfYFT1faxOwS9RrP?=
 =?us-ascii?Q?JYjz3rmtSE6Aoq5x0rQ8hzX2MFmfNaRPfjMPJSXzmBxKfEP046AIi6u0F5pH?=
 =?us-ascii?Q?PHM9qRB77c66MpYFcPKocpxuREk6SOn4eOpMNiXbW5yB5Qqxm4Vre5oqXMG1?=
 =?us-ascii?Q?YgLfKnUA3WQnZgBDFp4IkKdrO9uvNlbxsmm2MHa8EYyrQOW7oYIBbtQGx9e0?=
 =?us-ascii?Q?PWZUbuezKTsGbpK9T98jqsJpUQKHNZeIU6B4ACWoahGcPAPwblpZ4G0KSqWo?=
 =?us-ascii?Q?q3UvwejLNyZGD9S6gleKLGTrZqFpNsm8VJ1cfg2SvPwYdGNJDW9s32PGoPwE?=
 =?us-ascii?Q?DrQ3lxEdbMbXzxvv2kXv9CWOnzXbzH9F1KIcNsRaVGXRz5Pj1YcBaZ7ykDST?=
 =?us-ascii?Q?2s1j5NycOqfyufTHlh9pr4lsGQmH1jT2/CHFZf5ZiorRjWHTVvOnFUJ3nAA1?=
 =?us-ascii?Q?1OPx7KjslRFfGvfFm+dNioWRfTCoHLLPN/X0fR1uc5uNAkLWhVFPF1hD1y6x?=
 =?us-ascii?Q?Xb6KFZQRNeZaykE7/vDeRQYfbRXRbktpT9apH/JNmnBlQvz0KcT2WPvO6i5i?=
 =?us-ascii?Q?cU/igNUS2TmT1+2fvGfiOHJgemSVhXdON3aNhvRzQa8B1xFW6w7OnT7CA2dJ?=
 =?us-ascii?Q?wu7TvOxM1xkFH47sLZvpVwlAN9vxnI8vPBtkn22Z4D1ZVoqLemIrHDyB7Qea?=
 =?us-ascii?Q?cPi22KIVm4RWJHpSsP0swnrWtWN2G1JUOiJoeSsIsnStEKGu5Ea/4DX9Qx1f?=
 =?us-ascii?Q?8i19iu0KqF13Wbt9BDa0GB0YY0sokDFM1jsjyLr?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: PvbKLGneMgHuR398HkcEtEoxjjIZCygKT1Gv3lG0ta5D7woYZ7ulnitw2QsMsX6MWwOtvIYS5idJAuEoQL3gF2s3xIMJLXDiUBWwegfrIXxDoz4Qg8oWHxl/PFPLXF6EHVmiQkuhQ+RwHaMx12RkWAh1jKmMb4zItx+63l776HwO/2EweoNAkoHCcm+ANp6AivgQ86igHZHplxxLwIMMCUdMiH27Foxz6WiI4Gg7f6AD/T39R5WdnT1byEa8AwFcSA7mnWK/xuYc3LpEMi3jHqROKf0TIfpd1ZPdkOpN5ZPeaRFLVlhFYVQRG0XrIEzGWRmPsK4nZM4PoYFTDd9mzxdtvmPNOeB36dII504+XJKOykhn3ssIlZ8H00fLqggdESetqFYvYTYYfJIaYnzVRPGB98f/UClla3jHMhdZai8=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2019 16:38:18.8408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12508fbc-26a4-4ccb-6fd1-08d6981afc8b
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR01MB2095
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 14, 2019 at 12:00:45PM +0100, Geert Uytterhoeven wrote:
> All other configuration options for the ext* family of file systems use
> "Ext%u" instead of "EXT%u".
> 
> Fixes: 6ba495e9259cd9a0 ("ext4: Add configurable run-time mballoc debugging")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied, thanks.

					- Ted
