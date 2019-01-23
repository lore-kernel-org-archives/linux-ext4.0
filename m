Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C4DC282C2
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 06:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4528521019
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 06:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="s8T1BRa9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfAWG1q (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 01:27:46 -0500
Received: from mail-eopbgr790122.outbound.protection.outlook.com ([40.107.79.122]:6076
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725899AbfAWG1p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Jan 2019 01:27:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/3eVRsaYDieI7a0Fcya+kKKkMC7iq0KaKOdirKsoFY=;
 b=s8T1BRa9h4NwPWswcqRt90G06UURLYySusVwrg8tPU1SToVEFjq7ZYMJW70rbzLfqMjyfX5t/8hl412HiKcg55Mda9TCt3AKkivWCxD95u+foBrmmIm6DBhdkrNhBn/JMiIV5bgxSwbcFjMzOJ/HWRyYFzMxi+zL98Cb05hRkvA=
Received: from BL0PR0102CA0015.prod.exchangelabs.com (2603:10b6:207:18::28) by
 BL0PR01MB4481.prod.exchangelabs.com (2603:10b6:208:81::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.27; Wed, 23 Jan 2019 06:27:42 +0000
Received: from CO1NAM03FT056.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::209) by BL0PR0102CA0015.outlook.office365.com
 (2603:10b6:207:18::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1537.31 via Frontend
 Transport; Wed, 23 Jan 2019 06:27:41 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT056.mail.protection.outlook.com (10.152.81.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.11 via Frontend Transport; Wed, 23 Jan 2019 06:27:40 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x0N6RcmB024224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jan 2019 01:27:39 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 107867A4C0E; Wed, 23 Jan 2019 01:27:38 -0500 (EST)
Date:   Wed, 23 Jan 2019 01:27:38 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
CC:     <linux-ext4@vger.kernel.org>, Liu Bo <bo.liu@linux.alibaba.com>
Subject: Re: [PATCH v2 2/2] ext4: fix slow writeback under dioread_nolock and
 nodelalloc
Message-ID: <20190123062737.GC7597@mit.edu>
References: <20181215054840.5960-1-xiaoguang.wang@linux.alibaba.com>
 <20181215054840.5960-2-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181215054840.5960-2-xiaoguang.wang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(136003)(346002)(2980300002)(199004)(189003)(46406003)(90966002)(106466001)(97756001)(2616005)(476003)(6246003)(47776003)(103686004)(6266002)(336012)(26826003)(2906002)(50466002)(4326008)(126002)(76176011)(186003)(33656002)(11346002)(88552002)(26005)(229853002)(486006)(446003)(36756003)(42186006)(246002)(86362001)(23726003)(36906005)(16586007)(58126008)(1076003)(786003)(356004)(75432002)(8676002)(6916009)(14444005)(305945005)(5024004)(478600001)(316002)(54906003)(8936002)(52956003)(106002)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR01MB4481;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT056;1:D1HkHPOor12cUbn8E8wfKceB5MMac25T1/6VoJ32Wr26V9W7tuBy/TpWvXV3yX7lCkRTghvpF7OiscJ15W8GuMxyWbTsKbfH+WBnbdZykFfvQuWYUaLP5JM75c3xj7w7KSQJsJmJKMz0eiEMq/U07qFdfzBPmEXVxXN953UfxvM=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e45664d-0807-4e5a-162e-08d680fbe07e
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:BL0PR01MB4481;
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB4481;3:G3GOb+wjt83Q7QRYH3NgHBkDOYdN/W9U+W6p3A9oz4aTNrfckDqpVNSkF4TttKycaUBu1T5KWYM0VKA9uYzogaiv4cLi8lTwDFilARDkNp9gP2o341MEwuTWeTqa+styKuAOfhOwBxvUE9vx3Tlq28prOrN9rb3AqCabuOu4XSG9yfX/HiKJidrOA5R7+BhA1bcQaOmoHNIlwJ70ZgrBNaz1kfGza82ZPU1yRstiRGu45QvufyDFAmUg6p+PY3tW6rzOeN76w5tXfykGCk7aXOtMLNOOKlUhdq1JZxjAC11kHoBldhGaYvX/cUkzzGn124J4Im5L/di8n3DvxHAA6qeVCRRp9bbwNQLZ6bDMDsvV/jTsRK3EClSEWQA57Nrh;25:vHFI5M8eK38ey8n5mVnC9tJsQNLp6D0JnkR1OCBUS+5Kc69xDMckQWGWaH5+Pd4o5ubt+BR/RhBQDb+kCYX6sVv2XVByH9xtLfQouLOXaWwetKMLQ/q/tAy/HHkn/mqJZ+9ndi3H4dQcMjOUC8tx39CMgfhf22MCizlNWH/B87aJPhToxzDGodaUX2CfZXQ1G3Kne6hZmOmM23NGophK2omRFUFe9TsoCGw3/1QCKxdUNLmF6crfiowFX56z/9WmgUOk6s5AqhlwZUWkZacvcdo+8LcgEl35ffeB37oc5r5zBhCF9VYoUdzQOA5bGyiH9LVfgOpqgCGyV6trYVXbdQ==
X-MS-TrafficTypeDiagnostic: BL0PR01MB4481:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB4481;31:Z0b6a2uav3kGaUxdRTlGzY49Lc339jLzXKKqTnKsrW0n1XYa5wPN9a6hXcWzND8XAH1cqslYGmlSsmxP6suH2yq7oybRi9WSwYh+iPftUDTHvtGakxzy8Kc05/14sZpzG1wuqBRgcB+vpLLih3swNafO4iPqoJbTlTjjXUAsH4wSAD1PXDod7KDWFBnvVUayqjnchWoo1MKHlCctnNOl4MJBdH6mtPUEbuK0aw1Mnow=;20:ALjNp3A9JYbXEY0fj1EaPmxYj3Q4ULpmUMuS3gg+jIPREDPrmFdIF5kFwLpVeWUPoT94R8pSLbcsSguK9seutqOURx+VpjfP435drrtUlc9cTsMQxPhvdETXu3p7a0IDiUBV/3uj6LgOFkblZ8gEDhpNoq2YdN0Csicop/j0kx5GVtgF9v6yuivSolWz2rQZ4qHMRMFF59LlfHKCqXys8xLkx9gbQffUSXUP8JIj735XnvhWhjrfnx1mZpGvvebXalW64oA5NignJ5V+54xLkSWm6mgzdOToMCvj6+vMyQtC0i7CFTva+ZHQXog4DwQV1X5oF9/BUrlyglwNa/+QVn1pBoRi2w8OYkJXk4zAzZR1Y+88QcPyLE/imsUCPc81SrSd6PA26v2k0sxeeI4z7wJLf3cheANbhp8B5ctzmo0I8P77ZrO26AR/fmhABUSMPlr11WuHh7ED0ZVUfP8M/LdpGA5R6ixa30j1JxwdF4V84PuR33/yD1kRkc/sXsDBbiDcUxkHmjEsahJJYvbVYARNBWOcZ9/xNpYLpVAqEPnQXUasiYgaFP1cThVnniRJ0xGd10vQmGWSw5jqDu8qGMEDCSt5kF77fZ8V9J09ftc=
X-Microsoft-Antispam-PRVS: <BL0PR01MB44818298AE5468A8C648C301B5990@BL0PR01MB4481.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB4481;4:9UQWqNNezjgJ7vJDuT0FpG/SxkDZPJf918zI5ztaNzM5kzPbDDJErtwT2A2Xqnsh5v42KDJ8xwGsBVr0FKw1p1Sn7vsz+BU7eb26KB26dmUBvux1UDQXpVwasIpUK/a5xLpH4W0z6NEqRStFfwQyrS/E5TCnkVOn14x4DIM8A7xJz48tdocmUWws5q6JtHb3hrutl89gcxeSSa5HU2nu3Lcwx3uVEozBTFAnoDlYWDVtJE/DoOosvZ+HwZCN795BnGZGEFcIe+NWgMEU5tZA4nNGzPB+3TQhWjw/dKEQ1kpXUWMmMW7S64cJ7MBrNjzc
X-Forefront-PRVS: 0926B0E013
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BL0PR01MB4481;23:isVwGesu52C1ZcULku+6mtdrfluF6CDXg10nya4Ap?=
 =?us-ascii?Q?nxsImMA7QjSs40WDf66JWx1gMTmyeejxdIl6LvKEUxAGKvGvdzDNHcOYtTFg?=
 =?us-ascii?Q?Qg6TZFrm0BsBRIF1+QG10YOlDOihN5RsDz9efmEA84oTmAUCb+nNIZw3Tqb3?=
 =?us-ascii?Q?I1POWEusZ683huJ0UAxdlk1vy4y24bCdBaRT0UUeicdn2VQwTF6tIOdCJ3x6?=
 =?us-ascii?Q?U6sh3kvrcyBVq59KFETmgU9O62Z8dLdcmf16n4EOoleu1EHIGBylGfkuTSpo?=
 =?us-ascii?Q?lCaWWDl95KpgSm2kINHHnqyyDsODuKUjrW+A6O1DjLYpa4f6SdAvBjZna++g?=
 =?us-ascii?Q?UmbxcFe6B8FOZENxv/fXQDpoaU3AQD0nvU1LSnNhvhNbXNfQkQW3YiUqSa/M?=
 =?us-ascii?Q?duD+4ID/lkdFdyVDQN09tug3yAzLsYRYJ78YvUAx9CcxWMM+5SFiOkjMjVr1?=
 =?us-ascii?Q?9XEKVRPwiVYFYHBVEJ1k2G1xrj6jNGotsYD9ghIaSOgCybBgJySSD+lgXqIq?=
 =?us-ascii?Q?FNommYawwXvdcMCPgzLKt7+5fQykaz8RegOE9duRGrpf1qlNdMQP92ASoWk0?=
 =?us-ascii?Q?wxH25BGpn4QMncM5hvt4JMZsV40USKhfYJ7b5J3TtBOuiQNtD6itf6hAjsN6?=
 =?us-ascii?Q?qHdxeoAJmy8wpeZdVdmD4btzHRII9Q4hjnxbeq+jMVaY2fpBlm5We5m4UcVC?=
 =?us-ascii?Q?KSfKu9SqMUxMvMXRhR0GY6eGx1HukB9F/pCpXGUzNZYvVX5p097bBpF32Aul?=
 =?us-ascii?Q?ZXfE46AKAJGqgcvxIQonvW+4Nt8TT9NVdMJge7xlSi79rJjuQil2bTR+05PM?=
 =?us-ascii?Q?CdKQi0iNhOoG+CEoRNYGK20ohvKO7wavQQIRskJKudRij4ZPXq6UhPHtZAQY?=
 =?us-ascii?Q?W4wQOdRAeUrLT9A6GBmSVMWnO3G2L/tvcYfMomjBrhqlTvrpamMkOAUves6g?=
 =?us-ascii?Q?TYzu2fxaGjP9ygt5jLy9qp2qxzlELynGJR/GzFjtg8ilAFNZd2OybnQz0set?=
 =?us-ascii?Q?UCU2rdo12gBnra5/9lIeu38cxZrPDidLjP3UcpRoJ6se+OpHc3L4SRFNI/vr?=
 =?us-ascii?Q?Q4tsOCky9EJyD+y3Hh+9PeSpY/f1crJNLsYnLS8qq3NPkGHkmeH6sdm1Gc44?=
 =?us-ascii?Q?VP9GTToTMnsBFIvUlwClZLORgLNP+eGW1GAgRksdNimYTFK5aJUZVV8+d3lG?=
 =?us-ascii?Q?vB4gexZ9Wjykkuh1KYtZdMjN344FNmMTZmFseoYI+puOQKCnErk2+asWl9B3?=
 =?us-ascii?Q?7TKELDiWZC62Szw/M4=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZFmWsM28dv5kTAcFi1dVpd0JUjXHkmqvF/7HRh5gElScRXsIPPvfJrzymvA43XQ/hOPfbbsZJ6sbKt95801kRPJOuJ3yjEM53PtYBIlsIynq/eptSYJ5TOC++M+yeMWAYyLA0sE7B8zMeic/52aTO03KIFe14eAy9fPINkurqhucAVWsVbNTyPIJdfkAwrkK8hRjxIvekVSyEWZu5CqBeC61O4+wLrtW6S5Win1fF+6cZigH/othqvnrQHS7rJYos2khRg90rSW90pJLoPE4eU8Lvk4YSgeII8LWlNlpTeR1Mbd+AMQCDIPoQ2tHhpn2Z6mJFpG0Pi348jgnlIPSKHPse0UepYdF+H/0iFwqw5SoyM3tbGAT9dVUnXT/mkiG7+3ftMBrQpO3CNaBnCr0yEZPh4cTJjW6S1Y4cv+TrZg=
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB4481;6:TBnz43Tbq6hwmaWTnTf2YXAJi7mw2bV3JkWuAFz0wc+i/5EU0PozH/vvIEh7x5/wRwqUg0j8GxNWJ2Utw2M5nIhB1y8XLB3grg9csDM3btxZlKUOhuLs5+9WUja7E+LJRJbv7VzwmZqdPi8Oz601vx7OZ7+01uYljCA6N86+1RpnjKUcY4BRSGDiFCk3RkEhgG1panOlbl2wkX++o31K+kIb3UwXy8Afj14ejyIrRpG4DunkUncIvqvr/zioLYt+VVZafO0LjAezE2k7qaswspmBUNJ9CbwkemN01sp2ASQw9Ef+eaoNEnqskcDSB4GxgFvWxttSSQO1BLndNArNxeKE0QWBCLMe2ImlT85pt5CpNHNjNwZrM6i6Shww2XZlirik8F4Ac54NoF49ROV6Msp15O4qqv96tAmIRBCbZAA6FWpnu//vDYxlQ8aKqU7xSZ4cCgakg8iLl8bsJRH5yg==;5:v3WD88QyHfOs9GB0Jxepr2WA+W+coRypVppsVcojbKd+nthi/quN792USr3Szv3cBV87XD183d8ORy7oivPDVpIOwk0g+B91nMBqsCg7nLtCo2QlYBJ0mzi2wyFawgKCb+m61b0Xoi328sjyB3DPMfccWEUzTLvXPuxA2Y+kxuNE8odQ0S4Us73D9KbRnVlH89VoaZDFM08hBh57uKMeCw==;7:3BxUiM/nyXmO/wTQ2Inhc7kc2zrfycMm3oB4o+z+vvnWzMZDDZYetHCl206H7nem1xt8lpB5sIUM735QAnF4nO8j/GsYNU+rmk6Fu1vSIq7DJ1NjA1eWrC2SLPz9ViptEgKSbi12LwaCPs0k9E/SdA==
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2019 06:27:40.6947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e45664d-0807-4e5a-162e-08d680fbe07e
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4481
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Dec 15, 2018 at 01:48:40PM +0800, Xiaoguang Wang wrote:
> With "nodelalloc", blocks are allocated at the time of writing, and with
> "dioread_nolock", these allocated blocks are marked as unwritten as well,
> so bh(s) attached to the blocks have BH_Unwritten and BH_Mapped.

I've been looking at your patches, and it seems that a simpler way,
perhaps more maintainable approach in the long term is to change how
we write to newly allocated blocks.  Today, we have two ways of doing
this:

1) In the dioread_nolock case, we allocate blocks, insert an entry in
the extent tree with the blocks marked uninitialized, write the
blocks, and then mark the blocks initialized.

2) In the !dioread_nolock case, we allocate blocks, insert an entry to
the extent tree, write the blocks --- and if we start a commit, we
write out all dirty pages associated with that inode (in the default
data=writeback case) to avoid stale writes.

So what if we change the dioread_nolock case to do write the blocks
first, and *then* insert the entry into the extent tree?  This avoids
stale data getting exposed, either by a direct I/O read, or after a
crash (which means we avoid needing to do the force write-out).

So what we would need to do is to pass a flag to ext4_map_blocks()
which causes it to *not* make any on-disk changes.  Instead, it would
track the fact that blocks have be reserved in the buddy bitmap (this
is how we prevent blocks from being preallocated after they are
deleted, but before the transaction has been committed), and the
location of the assigned blocks in the extent_status tree.  Since no
on-disk changes are being made, we wouldn't need to hold the
transaction open.

Then in the callback after the blocks are written, using the starting
logical block number stored in the io_end structure, we either convert
the unwritten extents or actually insert the newly allocated blocks in
the extent tree and update the on-disk bitmap allocation bitmaps.

Once we get this working, it should be easy to make dioread_nolock for
1k block sizes; it keeps the time that the handle open very short; and
it completely obviates the need for data=writeback.

What do folks think?

						 - Ted
