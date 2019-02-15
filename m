Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F50C10F04
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 02:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C09DB222A1
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 02:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="GG8WeOqo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbfBOCKu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:10:50 -0500
Received: from mail-eopbgr710103.outbound.protection.outlook.com ([40.107.71.103]:49232
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390489AbfBOCKt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Feb 2019 21:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKAgxopEaT4TxPq5/DC8pZ4iFEYiMMMXBeaKnruFJZk=;
 b=GG8WeOqofpzIOSG7e55DsaiI5JUZh0jz4InSSBcans4ZlRhc2sFATi/MXQiAkcXstYOI+osPze1Ixba0nQm0p6rL+3/EqHllzBvoMTigKwpjdIhC7r0nbM6ZIxNejpoBtNOx3JrwFVvSGdzk4+pF9Wm1blVj+69P2XkNkwzIP08=
Received: from BYAPR01CA0049.prod.exchangelabs.com (2603:10b6:a03:94::26) by
 BN7PR01MB3988.prod.exchangelabs.com (2603:10b6:406:92::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.16; Fri, 15 Feb 2019 02:10:33 +0000
Received: from CO1NAM03FT010.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::201) by BYAPR01CA0049.outlook.office365.com
 (2603:10b6:a03:94::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1622.16 via Frontend
 Transport; Fri, 15 Feb 2019 02:10:33 +0000
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT010.mail.protection.outlook.com (10.152.80.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Fri, 15 Feb 2019 02:10:32 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1F2AUQH001809
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Feb 2019 21:10:31 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C5DB47A5756; Thu, 14 Feb 2019 21:10:29 -0500 (EST)
Date:   Thu, 14 Feb 2019 21:10:29 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
CC:     Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: don't update s_rev_level if not required
Message-ID: <20190215021029.GF7387@mit.edu>
References: <CAMuHMdULrGHfgF+RRGf5gXAc=V3KaB4549NezxEc3CvfsKWOyA@mail.gmail.com>
 <1547339800-50257-1-git-send-email-adilger@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1547339800-50257-1-git-send-email-adilger@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(346002)(396003)(2980300002)(189003)(199004)(75432002)(336012)(229853002)(50466002)(76176011)(6346003)(54906003)(97756001)(88552002)(476003)(186003)(15650500001)(2616005)(103686004)(305945005)(486006)(4326008)(106002)(26005)(33656002)(6266002)(246002)(356004)(126002)(786003)(8676002)(1076003)(316002)(6246003)(36906005)(8936002)(36756003)(26826003)(4744005)(446003)(2906002)(23726003)(11346002)(42186006)(52956003)(47776003)(86362001)(46406003)(106466001)(6916009)(478600001)(58126008)(14444005)(16586007)(90966002)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN7PR01MB3988;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT010;1:xXQrtYB+lLIYfZHX/GlwcGvDtNzmK4NeEjWu/0NlMlrPnj4mfo3pd6ggZzEBKGhBiOdPjmyOsgWl3A1CZRCpQecAsNjU9/3TYp+6CUrTadPI6kuTdKpof2BtKE83WBZS3O79+g8LjmuMEN+ikTXZ5kUYStW7iLcz6eGdXFOiq7Q=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a8d81a5-927f-4bb9-b06f-08d692eac449
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:BN7PR01MB3988;
X-MS-TrafficTypeDiagnostic: BN7PR01MB3988:
X-Microsoft-Exchange-Diagnostics: 1;BN7PR01MB3988;20:P+dWayic0Y6ioOOEMxuGQEQOAi3dcSMklqYuvnfn6FPtWVe7SIfVc4nBicU3gr6sKMjnG10W06tWIdNyuAhmZ8i7a5ns1NZdeBt3IGlNKRtp/U3S48+9cGCC8fV8c/31ynFtSHPjleTdYUzl70mSo2uzYvv+VPQDRiwz021dIXBQZfok8OdabAKHlWeZKgZaz7RLUZZF1z257RizXLm7kAvkjV9ZczZA13XQOEdA7Fq86knWnfunBPV2hdGfFCjg/PjgrJc2su8H70rzvNQiQgAYci0yTbLFcJTsZsT4s2MsDy1Xkh3jfeP1RF/gYCaKSFHhbK29lCgEAFF3lZbHwCW6nNF29m6TDGT+kYs9p3F0oc/DhCiSt0P4dzK6c4nfmj0/2QvbZtGCs3igXT2x00SlT/a9rszyLL5hKUizBubfKowwJvGGhysZet/eP5eE15bcorTd0E5jaKtVbdsGFeF/6qaQ7IeyXDl/LX3lGYdFYATctGLmu0yNYWWnmlomrlmy6oUmllLxkT/7pV1SJnWfpbh2A5HWF4u/fRGNEVQF7CDUJcAZti7/PlNLzRNXdRj6juOuAjIGHFUM71Mw3s+fj9eyIR6/Kfd6IUy9vPQ=
X-Microsoft-Antispam-PRVS: <BN7PR01MB3988DBD5838AA41F1CE578D0B5600@BN7PR01MB3988.prod.exchangelabs.com>
X-Forefront-PRVS: 09497C15EB
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN7PR01MB3988;23:B8XMM+Z9nwgOOxCTyuFq41DVBIbWTVnXd5Y02Y3eD?=
 =?us-ascii?Q?oso16nRg2nTduPvwoBZqhYUSEyuLFMcuTTNQkiBkz755biO1B1YyrpI8EiWf?=
 =?us-ascii?Q?F9dnYX2ebCrj0dPDqXVRQ7mfUiK3W/xUqyeeVoATuj3U/gHqRXbj/wfb7i+K?=
 =?us-ascii?Q?OCtpgVGGSRaMvCefjK8CHrJEwUCu3XeyKqL2aCcXMTioz/AKaSa8sr0lN0yx?=
 =?us-ascii?Q?vyJIZjcSCVNkHnOH0URaIg+36FT00wR4MByU5Mr00524Uaejz/UCdhtuxhVJ?=
 =?us-ascii?Q?VVZFokfAXzFyLWfVcRP9l0DAiLhYAAIla9WQXwoFCm9HoxhBVgzREikcnP+l?=
 =?us-ascii?Q?tm+Qh8/rbOU1pvKQ647HcdaNNmcHLWY1hTxsK6afJHZffnEm2K4NpTgJC99t?=
 =?us-ascii?Q?XcILJr1jZiksLpb0y4Fp78uyk9g+bAZrQ7EJ+KqRTKv/Xlbsvfx/J84Zbp+9?=
 =?us-ascii?Q?mLHAs3jTHxByz7yXNbnajYTarz2VfoEtluNODKbGZsAZMCdN246b2QwAgN3c?=
 =?us-ascii?Q?AMf5C6DDCU71UaVf7+8vOm5r2eE/xmeez3Hns5PquAJfHiQAtygTs1EPZw3D?=
 =?us-ascii?Q?G2CI353ETX+FkEAtdkIDaQ+j6vvq7edHPpyGXlmI13OlU22P1XVi6IDL703j?=
 =?us-ascii?Q?Bu9YEgdOvpt/cMjU5KUS1zvoMhkNVQGlEJSndvueP3PFVKQraLRIHxUcz5XX?=
 =?us-ascii?Q?RiMVjM31PAoCc7O/SHd7C0zt4xBMXv6Rb0UPutHfCWaOmIQ53Ni/9rBp/s47?=
 =?us-ascii?Q?yXk9kpykVTggvY5YvLTTa0IsUGEm62gNWFSNtBOFtdTjWNQDlK9GTRIbSMAn?=
 =?us-ascii?Q?sQhujwOJKKoWXm5ZL+TuBQY1evkHS3iw6/ub6FCf1Lxr7dcNxeVVxPGbyKQ+?=
 =?us-ascii?Q?W5i/R8iKIQZabz5+Jp4ltNua/P/gt9ycIMFl6yxeXjUpdIKYoKJ0Jph8BxUM?=
 =?us-ascii?Q?a0gjH9jtEnYVPYxS7sPTfA2n5/aDcXd9pN+K9HS+GjyefH2TFzG1SmiJfo82?=
 =?us-ascii?Q?CJLPf8dSGaAzfg4cZGNj7nrx372gmFOU3KHP9BJ31i+0P/3rPTR4dLZZTa/8?=
 =?us-ascii?Q?Ur3SZaEDuzT88CQFkayr2U251+LyV80U4+LXCHpj9esWQbWwxwxJU3BizVo3?=
 =?us-ascii?Q?w6nFUcPpiUjIqtZc5WS6VxtQR6obtsHu2zaewkw7Z+oWAkT7ZuyVKmCgD5Nz?=
 =?us-ascii?Q?f6cQrkfoLdb9f49SVNYGXVg3doAf7JVGOFSJE5dxCTJUtCC0YeVTsF/s4onY?=
 =?us-ascii?Q?a6UyZsMns68dAh4egidj1LmGHJbOP00YvziKqHIL/koII/2Y1fAyyNhSLlXM?=
 =?us-ascii?B?dz09?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: zPFizetYPBn0YuwoWw4k5N7m4YidzwAUePrbPqJZlVV2d5osnhBxdLiFJVbcKW7gpyHsU3LJfcKmiJT2tMOYFAdqfFnloozl3gps6IoG4l8XBrmX6aOizQFDsNGHo6JBte/WEGMALUwWJ+6am2oyrPdQbb0MeSXLz7SP0ZKDtaUVHoqgrBL6BKXAR6lSgZWFrx1HLOnVVvzeRlQO+SZJ8Wipy00nxniOZHPseBCutQAs9gOhZYK5LXuMTWJomsG7er0l5Vrx30k4chWGxMY2JSnWpKfKdE4keG6pLrmqxa0oEEerqqCRJMdAG7HwIwAok0H4e6hjaQJx/DwaKWkAlxz2PNt7jopfB6D0A0d36Ox/q2rV+51EqQev5X8Hr0U+Dy86gkMUfZ/ulV+RlzF13c2Y3JdZDZi2S5MHQ3Q5vhk=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2019 02:10:32.7576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8d81a5-927f-4bb9-b06f-08d692eac449
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR01MB3988
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Jan 12, 2019 at 05:36:40PM -0700, Andreas Dilger wrote:
> Don't update the superblock s_rev_level during mount if it isn't
> actually necessary, only if superblock features are being set by
> the kernel.  This was originally added for ext3 since it always
> set the INCOMPAT_RECOVER and HAS_JOURNAL features during mount,
> but this is not needed since no journal mode was added to ext4.
> 
> That will allow Geert to mount his 20-year-old ext2 rev 0.0 m68k
> filesystem, as a testament of the backward compatibility of ext4.
> 
> Fixes: 0390131ba84f ("ext4: Allow ext4 to run without a journal")
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.  I had to move the declaration of
ext4_update_dynamic_rev() earlier as Geert suggested.

						- Ted
