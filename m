Return-Path: <SRS0=87aU=RG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39586C43381
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Mar 2019 02:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE12B20838
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Mar 2019 02:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="n45IMblu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfCCCH3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 2 Mar 2019 21:07:29 -0500
Received: from mail-eopbgr690102.outbound.protection.outlook.com ([40.107.69.102]:4116
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725942AbfCCCH3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 2 Mar 2019 21:07:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVSJ1Yo2Hh2FED1fk2lSla11aMFAk8G90RP/19XQe7s=;
 b=n45IMbluqQyyjOr2YuLm+23krNDCTTt6Z9z8n3sxfOBBIaLkhAi+rIIIYTXbmjIk+m7kqv1gXUckl6VBGqkTRMtKlrDo1x0StE10FN/OarG9kZmAR8HbyoV24AMdaRNWuoZkIA86m7KzezKSL6ZctPHdZFfHiS4bGg+rNb2R1rA=
Received: from DM5PR0101CA0033.prod.exchangelabs.com (2603:10b6:4:28::46) by
 BN8PR01MB5602.prod.exchangelabs.com (2603:10b6:408:be::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.15; Sun, 3 Mar 2019 02:07:26 +0000
Received: from BY2NAM03FT013.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::206) by DM5PR0101CA0033.outlook.office365.com
 (2603:10b6:4:28::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1665.15 via Frontend
 Transport; Sun, 3 Mar 2019 02:07:26 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT013.mail.protection.outlook.com (10.152.84.236) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Sun, 3 Mar 2019 02:07:25 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2327NMB005931
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 2 Mar 2019 21:07:24 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9CFAA7A3E9A; Sat,  2 Mar 2019 21:07:23 -0500 (EST)
Date:   Sat, 2 Mar 2019 21:07:23 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
CC:     <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: Add missing brelse() in add_new_gdb_meta_bg()
Message-ID: <20190303020723.GC7930@mit.edu>
References: <20190301171504.8583-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190301171504.8583-1-lczerner@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(396003)(2980300002)(52314003)(189003)(199004)(8676002)(23726003)(90966002)(1076003)(6246003)(46406003)(14444005)(4326008)(106002)(103686004)(75432002)(36756003)(6266002)(356004)(5660300002)(6916009)(305945005)(229853002)(50466002)(2906002)(52956003)(16586007)(58126008)(476003)(126002)(11346002)(33656002)(486006)(86362001)(786003)(2616005)(88552002)(336012)(478600001)(76176011)(446003)(26826003)(186003)(106466001)(316002)(42186006)(8936002)(26005)(47776003)(97756001)(246002)(36906005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR01MB5602;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0df4b400-1b1c-4c87-b457-08d69f7cfb2d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BN8PR01MB5602;
X-MS-TrafficTypeDiagnostic: BN8PR01MB5602:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BN8PR01MB5602;20:YjSIt+2dX2RY2OhTLl2718wQufOQf70VRH8Fh+nDEU9ZQ26fpmAGkGBNR/6HQBf79hTYqhE+abVeWHjAYogwaVs7CARSnAcroNMYCUCUsuGIuO5+Xbq1HaZLRuwPG5uYS2GQzD41AXQWefufSbSI4j0CeeOgNrgRyfoFeoC9qDFhdb+Z87OVLka+aE3lviot5kOc0skQO1FqKNT68wQ2F/S/3ftnTVGE2Wro4MNzmdNe8y7gm9qXSOxyxqw3KsjMR3dggtPErc8AyEsJZUy8Q5v61oKHApKC8c817D/Fe3p4WZtESZBpiT2/fE5XsieuCS6U26YdNZHxytwQAkB7Eos/5HvVkjXnh9shNH3jKPLSUbmNv1X4b50NCgNNNO1BP0zubd/+QWd8tOO/k4gRdoURFnIiMiKt9OTqP/inbZ+5rKcywJpTxBi6083i85454xTBJl3A1qyhIgX9t6Ficz6CIUALMEoF4Qkb+duxli7LI42AZO0smhNEKIsgN/CDX7QeF5lplANCFh4ilWVMzwG15NfGsg1kQV0FLgqMXbJOudZ8f0Gs6RQXnMsY1Cey1vaLj2IecYurZ2FY1WhFMaVNY0BfV9G1zWVsuKg7zrs=
X-Microsoft-Antispam-PRVS: <BN8PR01MB560281F76A4ADD3AAD738BDFB5700@BN8PR01MB5602.prod.exchangelabs.com>
X-Forefront-PRVS: 096507C068
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN8PR01MB5602;23:H6cQhnk+4oOwYcVvw40YG0Szsy7xCvSO41bNr6SAS?=
 =?us-ascii?Q?yQqVOVLDvjvqIO5wolx27Fq05wLN7ti7QgrW0GW6nQaYCnwd2PBbycJy6Mw4?=
 =?us-ascii?Q?M4Lzw/nklW2tNKoMbgLAWQ+wc58PomwlKhOvYg61sRyvgaFXE0gibxo6nXEV?=
 =?us-ascii?Q?SPec0kalpH9cTmF4eLF3POilUaHzPjxx/C//9cneSqIGqFYcc/pLA45QMmh1?=
 =?us-ascii?Q?ZJ/Sb4IZGF5B8akYdv2uiu6Bl1b7odn+H+YP3SoiTCG5idhIMPPs4uluK1tP?=
 =?us-ascii?Q?AmMVc2gMHq6seornsZGCdnyIy0t/VMl0FKvgHd/qXH+BskU+9j5/9AIEkJra?=
 =?us-ascii?Q?Ud+yPAVaE3M/b/TPljbEJ/K5ocvvs3RJXJURa49zKr6ZLRL9SlrMrG+zb6Sq?=
 =?us-ascii?Q?2WoCD51i7JCONI9Wij/RLsSee8DLdfvddng9kbt0RYm4wSu2+bHxVOcMzDmz?=
 =?us-ascii?Q?lkXmQzZu4cuuUc/Vw3S/rduiTrx9wdXnO/12zIHV3DAh7Di4rQ6+rLAajaQB?=
 =?us-ascii?Q?7j8oZ1r/CyfbuyB76VPb6z3D206rhGwsoqsbmhLKkuHQKXgCuOUAy4+M8FeJ?=
 =?us-ascii?Q?oFkr/5+My01hZn3DgLeYoWhGq8ufwS6gxLcG4IgxlISM1yazONAoBQsJYzEJ?=
 =?us-ascii?Q?yWNJgESsE32qAI4iGS7HQfSfu9Y2SDrzfnGnWGaoceINbNEHM9wy25N5nqgI?=
 =?us-ascii?Q?QXDCpKkJU50nToUEwOVyxSiuAS8XGNWzoh6/Hl8nnylrqpPhMuxDy4BOPDlW?=
 =?us-ascii?Q?Rc/9aMNjQka5Ql+hXSPMxfSKLl/ImS0PCWOYISc0ayGhGWrccQiqP1apz35Q?=
 =?us-ascii?Q?0cW4R1/SvkJIl1/Dz5M884X6uh+5aOIVmv6jT3Ffna0CLknxPpyX5c/HBFaK?=
 =?us-ascii?Q?rVJNhJ68h7S3l42SCi62WHOSKwO+PMao4RWepyvuW7Kon1wRBDew27/OBhBA?=
 =?us-ascii?Q?TjSJqsST1XAmETTR4pHtXIwnLavlj0XvfzoNw56aVr8kwhm/ZbCmdbxSRRCd?=
 =?us-ascii?Q?dGWk7KjcIKSw3kI4VIMy0Z5IpYqpkbBaOOQlHN5LrLHyLRQh1XxKa9aO37HP?=
 =?us-ascii?Q?ifsWp8UfpaGXHexP9r8DVQJMRS/TCmVKbCes61uPTLAvaZB/GI10bgYh/zCb?=
 =?us-ascii?Q?TQ0+tJaLjlyB02ozn9vcHtTq82iQnrVs7wSewsHgbfGJyPtnsP6Klqvd58eH?=
 =?us-ascii?Q?R4AmG6L+u98ACvYj2AP5m4+8XIjHFACa8r8m5LcVy0sPPNArwMsXV+BvA=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: dLNM7/ZJfrrEdHYHjLWoRpGIKTxlYYc5zwu1efypoJhSjCcCzCmz8fPcDBSZ11uIPSYXckyrfpKlPn8Z1kBNlc0c/aaAOpzAYXzDPvuDBDTBmuvOEohtf19bMF3xV4Bs+lhp/URqLQ41hS632Ug9FrGr/Zb1qz/umRHQV7swLLzs79nSw3HkdT17Y7vs8PX6oQS77lzgtA35Uskm6kikP7VmCRxM6eI0DG4fLDR00gvxIdGgNNce/xceQ34sYXEp+RTmPD/V6M45Ou8J91p+AlS9JI23SgILzlPiQgXUHdGpxhuwajbD7CQ5ecr8/I1odtoxNoh4OgugRKkK9OAhR/PcmiUpFrcmx3/Ub6E7g36Bs0si7YIMMK+U+g+5RMEFPetv6yT92JplspaCOWB6vKCBLybgzJN4ykHHEDpjBhs=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2019 02:07:25.5309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df4b400-1b1c-4c87-b457-08d69f7cfb2d
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR01MB5602
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 01, 2019 at 06:15:04PM +0100, Lukas Czerner wrote:
> Currently in add_new_gdb_meta_bg() there is a missing brelse of gdb_bh
> in case ext4_journal_get_write_access() fails. Fix it.
> 
> Fixes: 61a9c11e5e7a ("ext4: add missing brelse() add_new_gdb_meta_bg()'s error path")
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/resize.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 48421de803b7..e945f412cf58 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -937,6 +937,8 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
>  	kvfree(o_group_desc);
>  	BUFFER_TRACE(gdb_bh, "get_write_access");
>  	err = ext4_journal_get_write_access(handle, gdb_bh);
> +	if (err)
> +		brelse(gdb_bh);

I believe this isn't the right fix --- or at least, it's not
sufficient.  We're releasing gdb_bh, but there is still a pointer left
in n_group_desc[gdb_num] (which is now invalid), and we've already
replaced o_group_desc with n_group_desc, and incremented s_gdb_count.

So we should move the call to ext4_journal_get_write_access() earlier
in the function.

Ric's comments about checking similar function is also right;
add_new_gdb() doesn't really get the error handling right, but that's
an extremely deprecated interface.  We actually had a bug in the old
resizing ioctl's that was accidentally introduce in 4.4, and no once
until until December of last year.  (I think it was some crazy user
with an enterprise distro still using e2fsprogs 1.42, and they tried
going to a modern kernel, and online resizing didn't work for them.)

Anyway, while fixing add_new_gdb() might be nice, we can save that for
another patch and I don't think it's super high priority since it's an
error handling path for a code path that almost no one uses and was
broken for two years without no one noticing (although maybe Red Hat
would prioritize it differently :-).  But could you resend this with
the call to ext4_journal_get_write_access() moved up earlier in the
function?

Thanks!

					- Ted
		
