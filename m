Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1402BC169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 05:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A999320873
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 05:02:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="wRlO6alg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfBKFCe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 00:02:34 -0500
Received: from mail-eopbgr810107.outbound.protection.outlook.com ([40.107.81.107]:11848
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfBKFCe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 00:02:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5jgiNCLxrm/8GCPrC0cU8YTUXXuxVHuibbusZX6rlA=;
 b=wRlO6algZsLoyWYffZpoNMF8RDE6Jt00xhUo03OSGyd367UqyL6VgJSvUqD1S6AhMblkXWYO3gg/025Cn453xetPU4/ZdcxwJoFmx/oHMdh3Hs2tQegaCOYy29xs5Vhhe5iZSkce+Ot6ILKhFVWydL1NPDD4WerES0s57USawDs=
Received: from MWHPR01CA0040.prod.exchangelabs.com (2603:10b6:300:101::26) by
 DM6PR01MB4490.prod.exchangelabs.com (2603:10b6:5:78::25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.19; Mon, 11 Feb 2019 05:02:31 +0000
Received: from DM3NAM03FT013.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::206) by MWHPR01CA0040.outlook.office365.com
 (2603:10b6:300:101::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.17 via Frontend
 Transport; Mon, 11 Feb 2019 05:02:31 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT013.mail.protection.outlook.com (10.152.82.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 05:02:30 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B52Sq3030164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 00:02:29 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A448D7A4EA8; Mon, 11 Feb 2019 00:02:28 -0500 (EST)
Date:   Mon, 11 Feb 2019 00:02:28 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     yangerkun <yangerkun@huawei.com>
CC:     <jack@suse.com>, <miaoxie@huawei.com>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] ext4: fix check of inode in swap_inode_boot_loader
Message-ID: <20190211050228.GJ23000@mit.edu>
References: <20190122065823.67957-1-yangerkun@huawei.com>
 <20190122065823.67957-2-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190122065823.67957-2-yangerkun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(39860400002)(136003)(2980300002)(199004)(189003)(23726003)(50466002)(8676002)(6246003)(8936002)(54906003)(88552002)(14444005)(305945005)(2906002)(106002)(229853002)(46406003)(33656002)(4744005)(6266002)(6916009)(1076003)(4326008)(36756003)(103686004)(246002)(76176011)(26005)(106466001)(26826003)(52956003)(90966002)(11346002)(47776003)(356004)(446003)(478600001)(86362001)(126002)(16586007)(486006)(476003)(42186006)(2616005)(316002)(58126008)(786003)(36906005)(186003)(336012)(75432002)(97756001)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB4490;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT013;1:qk0JO/1Mhj5b13bo6uqMn7hnoQfsU2rrN3kwTCd2IoOuGcpzqJlEwvaADADZYVJexL3HYuyp9VUDtnRU3V3kT1bOXbBQ9puGkbBoHrPuislDv9Acw3AI7BOWpKr4ZbumGOm/d3gmz8bCujkJPb/uP2gQSiV9N2W50dp0MnFJv1g=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02df80ab-87dc-4a85-7b4e-08d68fde20c3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:DM6PR01MB4490;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4490;3:NAb36Sq9czoylKvY9vZIRByJY6/BBWt+DayOKcbEXef70Z+8Prn0UEaxop0o3zC1hKofedpSzXwJkwzKwBWU+Fm29pT34Up7O+qUwTNauSmEkLalrCSxLhob6OkagSWcLziF1ZSYAHKAduABEUPkcUhQdk1aSlXn7FnQbzaUiM/22nGqYljZvp+c5HiQVt8N30J6YuAU1491RHdu5PJQld1EacTXet90WLXXBMA/n4lpflZdENuovQo0eFCuUT6Nm9ye2sfaFyA2Y0i7j+QccKAicf8OKgFmZEGTBN2o5ndNzR0gXvPg3pYaOXsSAyQVubalc8nhuLXVkpt0zrEgDFnTLzkSp3f1S67tAK9xNb5T+qSdWKwjqupk6LUrXquz;25:LJ+186cf+IviL61N98AaYTFgyJyxh8SyBT2bngt9QwHcF3GbO3RpCdSpyb6hJGSAHBRm3i7ZIxkSVdS0oRMBk5/5R07XiJo3OxkXEVoOqAMdZWbqWhkjMcv1+1vU078IopOkMNOhnfvIbcPi32dSSZWX3u5mgFjBxKnsypWG/Ru8BZlvyqItTkbup3RPriRL0AZtqR8/vxNUJDbEK6+/BlMYIxP6mXzA+0ucGRJtuV4v7ZNFv8b2C5ovUf/x/Hfjuoxrc7FiadRD5Inl9EqKhSJGQVTCOK6eCxGetdneqMVJBZOIVwbXNOYjj9ojLpqAIas1PE67F1Bcc3oLgkAapQ==
X-MS-TrafficTypeDiagnostic: DM6PR01MB4490:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4490;31:adDDVYS/ttOCIOXfSZ1mDOGsMtLO4OwBBN1ZbDQgxit6+D4jMkIM+WIY4dKq9O+c//uQX+/J4lt84K/cYaJZP0PKXdAirmupuFXzJMY8USfJoy+m3ewr9IhpzHjqU7dRc7gro+ablApDTYAlWsk3jo3IDrTpji6qVUhli9QyfREA+NZ7m3ltkmwGRVH4nnNuzcJearTAunQttnRRBwGlC4Zjb9f3oWfnv1fQto2GQng=;20:hmuEj0dD0XpnW9dVbNhzNB4RXjAVj9nfz0Sv2CncgEibFdHDh+uqgQU8GNXbyYfmFwUT26g5zaWzlLF482dRCYAXQ94+1f8Na/pS56WxMtREXMlcNIjPa9+1wvbExzFvhPJuTsWL3MJMmn3Ug26EjEwwjH8zvQD2x9f7c/FNc4PyZV289tSDHOrQTgDGcBsi7K+Erqfx3tYzmNwWHCTvPpdDZ+IPSzQSxslq69df/Zm6z9C1S6Jr+FIn6qjfZqMjjqvLcApKgB4uvWgw3ZlhXN4Modrg7F3PDCku/nsN5TIAuLG0eTVjmxelLorYdPjg4N7lsRlPhBu3hlmZHBKAn7hSbHv+RDF4JsZJbuUisTgEQ3676h2EbHM7L7XX+BzQwgefTxJky4D9UBw6Nj8zJBr68GyEBKqfoZAttEzL7NpUQ+A4TtKibEzvwkcz1EaYJApvsvgUs3M/iyg2d00bv+8KoUkTXH4lbuDXnb1xrQ+1sza/+m/ymBE44Tj1ol40tE+ZxPoOBsC4hPLkm5JCG16m4u7laXbSTBxIa2VbwybKQPF8ihnuygOHkiXYU5s1dcXwpOVvG4MfFr9TGpyb8kDBGZylvKgmF46aBdrw/b0=
X-Microsoft-Antispam-PRVS: <DM6PR01MB4490C1606149874169327786B5640@DM6PR01MB4490.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4490;4:XjQml1ZgAl6U4/ufC/S93uxZeiiWwrRKU0cH5rTGYmmrzcuqzh+dPjeUoV1/j/0zvweC0z1LJSGzgBPBXrx2SqWHvjEFq4KnfJ5i3ihdBmCurpfBkJtKs7att05lnxzHjo+Xp52NsVwt/Jbo6FJu6VxkdRL/6V+ezzCkbhlqg1mlFFnCcr9w4+ZXcdRfaWtddBcyvl+w4uN+PFItNH4FaEor+ENyTQ9wy0IYRSZk3IpANrP8RxPHspivVONUqkd9Z0EU9NAbkldgfhACjCVJL24yOdEPXod8xTswM5WKSyc=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB4490;23:bArIbpX8Lvd65zdJzdS77FuC3G4MzJ9tT5UK2l+Lh?=
 =?us-ascii?Q?Ie9GqVXd/432xJyqm51q1+ZpOT6DpLs4UtEHEfQbzpfXzzfG3GKSynYMKlhb?=
 =?us-ascii?Q?LjaE3oFtMtIJiMS0xjyjMVlG6nsEGK3IlT35cK3/yvAHCZoL4JFsjHhM2Yys?=
 =?us-ascii?Q?JMYtOfT04uTPrYJ+GTRWPXJHorZxeYsupG/wmDhxznKrpnAsmmV0RyfxmO78?=
 =?us-ascii?Q?TM4RreZqjxcrcfq+nse9ylg6jJfH9GD6Yj0w/zqK1vQwsX+SalMEGluhjohq?=
 =?us-ascii?Q?k8HKd0lydO3io0N/8G6ZWgiC2V5gWkeISxgC6p17tc8WtKDxSVC0k0mSyTmG?=
 =?us-ascii?Q?fRjSKGNR+1P1PhJLpi0/z4A7/otFLbcAE35lhw1jOunO4ghKLGb0ykToGiZJ?=
 =?us-ascii?Q?T9kH2sXxxtyiJRWISCtQH8m3Gtz41khuwt5mhond5YXK1wzrZx1hQx3mIPa6?=
 =?us-ascii?Q?iLCq5znOBCeiUnmdeKoXFyemHgJn/o85TvYeCahV5Y0l3IX+fog9AKfeNKL2?=
 =?us-ascii?Q?xr4B/gZuV9t2t29HoCnSSCNZ/FEfsDRZlM5tys5ldEn30RumkhXUFhXgNRjr?=
 =?us-ascii?Q?4UcB48mUvQX+lRjSjAuWcMO/CxQP9B9/LKktbF28L4qAruer81r742J7ntCI?=
 =?us-ascii?Q?QTw8iWzNyfXaB++WbS89EHn/q5h+EZQJhpPKr7rxJAWMcV6Ozxt00SHQG1iz?=
 =?us-ascii?Q?CH8GOJB/cZkTwlYWQhmUsixXMkmvDBWpmOFOxUkiYDiRsZsUtVRngAgbsuli?=
 =?us-ascii?Q?5Nx8d0CJnGlMBVLYy+zIaeuaWMoXHDoj4ELEZbqD88zcPUjfCernETW8F3/a?=
 =?us-ascii?Q?7tEAhiAQbLZATbg+Lxa3j2Xueq4UHxtV/VXUyHaplUngYx04avWGgCAFDFFF?=
 =?us-ascii?Q?tV/Jhwefom+5wvzlThRmyv7jfgNTl5plWMDGUYVypWdi7T6haiiYy1+y7Pk1?=
 =?us-ascii?Q?i14Ph9QrLdelq3ZlzBoDgc5sv9lpwAtqHksDyTtqrQcgje9DDruRM+dO+J1o?=
 =?us-ascii?Q?YXCbY+e/UquyT63X9VKprbcqOqNNHyhpwfRLrCLmaRmNQXlWAlK52mxq2viX?=
 =?us-ascii?Q?oIMXxVVTGX+9oiaTXIWD7pa+4wahr4GtrG2kJv8Um8Ds3nSOoD5DVnglf7Wv?=
 =?us-ascii?Q?taONed4EcD7XLeaEeCBAIl2yP5OgQH0sffeMKR043TP4UQYn95ySct5fnbGp?=
 =?us-ascii?Q?AumY8LjGllhNWm2QVrXbEPqc6ifBaPVp8Q4XYnvbdEfdJPySU02EfH3EaLBI?=
 =?us-ascii?Q?lB1ECskWDR89RVb/z8=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 0AhFk4BpZNdxUOQHSiPE23GU7T2nwXvfKncDMX7o6NdSDRw7EvHtT2RDlVCU4TiUHbTGxWXlz/WG84nf8ldS+yt9EtnNWkUce4gUyAFLYnFv7Hubd8ceZbu1jbky38F44MYAM90uUZpKcUHv5boqiigm0MQxajGwZsvzyH1LKXRXripB8eakyEJMIKNiHrZdCIKh0tzlkKzKiy43b7Z2sgbIxYS5cWv+uV6Rw6lXb++PdJCbnW08Bvkabi9Tm2w9mTHE2ovsI4VhLCK1LIp+Bkfym1qV3X2g700D33RfN2KqzsG+HhPNS25PJEMpsgc+UzcQBG5UXiA/CsUZn3rTtT+m0ukWjMgaKTRLu76FJOj2E+gFeCl6TspZs/RSrtcc5qUe5fYaS9pCOLLGmaBZFBX/xv4fx1I2XMdOYDlHUG8=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4490;6:x+YX9WzH97xRAF93rh29SChm75VogB0NTAkcLu2LKnpoSbCQukNUg4HPvGZIDwjhaGe5qHTMt/6yfoA1W6J6LE/RgFCNhXFc0Gk8H2xdNa0x6Sq0VF2IECH4s3yj74WVhs3izK3AaGWxAchDp0BWI4tQStjWDrFwPgaMHvbFApl4EacknUBo08MLMEiJC8WhMkcjVrHEAQUL7nlg/PTihh+S+LomOlpI0/M0XEwxu0Qcnvf8SRlfgrO3MvblMm26yMCT2qMXzNpzk+xrVLYp8Grbe405Mxm4g4xbZ7uhIBGchznfQX7lIcu6CX8BZ9Yhw6lFZhVHyKJ1RUK+82oPqsGE1C/fIyONCI+fL66+DvPZAHprPSj48Vl24TBolgS6HQ5eJCU76IElu2wAtmC2G10oMNolGBJpvPfE7myLnpiWDUDdd27lbgZzHZ4BwkKMwECprwRIugxLrIjjP1TmXA==;5:GuAmvdfCMZFyA2FTfKKx0OBeFLkwzXVFClPuQeRkeAcbFlYXbVBjnt+RKCzI4rXL1NBHe242tH2TtRbngNMWQo4GtuvGOthfoWQOOpf5dFZuHGx2ox9QTm5HStk7hQhLPMqU3fCyT+/TOCX/kqITD62c59eV2qd3sY+6EBkJ2lIJVQq2jmZ0FIjeXguuaaf4pyrV4DuS6Ufm0hijapoCAQ==;7:PWN48SLBVmi7UtOWPdHJwUjWgfguwFxMwGO54xAuWyz9Z2jSMyoAG5xzZTjbPTrNrgk1+Z4ndeYMH+Ms7roAWRk72dv5tgXFZ4Sv3iO1Pxb1P3tYJNTg1CbSYf2ckWYnuxrynrlZThU/FWIG4hJ5Yw==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 05:02:30.9421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02df80ab-87dc-4a85-7b4e-08d68fde20c3
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4490
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 22, 2019 at 02:58:20PM +0800, yangerkun wrote:
> Before really do swap between inode and boot inode, something need to
> check to avoid invalid or not permitted operation, like does this inode
> has inline data. But the condition check should be protected by inode
> lock to avoid change while swapping. Also some other condition will not
> change between swapping, but there has no problem to do this under inode
> lock.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>

Thanks, applied.

					- Ted
