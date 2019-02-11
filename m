Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93FCC169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F9C82146F
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="oFrMt2yx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfBKEyh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 10 Feb 2019 23:54:37 -0500
Received: from mail-eopbgr750101.outbound.protection.outlook.com ([40.107.75.101]:1472
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726226AbfBKEyg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Feb 2019 23:54:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+95USOv04UibTfFfCvBUV08WG8GF7JUp42EYUTTo+w0=;
 b=oFrMt2yxzZtJYYz8/J+5pnuoiYk6ROGKxeH7SQC8BVt0YN3mfxjYNOuM2hb5DtIYlvaZKbU2G2DGGAfU2NEycEGxRmnEicjqmPNTFZZG9hD8IvE34TdzNfMLDXDgOhnEV8aSIks6TKLe2K1UoWDN8TfRJofYRT9ZWGmDtpni1mY=
Received: from DM5PR0102CA0016.prod.exchangelabs.com (2603:10b6:4:9c::29) by
 SN6PR01MB4496.prod.exchangelabs.com (2603:10b6:805:e1::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Mon, 11 Feb 2019 04:54:32 +0000
Received: from CO1NAM03FT007.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::202) by DM5PR0102CA0016.outlook.office365.com
 (2603:10b6:4:9c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.17 via Frontend
 Transport; Mon, 11 Feb 2019 04:54:32 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT007.mail.protection.outlook.com (10.152.80.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 04:54:31 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B4sT9g028466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Feb 2019 23:54:30 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A29127A4EA8; Sun, 10 Feb 2019 23:54:29 -0500 (EST)
Date:   Sun, 10 Feb 2019 23:54:29 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
CC:     <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: unlock unused_pages timely when doing writeback
Message-ID: <20190211045429.GI23000@mit.edu>
References: <20190129020531.1665-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190129020531.1665-1-xiaoguang.wang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(396003)(39860400002)(2980300002)(189003)(199004)(478600001)(246002)(33656002)(4744005)(90966002)(2906002)(26826003)(36756003)(1076003)(356004)(786003)(42186006)(316002)(88552002)(46406003)(229853002)(58126008)(16586007)(36906005)(106002)(6916009)(76176011)(126002)(186003)(26005)(8936002)(336012)(446003)(14444005)(52956003)(97756001)(103686004)(6266002)(6246003)(486006)(4326008)(8676002)(305945005)(23726003)(47776003)(2616005)(50466002)(75432002)(86362001)(476003)(106466001)(11346002)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB4496;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT007;1:2WglhRN4ZW+mnFNkcbKbX6Ry1suafD/WdbSDFojyH0dbykM3s7WKWi9MHCNCIHb5E2gIvRTC1lazA82vHbIwwfBaA2OkfHcJMFU0l7pu0mwnpBmFbhjU17ML8jW0ascgMbFUD/uiYZ75uv2/c2dUQWAUEzlhHGxNyyhgfHUgikg=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69ea3d2c-0d8f-438e-dbb4-08d68fdd0316
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN6PR01MB4496;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4496;3:LHoLZR4EZtk0lOivXd2DKb2krmGRjIoOZlMRi1Rsg8APDMQBVB6ggoIAwbFAqLB7GLr4VfQ1+Rqiwvse6uMhtaRJ7cn9M3lySRhFJtpQrzHDqdGoMrXW6q125+2Eb1zOZFFurk990XJuf/24PujfMO4p7Gp6Ia6SVAIpks8qlBvWTnyYUoW4AVMEX70rz/Ovo/gbL2s7wM+LAEPWPIwRT4hg7AA6B+Bx58SqnXhJ1Zm5QKpZ40E3XDiRmv0aFv81bYbr6bL+KXiSlAhX/A5bOuZflheMuAO02VA2HLR3Tk2NXt5/SJcl4l8126tkT/3KwIFG0RwgJNYfXAbOtyHzefmANc1IWKiUG8dioas4VfH3/w2L1NBiSBPochTh0zQo;25:eAX5htE1nhfmlQccdXjS6O7Z0tyO4nY3aMMZTuP/tyG7unXZqabw82dkXG5u8sE0VZO5cQhNlZ39i6EFmZkiEyUvNQBg6usx5d4shhGmd5fhbz+WfU9FyxcNijpBXR/sozgfXRmG/sZXewb6k7XgvMxQ9OdBjg3H7yiIc2iQCLgRhlHQ9J7+ifSkkIx/uHm7bX/uAYpE6OM9Fvk7AclDVmaLb8rgBLyZlstkLTrnbS30FpIuZXujdwEYxOI4DYUEN9+QukksYO6l+46FroDgDpcsSt0qTnBbp6c6DrcPDHxka3WojbZDrkv+FLXngC+Db9af0YFApWm3iYp5TNW6LA==
X-MS-TrafficTypeDiagnostic: SN6PR01MB4496:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4496;31:UHBT/weITRCfKQqBUqHtd5RHo6915IMlgVnSjU6kYZGAuGhFJkOeErZocuBJYWjtn19zNuhU7mhhlPQKV16mp4/w1NcBYZ8mW0yM0+FcMKnISoOGrT7M0eH2aM00YZIDusU8eX+royB6EJGofNbQhXoLOwL8nllU9mxkX0M9fIaK6N5Ce0uh9cWTXE1tQXxhVLociIUKUIjSMXLTWa3jSl2T9tak1aE7AwhCUECO5mQ=;20:Ymcy/uoENEdRxMsIrtFR915E7HAuQbOEBnAUtxo9sa0XU9KVkiqiPIX3mwBYfmcj/yPzdV+KD/EuBuuZwb6Trck2TT5O69/o02aI8Whhw9MZYN8JeFMs+qTlOZkqvZH+q8pYTAHVAiKk4ooShMARvjqtYcv3Q58OgOKpAz7O4DttWrSuNAGjMFYXa6ZVnaK8YhgeLxsp9Zk+sTZ7m3W3pAD84ysoCGQ7+QoVTIz5wx4exAbd4iN5ogecRhy4iJ3UI2+h9lKe79OG9sRSgMyKjFi/9e9N6V/I30ALQhuzenj+csdHTtMGR2/mJiXQTcaTzleknD9AtkFGeueCfw0q0eA8YDxVEKOrJwjof495fhG28MHGQmsQpqVp4AtQxyZSe6DiO40heYM06G3MA2+L2tFAipFk8WtQhCKPxSIPCY87M9M+CXKT2+K5brxt2VtzR7OluTvn1Lp8j/UEKq6jwFidigUtXNCd3fDugJxLGXM30/0sn8CHPqIO81BGf69D47Dlr/XbMu04rPmak7OxwEgJyZ30C1iiw2q8gVggm1FIxxxVN0E6+t3o87Kg89F9b//wYmczdB8nll5bUfCy462VktYP8Z5dSg20FT+XR+w=
X-Microsoft-Antispam-PRVS: <SN6PR01MB4496A05EDE37C3B6088192E0B5640@SN6PR01MB4496.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4496;4:TuEtdo9l92Hnh1Dj1gqXwkT2kwoPMSdjxfrHR1ihI6M3AhFiZ4LVelW/8zDTBXj7/I9RYumiKzCCQdIdV7NFfyg5Mk1MbtfdsNl5k1wVTILq214+tbAcWIl2xBEZ3WcLgLkVzscXAT4oPB5OdpqoSFs5lANm8C0tPw6In8EJlgFm6jgZWYWub/YNwXZHl19zXnQPt86z1vTlDHP5PikDe2UnAlKUl3nRyLNWgxnHprIrHCeBz+Iqh9dTAcJ9gBEE6Jd0gRzaRMUhdP+/AINEzXFWZ4pX0Ok7cTQb263bXls=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB4496;23:waRBeOUZf++cCs4EGTBZIMrRfNos1yMkCBZAoCYku?=
 =?us-ascii?Q?UgP8vbej6gvC2RewpjEpX8Tdx/cCrpfK12W7KoRpxaqgrNVDE1f3b/Srj+Km?=
 =?us-ascii?Q?28vTO+pPY7mg/pPxKDx2CfAuIFp135tnvqlW5F6+cZHm9TTth+PVz7XeZSPX?=
 =?us-ascii?Q?nM2Wfn6/JRXYLeJmcepTwolKXE+PWghwFzORkBM8D/9O8RheffUBpVy4GhPG?=
 =?us-ascii?Q?1g5Wbp4vzl7S475roDcUn/oBAzj3QSK24euEBKsNidCJKkJe8/OBCkPaT/rk?=
 =?us-ascii?Q?YXtTkm174j/4ylttobr4Pw8TbKG9YUT2fV2UUPGYfNmVv0QnjU8F03GsWGjt?=
 =?us-ascii?Q?JnOSmv/VuqhJwANXFBDu5kJitwyprlyb9mlD5O7Rbgp7Teql/uWqREnXGHr4?=
 =?us-ascii?Q?amoaCY/gQN42fU0lqfpjD1LRJI3EyFo09NBH00FUlmfKcXnwKFd/+LQZsqFW?=
 =?us-ascii?Q?5/RhesD+Pb9Nj7jB5x4AKT9nHH/U8XqRgBoQWL7PZl2oIeevmi/18J9RGuXs?=
 =?us-ascii?Q?GSlcCJPsEHo962m1k/EgCJ8jozNPknnl9lxaj5qAv9Bs9tZfHdJKldkpYvP/?=
 =?us-ascii?Q?swkljpt9hON+cXIaW/ce6mDGCD5BQi00N7JZzjnHeM94/+32qrlJsn2l7spL?=
 =?us-ascii?Q?OiWJOE+Mx2IwMkDDktnhYp/X+ZnMxMWHilzGtRBvG7ZZYrkFIxC30ojw9E95?=
 =?us-ascii?Q?AK4SMeALmR7XxKougjHcgmJ/wlrDFMIW5IiwyXGTFQEFckKd8tN8Eq+jhFlt?=
 =?us-ascii?Q?n6uT2GNqJddLfGHn0iHjX1Ze3lC0kSSEpcyLOWLCf7c6ZLvPnVI9pMrr5FpT?=
 =?us-ascii?Q?G04E5XKyf3E8FAcBcojvKx3FVs9vUIKuW8MbSqslaqLANFL6eUZ2ZN6kn86I?=
 =?us-ascii?Q?ig04qsZTinxp/rNaV0aYWEIsEGR3v2f0zc1Yil2uUt6zO1uAO1ggkRzOBWLe?=
 =?us-ascii?Q?4laokn/AfAS31dFqmfTNHArqNz50Fb1ODk5gVbe5rjXxjG4tO46H21ilGU0H?=
 =?us-ascii?Q?Phe624vtEHK7FgIZc1d7ohSObHGnZbJiEIZhpe1ey0T7g6icLTAVn+1WYf8h?=
 =?us-ascii?Q?2/M3JWAgENJIIA189SdyLH0unXVODtkS9lUepnEq997Cnxt2I14vODbayagI?=
 =?us-ascii?Q?l8mhftHs3TeLIke2WOaoXTxk3yeX7TlUwylVCbK8kcJj5K27jPUr2PaRjB54?=
 =?us-ascii?Q?VvCTBiz8rROCnOqltEPT1gjbqcSsN0le7q3wc/5QEY0x1jRwBYE1tgv6A=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: NwC39m5ez6wH6sNlEmYBGpI1qpegPiYN7X1k+91iwNMKG4eQ99S2WxBDWmi6xRizmerF+pcumWFYuWw5rOoas6iA7ro/xsKs7vvmEffjvMgNGhgboCxCNQfO6yFTReI92H5WKENUCYfM2249BRUurcn3XEeyWzqGpxgH1tca0hudlIOxL4wHALj6GRqisAfMJALwbvtXjR1gGFMlH0TN6wK7setgv8aH9shccsde277dtavphvv3T6U9536HluNXGidC+WAtRui1xYaArruPUCJlBCpNfVWzylLz5ceuLdifthkF37wEpAs6bPqGd6YAAat0hracmHrA5Dz0aNEjzFL4kMy2uQwJwYfWubYVri5sNcc99Jd01qrM6aTBSPhSe0Ddp8Hu3BZJ9fntE2quli6sTxGMZAipXgwO0eEHddA=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4496;6:Jr2s2+you96Clo/BJMb9JFOTVffv4CfUMoBFRV10yaDxqXWocvBQXoy5+P5UO1K3laaF8FnwjXIn1Cpf0yTMWeZfVYI7qpaD2ag1yMmy07gWqjyVp90MHizN8U9gnERoFnk7QtXYr2nh8tVr7I5iEwsFtbe3R1Zha544OJZmc9QTD4KhctNtMs1XNakBcFabPuXAzE21FaXOm8ej0oIIupCC8zM7nfm6bG2boHDC8GnXMHKrxsDPzfIR1qNHj9exp/NbiLjfFGNubf38yLOTMtIt72SmrSQVEpAIcxkv1PHMOpyuf65YY/HMWhBNecwbCI+d+tVbPnIeLF1AGqh8QNJWO8sKjvx/YXwG9C+444VkEZZqJYlKWAqyOxZK7vtYGAt26hJ8xch5cFhHPyEj+eYmN2FY4OYbBvos/vCA3/fdHTfXQ04qJvSfAXIcf1GHY2CJe7DRUkDmnJSuu/FfIw==;5:1cEe6RajdFG8Jt5nqWT+qpeTNXuqkgq12QowHnE5i1JKsgwW9uaf/bVqAkHUQbqpeLLuLAA8m1v3qdqOqN1e3I8qAPoS700ECigSW8PTo3UZ8YTzQF4zcxSgOmOIwXPBYcqARHyyjwl7vSgvhxeni4xYmE8N1EreuAp7jc/6+5w6uywY9rQQ6S0t/Gl3B0lGmZIMSpyS9AERpHrvUj04hw==;7:+SpzPpRZBOXuuK0tsWY2pPAMl6OZvtI4zOQ0kk30fmcXMRzGar0+q0jmFDN1v/WO+nzhQKThqCfPIZVm63xpZgfk9054yQgmAnFGaKjNRzlKeK9mhc1yP1QmRmIu8rH/pGMQtFE/YVfvQ3KaezA9Hg==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 04:54:31.8595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ea3d2c-0d8f-438e-dbb4-08d68fdd0316
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4496
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 29, 2019 at 10:05:31AM +0800, Xiaoguang Wang wrote:
> In mpage_add_bh_to_extent(), when accumulated extents length is greater
> than MAX_WRITEPAGES_EXTENT_LEN or buffer head's b_stat is not equal, we
> will not continue to search unmapped area for this page, but note this
> page is locked, and will only be unlocked in mpage_release_unused_pages()
> after ext4_io_submit, if io also is throttled by blk-throttle or similar
> io qos, we will hold this page locked for a while, it's unnecessary.
> 
> I think the best fix is to refactor mpage_add_bh_to_extent() to let it
> return some hints whether to unlock this page, but given that we will
> improve dioread_nolock later, we can let it done later, so currently
> the simple fix would just call mpage_release_unused_pages() before
> ext4_io_submit().
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

Thanks, applied.

					- Ted
