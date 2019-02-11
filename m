Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DD5C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7679821B68
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 17:55:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="J4hJXxJG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfBKRzU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:55:20 -0500
Received: from mail-eopbgr690107.outbound.protection.outlook.com ([40.107.69.107]:50016
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726104AbfBKRzU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 12:55:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wC7x2ya9BdgEm7EYYr3zAaU/WQ8G6hwNU0yfWwn/ms=;
 b=J4hJXxJGHmDHvwpdqmT/g1O46R6JV726gxNN/8OAmYuK/e8Sgle2oB9YifFK4U0DMtbP6o84XsX04yeNSfznLu/uZuCoiQ3ymjG6JUwCYwynDk1rRkwqrCcUQp0g62PYmM9Kj5J1D9GSrLkSPR90a0oA+QJ9P2MxBbPo5FmtNP8=
Received: from SN2PR01CA0017.prod.exchangelabs.com (2603:10b6:804:2::27) by
 BYAPR01MB4982.prod.exchangelabs.com (2603:10b6:a03:79::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.19; Mon, 11 Feb 2019 17:55:16 +0000
Received: from DM3NAM03FT055.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::202) by SN2PR01CA0017.outlook.office365.com
 (2603:10b6:804:2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.17 via Frontend
 Transport; Mon, 11 Feb 2019 17:55:16 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT055.mail.protection.outlook.com (10.152.83.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 17:55:16 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1BHtEuB024020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 12:55:15 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 489C07A4B9D; Mon, 11 Feb 2019 12:55:14 -0500 (EST)
Date:   Mon, 11 Feb 2019 12:55:14 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
CC:     <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/2] e2fsprogs: fix potential memory leak in path_append()
Message-ID: <20190211175514.GA25892@mit.edu>
References: <20190115134203.11448-1-lczerner@redhat.com>
 <20190115134203.11448-2-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190115134203.11448-2-lczerner@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(136003)(396003)(2980300002)(199004)(189003)(26005)(97756001)(33656002)(103686004)(336012)(75432002)(186003)(16586007)(6916009)(90966002)(88552002)(46406003)(42186006)(58126008)(316002)(786003)(106002)(47776003)(36906005)(229853002)(2906002)(6266002)(6246003)(23726003)(558084003)(4326008)(36756003)(76176011)(50466002)(26826003)(478600001)(8676002)(246002)(52956003)(126002)(1076003)(86362001)(2616005)(106466001)(476003)(356004)(446003)(11346002)(486006)(8936002)(305945005)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB4982;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT055;1:XCam+iXQaT9tmhN18B+aJKTcx84RSxOi8sHjeNcX/+znFGXB+3O6zEBI6p4Zyj+YLaJ55+5cxJLo/9RD4Qb8LstG3slc18W6z8I2ane5gFWTael91Z3lOjp6khk2aIxAjRaBvuHtMICBxV7dPB9B0D49G96UkPABYL5yKSfFz9A=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7c37466-9568-428e-94c9-08d6904a1485
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BYAPR01MB4982;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4982;3:ApSUYHqjeW0M+kwf3OUcI3Ju7ZF4aj/dcAqB6pYDAov3omhIYtzZIoSDlnGzLjoJbXyfGiC4wl2rAASxOV6WRKt2po3LYUjFqQOOi7dEAyWCy7RwdWKUqPnitY5jMm9YvpHkBsnMhOj46rf5ubi24k8TBOdjHTg/ETrUV4PxBcP8iqMmaP2TR79EWkF9DMOMfnv//UhUvBY65qkWqvUDXF7WgVI1QeWmJM9xEV61Du3IQUuzFyFd+D7f/k0mgxE8DaguhO0Kb+TQk+Up7G7kMufsTu3utvUm9DNZq9u5CHU+1Yc79MnT+WchEZV4zxRLxUWcnkQ5CLJoFQYoM2i1RTIOjXo4gzksfh/pJS/7OuPnwVr16yfNIORa2pZGwRqK;25:SRjgju8dkv+mYfZVHG2cjJTT/YcT6FtYT9afg4mQySgb7rShjSz5HJSkf4wMRuiqwQ6wB6UHitjxmKzMY6fo3QPMlAk+39AFhVQvyjfeA1PJxNPUNKRAXwskrG6Vq0iGwc15Wv8KPjEQR4PPCxRYbO8UgbESaaJOe3Eqf9UgMmDwgSm+NwJYLgwl5gf6LgvhpHYpbQ/xn3n8BzvlygQvEZmiOQ+dmP7mU9xA1XmEd1Swb/1HbEzIfhOG1JplzLIH98PzZPZojlzIh0+95n4iVRTMsRTVRu1+uCPv7unFJduzOqtSjz2Ws9y0h2b0XHolMdkoFgpW2mzhVA0Eedsvkw==
X-MS-TrafficTypeDiagnostic: BYAPR01MB4982:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4982;31:0NG/xeLMyNtqMKqsIlpR0lgouIpFZxLEQMCWXJ4YTnQnjSChDbU4BX+GxcD42Th2gBqgLrUWCy1x8QAOYcbYtv8enMwGIho8ktASSXauPNx0e6Ryn56fy9kEG6SH15wEduYusNtrlBMh2rgYxYFRc4UKGuSYb90EII7P7ZfaGOcRxns57gqL1FMkOeJhjR9uk0jMeVTynSVlEw35dU4PH6NU1sZhLY85cKNbifnrFQA=;20:CgvQ9c4UlqNl1GbDidu0YeqUwGvrGd+Ci5JVwhPth9Ey4RgNlJ0h4WRtv37q+b0kSB3wEWWrrMovzmjds7yOeHcmYY2A69V09TCmQIdhvvzlWPrx598xsuEHxABnb5B0lJLSkrBztkKrvId0BPhYISu8aUy26iO0x/xmBPivY37VNILRfGftffxHOYfpaNltoHS0LPpuIsdDVyycyTAD/YXaLetSqHsnGcewJuQK4NXyTOKcKFEko2Gk34ru3GKl9b9Lc0CwupNd4AWyxY9FG0NMc0g721xQ4BvQCXyajmEasWQCmoz7LysXvgO/WN9R6mVWB+CDZVfrTMcCRND3x/OMS7TfFC5Y5FZkbuCba6w2pJvLidnaxCSU9I5KJcHyLZR5vVNnBqCDc3A0r6G4YjlT79ZmScOiyzE9kRUT5m25hScQqvtykkPGYoCT/Ce530kK5qq1pO7s8N0gYAVX0B+uHmEN+birJlKCgfQPJE/HxWKMZUWUAEekfxWMqpUxQzaAnJa+WRQeX5tJHWsobD2PoZ8wHrhhgntIk6eLo60t8SF1itb1+5wo+N4qCm92FkFMw5f3afI284+rszgWZD74iiaXmVoMNdQBJi1zAUI=
X-Microsoft-Antispam-PRVS: <BYAPR01MB4982CD281DD4318B32958317B5640@BYAPR01MB4982.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4982;4:z12HNxMz4oPGH+Wr31TEIUsFXGXQXz0GffSPu1Sb4AjBUQhZWIhgw33wW1XbD4hTHr9unFu7o37pAkCmV+r+qThX06xqon0oRClzZiWnpCbQBDCi5cGCSOctyquZ4N0Xu+M9JAbz+tVmDTt/nsFfffIjp/yedMHahQeWy6yUGjkVBnI5HehCnlGWyelf8jpMwZJMCkySXY5oVuEQct4jTcyolRvqqDBoWF5AKmw4MCX5S63biM9AWgyaFI4yziEaavrUZPWCXlGjHmw6LOnGgMT3Lsqbk9bs7oUYBKEsDDI=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB4982;23:H2AC/IluTswONFmaW7pBaN9ZEPqwXfH3L7fyfo95h?=
 =?us-ascii?Q?+8c4cDtLhOJIe2n/Ex8Mb3ZRLRIkMKvjDa/9JjHStt50QuSWo4Z/pYGP7EnL?=
 =?us-ascii?Q?90e18N/dpnsSglPm2Jqt3ZdsncKcMuHwIoxnugQYiWVH4xcEmhAYGvBGyiB7?=
 =?us-ascii?Q?dCKNh10qTSrw20cWTo6vul20akhWtvxGX1onpg4s5mjH0dYkmvGbKLVEMg9i?=
 =?us-ascii?Q?WRGLLqHaS3lcflICNUouPPEVjb5L1F1n7FnmKb3fVl2El4PJysqOClShX0Lr?=
 =?us-ascii?Q?x9zKl3Pbfx3Khb+rXXjvwZkYRhDc1Z+cHMt9+gyIVWTOfywt1CzY7B65D7xh?=
 =?us-ascii?Q?UGrR0qqfWDmrMIVqCdFlEykfB1CCrG4B4yPWa/61dAMJ0f/ZR/e3f6/IEpvh?=
 =?us-ascii?Q?WZtVayjimsXyCtJr62zzKsVVCjC2XvqDNlGtWXT9Y8dWYIy/73YTFlPJGXDm?=
 =?us-ascii?Q?09JAvev0BmIj93TMUFM6HHcVymzDo2ZMG7r/gi1s6A1mGPRX8WHdWYx3l2SG?=
 =?us-ascii?Q?IauG5wFzNeCeew3eUkSYFq4gmQWwyFGBanEHhfwnmm52fuYu54U0wGOR7TSZ?=
 =?us-ascii?Q?BmByDdGRFVWhnYKXjiqxOMC4tb9hXSYrXPWkgNravptgyF635i6Iw/Tl7U5i?=
 =?us-ascii?Q?EFiJtkUCFFMFQledwnDm2/gQWF6fWmdujEFCoxzMCGH7Gg9I9IheYoA6ClKJ?=
 =?us-ascii?Q?dGHJgdwr3Ex8H0wTekPM3ePkWLHRALOtx4EXYWSP9RXmag9ryhLd9ACX9BTS?=
 =?us-ascii?Q?GIXjz2SG7i5wpoKd5tmQ/9lyH1W7W0afK/fF6LCu4/fZ4qCkoGruIoxZT8Wx?=
 =?us-ascii?Q?XCFk1IDXqdtxVEskphrqv0yfmYW9o70+NHPrZvY+GLmrZQ/Sbth6zvcp7wKw?=
 =?us-ascii?Q?nZw5l/wudWQuLarL/ovmwbokMtW/uz8ZltRQ4LlVQTQ+Xt3TESbZxuJ+emxA?=
 =?us-ascii?Q?mKAe3F4/qolma2Eb+NzMs8KgCoiszUeJcvwUE4nltrqS7gWI/1ZQnDSMuBep?=
 =?us-ascii?Q?VRvKZDR8Gx3SaTgiudeT385dDeHd5LzF/VgnLdPq1jAg2LpbTLO9eYU8pfw4?=
 =?us-ascii?Q?bfkei2sBd1/XJVRIuPI1x9Xuh5UWaFGr2Ox4j43kTmwNn2TdyAtDa51QNu9I?=
 =?us-ascii?Q?07+HHbYZy66A7MmA4LZZhQh8MDzXsN5u6OGb7ncKOW5bE7CdLncdhO7sXk7j?=
 =?us-ascii?Q?T8do//mrgFNGXHjok7Sr8VuRvQzVVzEsw7snS2TKu7NRTKWz3cJtyeoPg=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: eMGiP5tWI0jl6DbUigsXTigkQIpv1mOXnfCAFpZh+RY2lkcEfrV1O1eGF/gcaBpVraggUjT0Oqt39+iGAiwZquTGuGkJ+V9JaJPOZsnDi4r8Hn9oq5Aae5sZN6vp9iSiX+ZhagAXNU9CBUicNDPX6EewgCzEstzJE039DFTBbyIXHnqIZhjgIkbRjVMD6wN1kZDOKdVsV4VkGoQRZz3JgBjqbVMdFnMI99ORRky6nhsOimOmI8tQZERdGygZHbGWKxvh32Ic6NJ8oAhZl73sJQ+4sBBmlbcQ7Nt4rHGXUmRueGKpvwcHtXrV9gG1ySWznUXVIViV3xALPeN3tCCizNNZqxJJped2Rn4lfUcTRPBHQi9qWMuDxHsKSYx1sy7lxgrxSy/olL2nqnXpcj16vYu+S6Jyq0gzEehrjbFebCM=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4982;6:z6D+D9pHHAV3Qz0rM4H/mfJebWOLnAi7wune4dIQUkNArSUAGg7io/F/m7MLm7NPU7MPMNH/b+/th43+wKvIr+fi/fIumOtl6crOhRRgFlRNZUjyn9BEkR2U3JmIrxw77g2PWiNrHU0arbbG2FfMwElTTBA4PREQu8lkc/VU3NCCI/YbWjIBR7YbQmvDgFIzNGj94Jt9+86z5yrX0kPHYZOQbwDXmQzCyz6CplHmIk2ZCTr25a1Js/7EEJG7q3+zrb9z5ad8ypEprron3AAhcST6Qn4Gkh6105np9KCsXe38WI6hZ1y/JL6nnaQgQi5+q+iIPbGZYBdwjDO1TTlL9WMEQtomV6l+d6y8Xz7SVkx6cNAPG96q9WvJd+nDVaI7bF+NnYNJP+q/lU5lNAoTHeKT8Uwt/qlNIHPM8co4yI06vbZLzz/UlOBbRFz/ijUF9JidVynMflfq2JFpJwwZyQ==;5:9g8d+gjNdseWW+YCvbUKVsN6hfrlmeUOgYzLJKTW1agD9LCR5sSt7dWdbEMi8pqUdc0PGh27EzDT5E6S4lYNi+DBDtlM7g9/VxylrE7xnUrmJ70k2Fqwld7mpnBoXPMGAujeRPYSf40iufXYAQ4mRusgq8KtWeThvYzif5td6CQhi3VY5QK0ep2KS/wF0vtSZhltdEafcUr0olngh7t6Yg==;7:sMAgYXw+5HCJt3fiHBDZMwHev3rBviBVye32e4TA31fpKccmR3gfcyPoQyr9E50qyHUYjEWmrBSV1KHgUAFWUrHL3zbXcs/D6Q1PoF3VFlYy5sdE3SMFttKHMMv1xaGYqhi9ST8rmldRa2VjI1DwWg==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 17:55:16.2239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c37466-9568-428e-94c9-08d6904a1485
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4982
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 15, 2019 at 02:42:03PM +0100, Lukas Czerner wrote:
> If realloc() fails in path_append() we will lose a memory pointed to by
> target->path. Fix it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
