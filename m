Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEA5C282DA
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 18:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFCAA21B68
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 18:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="aiU7ztiW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbfBKSnn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 13:43:43 -0500
Received: from mail-eopbgr760123.outbound.protection.outlook.com ([40.107.76.123]:31921
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732117AbfBKSnn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 13:43:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsR8X91EcxndK2pdPwJXpFnGjgqht5j2H1ViQ78VHG8=;
 b=aiU7ztiWBo7j6FRGNLzeFLK6vDqeOUEX+HabxrKqtNyKf467n3Ic0kSWWw4wXmuZARiLom6CZUQJ6Ihqapj0QiZV/mz/4M13ul7T4N/wjO5lmG+9V6tlPq3kLEzjR1JReJbR8QgUiHOy/iG+Eq4I+cp46wtkYMduvS6dSlyxJP0=
Received: from BYAPR01CA0001.prod.exchangelabs.com (2603:10b6:a02:80::14) by
 SN6PR01MB3757.prod.exchangelabs.com (2603:10b6:805:17::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Mon, 11 Feb 2019 18:43:38 +0000
Received: from BY2NAM03FT028.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::205) by BYAPR01CA0001.outlook.office365.com
 (2603:10b6:a02:80::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.19 via Frontend
 Transport; Mon, 11 Feb 2019 18:43:38 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT028.mail.protection.outlook.com (10.152.84.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 18:43:37 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1BIhZGD011570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 13:43:36 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A1DDD7A4EA7; Mon, 11 Feb 2019 13:43:35 -0500 (EST)
Date:   Mon, 11 Feb 2019 13:43:35 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
CC:     <linux-ext4@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] ext4: Fix crash during online resizing
Message-ID: <20190211184335.GN23000@mit.edu>
References: <20190124162606.9686-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190124162606.9686-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(396003)(39860400002)(2980300002)(189003)(199004)(6266002)(50466002)(90966002)(76176011)(33656002)(486006)(23726003)(26005)(106002)(446003)(11346002)(336012)(6246003)(2616005)(47776003)(126002)(476003)(186003)(4326008)(6916009)(36756003)(2906002)(229853002)(52956003)(106466001)(8676002)(8936002)(46406003)(356004)(246002)(42186006)(26826003)(305945005)(86362001)(786003)(316002)(16586007)(36906005)(75432002)(97756001)(54906003)(478600001)(58126008)(1076003)(88552002)(103686004)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB3757;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT028;1:Wh6XxcrReHcB3PRB0xqzeXENGXGbA/MbuVzKzTS5i+5cxKrahtcaki97+JcpEPfzXI/IwITKuW837sSO+QYaOM6ViGU3CCO8nvn3NLZDob4YSoqsDnsxbCWaoLYakSgK9tGdL96zYrdATzR4fidYyTc4iUcFIy6lo53S7Z7xzos=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a381d7f-2be5-4cc9-2eb3-08d69050d62d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN6PR01MB3757;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3757;3:RO7NJfX6m4YL+yRgLrWUgYDkTcbrwi/jfrVY4pF5BeNTO/b6QQFBlWi7wrX1QZHua1JkSwr1DHFJQh+ykxhohwccuTGcRWWZH5KJP5dorTlCnAKs8g8Dg3ebeU8XmrPz0+4/p7f7iiYpH+cDq8K1k4FrgykJKjH5tziKIbgacAUQPo8mNYuRg65dSeitwFJglAOLLA9V3ZAl9+Ly0XirvJNyqUDQkifMWv9F14wMGyfI+eiLGspsZJ192CXIDpR6asC35CyWWr/0WusIxqVonAlf906tl5eyiKeaf7uti5LwjnFffcl/zZxC+ZhBkrrReRO8z3tjdY7d09phFzTO6lCSA+xkattvn0elWFeQytVMXuDkcsIBd15ONoNngBE3;25:1tc0Xezispx3+s5XsWFAX82MJekmp8Zc3IEoQNSEFDUivjkY3RYRFEvQKI5JC/1G8V3iaLD5yuGmQhhIEYmXjxqCSA9DagwLNoVoHr4t3QLtdxaCEg1y4uF4n1HR2377piJIzhHotMBRggPMw3Shp1tCEPbZ/W+oS9LdMQ3aUkRA2p6CDx6uTkd9fzvfdPneQRztF2l6R+/l/t++WrdGEaE97pFvqxbe5LjQRqBARvmttjCnXojvcDDwOhGmvKcOxC/BjeXNVlM+f3vNQ8QE9x+BIdQQp9mXu7cEGvcZSP3evPZ951AFCeIqPhIAGe+e02rtaTHtpvX4prZ4DhB5Tg==
X-MS-TrafficTypeDiagnostic: SN6PR01MB3757:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3757;31:0CX9nUe6K8AqfryuvCc1+uAsubS895gln4d3Migb2n/L+6VftK+wNw7yWtsCRN996aTp+UOVQMiGm+wDyUxzr7/9E76nn7eFaOZUhsLhptEm6afLZ1XhL/WVNh6FcvJkWjQddBoRyqONqVvZtnTYcQvXFrJNz8e/w4kCu/te9wk6T+ctH11ej8sn8RYcDbRvgiMAwPtQ8PXOcI2XMyjI/dkyxYvBHGLgBBulCZYPZ4o=;20:9FznxSJY6WGdo5Y8IdCzwKMMuMhX5ji515mMWSWB2U2oUSks8ty5tVZI8H5svgro7coUbOAwJOF0dOUEzIU8hzWlOWgh8z/JhSfMQbArh/j9smm7T1OGuhSeSCRWFVizeAx9nth/pRdQXfkN7M4Vp2SkuaSQn9Poy4ZGC4A0siNylAdj4Kp8zcWqtCyCVTpxxIzIADbAgwXCXSoxlpUthx7lcfPmXmTyJSeKCvs3IiP2sksnkKztNPdpWTiXo6p1iwPHGGyYjx/3QF7XDa/S6KUSRKywE22Vrw0wLtbik99Ux/YL40sY1QNOg402tNDNMNLGwv+dhT86lpkZ3QiFrVm55ItEKqpiW/kdvWSivrre68qaYeGYjWfwmk1C/rSV0EvL6w1lmx279ZENhhoVQgG1TaAFFzPVxLFUbfmbQTs2dijLPL445rfX47fNrYAdGT7lazWgcOLfs+ChJWb4OLrf8iJPmFkDp5wH074WNqAq4esS+kkAKEqumzjKc3MSBbI4z/kP+d6d9NMpIG9sDBH37cAyumXvEVJr3ai15GgSHxg5lEY/u4yO1qaOU4tqkbRPR1G10fME50LKdPnA2mNqKX6uiRiXm59tEg63Jt4=
X-Microsoft-Antispam-PRVS: <SN6PR01MB3757E69DAFC8FAB0FC85E3A8B5640@SN6PR01MB3757.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3757;4:Pfnhyq2cBHT8gnn6ekHglYHYRQp+UzGlMxpyYNCgjpvWI84vPEKybllKcoAPZ8RFwdJDYau1erbNxDcChQzymjSWqzUJqlytOZJBcKXX/EDnTgGKKIxII71uHG3OhkjZeDWcszKHXkZ6VU3PJQUCfosNqH9uI0sWR+6Rl2HIOj1VVKp9rQfqFN7u7i9J/6NBQebi9XsGeGvy1x+G9S0JVPPzlVFVvPxRv5dxz2byhRTnofsMeM7NihpiYv/rOA/1oU6mNt1ou8hZlXExQRpz1QQn+JTvTfSilRnCnOsLqsc=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB3757;23:Z/vur1qscbJdDvwjC3QUChMjND3Vh1M6vRjGqvUaN?=
 =?us-ascii?Q?gPl5dz5/y/Hgb4wq73cNboqTLwMzxg+/cNgMlOQS+KKg75RLJmpqpMEX/nTf?=
 =?us-ascii?Q?EgsmWlGQ8KDbsYwwqHM7vYkeUyfCsV0QTi2QUof8DtN46ebq2aSmwhIblBTp?=
 =?us-ascii?Q?fI+HmCepvIpH1Bmanesl/rry0tRvaRl4mo6WSi0xUpmdQdNbMzMAvBhO+FiT?=
 =?us-ascii?Q?3ob0wX77ND041vucPh6o7ht84EZnYys7PNzDzKI+LKEEJh1mAPSc1cmxz1hA?=
 =?us-ascii?Q?JWjtv6JTwKuDreYWyx730l01dRbJtMRMr61i7f0D/lw6UlsVcDwQydREd4qx?=
 =?us-ascii?Q?TcAuG1qJDMMFY/x+JCEnL/vyrwaG8f9pUQguel4lkd06Yo2kO4wKG4gzIkOL?=
 =?us-ascii?Q?6xt7rc+VDzviMKnL7Cg4LtCSNh+KCxnuiKP2B9POgLeKpiJhlk9OarlPRvFQ?=
 =?us-ascii?Q?84aZs68eTTC7BeVJgeRsIIemChagEP00OzNAgcvS1j3jKYV38oJGPWjRQVjP?=
 =?us-ascii?Q?u1LVVVxoaVBAMCQYbTPgGoNTO+V8srE1FmMEifytCPpN9KM0upRo7VDGuFWs?=
 =?us-ascii?Q?Hk1IQPvcNIhQ0tClcbz2IxmJCeNTuNYoThP1n2TZA/j5buKacKjAHLsMsZAv?=
 =?us-ascii?Q?z76KYiXXUmkn6FeAjOQyBmUqFgMidtTQWeZdXvAR05M2WKcIw7U4ksYMvVvW?=
 =?us-ascii?Q?Neg5NeOw4iqASYmvtOjroa4a5bgrnOjcezrQ6JZhiINSPDdMO96DxSNlr5VS?=
 =?us-ascii?Q?iOnWx1OV6HNxGSyX/hkDbC8HOKUYYYap51qrhU3PlEMhU7/rF0E5ZlKlMmCp?=
 =?us-ascii?Q?mbLCiw3JQ11Ob0OXbYCt2/6cJv1EtieTN63ZnPrYxxhFFu3Ai4dkP4uIybct?=
 =?us-ascii?Q?35FCSTrnlgPVq43+yx6CktDB7hvcVV3WQZA1wKM2XeH01lvV0lZi4/82UkFX?=
 =?us-ascii?Q?wZhQmNH8EDhB/cFOqme7Bo2USg+Vg+BAVWtoJOXHOAsKuHHa+/OqSaiQLp75?=
 =?us-ascii?Q?LQnF1A+rKgh+l5ptNqexNUlxlV1cvYIuAk7b1RYhqyvArJnoJYpcvLJHdAOp?=
 =?us-ascii?Q?kMeJDZptiamMQE5Oh76vEKT79p1A4JUOHtks63flwVDBNZ8feXsLODJ1ciN3?=
 =?us-ascii?Q?f+coC+xlLtLn0eExNG+O7lgpWQQI4OhFP6hIGbQyFw3Wba9Ko9bLdtBv+rQZ?=
 =?us-ascii?Q?P38X70reFmvRYxhRlO7AFuAPCPx11hfunRkQYHWJnCPr2T5zNUGO8Nhng=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: /3yGToBHfEZBrDEf5qtx40ZGe3edziD5xJUP40iDR1g74vBd2PyjtCPvE0nhSUaDUz04/E01/e/ZvN6z2/RErhIByoRwJsRmHTVQK9FgaGasQ+5eVJCs0YhdeDriKu72G5zQWedThYkL2iiYtxmPpoK3DyW0iFHClKF8cRF4CU8mym+kslgIX36QReRwAOGW6LxyhIkRICk/MbPKNPgII7Oj3/hcCgopiku1T2UIyAnQrFEXQtfOiObURnSTAhlSSXPzSLeaBfNLbH71QpP+5bavJ0s/VDDaNxdtNdDiGU9YexKhPZSudPuEZjCzCWINdm5LRIEHpt6wqsmfmLfzNJytIhMdWFC8Qaa9NxP6F3swATYUc6h/yD2XXGgNo2U8FdCwsay42a30mWLvfuTC9Vses7MkeZzxQFTJplrVX9A=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3757;6:+iNkaP11jXARbReZOaMzuX5zCUI72xqnJ91EMRzLiMBwrf3keq4DlyETKGqvxero3IFkeZawBgPbSVgF2EHtu0hT4RM/U8/6GKlSRqbIRWEsy6E1xdJ0I9efOPAF41rJ1FQRqzCBl6BVTUUZzhIR23eXLVxWHI0hzEiaFR/FePdenuYvEeUqUSLHMdudLqvtT3Occ81on76zX7ioU70KZ9AZiGkeaa2DAvUSdzvYwdJUmo0j+K/xkn1fi5ybCNStm0GuJo3xzyaZxHDeC7L+xb2H3BncPIIgV3uOOwDuS8Q07oAZ9FXJhxfC5lw9FfZFbNX5kq1nFddrRYqt7nYkXuG5LoPx1B+UHI68lAcXIk+18mJLHcC258hN8lGZacj0g6fFcL2sggMFoYDd0SZeZaZGIZ4/nP5hUEjrl5R62/dH3w/Ap3c1Cz9gsC3b42F1yPPNZw9ylvixFHSyyISUWw==;5:nXh06Ksk+tP50BIE7+UkmIdw5CDwIod1zyLw7ekjxTuzPOesXtJm4zrFoyAQNvhIspt21wO77xQHtyzItrwGL25jjduskR3Wz0FpXfVavFlwiKM+f49k5EGPD93ndnmb70XwNmG88Xgktlacgo84hgZX10va29u38XwHvzf89q9/62QP69JIpJA2CJt+KVrd8/QD+2QeGTzZP5oQgxX7PQ==;7:CVBrKj4ri4mgbjNxtO4Q8rrK8HJP6Dp1nGrcLFbd3Alt0158Hjm3iydQkkq1GUrcRNEdbqHgJpaSyw1dJ2diSZP8+LXluY19S7D6CouLtaGsWBPldG1HFU6aq+YK/YiIJmF5FDkBAoSuk6+I5KRXbA==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 18:43:37.9818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a381d7f-2be5-4cc9-2eb3-08d69050d62d
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB3757
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 24, 2019 at 05:26:06PM +0100, Jan Kara wrote:
> When computing maximum size of filesystem possible with given number of
> group descriptor blocks, we forget to include s_first_data_block into
> the number of blocks. Thus for filesystems with non-zero
> s_first_data_block it can happen that computed maximum filesystem size
> is actually lower than current filesystem size which confuses the code
> and eventually leads to a BUG_ON in ext4_alloc_group_tables() hitting on
> flex_gd->count == 0. The problem can be reproduced like:
> 
> truncate -s 100g /tmp/image
> mkfs.ext4 -b 1024 -E resize=262144 /tmp/image 32768
> mount -t ext4 -o loop /tmp/image /mnt
> resize2fs /dev/loop0 262145
> resize2fs /dev/loop0 300000
> 
> Fix the problem by properly including s_first_data_block into the
> computed number of filesystem blocks.
> 
> CC: stable@vger.kernel.org
> Fixes: 1c6bd7173d66 "ext4: convert file system to meta_bg if needed..."
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
