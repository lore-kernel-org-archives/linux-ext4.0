Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A8FC43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51AD52147A
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="tCT9eyns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfBTAoX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:44:23 -0500
Received: from mail-eopbgr820102.outbound.protection.outlook.com ([40.107.82.102]:20640
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbfBTAoX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Feb 2019 19:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiIO8uD+m/HNNVBMLDrWniHK3T8Ww45GEyBB+yS9RAY=;
 b=tCT9eynsN8QbJAyobvy3FIxrbT3QrBj/xTtpCAz7HHgIguxZLuJszdqYsxbk+1oC6D26M7oCXkqacAF9AFKdR9x5oMmGkkWpiGAiDemyNqF0vhC48L2hvx2nSH9QtzCkBbUn4Jd9Z5GC9zAEIEbPkOuJUZVaqHNvwVT78r1DuYw=
Received: from BYAPR01CA0012.prod.exchangelabs.com (2603:10b6:a02:80::25) by
 BYAPR01MB4854.prod.exchangelabs.com (2603:10b6:a03:91::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.19; Wed, 20 Feb 2019 00:44:20 +0000
Received: from CO1NAM03FT058.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::207) by BYAPR01CA0012.outlook.office365.com
 (2603:10b6:a02:80::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1643.14 via Frontend
 Transport; Wed, 20 Feb 2019 00:44:20 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT058.mail.protection.outlook.com (10.152.81.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Wed, 20 Feb 2019 00:44:20 +0000
Received: from callcc.thunk.org (guestnat-104-133-8-99.corp.google.com [104.133.8.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1K0iH9X028662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Feb 2019 19:44:18 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id EF7507A3F1D; Tue, 19 Feb 2019 19:44:16 -0500 (EST)
Date:   Tue, 19 Feb 2019 19:44:16 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "Richard W.M. Jones" <rjones@redhat.com>
CC:     <linux-ext4@vger.kernel.org>
Subject: Re: Create ext2 filesystem from a directory
Message-ID: <20190220004416.GA31238@mit.edu>
References: <20190219080333.GA2912@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190219080333.GA2912@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(376002)(346002)(2980300002)(189003)(199004)(1076003)(42186006)(316002)(26005)(16586007)(2906002)(305945005)(786003)(106002)(88552002)(52956003)(46406003)(446003)(4744005)(23726003)(356004)(76176011)(90966002)(75432002)(11346002)(58126008)(336012)(186003)(8676002)(476003)(8936002)(2616005)(246002)(126002)(229853002)(6266002)(486006)(86362001)(4326008)(97756001)(103686004)(50466002)(478600001)(106466001)(26826003)(36756003)(6916009)(33656002)(47776003)(5660300002)(6246003)(36906005)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB4854;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2178bd00-2af2-42e6-11ff-08d696cc8d3c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BYAPR01MB4854;
X-MS-TrafficTypeDiagnostic: BYAPR01MB4854:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4854;20:S5Vl4lylZZxHeiQdBXMthfYSswC+/lke9yml9qeu0QgORDV8igxYmCVkU9X6pczpZDi9+P+ZYMvGuvrICAiAzlc6V0ZCXh13ZbtEY8dKxDfTtzsax/ofaSI6DKN92zN7G5peVeMIRdwkESaZWVSNyr4RwBYs40pU98UEyrU9hUOr8rJt5ISreolKytkPWOGYvdNeMpnl96dKzS3GNJOkGnUXYsGSNlYNzsL84iqEuh7INyZbgZebHUp/xioJGUkan3W3fZVP8nE8WUO+hUaGCIAGh9D2oAqavN22WzpsQAcwiNjIw+eaoNxkDrKdJkPTCzN0UdJlIGLUEbitxjx3H2/7BsLwC+Dp2S1WSlhJ3nXcCj+V/QHD7fJHFbqz0nybK7yG102vrgVnFNFfK/Ysj+vqZSY8Ttbe2y4gfs+h6+QxNf+8ibstHsgpSrQGw+8RCe10n8i0p5o8pS7bPnpkW/lG9J7wIwOHBxQPHcxbj7j7YMulFnOi44qfwleZOwr4gsWKqd60jDJRkNTyS58YtKekTorzdlKK6MlIEFp1XQdxnnhBJAIDEKbl55720g+8MZNLEk8/QHbVDtxEqCeTGJsTpAe/RK34ynG73zsEMjM=
X-Microsoft-Antispam-PRVS: <BYAPR01MB48547B6E0FDD2195953796ACB57D0@BYAPR01MB4854.prod.exchangelabs.com>
X-Forefront-PRVS: 0954EE4910
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB4854;23:DMNIWus5nReW2/zh07MWEiB/0dsfyLXzyWkxkB/nU?=
 =?us-ascii?Q?lafU63g2CmwMIMGspd2TAtxNT4HLHx82LTkujc6tdAZGq9GlLrwfN8OgTC8p?=
 =?us-ascii?Q?is6k5NSMFr/9NLUKegRPOhOdaAnZmOBv+GR4j19bNNuNeQm0V7udicL/CFCA?=
 =?us-ascii?Q?k9u4bMKXuPwD1vw0D55s1CEo7jK1Lz2DPTfq8an8fBSJY8+vMZF5BnMNkXsD?=
 =?us-ascii?Q?da65mi9twdvRJAZycbhsMR0xT6uu385D8iuuYw8fPHqnYBTGOMfJqeBChfbc?=
 =?us-ascii?Q?nE9a5MZKwHplHKxlswyZb9tQIE9kBtooQqiAlzelRdu5jq9g4BMRRgY6tXTK?=
 =?us-ascii?Q?w8ltS+X3SdSpNSwOhG6giPCQbIQJH9T5rfN9l8XlfUp6sI78POxj5ArMMbIX?=
 =?us-ascii?Q?RRhcZ9MtS3OWuJT5PzUikJiq8E7Sih25VeYbtGGbIt4Y7PwrvmSoz4c9QAj4?=
 =?us-ascii?Q?Vx/PrlqHnS75CsBNfZPngK/Fqxokyp+E5lERx5lvohK+h2RmpXxeK7qHM2j1?=
 =?us-ascii?Q?Wn44NiQr+cqOwAuf2ffYp2N0sMPxHZlbjS0VBauKwDnemx2kzw7eN1c8kZrX?=
 =?us-ascii?Q?B1jFYKEjPt6bPyOEtxgYtc0QNE+Q12lKWS6scKQadrAomxwLYZX7Ou9rznVk?=
 =?us-ascii?Q?e295nwWXy0/jo9GxNwCyvuSZcd5lxFN8GQPF0IVan6/YEH8s417O9hEI9kfD?=
 =?us-ascii?Q?5MtDIJMQFLQ8G8AC+0194nORiAJzRiRhx/9kVFO7qd/hHGJtFVqLKUBhutGC?=
 =?us-ascii?Q?kF9XA6+r/18gOmXuKAxcWgjJqfFi1a580RrW7Vn1i+lyC+Mwj/UJPyaYA1p+?=
 =?us-ascii?Q?jJ9K3dQBw7nx0nDLHYc/gvdL7aHIREu4nnyN38kPsnJDfToJdbAL0M/G3E2Z?=
 =?us-ascii?Q?NFN83Zk78gtRXwUDgFw9x0Bt5gUQ8i/GWavCkLU06UhFmPTj7NPSLQzBp/yT?=
 =?us-ascii?Q?LZuaQHJQFCEyofCxWMBGOEmE9kiUagpMW127CTfmbaSVzw/hT3F/dgbh08jM?=
 =?us-ascii?Q?FnsV335QBL2VjCrbgISrksQcZLhAjOfoUUOtqKNhlJsrCcslVYOrWVGni7bG?=
 =?us-ascii?Q?dm4loPgo08AkEz8wOIEcdQBRNbgJh/oBIwUGzJRZIilFTs00iRQGhvTUKpd3?=
 =?us-ascii?Q?2iX7Oq9ouzvZTigmR55/Nh/Ir1wqySP+xj2F5FX6cfVDFYqTdz+QQVHP22ld?=
 =?us-ascii?Q?rq8V1Rut2b6TSD0k8zzF3oHjnW/sBFE1D9Oej2Kr8S7udOsQLf/UcNs0Uct9?=
 =?us-ascii?Q?bQ4yNktpZqhSZNLkec=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: q6kmZY8JdbBQAn9Z56yJYuflmjAA3JxtJQ/HQOLUZFlOawKOhk53NZdprYv3qGbNpxBs6tE6sTQPFkXSfp2M7nNUapr1vEtbOZQXF3x9Vn67YxSGAFiA+lH4LAtcRST6KQj4L7KJlijT37Clt+kKKbaTLVXKyKfGZmZ+WGgvWyd/bfdN7Ij0S5+clwaY6kssrxLpOWT0qjpM71h1ng5MdocAc8XCHJbM0Wy3fPz6K+1WE3cZ3M00MTp1zrZzPiucKSvz/Mr7E8Tmreqw3pPa7he3x7Vks/TUAZ/l8P/KAuidOQxRAVVjEnb10YA/4ydU2Bu3o/o2hAA6TuYRPIzl42Mw3c7pAjT1JatIus8JPFqWwRyL+PK1uK9NUaOvUt1GmM3ikzpYA6JW4LDv8sZGblx4DV/z9FusXQONsODLMTQ=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2019 00:44:20.3270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2178bd00-2af2-42e6-11ff-08d696cc8d3c
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4854
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 19, 2019 at 08:03:33AM +0000, Richard W.M. Jones wrote:
> 
> This might interest/disgust/shock/scare(?!) people on this list:
> 
> $ time ./nbdkit --filter=partition -U - linuxdisk . partition=1 --run 'qemu-img convert $nbd /var/tmp/ext2fs.img'
> 

For those of us who aren't really familiar with nbdkit, what does this do?

    	     	    	   	  	   		- Ted
