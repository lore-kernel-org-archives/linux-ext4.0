Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9F5C00319
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4734E2083E
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="NzoKgBx2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfBUQxq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:53:46 -0500
Received: from mail-eopbgr740094.outbound.protection.outlook.com ([40.107.74.94]:42100
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbfBUQxq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 11:53:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2Enxdy59JSiVqo6PIsrnJvqw/asAJBx4rU/50I9Uhs=;
 b=NzoKgBx22vIqixWFnYVIA57cdN70oQONOp0diHwRCuWGgMqbjkRyiokI0DsDMAO8G8vcv95205c04Eb4UU2VgroGKGdlcEM8G4/EgeMynlBP+gCUIPKKcW0BbDRP6VYkNNq3wsB8FiO7/dp+Lb6xIBVPzqeFS7U3vQip+ATXNYQ=
Received: from CY4PR0101CA0025.prod.exchangelabs.com (2603:10b6:910:3c::38) by
 BYAPR01MB3990.prod.exchangelabs.com (2603:10b6:a02:92::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.16; Thu, 21 Feb 2019 16:53:03 +0000
Received: from DM3NAM03FT021.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::204) by CY4PR0101CA0025.outlook.office365.com
 (2603:10b6:910:3c::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1643.15 via Frontend
 Transport; Thu, 21 Feb 2019 16:53:03 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; yandex-team.ru; dkim=none (message not signed)
 header.d=none;yandex-team.ru; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT021.mail.protection.outlook.com (10.152.82.187) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Thu, 21 Feb 2019 16:53:01 +0000
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1LGqxaV018348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Feb 2019 11:53:00 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A37737A3F9E; Thu, 21 Feb 2019 11:52:58 -0500 (EST)
Date:   Thu, 21 Feb 2019 11:52:58 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
CC:     <linux-fsdevel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: add sysfs attr /sys/fs/ext4/<disk>/journal_task
Message-ID: <20190221165258.GE10245@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        linux-fsdevel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <154927546304.133377.2385004506198637025.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <154927546304.133377.2385004506198637025.stgit@buzz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(39860400002)(396003)(2980300002)(189003)(199004)(8676002)(46406003)(11346002)(126002)(106466001)(8936002)(2616005)(97756001)(305945005)(50466002)(476003)(246002)(88552002)(33656002)(356004)(76176011)(26826003)(478600001)(486006)(2906002)(75432002)(23726003)(47776003)(336012)(4744005)(90966002)(106002)(26005)(186003)(4326008)(16586007)(42186006)(316002)(786003)(36756003)(58126008)(36906005)(14444005)(6266002)(6246003)(54906003)(5660300002)(6916009)(229853002)(103686004)(52956003)(86362001)(1076003)(446003)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB3990;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c069155-0b48-4e73-04ba-08d6981d0ae9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4608103)(4709054)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:BYAPR01MB3990;
X-MS-TrafficTypeDiagnostic: BYAPR01MB3990:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB3990;20:diXLxfhqCPT4qf5ZK/KehGZqooPdapFvSZL6/EQ1BjtEVbjuoZImXHL5GvMfWilFSOImDcqYjJvYMa5yj9UPyYV/C96ZcfMLEw632Cxekn9pP8mWjj2iVP0zPA52lLVil/dhHfUN7TCq84RDb5Uuo/CYhqSxSVZVdhdb5V2rMwcYBxiC31ne3W6G8qKZ3M3O9y4PNRz7T2LBP8UGfgtbuT+7brBgG8LrT2/q5HRorXDws4bE6vM9u9Eki+wjO379zEbUVKRYAew8TSN73dlcTQQSrzszqUJh9pSb6Iop8JnQJPSs8wkuECwjEgDhFhbs14C0kiafE23+pMReqc6HJIqhN5WVSXY0IVXRca3tMCXg1EYHcaM9oc6RPu4bmkwAVDqqqdnNAQ+5a2myntrmadZ9SX/wVnCo6CwhBJniC2+ohOJQiXxD1abnRQ62R22bhWQGJyfbLlF3z2XKSyYaOW/B1murkh2IUZMFNrwWh6x022rfMMxhbPKs/FYB8uElQLACXgEOPE00RVdF+EMFCMbMRhmRFtCU8PctXx0GgKhGXlyRYQTZDX94oskilL0qmB5Y4AxKATu+aHRIrJN7DNEW8pZYAHFSAKm7eyLnmaw=
X-Microsoft-Antispam-PRVS: <BYAPR01MB3990969F0B8EB8D529EBFE3AB57E0@BYAPR01MB3990.prod.exchangelabs.com>
X-Forefront-PRVS: 09555FB1AD
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB3990;23:lBpZd27Vz1r+72dFCfPN5A/4tspnucTOwDNWD0w/P?=
 =?us-ascii?Q?cZerQe76651vqsVD2aDk6xDKO07BMldbHOX2wsHsPZggUCx7pYErHCgsUZU7?=
 =?us-ascii?Q?OZpzDhkYGtMBMnxMroNxFaAS4h5T0UpKvq8o8b2byek6Y9d1MKGAvFJxCmyt?=
 =?us-ascii?Q?omamwrQtPYlRG63vH8EWeG1459W/nKpsjEn22TA7PvhCeM09nz1UmCk3qbZ8?=
 =?us-ascii?Q?pQRl0rUHzxz8A0woAhjpC7wqqS6knRV5G14MMWH5gYOJjYqUQfodu+Et6u8P?=
 =?us-ascii?Q?Lo+3TVJlPgflBzTE80gVzIA0e/Cee3ZaZs/G3RyuSkXwfCbVPncaRryJ23Nf?=
 =?us-ascii?Q?dgi/2PHA3fergjost+il8zHREL37pIv9b9aowL0ND/ImtJnewXn/f3Dgub01?=
 =?us-ascii?Q?jxt0kp5ch0uGTvIlOTJzRhBH1YrV3Q+11QKMQ9Ny3m87meNj44gPTxFy8Yxf?=
 =?us-ascii?Q?7qyQPpicsZAdWZKmk1VubaSQfQBnDEi9G7oLqbXYjMc4wowPDFxzsUd+Efbx?=
 =?us-ascii?Q?uE1TF5TXGVvK4pZMHSsoVG/5a+Hq0fgRZjcj5yVmbLf0d/rQnCg82isKRflK?=
 =?us-ascii?Q?9GcGn42M8IMkM3D+wYGAgj062SF0/MITCr7gCwi8pl6uwbQmcDqDibTH8vbB?=
 =?us-ascii?Q?DJ7HkoSKZoaPXZ87cnSfmYolkdpGTR0ZGQD6o4WOk1nxaoHCYmJA4ZIeB5Ox?=
 =?us-ascii?Q?1q/T5UTqch1PT6ttp0WzU6sQSRbyAFy+GrT/1l4uScLiudaQegUiZg2EuoZi?=
 =?us-ascii?Q?5Pe1GZ6bwZzzQdya0753JB1ttKPS3/iLQbD7j3SYJT+xovFOK7Uxo03ocEEA?=
 =?us-ascii?Q?kFsW0O1Pl/JfmLOqQg6QVuzQs5WJXx/Ma/dAD7WkfOwFVyiBbqoLbz2f9e/i?=
 =?us-ascii?Q?1IYY5YDudiC/WsInYEMZncsBuTSUwA7kB1xXeNOMHXugrSsOq2daRAluAJaz?=
 =?us-ascii?Q?2HfCohfq4yh3sQYVlucnalmqENkXqidRx+wFe8nSgaIs+SnWOm/+FKbP2STC?=
 =?us-ascii?Q?HktyTvYZo1i8ei9UfGPywZDFgh6UbfcP72hM4gVlYflN8BGTti+X+oD1rmCb?=
 =?us-ascii?Q?g/BuqGCkndthP++inGcybjhR3NhkWDEdKWZ0hw26GzLyy19DLNnTOQAR+H8v?=
 =?us-ascii?Q?lulEMFtgoRYMxVj5xN6MKXOM9w3jX5gA6BPLnbtsZ6z5oCVr3B1ewAOy9cGg?=
 =?us-ascii?Q?/HysR4459Z2LOWC3XzDvOVUWH3lcqavHbaeRVm41ycbdrs4BPooqqE+QLEiH?=
 =?us-ascii?Q?EKPShECj/X0lvJ99PQhOpM27KpIzNUO5js3UnkRKjDtr3tRnSiIK372WCq75?=
 =?us-ascii?B?dz09?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: /Sbbeo4Tq/VltLE42fy7cz0yeaqbgefiLZq1B/BgavnRqPyoSpAPqr9crqPC5ppN1hnUJ4Rx/aG39WT33EWu3V30Lr8Oolr71cGxDt+K+uQ52fRtBW01q9XvESjwzmpXE3O5RhX8gxBPXzjGfKPfZcZF1csfN1WvjLoGfUqHHTBqyAWjYNjvDiQ2ICoauOT3GEvxES245K6OFvOvhRC7cvzSM3aJ+iw4bXo3FLPBoK8LCQ2VURT5hkjO2mqwT1OBr/jg+Uy0bvF1EePum6tx8mI8xYIbkjiirSRgM1JJ8XXlt2qNfMGQRy1tIjgZmBFF8ZwuuTHtNKAh+++dsQ8UczbMDRNZnc3dab2XLFrJYPy+7rkZE/XCHCmxP796vNhgyyLNtojlD+2EhkCKCcw9BNQnukLcfGb1D+B79OtO6Ys=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2019 16:53:01.8786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c069155-0b48-4e73-04ba-08d6981d0ae9
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB3990
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 04, 2019 at 01:17:43PM +0300, Konstantin Khlebnikov wrote:
> This is useful for moving journal thread into cgroup or
> for tracing it with ftrace/perf/blktrace.
> 
> For now the only way is `pgrep jbd2/$DISK` but this is not reliable:
> name may be longer than "comm" limit and any task could mock it.
> 
> Attribute shows pid in current pid-namespace or 0 if task is unreachable.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Thanks, applied with one change; if the file system does not have a
journal, reading the /sys/fs/ext4/<disk>/journal_task will return
"<none>" instead of returning a ESRCH error.

	 	    	      	      - Ted
