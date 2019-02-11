Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EB1C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F9A20855
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:38:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="RrMnfgOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfBKEiO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 10 Feb 2019 23:38:14 -0500
Received: from mail-eopbgr770114.outbound.protection.outlook.com ([40.107.77.114]:48648
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726244AbfBKEiO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Feb 2019 23:38:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USVAo+fTa5seyw1tr/HDuOeqbtqYO8HOXi0tjBTRshI=;
 b=RrMnfgOWVfLMQO8hXOCq1xiYkCmI+shjS7HqCA4Loki8dRLk4NRjgF05RoVnoVoFk1GX0L0L08nPz/mBuOC5Np2TH+7FCjRSLBbNc5IzekJ883WG0oH7LwsuzKHJ7xK03euGfiq63FTgRC/FPHt9eNHR9r9bkZRrWz+FQJ/OlMg=
Received: from SN2PR01CA0003.prod.exchangelabs.com (2603:10b6:804:2::13) by
 DM6PR01MB4491.prod.exchangelabs.com (2603:10b6:5:78::26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Mon, 11 Feb 2019 04:38:10 +0000
Received: from CO1NAM03FT007.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::201) by SN2PR01CA0003.outlook.office365.com
 (2603:10b6:804:2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.17 via Frontend
 Transport; Mon, 11 Feb 2019 04:38:10 +0000
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
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 04:38:09 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B4c7mH024712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Feb 2019 23:38:08 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 22E157A4EAE; Sun, 10 Feb 2019 23:38:07 -0500 (EST)
Date:   Sun, 10 Feb 2019 23:38:07 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
CC:     <linux-ext4@vger.kernel.org>, <jack@suse.cz>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
Subject: Re: [PATCH v4 3/4] ext4: cleanup clean_bdev_aliases() calls
Message-ID: <20190211043807.GG23000@mit.edu>
References: <1548830980-29482-1-git-send-email-yi.zhang@huawei.com>
 <1548830980-29482-4-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1548830980-29482-4-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(396003)(136003)(2980300002)(189003)(199004)(47776003)(486006)(90966002)(106466001)(11346002)(446003)(305945005)(476003)(126002)(2616005)(106002)(54906003)(46406003)(316002)(42186006)(786003)(36906005)(75432002)(36756003)(4744005)(186003)(50466002)(33656002)(26005)(76176011)(336012)(2906002)(356004)(52956003)(6916009)(23726003)(88552002)(8676002)(86362001)(4326008)(26826003)(246002)(478600001)(58126008)(16586007)(229853002)(103686004)(97756001)(6266002)(6246003)(1076003)(8936002)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB4491;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT007;1:ph8YeEv9rz74v78w50oS08P8gKkh8And5/wGHYoUiIQ0iNLLJ3P+fGy2BVtcXjWzvtKF7NrQUHrQ6dsx/RqwGoGfhGVhOBFb52zg4zFGsScHh1eQ/fKSJGTYqp5zT053C5IhG9BTbHFXSWejqltyiabithl6h8Cq8ABgtucIYE8=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09dec793-db0f-4364-6909-08d68fdab98b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:DM6PR01MB4491;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4491;3:XVRZ5NcMf6A+3bn0Wths1z51WQmUxg9in4cP6lpvLQTEa7eyHxsoesgHXhFvgut5Zby72IEnBvUHbS4ZTbE61ZjubX1q3GnGCrfFl8nlsPwnjksU94pts4v75s95apD/IZ4u83OtJDR4Gc/Gp8MIb7HW/rnzOA6Rf5ojKkqkcI9oIFUThq0tAjP3yIzVQ1pvZScqthoTqG1U+iT0ICZE65le5UKvFWjLFAiUoscDyX8Kqti7e97qS5+RWu/jZEWh4m3kz6PV0x8yPB/EGh5xdpAteHeHZrzx2xvBZYe3HPvYGcjUYKpiacf46Ms80nVcc9l7/2I+zFfrK3dkfr3tnhV+/xgE9sYo1nCKbrq4HIuhYniTkimLVCf0UljBZg4K;25:yGKWr41Yqx0jgY8kBejFgIhoByJMpSjFYRDJbiKN5BxtV361XApRr03K/a7d/B2R3OHT6LgmpHANAqEEQ+WX7c3GIOLt75BSKkxhU1wtef/XT7kUBLRU7WNsx/DHnKyZjivUL5I6qloJJYp8Z2kAmj66IjIB8gMokdkdEWBDOqAcL0tKe0pesouAYQjfWRYqNPw7HiqTgfh27lfCbD49n2KpzonvlXkwNOM3xao51jddgR+24VYzznsTtFQnlB1NLbRbW/pE2YbAxkRWh/S4ZNR2k/24yawVDiUt/p7MqrMsdDIDodL9aOP9yS+SYraEKwCE8V9CYhD3FxAjOlAysg==
X-MS-TrafficTypeDiagnostic: DM6PR01MB4491:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4491;31:iaIoW1C2pJskO1TEZGeWtUyhBa6tZ0AXNKFwyHqbQSphHD4ZFcOPgBuUOqqobw1684rcK+a4OL0kU0LrPLeZ/HN0M1X39CJFwktuA6rpw0jr0we+usNA4JHZVluG2vuwUJpgpbUJXAufgtT1No3tq0HhFvLHz/t0eubSV1Kls0F5uPyD+xTj69eYM4pupEpTBCMHsHYAb5+tI1y884OHvIqq/gPjoQ9FSfHjQBqQ790=;20:51qfbNbM1W9cYLinnnqYiw0e2UzBpdkdyHS71o722b+RJR/cO3f2NNADc8DqPVBvW7LfnIh1iXMuoesId/0+MlaTtWLm+0xneOzmMy9gzBaUjQN76PUIHBOKSVt0Lm5Oqhv0Z6N46004QR6lAwznyqczPdbSse2vF5L2U3MG5l23GC4od3+lLWoVakkMqtIjgHpnfmE7a7jE2bxvWXjSOe7s3zgSYGe/JC1EcTMN8wEm/3gM7DAI9FdqGk+8VhyNa3W5bMI0d/muhn15dZHP0xlOpvRZ6syyLBrK5HKdJpwZMbTFySH4V2LMSZL/VhXW4NE4H0a17MM0FU3TebyA41hT0L12JAApjbvB8oUnOGDXjoE9BmU+buznqDKGX07sBvkGvF+aDqwPpnND7/TaK6slO9JW8nvGo+M0AZoW5qn865lxkZwOy5TWGoQv967xhnhk+5KY9/UtpWtOUYZEkdMxgdEncAbbLiLxpZKg5ym/oINC8gC/f6FCA119fa/yNSaD8nzBVe3ZJJXon3/ZZI+u+XR1zBe4l4xwoeQgHpcjadXXviZVvuhuzGjuGDTQmtMVpVOVf76Vd05VsIU8VhnP/JpkfEY0wyrJYMpgJ6s=
X-Microsoft-Antispam-PRVS: <DM6PR01MB44914FBC05A8D939AF1BBABEB5640@DM6PR01MB4491.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4491;4:20DH623xTYBzowB7yICMKz4kvMRXmS4M8vPaUln3SuIIUiuq6+RXS99urgIaJ/5b3xPmjbjdpquVSIpDYNZUEl8GWPKC4cEs7rPU/wT4dQ6SqnOF76a5Xbdy3VWvX5ML+jOj2S4Ya6L/iO43pGjPtip9b6IWf2j1UicULdbu3R77HJfYBZS7HOlJ4f0pJDku75nio+h+aEHRpGQS8+QPE9O8Gsd4oVCHa4xgfw+yaZdLmyHU6lH7jj0onR4iywnsyzTEXqjQDmgo4OxlX8LCFdAtcufiRNenTFcJanOsjBg=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB4491;23:uLXbXH2xb3ma433CuO6kEEbqpF1tLbQW0xoJq8nCw?=
 =?us-ascii?Q?XSciYiMnqs+FX+JIRQAiSXN7/GM0MC3832WVE+lLhgMUgifvPx9zvd5V3zxV?=
 =?us-ascii?Q?gWcRM7Cp7opbhz6qkuYRdy07/fTknQlGlFdC6g8S1XbM6oQhDmWTsPvrfCKw?=
 =?us-ascii?Q?0SBFN4qTsuU8WwTy7/jiN7VjDgzJSOvzma3LBwft89AF0UIVh5P7bkcCT2lE?=
 =?us-ascii?Q?OKNscJCi5FkFEgrjgMoR/VOQHwi3FXleCF/yKpeRlLC8HPPtGIb5tH/3daqm?=
 =?us-ascii?Q?6ZKi844jjbkxGV1P7TNJ9QJQ3ylkajzw5KzfOn2gImNZrMCY+uR0wX7q66yH?=
 =?us-ascii?Q?mQdBYlMYy0stLbGtbE2BuhbyVOetKpwemp2XK7N/98g2ueHWnZm2uwxePHUE?=
 =?us-ascii?Q?R6pkwu9LfPhJ4V1In1f6KmR9IDKOrnaQ5HzaNu0ExAvnhAvjvYCXw5bdkulJ?=
 =?us-ascii?Q?aJqaKyuG5QYIBPMH9tzu9LYzZbMr/2IjK8jkBJWDpXTEdnecEhLJVpsSCUtO?=
 =?us-ascii?Q?/EL8y5FjWpdGn/ratVQST4AEvxLW0+Kv4+daaTTKY6JeseR36q7tdUgXdRuc?=
 =?us-ascii?Q?ueiKQIjlrOoIbxz27cBDZ5iz+N5BfclOKxdlgjbWSU98BDi5eBYKBCBdSbi9?=
 =?us-ascii?Q?oGWj+4Nyp3A/Mk7o+rPbXGl/RTvK/gc/J2/LGNMPfPFC+uTfsTNFkkOktVO6?=
 =?us-ascii?Q?BdrCFX4TEQXzk582YA96shooL3qlMHrqOEAWiNGWEm2N5YVO861iAClR9yeR?=
 =?us-ascii?Q?Yk1xJQnR29BeY0xDirLRrQcVs1GM/4yrEF7I3Bsm3HsCTFrtJS+AAntNAy2Z?=
 =?us-ascii?Q?eOw3ubVm1gfKAs72nrL6D9w6tYfaDNaY2SuFqtAqilotc0v/0oPDoybISOAr?=
 =?us-ascii?Q?ws3yBkDLIZe1l99OlGNYfcHhSg4fmoV8dhfZ8JleVH9YnUHX1+zxYOVLU7gT?=
 =?us-ascii?Q?zDu6wfsyhHEGkJnb1G+agclpctcftUHmXsn5VHHAh6tA4yJYZj2CcEYIL/jX?=
 =?us-ascii?Q?fATRbGZWNq+vgcrJWsxJv4XB21apZ2TXfgOw4EPA4Y+zy5EDCnCBt8tJF/JZ?=
 =?us-ascii?Q?ggFE4PXGWzul2l7oDNqBcShtcQpf/BsQN2dMXON/94SQGvMe/BqMUM2agxz3?=
 =?us-ascii?Q?wh1h9ZUs+8ETXcgZl1YuxZNmLLbA9p2hcwi1VSRFKW8ZCxUAZNJWNEwJljEy?=
 =?us-ascii?Q?7XgtkG67iQx4Lut9BQZmc+2yNHPDFoqVmUqUIPHZBOgH/YV9qfZOB3ZZA=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 18mvnhi6gIXabRN9CViBg9LLO3NzAptSJ8WRO+7r1HfupfsFr1cdMoeMRPeTX57Xb7lXRIXcL++4CoeWafsvOCZr7cN/vtvCBjP+/dST9h8LoPalT9zJqbKLRvk1c3bdlZsHumHtmC9DwAubZiwFeRLookCDAcw2Ew2yHgzA5eZkmm2NKPK2AmDv6QQKcXYW3SkWUR06af2WNk//wt2sdTmJuXVBb8kjibna6Up0taOz/ARTIBMfzLV2dCiWR6EazwuFwXIg5SywVNYB0HZcX+CYV6KihxRrWbuvthdGAq+7sscCpDDlo55Sx5P2iwgx8mhDbooYs4ivhPMPoP660QxadXYXGZ5OGZX1Xpj7b2Bz8fmMS11x2r9mUIKe+6ku5zbjCFdsq3Sl4m2tDHWLexcy7intknh14go5W5G/MOI=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4491;6:lfrFxzm5MkODBwjCqZsgCaHIodmAC+z+oKR9OgasLIt3jC8MKpeu1t5F6bf2WKZ1AyfG5eI76tdTHjWM9/C8v9Zk/8Hh17h0XwNqArHEiKyGGQ4vjps+5dWI8ZXVFfKQf+4OZTRut0WFqwnAhEB3sBeuMoNez+wAMjRK1XL0v4Kq4Z7BguSywKQfGfHzoNvyeGGY4FeYZ1niNMWPStJ/oQQ6ccI44eykyYqa4dGCxDH6RDVjXJkzPk/t7DIMPzUiSrR91dfuZCB7yfTBneB+MTe5ZVSDOv1GVZg2mkaLPOVFZRAewSQQ3SbD1F5F9rEeKKFb1viSR32RAK3OZA5+a5HgbIfwrE2mQx35qsKWWzvW7dFsn4xE+pnLwvcxiRIDvj9psxRG4lwmowpP3kyIQIcNPocIBURlcCfhy67Kqs03UZ/++Tu1lpX+XIsnWfQvCgIZBoQfo5Qch+y05XOvag==;5:VJrvu/53W94VrTwMY4lc+tZtsobghCqKnrPbUhTn242X7y43sVhZKqqj3FNnoIenBtx8foXneoIHP7MTkOyejBD4OFsOanJXzryugsnEYYdTy3GUZPG8PeSBO1Ya51IpbGuWA7l4iGa0uNTO87DpKLr48oOMgVvLLndppnzY1n5qP9XNvIcGAvCNIfnE3ykmsNmaCLm6je9IiWLAAHDneg==;7:I2bL2hJENB1OMNfnPDnUmFusVjza1rKtAAFBE6rgDFqn1ssWU3DswrDMk9vlT6cowGtPCuY4Ot6EZNHz0XTo3ff/FA6pjQc2zmf1qWL6fZKoUqfZFGJ8gkCnAr8Hch1rUIlN94GZ08BPyKTuagoc1w==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 04:38:09.3575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09dec793-db0f-4364-6909-08d68fdab98b
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4491
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 30, 2019 at 02:49:39PM +0800, zhangyi (F) wrote:
> Now, we have already handle all cases of forgetting buffer in
> jbd2_journal_forget(), the buffer should not be mapped to blockdevice
> when reallocating it. So this patch remove all clean_bdev_aliases() and
> clean_bdev_bh_alias() calls which were invoked by ext4 explicitly.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
