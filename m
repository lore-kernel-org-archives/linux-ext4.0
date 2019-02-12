Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AD2C282C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 04:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEC5221773
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 04:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="HcYWjtS4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfBLEdc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 23:33:32 -0500
Received: from mail-eopbgr710095.outbound.protection.outlook.com ([40.107.71.95]:38176
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727166AbfBLEdb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 23:33:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLLYiH9rfels9vMe4aarAw182iF4B51UIpOaVFpno2U=;
 b=HcYWjtS4r9WmoTIfLpkyhLrT5PRkt0E3+YEJ4y0PoaTqnA4z3DpkbocOgrmCr6z1Bs+0HlsIKkUf4ksGOOhXJZbc96+5A5lYx0vmg4spK7iOsnPz/4AkRdUdvJdBKp4YPVr4Q0QlshaDYhc+tx+ZOvtIi3EFvHj3Zt12tPq3qo4=
Received: from SN2PR01CA0009.prod.exchangelabs.com (2603:10b6:804:2::19) by
 BYAPR01MB3750.prod.exchangelabs.com (2603:10b6:a02:81::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Tue, 12 Feb 2019 04:33:28 +0000
Received: from CO1NAM03FT011.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::208) by SN2PR01CA0009.outlook.office365.com
 (2603:10b6:804:2::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.17 via Frontend
 Transport; Tue, 12 Feb 2019 04:33:27 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT011.mail.protection.outlook.com (10.152.80.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Tue, 12 Feb 2019 04:33:27 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1C4XPcZ013844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 23:33:26 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C79E57A4EAE; Mon, 11 Feb 2019 23:33:24 -0500 (EST)
Date:   Mon, 11 Feb 2019 23:33:24 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     <torvalds@linux-foundation.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Subject: [GIT PULL] ext4 fix for 5.0-rc7
Message-ID: <20190212043324.GA15822@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(136003)(346002)(2980300002)(189003)(199004)(33656002)(54906003)(58126008)(2616005)(126002)(246002)(316002)(36906005)(786003)(47776003)(476003)(6266002)(4744005)(486006)(26826003)(478600001)(88552002)(42186006)(16586007)(8936002)(6916009)(106002)(1076003)(2906002)(8676002)(305945005)(46406003)(97756001)(103686004)(2351001)(106466001)(23726003)(52956003)(336012)(90966002)(356004)(186003)(75432002)(86362001)(50466002)(36756003)(26005)(4326008)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB3750;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT011;1:U8vvw7bk9rNpX0nIMS74ozqWPkFBlaANy37wVVUHo6HNAtX/6H0JlibpUsSP0ylEJbz/h4Q5KkZIVV7sy12cVCQOoMHzC8N69Tfu/L0zBkBiZTF3ydB2jp91MeCYta4mwoiJHUDUhqkKimWTJTd6TApOAnZgUj9YyHlhkr73AA8=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f544cad-9ba3-45aa-3882-08d690a33bda
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:BYAPR01MB3750;
X-MS-TrafficTypeDiagnostic: BYAPR01MB3750:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB3750;20:LuzDEai4OupzWj22y5lYv4QBLPLsY6b1bY2uGHy+u+wUA5aVj3t41+QcSS76iVgdoMymxNrdKVsO42iZDCkD5TZI6JAvoI7tjamcXl21NI5bLA43hsRzSbZ3fg1KHQhiK1P6XkgOeeY620ZGMbW0ag5Ef1+YQK5DLnp2vYJmnZAbbyNJMwRBispNND3TlJVyyIGBcSUmh9JM93Xb7rx3BNtVD6CHjVsxfLzXp6L5T+mftjs9QWHXvyD9F7OYnC4d6DlREdWjedRhrS0Ta0hKt+wtDys1+3XhCExziszAy6l0bYs+HNxPfN4iQCSnW7E2Ki5atFmlXoAZRTOYDkE8Sk5pOBicF58tLOVHESqt/xrGYWnTxOxd0Vu/2n4iHeZCwFbNC+lE7Q4NrtI5Rw+I6zRFw/CFvkYRZT84cVhyKPg9MNWekrIk4U4PTkRbLCJe0NCSYC0Ru2C1+WSu8wnVzT8V28IZJLajzoYV7QzkAfdxYJnDHBHIUHMwCruzyiOvol/53VVP0tjWcGZnbhCR8knaaLW2SYhmSfZTxb52BB1MSEj5uPzN/CR+Jw4W0wY0bR3pgkK+pj0igfnsoul6T7pXtRzKw8mvP/QDmKMklK4=
X-Microsoft-Antispam-PRVS: <BYAPR01MB37504E3D9AF49D53F91822FAB5650@BYAPR01MB3750.prod.exchangelabs.com>
X-Forefront-PRVS: 0946DC87A1
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB3750;23:xVhWIM/jODq1yWkFNO7/7AVqpo4W0q0oX8g1rI6iy?=
 =?us-ascii?Q?4Y2v3zFsJaxD5Dfy+sq6dZqSey6gLeYfohEHB3wf172qSyxfu57kjt0mWiIg?=
 =?us-ascii?Q?89rA53lDI4MDXlaaF2KeLCM5d7aOJ6/dHJ7GKCxEZPQ4l3Qad0+RBwvAaqry?=
 =?us-ascii?Q?+BNZU4lk/YosPo6+8Sw+fzbj+29XeuG2MFUL53Epe/w5ykDoENNF5/A0sFCa?=
 =?us-ascii?Q?NJzOAi11XWsM3+t8z6Bpe7XngvBrW5W6sHRP1ERUfc7ZdoIIuqKUmksZLWsV?=
 =?us-ascii?Q?eQkhsdv1fbXlygnnIAA33+3noJ9NXD/W4cunAu3bmoXMwylpro7erG2QCtKS?=
 =?us-ascii?Q?TawlSQeLH8jBul16ZEurzuF2lWXKzA154DQouTfLrTqSOgf4huJuuBhAxtS6?=
 =?us-ascii?Q?9cCplmmE4zqPxe4aCms8dVI4Q4p4Q7wyMHMgR4O+4ONY1pWBRVbmWYv0AKP4?=
 =?us-ascii?Q?RjylC86+A0SmLnBwcYt2mhFX9yT0InTday6dQXwscRXGBc0u0ID6FdmoxJQT?=
 =?us-ascii?Q?l3Ba5Abcd7sPR1Vs4nE8389kUJAUnR/AhrbNg19XTaCst5SMJd+1Iu12+fFM?=
 =?us-ascii?Q?t/pCUKSYXFuU/sznOcCP3IL6Kp64ITlCUm8qAIY2bF5EK4Augz9sFqgOkhaG?=
 =?us-ascii?Q?Pht2BSutsnDm9yf4SsPuDo8rUgtdG+vJiH5lAyXKDCl+biRaPNVr+SizqGe5?=
 =?us-ascii?Q?wK/HBW1noF83cpqtcNG+STmgsB69pArJox7BdBQzVZ/DrmaLjSxRqT+hUYFA?=
 =?us-ascii?Q?4VVUV6X1Jl0xAfAavqvvR92ogpX730APV/bdmqzfoFzOAknKWJdMF54CzjOs?=
 =?us-ascii?Q?d892nlS4A3+/M1kg2NUsNLk6TMrny7xZhmnAYKdzGkmwDmMhE+C5ta/R0g5w?=
 =?us-ascii?Q?Ow4CDmVxIewH+YN6n9rO7fagsYX6Ia/XqrUeU9YEbqJvKz8inRkIxr1GPTb4?=
 =?us-ascii?Q?yZe6k7QMmjt/bcOezRFrdvKYca3aN4ppd6uAJkNyu85rN7ByIwjN4tULGksR?=
 =?us-ascii?Q?Z8jHAH99fb47f8IMdBTEKvnkGLXGyo9hU+Tmv6hJq4btuhSZYIUyK0FcxSvK?=
 =?us-ascii?Q?F86OqFwPxlmmvha7RuoGUBHVv55inozwsVXiEwZZpTYSe7IJp0HiBnz3jg9/?=
 =?us-ascii?Q?UvYF6x3z6mMfFhUYi07UzywN/O0sjoq?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: XHHLrqwMqLXpvfp9UiZrtitHWwK4EFzaL9+ThoLWfPXZNfoDwQBKLngFWWLVOlvFXqyJJq7O0uD0itSr25+SwF3RjvzDHYLtZVjKQPxzIHDNPhrIdRWo3x7iCaeiJUBYgDu/SeOChYnOCuu8rRBq1J1a8TX5uXq5N/FcHvBQb4p0ILUTGsjzC7SafLQ0ybMfQEireaw2mg2awJ0g9jJT0pYD026wMuO39tg8Bg0uVAJsKrw8C8cpGTmvpvsEo6/ViPdzygvgF5W1FFF5Cz+wuVA4VVdHFRomkkcMzGQ1OSeIXWwyMj34/65yfZ7AHCoGfmgCrqgV1q4ht7EhpfcJPiuDabde3Lq4O5lQgqeHvjpPmSOLptbABXOQ/LZ58wmKwAHHcc9WLmi+TFOHll0nmgZRW3v7S1Da7ubMj43bkO4=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2019 04:33:27.4431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f544cad-9ba3-45aa-3882-08d690a33bda
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB3750
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The following changes since commit 49a57857aeea06ca831043acbb0fa5e0f50602fd:

  Linux 5.0-rc3 (2019-01-21 13:14:44 +1300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 8fdd60f2ae3682caf2a7258626abc21eb4711892:

  Revert "ext4: use ext4_write_inode() when fsyncing w/o a journal" (2019-01-31 23:41:11 -0500)

----------------------------------------------------------------
Revert a commit which landed in v5.0-rc1 since it makes fsync in ext4
nojournal mode unsafe.

----------------------------------------------------------------
Theodore Ts'o (1):
      Revert "ext4: use ext4_write_inode() when fsyncing w/o a journal"

 fs/ext4/fsync.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)
