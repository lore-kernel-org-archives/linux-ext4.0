Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3171C282C3
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 21:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99949218D2
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 21:22:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="wkOLQJcf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfAXVWq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 16:22:46 -0500
Received: from mail-eopbgr690095.outbound.protection.outlook.com ([40.107.69.95]:7680
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfAXVWp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 16:22:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRceVrDakBE3maDCXS/mmQRgMyYNd7TZm++yflOJGiQ=;
 b=wkOLQJcfEjTZTU4axLms1/5zSJRY9aelKJm8mH/zeK7Hz2eMXt4dBBfiTv5ph8lbUg28hNHKN5RU84Iucg5xjZn+nbphTE48jGIxmkUqDfGmMiWTLayfdyXTmp6Zf5R9r8xS22KZYogVBuJMoW77S73rd5bKEkLPQWFU+b7PVCk=
Received: from DM5PR0101CA0033.prod.exchangelabs.com (2603:10b6:4:28::46) by
 SN6PR01MB4943.prod.exchangelabs.com (2603:10b6:805:b9::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.28; Thu, 24 Jan 2019 21:22:40 +0000
Received: from CO1NAM03FT005.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::202) by DM5PR0101CA0033.outlook.office365.com
 (2603:10b6:4:28::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.16 via Frontend
 Transport; Thu, 24 Jan 2019 21:22:39 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT005.mail.protection.outlook.com (10.152.80.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.11 via Frontend Transport; Thu, 24 Jan 2019 21:22:39 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x0OLMaHN027933
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jan 2019 16:22:37 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6DA637A4C59; Thu, 24 Jan 2019 16:22:36 -0500 (EST)
Date:   Thu, 24 Jan 2019 16:22:36 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Guenter Roeck <linux@roeck-us.net>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [f2fs-dev] [PATCH] fscrypt: remove filesystem specific build
 config option
Message-ID: <20190124212236.GF8785@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <20190110233230.GA23953@roeck-us.net>
 <20190111010116.GG149637@gmail.com>
 <20190124050337.GD8785@mit.edu>
 <20190124182949.GB10448@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190124182949.GB10448@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(39860400002)(376002)(2980300002)(199004)(189003)(126002)(229853002)(4326008)(11346002)(446003)(2616005)(8936002)(476003)(14444005)(33656002)(6916009)(103686004)(106466001)(486006)(58126008)(786003)(88552002)(106002)(93886005)(16586007)(42186006)(316002)(54906003)(75432002)(2906002)(36906005)(50466002)(46406003)(26005)(186003)(90966002)(6266002)(6246003)(47776003)(76176011)(336012)(52956003)(97756001)(36756003)(305945005)(26826003)(478600001)(1076003)(8676002)(356004)(246002)(86362001)(23726003)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB4943;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT005;1:EXkrtdc9DNNS4nYn50cd0glCEtp2B02rBE8cnYkd2i++z0MgOOxXVyxAHsOq/xcR1naE9lh84MfIqdGO/iP5A2/aqqYlvGCvXW+1j41oPUgjwgEe0rIxn9jpVIUd2F+nAKHH7cBddy4Ze6SA7v2tjod7HaEPnaNlT+wH5oC15CU=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cc1d5ab-257c-42f9-a3c6-08d6824211ac
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:SN6PR01MB4943;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4943;3:816ULEmKIn+/7HxF9R09F6BZ5C1PWTvDkCGrjaRPkII0s2Hj+iAad75yrJqYmEVcT1ZplA95pyLnHSsOJ6AD/u/K1DVjr2ah0QxeVVRm8IwiwOft3V1vil/uDvPm+WxMypd8YKParsGsOeIvfxwBIdyu5UzXP+DeGgYV06pMS73ETS2lGwDhubl2IfTW1UNqN16WqlZ959O47PJX2VC1ocG+IfAbUpqHGgT3BoO9hRmai3kyyXjoThdSjru91sQwjCGQRu2v6KNprvDDKt2TQnx1WFO1k3DxmrpYdjApkFGpnEotsaXnWF7c14QrK/RxSAaVLbOBlb+ZRnYdTOnmWUs9+ChcFzNd2vC0fuVCwOi9UBvuH74N2oelzFmJeyUR;25:DMaDtywz3po6Lgucdy+dzITr+NiavZ2mznYPqZ1qF9mNgifpz0bojU3Dd0YN5GTCBqymsIQW/mkf60c7gFO/b479uZQ0AZ52ZCPbk40WSnzGIMpq7KIlE4SHJwFqOWR+QPMKgt9vt575ik96vwxO5MbSNfIM/bS1B2s3VVYEOy6Nf7X8Flz9MwEAf06mcx7cw/7MteVwne0kfdqGWWPqepOzOkjmZL/ttrMFAnVXCZoOc/sL4WzH2YA8vsX8DVxYCgXXgbYvrmZScNnJBoBO7jEfAuMdl6U55zUEMeEa0sRBVlD/hk7HqRNV5zoL1cNRnihkRyswV2209/A2wdcYOQ==
X-MS-TrafficTypeDiagnostic: SN6PR01MB4943:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4943;31:cl8cN9FolBTWGhPlYnNeQe0+ViBgZM3SLUgEQV3h9b7dDL1LvhZivPl5kR7xyw655y9z4kgnFL18PzKxqNAZRq5WvgyKubORy5keAsHMM1+NoiGR4cvaRXz5uGgPuDpyaqnuOIf7xb/lv7q8Iu7RUTJIzVsBi/lHZZqyl/y2K5Du/4+hAOOfCuHo40lxXiBfRnpWQEJ67XfQy0ElAOp5KoLYRQizkWmXE0UvprePho4=;20:NLeAkHndjAjgDwKt9SganEiJWly3cqIWOX/iZ/mq5TyJr6BHkURPM6Wo2J8UaPKAaxdIm7Kad9yIS74NINF0iVLWsvwfJy6JzA+6Qr5TeuvYggFuBCNef/6ar+oPdk6jcvfu8Ci8TRZI8QdFN8sqmqz/YJ1idFk864KMw0JGnNLst8lypUjZAAtDQyA1otho5n5aDyv9fIa+ED8KLhG/y2lz5rxmDQW/S/FD9TZMJM9AaBNcuILAIcmuAwo2V5KW+WgEHnX/Y5vMFSFu+SHSonOUl7I6aINGATXx1rSoc+ksC82k4hY5jLvdQH5kybvrdvhU3Pw8GfLgS/ySdb1NLGrYeQgc3XuFqrQOdXGUx8A1/G0PN+LacPu/bvKkTO44fikVQBAoXIxzq/zdXVLN4OJXjU3EtjoHkKw7Ywym3Y9qkLlCRznpsGa8f0qIDvqswyi2AkD0XS3/tS31vITkobWCEI07SCZmmh6OC4l3kgLpWBb2/VVAmDOhh332aJDvGM3hinoASAzEmBY7o++B0W/GtFVeI6rPpoXNnNzAZwLyKxD+qPtPmm5G/giMJyFXKcB4cjDPDFTUSCu38s/euOMoIyJwE2czJ1wNXIuvAmE=
X-Microsoft-Antispam-PRVS: <SN6PR01MB49438BDDCAFA77B15E3F308DB59A0@SN6PR01MB4943.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4943;4:wbQ9+mZTBQ726ZuigNi/6znTiJfIx6IHnGgH1PHgJRBkp4JFDM6zcKuxCeb5m+Bujs5IBdPF80FByrQu6W5+s/eyIC7z6i88DBuCeorSnmwQlG+wnVcrCFxX6ru6q/ENCwPE5QJOl9annuM2pDaPQBTpNrG/L59HdhZ875OPw9lU8/Ux8rKvldwiqEVqWK3bF5368PZBXDA8pQmPqgMztUHlUHa/qXn+8Gu7k1jtv79JOtoOQiFyNvx1Nz8E4HzjiAySe4bFp07YRXbV+Hskd/2w0Fwt3Pcp2n5fWkXjmgoneQ4LJpE4OqOtZiNE/R8l
X-Forefront-PRVS: 0927AA37C7
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB4943;23:RYveJsOVpACAuOmLrDz079BnMk+6dSgCZ0KnjONRl?=
 =?us-ascii?Q?M1du6DMn3L5Y6LfsvXfkm2FVR4q7yiAGvKkcD9zqg78LDcHJ1gbGb3K30qek?=
 =?us-ascii?Q?vUu6TZvrx42sosltLlz5XMao3HwAaHgHy3KZxoQmoK0J17CmpQbeyBYDw9CR?=
 =?us-ascii?Q?zc2SGB6Te/bRUQhtjHkvOJCPVDSKu3CM854WmP/yljN4/xClryuGJrIP2Mky?=
 =?us-ascii?Q?RS+zEuMg7tp6hNs+JOPCEBm82WXDJoEjTHUc5DRdRwdoJjpVn1LDRs++olC5?=
 =?us-ascii?Q?jbSkg4we22dMKPApXymD90eAGDzOC8Nv00zumNExaaUcunpl2q56TZi7EduG?=
 =?us-ascii?Q?tvATR9tHuiotGxARjOPpiGrtLgs2gk3SZSlWyjvCBaVGxlS/cxJ2Yaq1RHUN?=
 =?us-ascii?Q?Ko3DcgNzSXpRk0i/FZ0nZX2/i1Slr14M5121S9HUepPbUt/0z3Jx7q/4sCBu?=
 =?us-ascii?Q?YbQMO7BHQhLKc/MwkKbCx5eA1nIxqjIuQY/VPBBQeXLrjc7XUc4SHOr0ruTl?=
 =?us-ascii?Q?JmLwNRfPrFAaWMVsO/cWRtWjZy4SqiYZ/pov8z5MGfMnRjhDQiSDqT4W0Gx6?=
 =?us-ascii?Q?0UmMGLexM3ZhC9WduAnF9Ab6OT26bWWJ80E6/bTam0Mv3ULoA5XYE2S4EByc?=
 =?us-ascii?Q?T5jISP//bQGa6O+w/WChYvdG/cjIwXFqFUnL64XmKIruAHq7TNf5rV+dxFnG?=
 =?us-ascii?Q?AswKly2s55nA3V/waFpGZWorq/uW46Ik6D3s5heP61An2CsT2kXPGk7vFioV?=
 =?us-ascii?Q?a0opOWKCGxzAXQeF4gZqui9xOENFNAmuawYGnrz6sWQlbbv+D5esqW8QY3bu?=
 =?us-ascii?Q?1mgQKCt6rF8+xqlNiN7n9UIK5Zdwli1MxPxq4JKvM7Cf1nX+QdC4w+tsYJvy?=
 =?us-ascii?Q?bRqEbyGZ8aS5PrCCMl9j4uQwg8UfDZeRJgRtllrqQpMh6pgsx3lXk4nP4y/P?=
 =?us-ascii?Q?P+LkkKqOPlFaxBp8/1DW9GiI5hJpzi7Ak62e5o4aEF+jTVDOmcewPsMZXnE2?=
 =?us-ascii?Q?6VThBeVEJvT+1kCe1bWkINQfv2gMf7Af2q3BPYYBnLqy8abgd8yl39HkCaiU?=
 =?us-ascii?Q?QjwKCxo8Gbyj0iY/HwIpJTqBrvmWltyWEScbk7j7k5k3tbS7kZdwCnJvhR9u?=
 =?us-ascii?Q?SLgZPrKWY7LXiatuLy9EDZPJ2XaS7PxPKSFwtABXBus1aGECUoX34NsjsmmX?=
 =?us-ascii?Q?wseLMhTU2k8JyMLoULxE7H/lofVTN6ODt7y24wR9AwnWJMSbULR7D+0fEfvf?=
 =?us-ascii?Q?HLhp62MJzAA7Sd0WjA=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: S2vg+Q1k2ABAS3VPLbKYJsezGqO3Q2MgJVsl6aHqvkSGgx+RLl07WrCe0GlifW9gcyMcZg/iiRAGHHJeb+1pNAKjPeajMwu27PjXcRKP6MJKjixEhjMVvuXghkvCcK9mPISHlkiHnfSC7+7xC0r205EH2QbVWInwDojkk0PWgBMK+nIfb8ZPhuIfPM2R9+WGOKuPY1rru2Pleu16v4cF8mUTv2wLjkByEVTpX2G1bsJ/hklolzE6wpz7REysN+ederP85UMP4Hkw9m8JyvqJENuVFOjNeHQq5WJSQUazkd5KndM8pt7Lk5OyZ1GMk5VWpIm5fQVN9ANdbFe3QbxkCw7kiZolLUu6lYKRjV4UTVZkvuMpC/7igH3KDHMI+B0SQyjuI9edK47LthC3PY66FPqZ76ZPAC05RQSc098hbqY=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4943;6:13HOrloeSbg7ULIDje+eKsoyTdnnHkM0mcdu+hcnCjUoku/CARHkVxO2D0G3PK/tt8dDN9Qy7/vXez0ex4N7yJtTOsB6FG0k1hN7h6N7dL6HFTseQ8d0YVIsM0WKnR3prLGsr7euMJLN84cJcCM7iUN/3Vc0mqX1HEQdN+meroO6ujrSKljLHW+fTmLd6lGj9eTaJVCPRpLIaA1HKCnj6LAy4yMYjH0Gib2lef/6Rw+SVtmIKWhLJOfUL+Fh4QH6VHgLQf1cEjtDzVetnrdCsnJMja1Q/Jxrk4LS5ND7STGBPCTQRtsAB0eJNlVPTrt9dKKQI65YfkiQjT6wNZ4K5CypuWTfji8A/Qee0Yt8hAhTJr+VWagYYislju7O5UsibJBtoKWXyTSYwHpEG8KA5AI3JPJ/KzOIO6evw3wK7jdMSPXLZhXvt5ZB2R93Zqg8RsuVgv5j85GwUUVxRyJ+sQ==;5:8ukhL0SY8FrKiHoXRPlLQa19DmANmVa2YYyO5oW1ODQ7tqW/3b5Uyo+t9U2fuUh4Ium7J1yJHFOa1lyAGs0uu1Glt8kuxmSlBlz8+1glo5dhKfEGzR03Akdma/fK2SHB0By2It/RK9lijivZPCTcW3bJ+qjNAuWlq4q4ebMuGkZgLk1BVIWuKhc5lzyXyH2EO6F+PokFS5j74PvfvUjHXQ==;7:pdcmNBtOmbRvoMnXxFHb8vfkC6z/4Mzn9cW1wraj82Jmd7d8a18Bj6FzEd4AdE3ptN0aqDg1qcfQ/oQWCHP//TY8j1US0l4aqRe+ReFby8IhA/q9CGa6+15FQHchKsQzyxgSZMRMG6vjL/IA6rHZLA==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2019 21:22:39.0014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc1d5ab-257c-42f9-a3c6-08d6824211ac
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4943
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 24, 2019 at 10:29:50AM -0800, Eric Biggers wrote:
> 
> Hi Ted, that sounds good to me.  I assume you know how to get that set up?
> Also, should I go ahead and send a patch that adds myself to the MAINTAINERS
> file?

I have the request to the git.kernel.org folks and the edits to the
MAINTAINERS file already done, so I'll send them out shortly.  :-)

	    	 	       	       - Ted
