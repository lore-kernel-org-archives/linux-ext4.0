Return-Path: <SRS0=/gtt=RH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B0AC43381
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 22:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2A720823
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 22:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="ApxK1wlG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfCDWef (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Mar 2019 17:34:35 -0500
Received: from mail-eopbgr800134.outbound.protection.outlook.com ([40.107.80.134]:35415
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbfCDWee (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 4 Mar 2019 17:34:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLz3PZBwe9WsDE5XcoKC/b6Xp9hhdbL0J5iCVd/NDK0=;
 b=ApxK1wlGCcm9rr1g8bbxb8D+JNnKVhLtpCLyTOH84Kto5m8c3zaX9nrcOlLmnT7rwQJEC9cd9DyWzWSZtxMxZ4HiDr9IV/rimz7WByfSP2OetyH6NBRokMEZ7t6NM17BT89D8UtsT5E9Jj2U+tU2/dYFCtLGaJ8ytaWFAwkAIBQ=
Received: from MWHPR01CA0035.prod.exchangelabs.com (2603:10b6:300:101::21) by
 BL0PR01MB5170.prod.exchangelabs.com (2603:10b6:208:68::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.15; Mon, 4 Mar 2019 22:34:31 +0000
Received: from BY2NAM03FT045.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::208) by MWHPR01CA0035.outlook.office365.com
 (2603:10b6:300:101::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1665.16 via Frontend
 Transport; Mon, 4 Mar 2019 22:34:30 +0000
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT045.mail.protection.outlook.com (10.152.85.113) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Mon, 4 Mar 2019 22:34:29 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x24MYRH8022693
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 4 Mar 2019 17:34:28 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A84717A3F4A; Mon,  4 Mar 2019 17:34:27 -0500 (EST)
Date:   Mon, 4 Mar 2019 17:34:27 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jason Yan <yanaijie@huawei.com>
CC:     <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: remove useless ext4_pin_inode()
Message-ID: <20190304223427.GB6323@mit.edu>
References: <20190227022048.22887-1-yanaijie@huawei.com>
 <8ea5a72f-d339-450c-2604-49f730afa43b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8ea5a72f-d339-450c-2604-49f730afa43b@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(346002)(396003)(2980300002)(189003)(199004)(33656002)(246002)(47776003)(2906002)(23726003)(88552002)(54906003)(16586007)(316002)(42186006)(58126008)(786003)(36906005)(86362001)(97756001)(103686004)(4326008)(1076003)(106466001)(46406003)(305945005)(75432002)(8676002)(229853002)(6246003)(4744005)(6266002)(36756003)(26005)(90966002)(186003)(6346003)(50466002)(356004)(76176011)(5660300002)(486006)(6916009)(106002)(8936002)(478600001)(126002)(26826003)(11346002)(446003)(52956003)(14444005)(336012)(476003)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR01MB5170;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bdf2361-5b91-4511-fb0e-08d6a0f19128
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BL0PR01MB5170;
X-MS-TrafficTypeDiagnostic: BL0PR01MB5170:
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB5170;20:sPcFnrxVklpOG28VQqdD8k1uoMA6tRi8Gym3m5WYlOp6NCQEPWp2O+xnV+YObocc6u0pvQF1oFZ/9NWAusf15ZlHvGkpnDgW5EcGkO89SG8TBs4RuPWsDNLnyB/SQwpE8OY2j1xA2Qoo/NZIAwFZKZflG2tk++hiHFWHFSk3kKuJGrHW0V60D4eq/3qjdn7idXHvSnjluEhSnWp1dxklKB1/aud5uFzhH7wqfDxuT3WYjQ3CzTYhChS2fpjyz8JgbzqFaNDKyiVoXBk4pNHH/ptPqCKT64GoBBPTeuhCJyoxzAXgd2jThuaf1IepETYoOvL2GsgkPL60NfhIelwzrOvHmEWo95KP1256gDXPahiQ2sYl54kZS0VnV95O+RuRu0TjdbMS6onUP+gZHuiYQhZy1uWZaXKnnackLuhHIebnwrC3x+ZX65TP5EuGTYoG7jdgfnrE72FZ41hi+zXUJe7t1HrFpNeFa2szQj21D1HhLkI1kxJhEAKxBQPnzKNy7MgA1w6T/11mb5EIWk2bz/bg+eXcsB1h5oy+4c80E2xSA2Nf421QfJ+hgMxPeiiX+5CiEvE/O0bLJXWft2Rgyc1Lr4y9xR0Ru1HmVksg/5c=
X-Microsoft-Antispam-PRVS: <BL0PR01MB5170180F1AB83821834FB26FB5710@BL0PR01MB5170.prod.exchangelabs.com>
X-Forefront-PRVS: 09669DB681
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BL0PR01MB5170;23:d6jte6iwJ5zejAB/71GKnlrUb9PzO1qUtXPA0LUHr?=
 =?us-ascii?Q?7dNOLOtGlJ3YCy+o7cRI0eYSbt8jbT8la+9UaBJM7VFNSireWPjmjNnYkg2Y?=
 =?us-ascii?Q?D/Bjd8qb0/zdgrBZJB+9H5LOJPcQV+zsZCGMrgVpCWsV0rO4gbreQgoRZB/8?=
 =?us-ascii?Q?eKjwR5raDRYv+GJxWdho8t0tQ9/qUL/qm73ihywCaC4ObJVOFpML68HxpM8U?=
 =?us-ascii?Q?hwVoD7nHqeJkte7QVl2aFAX35VAAgrGOo/qVyHupRM5wIFypn5P07lxEo6jv?=
 =?us-ascii?Q?4rSCkswHmcCG9ROnsaKu70nf57pYLS5zLvHUEKhgY6v3bZzYJI0Wdg38hqGE?=
 =?us-ascii?Q?6zjHX7+sogrbWKq6r06XXFxlR4uTinvBBsllnxDp/mYw1hFZ3erEP5ikoTeT?=
 =?us-ascii?Q?FR4r3Hx3T7kBch1bxKJnpwKJI4IhKj6odGKKpj1NPqfRaBXz8tarjMnvdbiE?=
 =?us-ascii?Q?wZSjcvVKI5ecECUh22eYt0dXZDdFTfncrQYpF51M8sR4oA/gZPduqbyaeMP4?=
 =?us-ascii?Q?TZqUK9K3VJV2n5XWFISVAHu16Oua8L5XLGvZmRQjYPNavDv0rOo1flQIAkR9?=
 =?us-ascii?Q?fXyn7mAPRyaRC32RMhykGKFD6uxK42gnD8QOHtu4stthVsEunMPSpvjXKLBm?=
 =?us-ascii?Q?ThFXFVmETlpsqdW50LP26gHk1ljL12GgJTx/4ArF/DTeslV0vlFdAkPWz0mx?=
 =?us-ascii?Q?apEoPvj+KMt2HrPMfeKWsafspoF8j4amFm16q/Jz5EUeV3rTlAWEF38hx6IT?=
 =?us-ascii?Q?TpThUZak4IuHATy5986Vacb2rMDv/MouzWJGBDG+AFnXnnaITk3qdzaxsrQq?=
 =?us-ascii?Q?FPYPbei7G/lW4SjC9Op/pa53C6v/Fmz0e7MUShQv2ag4y8L42gSo+D+2LJnC?=
 =?us-ascii?Q?XX6AT6DF3jOwpmS/1j13+SC8H9dE0dh8vHeexQNYjwZd08MxZKqQH/0c+rhH?=
 =?us-ascii?Q?ok8whEe4trCpAPh5WOPz4M5DuI31zxF9Ybjjx70A0Xj6JssAumrd5aQS3L85?=
 =?us-ascii?Q?zf+vdXZWyFaybe+tEr8EHAkUDuJO1aePkxiNtBu24GtSYN7xLpHD9A3M5w1D?=
 =?us-ascii?Q?ZlkN1nx18jnicXAAtFC7cN1vCt1JqT7xCIR+NUjoGTghEkHnuY/jhGkT47GD?=
 =?us-ascii?Q?n5Zlm2DDQAnrIVSJX6kv96p7MS3/hZGodYmI0y4w0Va0k0tsgzof2Z8WPs3x?=
 =?us-ascii?Q?7WxwTtPXviAByt7B5dLgOy/paTN0Jtd0wpBLHCxeiAFIkP48+bFee0jcLVOV?=
 =?us-ascii?Q?anPSNsHgOd2qWeeUT0onO7IRTt/6ECwD8o0/paB?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: S4aNU5bqAB9WPA7g3xBNAXtO88Dfawn9GgkrI56kuG5diFGYuk2qvcFU7nS6z9jJyTeTUsd1WbJu4be9LoL5rLPqMew0R23bx7AH+YcHAxAJNsi/FZWdaWdw+o8GRcJGh0Tgr25ZWe2NAXi6pVnYQIliHeosIsjS0e/c3ubAEIQhf9G/kfOz/MEBONBzbOIbqUJ7ICPv6Jm44CV67KdVw4XQ3cHID0B+nwvQ1OYWIZ6O8sDT93J6/hjRVhRqrfXBJkLc1Y2THXilFhBJNnna3hyJFvKzx9A5KATiRt5FuaBix2nTzACdeDoxNa2WuqqaF58YoWJQ0ALwxkn7i4Sd0aaJg/V2lFWfVgLBbzPjty+GWcQ1DFpizA91eDZ/sORMvLEXCY+f0g5ArS7u0PcHbdG6kbtYFxfmqh6Z3I1BFXg=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2019 22:34:29.9405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bdf2361-5b91-4511-fb0e-08d6a0f19128
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB5170
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 04, 2019 at 09:31:06AM +0800, Jason Yan wrote:
> Friendly ping...
> 
> Anyone can help to review this patch?

It's just removing a function which is commented out.  So it wasn't
high priority for me to try to get it in this close to the merge
window, sorry.

It is being tracked in the ext4 patchwork site and I haven't forgotten
about it.

Cheers,

					- Ted
