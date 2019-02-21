Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB3DC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9D520818
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:28:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="xGMAIPYG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfBUQ22 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:28:28 -0500
Received: from mail-eopbgr730126.outbound.protection.outlook.com ([40.107.73.126]:53632
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726074AbfBUQ22 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 11:28:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfgL5XjNkEzAtRKJnrbqjdnDstDdxD0vpsvDDFysWfk=;
 b=xGMAIPYGSo/b5b5/t9qUBvsL1doUB4oaRNLite2iL0ccsvQJSwmNhI6PBHIYnTbzQEtuCSyGYQRr7bux/bGH/BhF2FAzIfxnDHFY0goA0KDv6RjZqtmkisAhKThg3LC3OG/gb/IUTn98EidPpRbYTR4LkEPxHHYqWt4BJAR8njk=
Received: from SN6PR0102CA0009.prod.exchangelabs.com (2603:10b6:805:1::22) by
 BYAPR01MB5605.prod.exchangelabs.com (2603:10b6:a03:127::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.16; Thu, 21 Feb 2019 16:28:23 +0000
Received: from BY2NAM03FT056.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::209) by SN6PR0102CA0009.outlook.office365.com
 (2603:10b6:805:1::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1643.15 via Frontend
 Transport; Thu, 21 Feb 2019 16:28:22 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT056.mail.protection.outlook.com (10.152.85.45) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Thu, 21 Feb 2019 16:28:22 +0000
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1LGSJfT018802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Feb 2019 11:28:20 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E92387A3F8A; Thu, 21 Feb 2019 11:28:18 -0500 (EST)
Date:   Thu, 21 Feb 2019 11:28:18 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
CC:     <linux-ext4@vger.kernel.org>, <adilger.kernel@dilger.ca>,
        <jack@suse.cz>, <miaoxie@huawei.com>
Subject: Re: [PATCH 1/2] jbd2: fix compile warning when using JBUFFER_TRACE
Message-ID: <20190221162818.GB10245@mit.edu>
References: <1547100399-127915-1-git-send-email-yi.zhang@huawei.com>
 <1547100399-127915-2-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1547100399-127915-2-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(396003)(2980300002)(189003)(199004)(14444005)(126002)(356004)(33656002)(106002)(90966002)(6266002)(6246003)(47776003)(106466001)(76176011)(58126008)(486006)(4326008)(54906003)(86362001)(229853002)(336012)(36756003)(2486003)(5660300002)(42186006)(6916009)(186003)(305945005)(8676002)(50466002)(2870700001)(446003)(88552002)(26826003)(103686004)(11346002)(478600001)(2906002)(8936002)(316002)(246002)(2616005)(1076003)(786003)(36906005)(52956003)(26005)(476003)(75432002)(23676004)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB5605;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0aaddee0-01f4-4644-43c9-08d6981998dd
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BYAPR01MB5605;
X-MS-TrafficTypeDiagnostic: BYAPR01MB5605:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB5605;20:jFr6MNADzBMsU4t2/NYSepVRJ7QVdE8uJXhPsU8Tf2RGJ7Md6qCAhhAevbNtamDDW78mQdQBiIq2+DNuoD5xY91z95xkEeVcVDhBU2CqqMNlSe3A0R9NxoQNx6/duqdGNQHXXnG9tp6lyOisl/mxNFP6CIbUVanYrFzs75CLCRq9OstmCICD1A6dtTke4jXFRQM3x+F2Xgy2wV/s8P3M/0ophWSSdrk33bdgDKjHJDh1fo/hRO9zzcwoFxBW1PFjAxB2yOkqy9AdoSWswFLFh7J1xx27RobxFWMKwKimg6oPZQ3BTIkGi+poFuhG388eyC1WdkNRg5zb9mqvQmwc0TK5MHP1bjbU8EjPVUr2RoYfQhcW1wm4cFTHw+Fbiyq9FRVJoljj3GTWxVvuwJF72EXlKC+CM7/vWLZa0Zl4nT+fxeev5iDv/AruyhcplM9QE13NIQL1H/zTPokOspCMfHrQUXrgsgvSVVoTAfDvNrKgLthTSdWCOcvrJVIfmweCP+kfTknwBIdEihDHcrzmQ3tBBtDb/2evkAgkulh0YFkwI1Lhs+P08QCSUyHLk+Ge00wDHO3TAnhDBBQ090RvcLWnJVEqalUosMfk12eT+Oo=
X-Microsoft-Antispam-PRVS: <BYAPR01MB560515B1FE573FF989DBA772B57E0@BYAPR01MB5605.prod.exchangelabs.com>
X-Forefront-PRVS: 09555FB1AD
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCWUFQUjAxTUI1NjA1OzIzOlU1WVBCTVFnUXQzOWY0MnIxa3dsV2xjbWJ6?=
 =?utf-8?B?L2xOeHJjKzhBTlVCcFNpcjNKaUpNMWZpVE5Kb21pZzhSZU00Z1J2NDU4RVkw?=
 =?utf-8?B?UysyRlRRVkxzeFFDL3R2MFRMMjU0bjB6b2c0U1RXMGFqZHo0cDJxTnA0VmlM?=
 =?utf-8?B?NTVOK2w2Q2N5WVJBMHp6UUhKQXNmblpuMHlaVll5ckVWUmhoSTlZQUkwblZt?=
 =?utf-8?B?QzArMEhBb05XanFINytSR3I2YXQ2bTZUTm1zRjRDU2RHSHVHdWI0TUUvcTds?=
 =?utf-8?B?Y2JzckZUM2c4Wk1JY0hiOG9sb1QzV0cwM3BHS2haMk0rN0RjeFNIbEFBbmtK?=
 =?utf-8?B?d1VBTTJYTmJiWW42SXJIem12OW9ybGFVTlhRUE5tRTJpbWY0Qjdhd21WUndP?=
 =?utf-8?B?UVAyK2VRWjFiUjRUY0lwbS9WanFSZmhjUm5Waks1eXlLV2xIT290Tzl2Z21O?=
 =?utf-8?B?VjZVYTdRSHVJZVZydGJxRnYvc2ZzaGVNTU5CalpPbk4xcGRFVnh5c2xNRXdI?=
 =?utf-8?B?VzFreHlrcE5KZ3ZyUkloUmJMZ2NNK3d5S24rZlpKaGJESzZyYm82blphaU56?=
 =?utf-8?B?d2J1NHRSUTBjdGczNHd6eUlKNTFXV0NSYmVqRTliQTFmNXdVNmg3bVpuLzBl?=
 =?utf-8?B?YlI4b1lraDd5eHFVMEUvQzlYSU8rTlk3aExoUm42cjI1WGY4TC9DT1IxbnhY?=
 =?utf-8?B?Y1hlZVplMElsalR0cmZ6MjNUemE3TXVneE93MU9MTExLT0l0WmJ3ODRteHZN?=
 =?utf-8?B?TUxIb2I4bTRVcThHZk53SlZvS2ZWSm9hS2NoQWZyOUd4dkFIck5aR1RYTnJL?=
 =?utf-8?B?eE1vWVBrYnRuVDROMlVyenVrandvTUllWTgxTTF5TnRwckRrNGpuazNqNjc2?=
 =?utf-8?B?WU9oVnYzOTJSQTJ5S2U5ODE0dERIVHBKczYwa3Y4QVMyS3N5OFRKZDlJTHUw?=
 =?utf-8?B?L3owNjN0YnlIZlJUc2tuS2pqeGM0bitzMDBSakhxd1pGbGN5TG8raW92bGN2?=
 =?utf-8?B?c3FpVS8rbnJCTnNaUHNXdGwxMWVpOWhJMmRHYkcxN0kvTEtkR0I3MkQrbzRS?=
 =?utf-8?B?eUdkMjNCTDlCeXBObjZ3Mm9MWUpmbThTUDRBTnFiMlVTUFVrR2s4d3piVEdl?=
 =?utf-8?B?b0Z1VW4yR2FvUXFlVjR0YWN5c1l2a3dSNWhoci9GVDRQWHAyeFBnejU0Uk5G?=
 =?utf-8?B?cHZ0YXNoN2hqVVpyODZod0xsTjA2anRURmpsS3V5ZzRESHZCK2t1TGk4TWZw?=
 =?utf-8?B?RnZFLzVZK1RKN2NYSlZoeTU4UEE2cVZyazZTUTh1VmVBWkRHMHgrYk9ZQzBC?=
 =?utf-8?B?TTYwbFcveHpXUjZVUS9yV0xCaFdSZkdHZ1d4clBobXl5OUhSNmFlaHhGT081?=
 =?utf-8?B?ZmpoNmlMK1Z6dEZwU28xTVBXUGkxME5DeEhHSTFLeFV5WEVkUTlkaU45bGNR?=
 =?utf-8?B?OEg2N3dlWXZ1UFBEdSt3eFJPbldBNnJ3R1p6NnRleUdtcklBN2xDMnlZRTlY?=
 =?utf-8?B?dlVtZXJSa3d5ZW1pblNnc1lyL3VjaHg5NGdheGlFbWI1Q3BzZHFQOFlPNEdI?=
 =?utf-8?B?RlVpeEJ6MXJiM2dPNTRyS25VN1lSN3JNZE9wWks2WjNzRkltcmI4WDdFZ083?=
 =?utf-8?B?a1d0TG9nTG9ZUy9nWW8ySnNrbXYrNVNQOURUWHNDdjY4aDJxTjI3Z1h3YTZV?=
 =?utf-8?Q?CweQykI8KvvIvqLECoyZwZr8SAMUjVfGd3+vgqk?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: TtA5zlHJ4lA0FOGtvqa+Urj0V2gZv+8qq87iKsHfpuZ4oeUoysPLmjnAp6UebbhsE2RXKnwHQloAWa44dk/Qkynv14UZYUw4LVmV5Omi83IQ1dyynXFSa02BTyOfC9bhlYr/N3+OjBb/t62l2V1no9ebntqvfiy3ZCN7wDAsmE9TafXNua+sBS7Bfc0EtCUVDK6ZquWJpF7eTt4jqLCLwRgSa0i3prvIdHxHKFNJvtlTnGd2IvLU8wtzMWwZrVOauvyDQykK6xFx1qa/pdn1wN1hRwutVt6X9fPOPL1oPPPb74wuBvy1AmP8neqE2PTmcHMz1Fi5nOkzI9EG1ec9qF3Gb7Vpmr8pBRpMPI6QDyLcYv42z48M3lJ98IEzh7439lCh+NMRGPZ1aftGHJDw6C+pg5pII8O7e+vY1q7X900=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2019 16:28:22.1802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aaddee0-01f4-4644-43c9-08d6981998dd
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5605
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 10, 2019 at 02:06:38PM +0800, zhangyi (F) wrote:
> The jh pointer may be used uninitialized in the two cases below and the
> compiler complain about it when enabling JBUFFER_TRACE macro, fix them.
> 
> In file included from fs/jbd2/transaction.c:19:0:
> fs/jbd2/transaction.c: In function ‘jbd2_journal_get_undo_access’:
> ./include/linux/jbd2.h:1637:38: warning: ‘jh’ is used uninitialized in this function [-Wuninitialized]
>  #define JBUFFER_TRACE(jh, info) do { printk("%s: %d\n", __func__, jh->b_jcount);} while (0)
>                                       ^
> fs/jbd2/transaction.c:1219:23: note: ‘jh’ was declared here
>   struct journal_head *jh;
>                        ^
> In file included from fs/jbd2/transaction.c:19:0:
> fs/jbd2/transaction.c: In function ‘jbd2_journal_dirty_metadata’:
> ./include/linux/jbd2.h:1637:38: warning: ‘jh’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>  #define JBUFFER_TRACE(jh, info) do { printk("%s: %d\n", __func__, jh->b_jcount);} while (0)
>                                       ^
> fs/jbd2/transaction.c:1332:23: note: ‘jh’ was declared here
>   struct journal_head *jh;
>                        ^
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Cc: stable@vger.kernel.org

Thanks, applied.

					- Ted
