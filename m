Return-Path: <SRS0=GcgC=RC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEECC4360F
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 21:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A01921850
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 21:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="AXU1YBO+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfB0V6K (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Feb 2019 16:58:10 -0500
Received: from mail-eopbgr690126.outbound.protection.outlook.com ([40.107.69.126]:47904
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfB0V6J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 27 Feb 2019 16:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4EM0UJHRuKQY4xmEEAqxWGyKbCIH7PYPJlfbQP7c4w=;
 b=AXU1YBO+kfMM2B6Wc/IjMmpCvjV0k8rmVLWZJrMfdJQSGGf8UUyFBlwfiqUPUQF7yWYJmG6lZUQDqG2ARHPvfQbSnVY0ig8nK7fd+ZuuvsqiZ/xBUi1P5kwZ2oBTcnfj2KqSkekbPwzJE9kNE9Z99d5tDO2pm+ecxSbAFZsgj5c=
Received: from SN2PR01CA0063.prod.exchangelabs.com (2603:10b6:800::31) by
 BYAPR01MB3992.prod.exchangelabs.com (2603:10b6:a02:92::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.16; Wed, 27 Feb 2019 21:58:01 +0000
Received: from CO1NAM03FT041.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::200) by SN2PR01CA0063.outlook.office365.com
 (2603:10b6:800::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1622.19 via Frontend
 Transport; Wed, 27 Feb 2019 21:58:01 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT041.mail.protection.outlook.com (10.152.81.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Wed, 27 Feb 2019 21:58:00 +0000
Received: from callcc.thunk.org (63-138-96-2.customer.static.ip.paetec.net [63.138.96.2] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1RLvtGv021960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Feb 2019 16:57:56 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9C6317A2F1E; Wed, 27 Feb 2019 16:57:55 -0500 (EST)
Date:   Wed, 27 Feb 2019 16:57:55 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Dmitry Vyukov <dvyukov@google.com>
CC:     syzbot <syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: INFO: rcu detected stall in ext4_file_write_iter
Message-ID: <20190227215755.GD10828@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+7d19c5fe6a3f1161abb7@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
References: <0000000000009a01370582c6772a@google.com>
 <20190226151738.GA6430@mit.edu>
 <CACT4Y+acnJnZ4rN3Ta-6ftFv4A=1q7hsVQSVJeh9PGCK0e4BbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACT4Y+acnJnZ4rN3Ta-6ftFv4A=1q7hsVQSVJeh9PGCK0e4BbA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(39860400002)(396003)(2980300002)(189003)(199004)(76176011)(75432002)(5660300002)(1076003)(36906005)(356004)(2616005)(486006)(86362001)(476003)(6246003)(52956003)(336012)(786003)(186003)(16586007)(97756001)(316002)(106002)(54906003)(5024004)(58126008)(6916009)(6306002)(103686004)(126002)(42186006)(88552002)(446003)(966005)(11346002)(2906002)(26826003)(478600001)(47776003)(26005)(33656002)(229853002)(106466001)(7416002)(305945005)(246002)(46406003)(6266002)(8936002)(36756003)(8676002)(50466002)(23726003)(90966002)(4326008)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB3992;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c921569-5595-4a3c-12b2-08d69cfea447
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BYAPR01MB3992;
X-MS-TrafficTypeDiagnostic: BYAPR01MB3992:
X-MS-Exchange-PUrlCount: 2
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB3992;20:GldSl0Ejvi50wXc5GzoLb/KAXiasmB2f5R5FShmOIiYmQ7cnpOXJOVViBcVWRpoKUlVmnD0D3ylRbdhaFPpLsNTP+cVCO/xB1DFbXIquIENsPoCPmGkFuivezKc0a1xFpfVMYstzBRb8a0d/2cYtYsPhqmhhUX1p8d0G1favEio9JnLsO8DA1rSDKrTXshGXMHLIs+d002fqlhqN+p1cJyekcpQsDys6UyotbWQA5ul4GGMsFJ5sVuSMrkdl8vRFWjT7OIEXQvaE/QZZhz4U4Go9ROBv2ZHDqVaezk+3JeEYcTlmXLTisEy0uI9W+TKk0hI0lUgMVkeO3g9vw0qF89gJMZxwbQDLvg4n9fte78jlzvQw3j++FJXgcDh1GEblmrLjGQJEb6jVQRJE6mLE7h1KC6mLxyyTTYQH22HULWZnX3pcDDSsOIRfyvNbsmfvaps9K8yCFNIYS+noRqh6RCjoUkhF6UAPj07Mbko4hR1udVbDuM/6NeP3GvXGNeC3kwswZkC+VqLdMXO4pzODrOl5ONEdgxEdngN0sgg1mXEG7EjekiwXYe2T90T+F2VViHLiHQJHiFaKynHlAz/uPdqGEhXuzxCOzDFxXlISONs=
X-Microsoft-Antispam-PRVS: <BYAPR01MB399283C71B7A33522168C250B5740@BYAPR01MB3992.prod.exchangelabs.com>
X-Forefront-PRVS: 0961DF5286
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB3992;23:vaLqyixX2/2jd2smVhyehjNrEdyp3dmZfkoYyfDKK?=
 =?us-ascii?Q?ubbTby1MI+uKqn9zIB6km3JmujiIqzixMJgXgZb5Ofm2L9+u4jczA/E6zSn4?=
 =?us-ascii?Q?9bf2P4ZUWGJ88XMVwEeSZJw7yb0vFeyEfIOZR9jg3/Mn4OfQQKauCbHf1Jzv?=
 =?us-ascii?Q?zpnQp7pxt/E3oocVfxSATqCi/b9ISlN47ihsItk6jqRoNVREP9rJqvv952D6?=
 =?us-ascii?Q?Dc5lohBDHJBrZbP5gT1QOD4SZBchaBFA6qgKkgzUVGWI8zE/gYwr0j9kaIAS?=
 =?us-ascii?Q?pPLzrF8z29ppE08i74ktHmvAFxrssnopRwXA/wu2C1VRF9DVZ1B2zLOhyPYl?=
 =?us-ascii?Q?5u/kvsrUYKU6usMYEOaZxmcNO/Q1Apf052pulIA8iY1O6KP+0B2QVIwnaZ48?=
 =?us-ascii?Q?4DyG6B6CmsjAaQjnUNBvxU6uDbVxpGu/3dn9Xm+BVKbEGMJA/GmhuFiTURb/?=
 =?us-ascii?Q?NMlcY42VdmIK7gXpTbovtzUzarDW1KoT+FaS2row+y24cU1GI0dyBgX38Xn0?=
 =?us-ascii?Q?xHUFIq1HhQYMfSSGWnIwKDulHeKAEPfuJ3Z0PYVjebNCLT031AN9khTj+mxd?=
 =?us-ascii?Q?fycp/NKHYajjIUmwwdOfAqJ8dYTJGhfV0yyhfEPsrbJtfKdb+bXcOUbTmN2r?=
 =?us-ascii?Q?aXk7JWL9VsOAg+pbawmcPWER7HU0FWZd0M2xHFYnAyavNhnKG8i4qu+v/kED?=
 =?us-ascii?Q?zZRGEblerJ1kOXNhmNMa6H1qoix4KG5nZfXliXM1TmfSXzSH7ZXblOOYI/Nh?=
 =?us-ascii?Q?jxHaZkCJF6Wa47mkRmRIqt+7LGiW2uRC9ClbkrSrFBXrsTgg38d1JhXj1YkM?=
 =?us-ascii?Q?114OlE3rhakfp5he3BS+gZdYlJ0rfcVdjLD3zFA1UaEALxify6tGY3fyG3YF?=
 =?us-ascii?Q?o1JkNGTeqElBrxRi9+sbnkAR4JtIgXEIog+eFYhZvtLQeBwwfHaBJh0LZHJZ?=
 =?us-ascii?Q?N0KdV7gA70uopiJvwseM7N/wmGFPEJ5PDvtdtc0tDyhVPrJrUWl/k8aLzNXf?=
 =?us-ascii?Q?DIO4ZO02p0RYXpXBAkwMhuB8s43GA/w1+b4t4cuBs3URTtsiRyfVEp1V/WZu?=
 =?us-ascii?Q?enRaA23PZAsKQF9zjbRsbmnZS5L3Yzg3xIhjJWGxq0fx13UIBoXTHkpzYof9?=
 =?us-ascii?Q?6+okld8JuqXY6PMz82TSl7T38tEgSHY6SltyjvcSiJKyVAF8pOhurtalc6sQ?=
 =?us-ascii?Q?hVorIjL2buRXPjs4SdmfAwWp3uNl/JVju5ZyOwDPO9f9w6Cgl/NQvT6MYWhR?=
 =?us-ascii?Q?gKDN4nSHS/pL1mxDnmFU5IJAyM7JqVUFzIqsFlfSCoFLTnkPdftnasyB8Yt4?=
 =?us-ascii?Q?ksePjt8VFpXZpA5YsgBCdygoqXnXjQlm2QBV3F5Awfe?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 4d9qye68WeX5bTqiItN2GNEoBPkzfbGyav3vdHQVFGvjQo267ioV0+qAowJhHXQYPg8u4mTVblap7j2QUBxaJP2C3mIxBSkfjdbC73tO5wRRqLJxxEev60TqY2YB6mFbr3GwfyEuxabVpAQUReOC9nSvJOd4AJg5l+XZt5zztge3BkKEgDYh2otpfD94n5kIbhx43Ljh2wDKHohnqPAwjAmrWMXDR9iZXlV4Y+qhDpJ4JsCuQe1McMdtbfhwXNst7PZVwZy7Su5fSxHokGeMl4oBqt1KJLK2Jnt3lWP6DafX3RkGVi08DyDDzYo4Mh/Z8+r7WxnvjIQLJzUDAG0qsORwR/k1tJ/FMKlwI4WlHiYukqHk9KQvaV6FtUOhRkpXNM2tp9JMoH9VSzhc+i6yne6kH6HJ9N6hEXKQ2UW9BlY=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2019 21:58:00.6257
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c921569-5595-4a3c-12b2-08d69cfea447
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB3992
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Feb 27, 2019 at 10:58:50AM +0100, Dmitry Vyukov wrote:
> Peter, Ingo, do you have any updates on the
> perf_event_open/sched_setattr stalls? This bug cause assorted hangs
> throughout kernel and so is nasty.
> 
> syzkaller tries to remove all syscalls from reproducers one-by-one.
> Somehow without sched_setattr the hang did not reproduce (a bunch of
> repros have perf_event_open+sched_setattr so somehow they seem to be
> related)

FWIW, at least for me, the repro.c with sched_setattr commented out
(see the repro.c attached to a message[1] earlier in the thread) it
was reproducing reliably on a 2 CPU, 2 GB memory KVM using the
ext4.git tree (dev branch, 5.0-rc3 plus ext4 commits for the next
merge window) using a Debian stable-based VM[2].

[1] https://groups.google.com/d/msg/syzkaller-bugs/ByPpM3WZw1s/li7SsaEyAgAJ
[2] https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/root_fs.img.amd64

> But even with perfect repros machines still won't be
> able to tell in all cases that even though the hang happened in ext4
> code, the root cause is actually another scheduler-related system
> call. So thanks for looking into this.

To be clear, there was *not* a scheduler-related system call in the
repro.c I was playing with (see [2]); just perf_event_open(2) and
sendfile(2).

Cheers,

	      	      	    	 		    	- Ted
