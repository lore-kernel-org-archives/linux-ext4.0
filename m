Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8F3C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 05:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 844EA20855
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 05:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="phmw/5NN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfBKFMZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 00:12:25 -0500
Received: from mail-eopbgr680110.outbound.protection.outlook.com ([40.107.68.110]:29216
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbfBKFMZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 00:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f22hrr7fJmLFrtThG3Cb3nlwIariaBg/a+NL4xR7jQc=;
 b=phmw/5NNx5rB812YWkz/+FEtLUqMYaUIBNRjyN4YOhtp2D5RqZz+wrMnakzCiMudc/db+k0pfd4EPqss03CqXMPUVOJODFGg4BMwmK1sNJeB2dBAZGogQoTmwwff9Vzlr+GCcuYz7ZHarwwGNhYaErLHZkKRCC3+2gjdPRiyaTM=
Received: from MWHPR01CA0045.prod.exchangelabs.com (2603:10b6:300:101::31) by
 BYAPR01MB4485.prod.exchangelabs.com (2603:10b6:a03:98::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Mon, 11 Feb 2019 05:12:20 +0000
Received: from BY2NAM03FT003.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::209) by MWHPR01CA0045.outlook.office365.com
 (2603:10b6:300:101::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.19 via Frontend
 Transport; Mon, 11 Feb 2019 05:12:20 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT003.mail.protection.outlook.com (10.152.84.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 05:12:19 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B5CHL4032273
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 00:12:18 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id AE6007A4EA4; Mon, 11 Feb 2019 00:12:17 -0500 (EST)
Date:   Mon, 11 Feb 2019 00:12:17 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     yangerkun <yangerkun@huawei.com>
CC:     <jack@suse.com>, <miaoxie@huawei.com>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH V2 2/4] ext4: cleanup pagecache before swap i_data
Message-ID: <20190211051217.GK23000@mit.edu>
References: <20190122065823.67957-1-yangerkun@huawei.com>
 <20190122065823.67957-3-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190122065823.67957-3-yangerkun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(346002)(376002)(2980300002)(189003)(199004)(1076003)(446003)(11346002)(6916009)(97756001)(26005)(4744005)(486006)(2616005)(75432002)(476003)(126002)(478600001)(186003)(356004)(26826003)(336012)(50466002)(36906005)(246002)(305945005)(8936002)(8676002)(106466001)(88552002)(47776003)(16586007)(103686004)(786003)(54906003)(42186006)(106002)(58126008)(316002)(76176011)(4326008)(6246003)(36756003)(2906002)(46406003)(90966002)(86362001)(229853002)(52956003)(33656002)(23726003)(14444005)(6266002)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB4485;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT003;1:ykOqfl5buQKzT2zCIApdSlxP4crDDIjai8VM6xo10FdZunN6DF3YePJaO91SzyFKReCh2kH3WKwcLkLvF53DdzjytTzSay0Y0vH50VfeEd+zYpzQBBhpORMNBJtzkKiYAEg5qHXNPwM++BcECdPpc7TubF1kQU0YiGU59IAK3hY=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65ed087b-cdef-4510-a4a3-08d68fdf7fbb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BYAPR01MB4485;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4485;3:muNCECZdjcfktwvaHjo/BtzaqsMtfyJef6XlgarBkBuojmDUiiK09g3JS4zX20ZbCk78brWwxCqRA6080hr91g2wkpbKnl1DYQ7ZkxCIx5eGhpd3fdAHZan/Pc0f2hJnFiWR6MTGmrKWJ2euJHmgO/vmGVeAw5NIZLbI+jd/0UcHNCUfFPbcixLOsqNzo3pUpOIxwkCHSc0fM5MXCAqT4GUuehdaeDlyHX4m1MK+D0gNCuciNaDd0YKh6Wi2GDatbPnLXdrhQ7Kfiw1vHyzx0jy4nSMfop2KUx6IH7r7fwuLzM7FjbTMrt1QQf+uARfQdrgEk+xsvSZ0hOqRE52t+k/FPD2mpG6CucfZgxRPOrou+05J+HN3kj8o+QMPapjQ;25:lxvnk5ULBLS/5TEWGS+tM7eNOmOjt0dkqcZiIxhdbeGCH0Pvij5WAJCj3gIEBScJKkkiX3nY+/awvdYUXJUpB5QOxeE1IQWsvlo34NADiw2S0HaqFloXWxExg0s5ZbiHcQYcjApYPp0uO42mPhn36lfcZry+lJIU6G29KyEWpd+UdSaupmIrnZ7FJgzdxidd8/spoXT3RlPGbHcCCknfTDz+vUxX8ch5YixLGq8wUe+2VBv+5VzcoU+k0TvUSMvvC5j8814g/tvqfDaiFtyLmj11Y9c1YWqfxA2EpaUtlkMAg3+aopQbg5PYARQr8gcdAKsMOBDaTxTXMxiMzjgaYQ==
X-MS-TrafficTypeDiagnostic: BYAPR01MB4485:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4485;31:ZONr/1OJUhdM69aww520AQD6xaMqp+Sz3c1yPZYvKZ8nuMRzOLmHb3MOnPB17/DImp3goQvC+OdIjcwfuUSamWx9t3j+vi3dnNQ6jjnEPiem5MzLEoGm9Mxw2NC+56L158jk9rkJkoZCIl+QXwlXH9JvXfAE9e7IpmhvjByPBemkgcz44DKlvErk6k5nTB64EpI5jG5qkhLkLtqO1P3+CV5mNJKB7evlCHhAVT2h2Bw=;20:gpN2BQGTyp0/gOpa9DOwSzZAERxDmsdSgeJbTkWDqlk8KyZ9bEhiIJa+z99bUMITfjvJn+IzIdeCBSDskyfq75Lhladz1Zy42QeSk/6agIPggjYOYkE6bH0GwqWH61ZwJRGKDgpaPO6Hp3VWJEclQNLcjxJQMMtHiI0W622L07VyRwXpkpFicQbS1qgVOt3cCqJ+SWiAPGpM+xZ4uKyWwkF/HfUVAeHgUiE887nVziN6FwbJHAp2E4lc3x5ROaQxRoEI1RkfzJMenx/3h82eQiRxmmAfyZgbvjsHNJVJfUQs7lc/rtHEUgzeG3DF/awp0C9cNXc1/jpNwHMMVvS50jdS2yf16S1agw0s7seYaSnqwIAFhf4VfgtV2p6kBhZEIMyaztWQBcjiOdd+VSi++OnJeFLWgOfZXeETUteLP4JvONaQYPcqO1dLBV6Zg+VwuBHsvUBulN2qYQ5h3o0bhFjbeRaxwOPiJ7iJEnXJjndCgEYs55skO3OcyBD4NU3STTl+7gVte9OH8KsGq2TZw/KQX4FvFTJrxkIPI+ZK+ZSXPBfE8XT1OXBEAfTS3xqPMah58Qy1uXGEwHbRM52RvdFfkPdYSIoRUya4q11pt8w=
X-Microsoft-Antispam-PRVS: <BYAPR01MB448506DE5161B41F3F551D65B5640@BYAPR01MB4485.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4485;4:LaPCx+EBY+mFNdaogCsV7VMDJ54xx7VQ4QCy/v/hzGkt25O3qgHGuDWNzNo6Z/jEcs/J9dOaM1DJVXovx1ssWEKNN8HW3ohqVKartAyD+PVcNrA7xaFsBdzHG/aQLMY+CYZb64W1g5evkntf9/ueHSRe76mXtEmyokRt7W8+BOo2DaZX8m5jGDuHp8UFfLN+DF4GmV0DfMMztAUzRjkwYjB0yHxKystH31Pt4rX84BdERIRsrsRivAyiU6Bc1YIHpZ2MAyWcW9GC5jiPWTBVoEI6SgPDDKI5pXfdrSrjWwc=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB4485;23:DrSzYC2AFx9y55kQ+R3oFhn0yzNBPYYQ3ioaqIZv+?=
 =?us-ascii?Q?8LShCZUUjtQhwViVuylvqO7Ihn0rWu9juVYQRys2Kz0VSZXTJDkiy/TWA9Kd?=
 =?us-ascii?Q?rwpNCyZ/KK92Rx8V6yrir4MZhcEuS9VIl/AtGpNJ9QVTst439MrpSGrLAc7k?=
 =?us-ascii?Q?QPcKlZABwFZ/oH9Sa2MMhr6syfvkBp+Xfc+C5sjyIsJheSgshNMYDhRJ+mzk?=
 =?us-ascii?Q?n8Qo/k06wvBjton7vFGZEz+ax0SYSug0WspFE+UzoPsA1M60pHvdjfnCsW3t?=
 =?us-ascii?Q?d2mzN41KS8mUBmWiKNPHCD70eYravIjbJ4cM52gRXH6YT0iMygADetpxYM/k?=
 =?us-ascii?Q?tiCB6W5Vh96mOcHZAIJASoesWvmcGPg7jZNO2Hk60l3Yl9M26Df15sbYKhpn?=
 =?us-ascii?Q?M1k07eJEio1TRd9Hszlt++cyCbjvsYYFOUxBOPrnoiXWxQaghvQ9BfowrHQi?=
 =?us-ascii?Q?ZqOU6Itkmg/sY+n8KBLvm5v32ucxsCT+cBa4KFar6d6uzYWpJsRnWowqeZbV?=
 =?us-ascii?Q?o8xYXyGIf3wz5CWER8FIPA2wTx3JBBr6IPY4OYGl9WqATSK2+58jt8DQMxFU?=
 =?us-ascii?Q?6L5y6O2Sfss7MjDwOLFGZQ+qPx10oHYcqy9Pum2Fu1qbVTzwRErrt7JR4hfQ?=
 =?us-ascii?Q?tMOC7YiE1BRSkPWkvdpoTCoX14ZXCQzm6Fjb5dXMgRSc4Xxnffx3CF4wLz8x?=
 =?us-ascii?Q?wpavT0Npk2otXJNjh7QZHlRr4g/DMb/k+NDjTCHgCcCCYyIV9vFqyKH3wzM3?=
 =?us-ascii?Q?/jz74qCqWdKHhNJ3wUMMPXY6znSuh8NLQgm+//128X/rg46meU7uVibECOwZ?=
 =?us-ascii?Q?fd4X9PwnHWKs+F3v5BeHCPVhzgwBZuIK+U5VIr1XGRvAN+5xVaBAFunFWZTr?=
 =?us-ascii?Q?YH4IVRllz/mXCpW1ZH5mDELMx5kG8IKcGPZxJb8GZEgUoZhZZ6+Vh9lC98O2?=
 =?us-ascii?Q?JqLU6TXUMt8ell2HLbtR2WefMAF06SIMKXg4wDhj4+fZ4VBV85Vz4HnNxpXS?=
 =?us-ascii?Q?sooE2cMD1woQUzFCXlwhq+G1nM+ILV+ShkhaA0WvbczxNVJ29p56ZfwuIUZz?=
 =?us-ascii?Q?XzaifzCxG7ERZeG/iBZsCNUpRna0VliK7XrAHOFm4q93YUQEzG+RsVOcBqEG?=
 =?us-ascii?Q?xaFLuPeo8XZvSmpg34e48KP9uc6UeMJiBenb3pLm/oWIVgKonVPOKUDR8iWc?=
 =?us-ascii?Q?VDg/YdJEk4oGMTmI9MN7SJeOUlr4UbBZXBgAexE7SmDfqwL6sWITDP/Yi0/P?=
 =?us-ascii?Q?oR0C1q0NFlHGIFso80=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: p7MaQ5bv0yBq2359cArqs+022NITBFZUtxcbvhJExEhC2fztL7TKcPlq3fekIlCqSw9eT9B01a9cSn35TEL/WXC3qr5Dv4yTWCHqKA5kAXhYtBMRSQ+LmUXLVow/aJo4zAcmdmmgev29cBEKAQxKyCGyXTl3M6uB7oH/E+xmaGD5oYe6N09yeWVeScJecRqsuOlz9cOUiPREX1S9Z7BLZPjiXD7Lk8omKBqEJYczTghzrYVIHJVhDtyZd5CdG2q+MnIsdDL568xNIxcMB653SvMO6C+ZDsoJOLgbBIZun3wEEll5AiAw+SHE8iPtHmsaC9DVZlnvEeTuzCY6uh7zqiqRadepk8NhVRFRiWVmZi7NJgfGvJElbOf5HbmpZAwlTHcCzQfhZMxAeCgaBub20Wv5sy9FwIhZKpkCqrN6Tg4=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4485;6:b2asL7jS3VeSIYmw8yrYJgpMy/jFNa/6VTCsU71lOX/LYf/w1UUKbTW/TkoiBcby5lv5tk3BdHfgIr4NZcrZJE2OPyNcH+X7C1I9Xfqupom1EZ1bY5LdYQ6Exx7NsHVpyGB6NxewvCXqQY/DBh69VfJhuRL0TSYs4jJy9WVWXqrJ+CkLD4RkJN4Ie0KwUd3EoHARajb2YLi6VzFKsRBAbrdZeecccU+7N2TEMagMsMcW7WOmIIc33RZEswi3Y0E+/7EsBGlPDXVyChkezA6RoElZuoCmC6PLuAMr9wtDa4Uyk9alJ75x67P9QUpR4eN1wUC49Bh+/zNNOy/1bFi5VnEz/xwbk6cAVRK5GxXbl+zlQk6+1daTg84/EVKwD1bjjnSz6YNV3YcYth4VzXTkvONx8CCIFSTUhael6/VNxxX/DVObI06hazCqh4gIpaac8/6yLO8UIvCI13iTj6DwZw==;5:ilHjr3NUHLFkvSX6nIUJtM6W50x2uibLmknHSwGndKgtdNZ630Onk2sb8c7cmUJO3GxBtg39i6Hhj6KLuMTdWIyz0gPY5xZ9HWPxZz7waaW7/4fRepe5B/tLURz7oExGdzYwN4OQLHjTW0nVq6C6WlBJOuG/qpkz4ZdNypzOQ1XZiS7JB3VmFeBAH1hb2UZUjPSwi61pYFHpnTK7UZd/qA==;7:6SmGwmlFUZtnOpCCs/GqIehCLF6wnU6iyCS9xvQL2o8yQZqcgToKvRrk9Gdgp0spK2gIB9RTFIMpJdDf2SxepkDFU8JwTE496dxe6KmmKQ5qolb7eyOyeC5fuRMzxmxAxQkZalN7ofJ/5ESPjZAiqA==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 05:12:19.8655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ed087b-cdef-4510-a4a3-08d68fdf7fbb
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4485
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 22, 2019 at 02:58:21PM +0800, yangerkun wrote:
> While do swap, we should make sure there has no new dirty page since we
> should swap i_data between two inode:
> 1.We should locki i_mmap_sem with write to avoid new pagecache from mmap
> read/write;
> 2.Change filemap_flush to filemap_write_and_wait and move them to the
> space protected by inode lock to avoid new pagecache from buffer read/write.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>

Thanks, applied.

					- Ted
