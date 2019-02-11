Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE031C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AC2620873
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:24:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="qL9cniFe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfBKEYm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 10 Feb 2019 23:24:42 -0500
Received: from mail-eopbgr780118.outbound.protection.outlook.com ([40.107.78.118]:60896
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726177AbfBKEYm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Feb 2019 23:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=517QwDak/a8E9xmYvJFvEKKiIbW5xniR/7jK3svF4Uc=;
 b=qL9cniFepiv3dRNs4Vy+ST+F8FwYVTBbxFAX07oZ7n/E/Ei8DU3imni8qj4cASmURrrqzQS38+NvS4xcqktiYq9/2jNAz7v6ikoA4xRNaz77lMl2dm5DaUWi0kb1dkNgLms4VbYSr7smsduHTwGubwqzFZo5lOVEebUV/OB3R9E=
Received: from CY4PR0101CA0032.prod.exchangelabs.com (2603:10b6:910:3c::45) by
 BYAPR01MB4485.prod.exchangelabs.com (2603:10b6:a03:98::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Mon, 11 Feb 2019 04:24:37 +0000
Received: from CO1NAM03FT061.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::203) by CY4PR0101CA0032.outlook.office365.com
 (2603:10b6:910:3c::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.17 via Frontend
 Transport; Mon, 11 Feb 2019 04:24:36 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT061.mail.protection.outlook.com (10.152.81.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 04:24:36 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B4OX7o021645
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Feb 2019 23:24:34 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6A4607A4EAE; Sun, 10 Feb 2019 23:24:33 -0500 (EST)
Date:   Sun, 10 Feb 2019 23:24:33 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
CC:     <linux-ext4@vger.kernel.org>, <jack@suse.cz>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
Subject: Re: [PATCH v4 1/4] jbd2: make sure dirty flag is cleared while
 revorking a buffer which belongs to older transaction
Message-ID: <20190211042433.GE23000@mit.edu>
References: <1548830980-29482-1-git-send-email-yi.zhang@huawei.com>
 <1548830980-29482-2-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1548830980-29482-2-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(39860400002)(136003)(2980300002)(189003)(199004)(316002)(58126008)(76176011)(4326008)(106002)(42186006)(36756003)(2906002)(6246003)(16586007)(47776003)(103686004)(786003)(54906003)(33656002)(229853002)(52956003)(6266002)(14444005)(23726003)(90966002)(46406003)(86362001)(126002)(476003)(478600001)(446003)(97756001)(6916009)(11346002)(1076003)(75432002)(26005)(486006)(2616005)(305945005)(8676002)(8936002)(246002)(88552002)(106466001)(356004)(186003)(36906005)(50466002)(336012)(26826003)(18370500001)(14143004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB4485;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT061;1:eF6LVm2fX93JuMpV5OmhPjozlz5xEn5pe/ZSOo0omei/ybdGRutMsMVs7iJgwqM+cTwzDOJZ3Zl2id60EDNUx+9e7yvKxaO9Qe/0w7oWq/IKeFrDsxQ8aPQDJbUnAjgTQ1xeL+pHVlPHz/7m51uddjreIjXCPZHfB9TDPuFPzF0=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d627e26e-0240-4edd-1e4c-08d68fd8d4f9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BYAPR01MB4485;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4485;3:3Rb6IIhRXa3wmtIMthwaSNuDlYoGhmpffZjasx+WPxdRQkL3Np8lmwm1ZkoNhn6Wh2FaP68cLrrgqfQitLa5IKaC9oVQTgdGhJ6PdfB+2IDaimx7+6iWxMIbcZGs/7yPUWxivcoRV+bdVrwRXaiC96tNq1XRSzsx0sWBLlT2uJteA8aLduKQz90i6cXEoA/Szafe94d2/qa13s3v/LpPDrRQrL5fWu8X7n85oaZrgda7LtYuFSHI1ZQh7rW2uZ+r3hqcrq9f4iLi92meuJfbPupYxtSzjbaF050885Gjm3kSrv6zURUNHx4FWMq0rnwQ5Qp/hWdHQJrjzsA06+T+LpGJIoCwvef/em9K5V3X28qfkwfowfBprTMKdW3kHlrD;25:EtYW8GFQh39vkHF4gkcayWV4oZBjsuzk+4sjW9exrd3WDMbySQn8f6l+njRRW36WZm0ctYhW73G6EB+Y5jUSQwFPwlUfVHATcQo7qWamulSyfJ+hZ+eOjqihEvDMQIl2/OmnGYB3SQsf3DH9uCDdgHbrKB7qKF1WkUVDqV4L1nAMgjNUn8ZgKljzij02oDzm8NSsxAcFwHlP9BnR+EsD36fn45UsJQlRbGfip9VprIM9avE85clqQri2rq1cQvCgB7QsXceTyU1+PMXH/hmGMARAegcQURV2jkA5oepqogP231DRW6bUaIffmkTu2FupSwCUMFcJqK3pPKpv8UU9Sw==
X-MS-TrafficTypeDiagnostic: BYAPR01MB4485:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4485;31:sbXSzhyns7TCiemd9y/p9/ykDALVCq1nHehLZWfXxqGozdtC2bP1a7wgxnI5S+fOnAGHEmoI1TulQCI5J/CzvHW3/lGuNSuhGcNCsrvYLrV8zl5FpHxolntw/KMqHwWR/tNPhgJKyhs6A6H5cmcvnX5S3b4Yd5gGnR1GHNb82os7eWGq1WWw7TkzVH+aaPmik5WufcAAcwZfDbgr4Ro7OGPJwqJhSocsT8YLS2/kQe0=;20:oxh3MHjWqNmzq6Ecp5TG4/oJrhjgd8BeSqdfKnVj6k2ZfZq7xX4Ui7WN1vWdUHMLR1uqKobvj2Unvq3MqEkJwbvmaViKosgF0lu+zkMzwVTONINvbpQ7bEJqi0GYdd1rVURqQJg7t9BL96a17gmlnYQweBSjjLH3K2YV7yIRC4Q1LZId37PIql6Y11OyBo6G3BaAwhqm+k2Sg9rxjySzENL7TgAdi7+PEfJkhKOyhcO2lxr9t4EB4I9hJEiIKGznDYkcSX68vnwOlpra63XxF1A9CT88D63uFCWxJn3FeTfCoOznZiywXIDzjsAPbTWUuL/MGJ/HVOO+wsgMejhSsGrlINivDPDAcn3yFHqzZ5uG6iUXrGREveXZ3hFPGvtppcedQpNNCJ5jxBVac3GLb5+bWpszVwFo8IqNNFhPmDyEIYhBsJAMsxMx/hEwdvF9AOalPQjnes8pLgAkD8fZXY53j6wpjl3ZxAKYrfwd4/uVnjGdFIHyuHyKMDXCMXyfq0ryDlUecgN2PYcCRlt8tVphWfGvn/ap/M1smAd2gzCSiMdOHh5uAdNOUIvjwWT/C3OWY+6xEJH/Fz90FcAqlSahR3qBl1YZJoGyTZRqVN4=
X-Microsoft-Antispam-PRVS: <BYAPR01MB4485333EDAB5A80789DC6833B5640@BYAPR01MB4485.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4485;4:j5oyh+gkp30JrGdYRQoxagh9QqypvAH1J7HgigPTd9f1O5OK7UL0JSDtVo/YMICtzLZFjOytDugVRqC3ohZX1uF5nYQOha/cEGXgfwksLqYmOjLnnNhIFGeBvPZVCS0u1GHL9lnrxWIdhz3za3jI4ZgAVUGskwhlddWBCCCxw4PRtuXhH50ymbgkwrlvxNSWYN7r1Dcrf8Pcd0wbTxA8Q+Ov1w0ARsU9SpXnkw8bABKbyb6Lch4saNstLXgSbgW54hr5OD2CQ+IZTb0J8A03gR1KgQzaKLxUmmp/AZlVNrk=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB4485;23:sTjpwebaQOtoCB7vhW/otfcrrQuR+V0chxZFp5/Q6?=
 =?us-ascii?Q?5/ycaS7NThkziUkWlLe5VhU8lzWkK7gJ2GhACs/w+qyVjg9Wlvv5BgPNmDs9?=
 =?us-ascii?Q?QDPffIwAVlFpfrWoHTghkZoXQDwkXI6otUP+FY+sMvyrK7vV9ThvG4C+YOdP?=
 =?us-ascii?Q?33xLLnvsXs7JP/KfijOU2Xbp/qk2w3gZWuHX/v4ei2wKjZ4s+xc+nnARPYTa?=
 =?us-ascii?Q?Pt4CilaAUngbioif2tY44YieKGCf5tVNGPfJxO4OTQ++i/LDBMw3kW7ybLHS?=
 =?us-ascii?Q?+d22Ca8yU/UeuTERPikBs9ufzKlq8VVSQiQ37+gDX0kwQYqEFs1WmiVYpgDF?=
 =?us-ascii?Q?FLF5f3bXJYZw0XjJ7fxFayxPafdhxRdpYnLd8H4HxqoEt7wnuPGjhmvzYXq+?=
 =?us-ascii?Q?f68KKWuYB1bNACGoh590rI/i0ov3Ogbr5D36orfIM9pvh8VJcSy6By/uIoSh?=
 =?us-ascii?Q?6YypFz646qEAl7oUxHfuBf/hkYb1nPG3ykeI5Dp3m+GtvlRkYBdnLwS6Yswf?=
 =?us-ascii?Q?lXAw0pyrglhiH60TASDeTw9u9S4X9MNvzbYASz87bRv3G/r6OoHAjv7bECJ5?=
 =?us-ascii?Q?NeBA1E/Rfu4G1GN0eW/rs/MBPJtGKvs+nhQ1J2B5uYOVidVSMgLOp+xlg5wG?=
 =?us-ascii?Q?hP81EwwscmV0vBt6dbn3ihnnW6+1jaqPg8E1aKzjUydrsf3B+cl5sSRm0gH/?=
 =?us-ascii?Q?CRb5HXwJMI558GpcYzgOdR9eUaTzvY/QSPlrLPnZAGiQKNkRbK1HKvmU5zkz?=
 =?us-ascii?Q?3+vEqc8bsnr2hQkm9pP+Zsl4GaS3h29PtyKGZ1h7DYvpeGaJQKt+dxZKW2ZZ?=
 =?us-ascii?Q?MXINeRqyunQm3qGp7zNsxWx8VTxoGITY2HQot+G3FlPNgDbM+npO/UCLWNO7?=
 =?us-ascii?Q?ZYDxJ+WkuY5GvqM/gqo2prYC6BlrllsY9P67rXcryxCttwW3SBBIXf8ZwmV2?=
 =?us-ascii?Q?6MfUCMo4qkQlopVHQ0qtchbv2ELkVIqKiXm6g3pQCsbI/Vv0qnQh6dJKz62v?=
 =?us-ascii?Q?jOpt0B/M8OfqtiswJeeLZ6s7gUNMAlMAaRYb4kXGd/C43zilg0vEO8PlRj3X?=
 =?us-ascii?Q?zNRGIymvA7k2GT2a3CmqkhslZ7O3jz79SEdPzNuiYBBlsp1huDQ6HGvJ4J0H?=
 =?us-ascii?Q?a9XfTqBKMZqsIAXCO8jLyDHFuP9aqZr5QIuRz9Glj9i9YwJ4YVK8MxnUn9wJ?=
 =?us-ascii?Q?OXSaELBcXebW1bwaYhcyen0wwMwkNipbAsr3jvZqdnxONV6qijnogjud6/Rz?=
 =?us-ascii?Q?XTuKHLANeX3rIYBnMo=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: XyoeDPBrbErBOSxt9af7OTILhWxu1v1ZHE/Xy7dtdVAAQJeneYI6o5tQkiFcUi62MhbtageQYTGh8Yy4aqTeInIHWkjxyFh7CpeOKC+lzEAYAen2GIbGUyXhJFN8S/euuPiWsQPL/c4hG8cDotKEtlq0zBIufvyj9h3z/I1gS5TtpipEQRLUaIyVnjOg7KKjPUIQmgU68s7thFzEZW4jP/7N+SMNGjcCVgMArAldajhkOZzo4Ssul8TKzmAS3YI/InXWxphlxtSsh3b+SIrzp128BWpeAVDMNgDgaAbOZZeRE2NjHNaiVkgECD4JCO+fsLE1p6G96K76n6/qa6o3EUSl92EWJUyiHVGcAHXNK9wjWoGjEk3eZQ8XE0IYI4aE9hox0j1HDsMldotNac1u0AvoieTtLs2N+JHXiz+dCCQ=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4485;6:Y3ZWcoBRGcRMC45wfHZZQItiQqFqcojhx66StbunYlpHMb4WgdTx1dS3LeIXAbe9T4vG5qbl3phJdQYZhx+7MTM3WO8QAUrhv29drllql+RMMnqmWAVS0DStmbRQ6ObiTbshtJjCYeDurL1OwRskQlRyRvY4qWHkc2MBlwTd+owGdCT+f//YhAKah0Cn3EIPwJi/lGt1FO0h44adTQwYt3NKdxPaUNst4IR7/WR05Pa1Z+hggXb6Jy15xucQPqM6d0vsbAMPxjb3Sdvxn9S8/DV88cA5rj13z51ZLLFVyZG3pui/BmBPCTppV5xbctlM5Hjvm7HpCnHruoxVZla/Z5517Nextfzk28pTWWkFZM57U62vzZ6QCmeSOO97U2ke8E1Oa9M9/2Jaqg1IAaeYzCnmdt60cvoe5hCpuZgsaoSoZY1dIgE5kiB99lfPBf38aeXp4XqOW4cYuUt//lZg/g==;5:leDDQ4XCsJbs5yVPyerJXCkdPprFPfotGB43KsOX/UlDRs/eycLRR/sL+iDOl5UgS7wrtVh87c2SKF17JdWy7kHWh1w7fIGxqpLr8/7OpEN7kXRk3fXloPKvHDNjznTN7V9OORx5e/O0w/MG+GWzCFZBKeP24d9BX/XmhcqDMFJJb48xxUPBHGBtlXy1QifuKyKwKXQhNoDE1Y9H5h7Pew==;7:3SQ5arivvSNtM4S651muSquQ0pbYhwskMwiwBl67qKARdEtpQEx4pUZWsM3ILlBogQfX8S9wpqYlBP5YYqyD8aLa1Mg4qpHLazkorT2jmsqUAZv+lDqwbdEaN43lP866hGvDcoT8E+n8IIgVzgC50Q==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 04:24:36.4126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d627e26e-0240-4edd-1e4c-08d68fd8d4f9
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4485
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 30, 2019 at 02:49:37PM +0800, zhangyi (F) wrote:
> Now, we capture a data corruption problem on ext4 while we're truncating
> an extent index block. Imaging that if we are revoking a buffer which
> has been journaled by the committing transaction, the buffer's jbddirty
> flag will not be cleared in jbd2_journal_forget(), so the commit code
> will set the buffer dirty flag again after refile the buffer.
> 
> fsx                               kjournald2
>                                   jbd2_journal_commit_transaction
> jbd2_journal_revoke                commit phase 1~5...
>  jbd2_journal_forget
>    belongs to older transaction    commit phase 6
>    jbddirty not clear               __jbd2_journal_refile_buffer
>                                      __jbd2_journal_unfile_buffer
>                                       test_clear_buffer_jbddirty
>                                        mark_buffer_dirty
> 
> Finally, if the freed extent index block was allocated again as data
> block by some other files, it may corrupt the file data after writing
> cached pages later, such as during unmount time. (In general,
> clean_bdev_aliases() related helpers should be invoked after
> re-allocation to prevent the above corruption, but unfortunately we
> missed it when zeroout the head of extra extent blocks in
> ext4_ext_handle_unwritten_extents()).
> 
> This patch mark buffer as freed and set j_next_transaction to the new
> transaction when it already belongs to the committing transaction in
> jbd2_journal_forget(), so that commit code knows it should clear dirty
> bits when it is done with the buffer.
> 
> This problem can be reproduced by xfstests generic/455 easily with
> seeds (3246 3247 3248 3249).
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org

Thanks, applied.

By the way, I wasn't able to easily reproduce the problem using the
given seeds.  Out of curiosity, what sort test system were you using?
(e.g., how many CPU's, how much memory, what kind of storage device,
etc.)

				- Ted
