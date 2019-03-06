Return-Path: <SRS0=J2/x=RJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810BCC43381
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 16:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3884620663
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 16:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="HSaKv0/A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbfCFQs4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Mar 2019 11:48:56 -0500
Received: from mail-eopbgr750127.outbound.protection.outlook.com ([40.107.75.127]:9334
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726286AbfCFQs4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 Mar 2019 11:48:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJ2scKTx2xlrcC2GQoLNJBTN5wtZIA4DOnAVimmBbqo=;
 b=HSaKv0/A7b3jHSxlL2MvU9K+P1GnCeuniI3dZXwHium9nVE7qWvICrEDcIPlH3xJdAt5bdeS/VG+tqnwzrM/U9Mu/r3ZuDwq3YMcL4KGga+f9IVV6uJwWgfZT67rrw8ZV5ZPAT/YZnRMeQf2paGInkto0cL17w3KJgyHsvZXfsY=
Received: from DM5PR0101CA0034.prod.exchangelabs.com (2603:10b6:4:28::47) by
 DM6PR01MB4858.prod.exchangelabs.com (2603:10b6:5:6d::23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.19; Wed, 6 Mar 2019 16:48:48 +0000
Received: from BY2NAM03FT027.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::202) by DM5PR0101CA0034.outlook.office365.com
 (2603:10b6:4:28::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1686.16 via Frontend
 Transport; Wed, 6 Mar 2019 16:48:48 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT027.mail.protection.outlook.com (10.152.84.237) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Wed, 6 Mar 2019 16:48:48 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x26GmkBI030298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 6 Mar 2019 11:48:47 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 4007D7A3F4B; Wed,  6 Mar 2019 11:48:46 -0500 (EST)
Date:   Wed, 6 Mar 2019 11:48:46 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>
CC:     <linux-ext4@vger.kernel.org>, <adilger.kernel@dilger.ca>
Subject: Re: [PATCH v7 1/4] ext2fs: opening filesystem code refactoring
Message-ID: <20190306164846.GA3485@mit.edu>
References: <20190129175134.26652-1-c17828@cray.com>
 <20190129175134.26652-2-c17828@cray.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190129175134.26652-2-c17828@cray.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(376002)(396003)(346002)(136003)(2980300002)(189003)(199004)(42186006)(4326008)(76176011)(103686004)(2906002)(90966002)(88552002)(97756001)(26826003)(36756003)(8676002)(23726003)(50466002)(46406003)(786003)(33656002)(305945005)(246002)(16586007)(106002)(478600001)(6266002)(446003)(476003)(486006)(6246003)(58126008)(126002)(336012)(11346002)(2616005)(14444005)(75432002)(8936002)(1076003)(47776003)(36906005)(54906003)(316002)(356004)(229853002)(86362001)(5660300002)(186003)(106466001)(52956003)(26005)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB4858;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0acae9ab-6219-4a47-0998-08d6a2539b10
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:DM6PR01MB4858;
X-MS-TrafficTypeDiagnostic: DM6PR01MB4858:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4858;20:LIj4NmmnWttfC4xuygOf3kKdco+Llgo89GmghanA5StLr9ooPTyAYvRry4jrIW4dNctLMf6mciv9MNrpc2SM3xHY9CBNTE9tee7cInDjDrbYaDw1duAJ5/xpiFDlnw1aB026ReRXZkILEHRpK+BoLa8LnvVaagv2vxwO+CWvazzyXnt6FnSVMCc3xuKq9oGNZ/W6rMi5kffM1GU94j3GnHSYWEednHfJfaZ/DCMKy7C1VP1URzYR/uN7dQz7GyXLgXeoHqu3HaMzm+F1YO0jY3/U/SLIe/82NQ3e5xLpXJr6AwzzQj+ngXuOsohEDb7+fIPjWc3lR+MI5qF6XWaU53rGIMcIu0ki4dqopFkEfGA3Tp5Q9316DR5Y/QVtL3vZ3DsLwq+EYl5mKq0YN4zVu/Hro+P8qqOCOZQnp26tNAhTo19oRgFyGSZ3ZDGCBKPlsDPLZBfjPbgGWGWUVegdYZoEK6wCJYMyINefWlFHxykHmTs4GXFKETASLf7o68R5aKmUIZhDu1rMQzlNhfmCdpFOJgA1liw0sBYh9pirGOv+28b0PBv6PDYxzIrQ4h719ByYYuNWtNxCJ7bwxfSLuP6fnH3i8F/WKzIyU7LurMA=
X-Microsoft-Antispam-PRVS: <DM6PR01MB4858745A7CF5F71FD82484D1B5730@DM6PR01MB4858.prod.exchangelabs.com>
X-Forefront-PRVS: 0968D37274
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB4858;23:mwY5jXUh2WGhuC4u7P/nYUU9wnU0wdMyiugvXsCFO?=
 =?us-ascii?Q?E7S+2DUKJMHlpbo/W/8QzSwlE6e5l2WcaRpihaRe2HtKRTAISG5uWkc7EGLF?=
 =?us-ascii?Q?2il9wvODmPPJISlySF5ErEBGbMal/wf/0xjtdY4CPOX84ktU4T0H7eJ8Lbx3?=
 =?us-ascii?Q?UK0iDkE4RTg9cbW5SEvdQZRjdPD/VzUsJz3pd0lIhAQHWV4aaAHmEtiwYN7Z?=
 =?us-ascii?Q?1HRVzm9mWWKJIj2fMmo+n6lG1cv1LNOqKB5uA0hehvjFXdAl3Ug+2fKS6n5u?=
 =?us-ascii?Q?3rFqpZu9bnzKoswOTTObhzwRPPR1xwQ+frhDjh9Iu6HGjuwfvUnlj3lt8Vxa?=
 =?us-ascii?Q?g+e5ARVuy774eyFyxilNcbEEDunO4d3p6najg5wCFq7vSWnnN/5dXdiVDixh?=
 =?us-ascii?Q?NzI6K98R0tnDNU4v1xW1CCYaSxo2YmRjWr0xbztrXUP7Y1h6617TvcdoiQOd?=
 =?us-ascii?Q?WIXWW+VoUgX3R0VXnOQXFq/SncgdaY6Lh6JNVyDYbxu8sg0COJbsX8xGPVR/?=
 =?us-ascii?Q?zCGvDYUnVePutSoPZxkVcQ2+PlR9lauuDo7ajOmVKVTfcvQDgrHUmxfOeJs+?=
 =?us-ascii?Q?ba21KmGB4ugy8yEqHesjP4ivB92o/K+ddT/oYh/M6QeSpSnWiJCtXwD/rBCz?=
 =?us-ascii?Q?yQFR5OKzKACqG3oiUQyPJ/h9oh+YrJ2UP2x6xOn441hfvLxF04y7Wgn2dQDL?=
 =?us-ascii?Q?K82s212JLszsl3UykYVui7/pinqAE9CsTOePcmXekicv2CDHvsRRCs7JTw47?=
 =?us-ascii?Q?aqa/NvYg1+MWkbkk9oRgnFWV4GWXHRQXmHRZbPZbFqHvVMzFuCJjrb51WPRO?=
 =?us-ascii?Q?041I5n+QQAByHn7eLNLNFTVcem82WMm4hnyl20ub7I8EA8Pj6LoBMLj9G1hV?=
 =?us-ascii?Q?Rud6JSwAlVcLunfMAhPJFyLk0i4dc/1CSyt3JCTx82yJm7shn16TIEQa6lq1?=
 =?us-ascii?Q?b1BAhhW8dYIog95xjgTW3cuVN41h+Pom6DDbaXIu3JYdacNi2dBXYbbhDqKs?=
 =?us-ascii?Q?41H925xAzP886brMLNjzbFQVKVoIYGYtMT7UI95smi5r5lmz2jhBbMlGvh3F?=
 =?us-ascii?Q?zWLhetv4DEv/O/Ikwpx5NEwtePkc8953/UZf6jlRXdhJn2vZd9/vOhfDQR7Z?=
 =?us-ascii?Q?ie+Dha8VGM74PUO3ZLZMDvz9mTZcTXYAGRQC0kxUQWgysufeEWaGdUJNQeC1?=
 =?us-ascii?Q?3W17gLsIYPMnCSmsq1LQeeNZLBcaDCebuOgT2LoJBsR16WE5yLvFERr9A=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: naMQSb86jRc72dpiM6We4p7xrKsD4S+3eYVGvWwh8MpFyl45Cox9l2kc/L8SKm0VABHBc8iu5HDIFntcrVs2vAqme9whzCcYwB6J7cXe2FbtaD7yQIZrePel50ZhljhyvznPialjSvQNUKTSVgVaWmlQtEwWnemjPYT+rX7eQflvnd8uUp9RqZm3NmzjpfxL2Bgk4mLuClcR/TIrasvnKHIVBvf8puBd1fCxTTkQRvWycyc45KL89zxwQJEfb4NULXIuDSBU6ss2yb24uLR8SQU1SYYAkS5UKfj3oUAvS6WmfsDMV8qkoMwYTMjIZBONQ4AjygR/sbwIok9ET3bEIqWt8gPwXaabpihuytz4b33JL1UMpUx0bC48fHOPTVXKUxMYigETMIJjj3RHuR7LXbvPPXzGBl7NUWOxmOS4KzY=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2019 16:48:48.3956
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acae9ab-6219-4a47-0998-08d6a2539b10
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4858
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 29, 2019 at 08:51:31PM +0300, Artem Blagodarenko wrote:
> There are similar opening filesystem code in different utilities.
> 
> The patch moves improved handling from try_open_fs()
> into ext2fs_open(). This function make one of the action
> based on parameters:
> 1) open filesystem with given superblock, superblock size
> 2) open filesystem with given superblock, but try to
> find right block size

This changes the behavior of ext2fs_open() when the superblock and
blocksize parameters is zero.  Previously we read the primary
superblock at the known location, and a blocksize of zero means "don't
care" and so we just do the right thing.  With your patch, it's going
to loop for all possible block sizes, failing with
EXT2_ET_UNEXPECTED_BLOCK_SIZE, until we stumble on the correct file
system.  That's unfortunate, especially if the device is opened with
IO_FLAG_DIRECT_IO.

So the brute force searching should be done using if an explicit flag
is given.  Using a new flag to request this new behavior is safer, but
it's probably OK if we only do the blocksize search if the superblock
parameter is zero --- you'll note that's what the code you were
replacing in dumpe2fs and e2fsck was doing.

More generally, for this whole patch series, in the "happy case" where
the file system is fine, e2fsck and e2image should *not* do any extra
work.

						- Ted
