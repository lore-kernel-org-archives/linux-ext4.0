Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4847FC282CC
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E413D20855
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="YRZ/U1hN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfBKEbg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 10 Feb 2019 23:31:36 -0500
Received: from mail-eopbgr730116.outbound.protection.outlook.com ([40.107.73.116]:63776
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726253AbfBKEbf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Feb 2019 23:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvDLjPm/tUMg23toZVohfVyJVvhoqROg1HIK3F1EdH0=;
 b=YRZ/U1hN8+0ANw4cLLhlYCkK1/C7bbVTzqwb7edtdKCuQ/cTb2pR/h3XPofQ1Q5f9+gEIRWr00u0FIazsVUn09J3MLix9x1oZXiThhXfOKLH4CkUDsI0TzIrIqrTNKUUBVxR94GdcAqiKXHP17746j6rpDTov0mKQpdJ619gluc=
Received: from DM5PR0102CA0021.prod.exchangelabs.com (52.132.136.34) by
 DM6PR01MB3755.prod.exchangelabs.com (20.176.65.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Mon, 11 Feb 2019 04:31:31 +0000
Received: from DM3NAM03FT021.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::202) by DM5PR0102CA0021.outlook.office365.com
 (2603:10b6:4:9c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.19 via Frontend
 Transport; Mon, 11 Feb 2019 04:31:31 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT021.mail.protection.outlook.com (10.152.82.187) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 04:31:31 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B4VT0a023067
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Feb 2019 23:31:30 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E95347A4EA6; Sun, 10 Feb 2019 23:31:28 -0500 (EST)
Date:   Sun, 10 Feb 2019 23:31:28 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
CC:     <linux-ext4@vger.kernel.org>, <jack@suse.cz>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
Subject: Re: [PATCH v4 2/4] jbd2: discard dirty data when forgetting an
 un-journalled buffer
Message-ID: <20190211043128.GF23000@mit.edu>
References: <1548830980-29482-1-git-send-email-yi.zhang@huawei.com>
 <1548830980-29482-3-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1548830980-29482-3-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(376002)(346002)(2980300002)(189003)(199004)(8936002)(47776003)(6916009)(6266002)(6246003)(4326008)(246002)(8676002)(305945005)(33656002)(26826003)(478600001)(90966002)(23726003)(46406003)(1076003)(75432002)(229853002)(76176011)(50466002)(356004)(106002)(36756003)(88552002)(52956003)(2906002)(106466001)(26005)(36906005)(336012)(86362001)(186003)(486006)(786003)(446003)(2616005)(126002)(316002)(16586007)(476003)(11346002)(42186006)(58126008)(103686004)(54906003)(97756001)(18370500001)(14143004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB3755;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT021;1:Aq9ACWr1vo2Rl8mEIOSm39w12ZjO7b+gXEeo+/yPY7H05DLai0mv56x7fjqDAuQjhjZpX1Xd9yQYqaSBLFOra+qnwC6qo8eDdRHuPVMem2Sf+L7+gYKRd6ABN5KycmZuRoURtQvrMKdwhK3IIFYPNYCfN+YPqm3INrpP/NeaTBE=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c79946bc-d7b9-440b-96dc-08d68fd9cc27
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:DM6PR01MB3755;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3755;3:9I/sOvJ0xpdDNKVGc1eG3HVvelbVZ21sUYAqFl7uETSGs7ga/vcFtv1fcG8nbte1g+RhT/hQrKULj4g2Z2iUzK72MPCyaCaidtMMPP+x6LH35gxbnBRgPzNdOZfNt/4L1g5RPhl/0+0cvTv5fpv8P/VaxZbQK1cK2umawjz/uIqtxT56UxhRKsBj0p6gJb2nBKNJdbmvMeHjimvBnaYfTA55iLI/EcgBJbouKzdXvCiHPBhnlRh7WxgmH3Br7RAtXjEyn2glAfoaPElKWejnny9uHtsIRAlBYOlfuKg0H8EMlE/6WQNQde8re6kxoyoXFBTbN59zWXW0z2wIJDaCBlL4KwWdaDc6ok/L9vgqVAEX+UeY9WWhAGiC11wiZqyU;25:ZwgJ/MxfxsnIsM9FVP8bWIv1p32ZbFDNMVX1DuveZX4Gqqy8FaX6JVK2VLNYjMupO6JQq4v3mTkidEur4bL3xO1I/y9S5gxqr85CQvoELKREUjqk+Z97fCaWCVDI1RHhRPAjy5Q8l7itG6PUhRbdOsKYaXyfN1Vl5aB/Mkkiua8d1dZuB/b2nzGcswsAGSlrLP512qO4w7Ebmmnx3Jw7W9TjNTQTPE6asYTYVcbVJegPsN8lSExw1+vYlIiepWFuaTPkeGkopVVDRq5nvdp4QGRNJdqWTfHdI4ygZEJYwbNGnvucLdemrFvhoXDzwn74o24YM7Xkw9r4A5evJ0CkKg==
X-MS-TrafficTypeDiagnostic: DM6PR01MB3755:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3755;31:jRgbwBGxHl1iffK8jcT6Vn3R5BQhXjm0oGJ2gBps3saULlPsT/ej81tfvgbbUM/jg9Y+mQf6zdkvBLqQbDWh2Y3b1sTcUohVAChxskePKsNpc5MkgdSTgOrtvag4HGSHj8bF7C9hbIFZiUBChMcfMM9hq/0+kR9WwA3PVtyTN+zIi6uLhC7//JHXcXqcBvuNMIOAIXUu/SReRcJg7plE6X8EuSLEEoq5Uzi+dlzHv70=;20:ablXPzSTlj6cqJssVzo4rxFbSGicQkig0Bhk3VejjSTJryBf6sl5zaBnCacVYVsb9+yliLXEZvTSzQYlNKS2gY/BriG0DvN4Q6+QnJIcQafm78Re3dWcdWKu010Atleo90pvJ1mlmZIfdFUricpq0OIeaJJXQUDUk/eePYo602LQoyIyFhrcUtAq+JSSeVRaw5XKyyW4F8KqtjSCXVCVEbnmD2Zm7HaHHeIK0B1wYVUw5xsTAM6kzfVXjR8qCPMG6eiFGuIQvgdGn489OAbXuqmVM7IOm9OfuXtYxcyuJMjYmuUf1Uk5QarlYB/94eKEz5PLqv7om1Ee19Ng5csM/opdscRXUFYIW+deoX8Dn14rH/oKhI/CwASvdaiUuMbf6VitSBNXIVeMSOuayrqfYMsRQmFnGm4NzjnxVJByMWk6REP0Xilgt+JzGQzgwq75/tveOdwIcV2xeYIVeaHGNJ42kwPkp5be4xVppAyXkBKY+3S4J5fkHRGwvmlBLiRm42PnM51LwnZekIvsdkYNAhbcRrw2DqcZjao1zQGGKMXijEeWhn4Ysxz9labIobEoOeCHMHNMMPlIcS+aUDWBied8Zg6dlzBjMYcax06fSMo=
X-Microsoft-Antispam-PRVS: <DM6PR01MB375547FEFD5EB5D7E26BBB3EB5640@DM6PR01MB3755.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3755;4:9sddnCZWLMtN+sDPgqyt3b3yvcgfk/ggX1gkNLF9+uIUl4TOW4WunBWGWsHzoYe81ncRyWE9hUWc4n7LwNhn6mb/xQaTzKz8CNETFrewaKcYESY3lR1fYw2wpCTFxTYpWNtzRzRBmYCb9jwkp4YhgW+vWJpyCyU7In9HD/ecXnTXEl1IqBSKCIU/qdg8uYf0sefwaRS9186jXGOgoMY7IObGVvDkoinRL3DvooY0daAdlwDRJw1Mhv8YzQOYFsUHf/3ANrXMA7765f2F5Ju73gTLWZJuzWBqW/iOlAcnnmI=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB3755;23:x3i9Rqtqwv7rI+il+rHm3+gboHk7tA/S4CBIwdw3u?=
 =?us-ascii?Q?cnz4GRhuIjGKiDT3aNDdHn75KCF7zlAszYASKOcP9LXFF4pkvp9vqlBHS/PO?=
 =?us-ascii?Q?8USZxb8Zth3Fa+FjrrnXBc8TfE5u8Rq+49A7bjhjwvPySXPJkfMh1qz+5W8O?=
 =?us-ascii?Q?9gcYv/UxJgPQ77iCYMJfxY+U41Gi4Wl/OIL+Bm2DY1+7hufMQmZ5Xmv6q1n3?=
 =?us-ascii?Q?R35nu/wPWrWIxZxM2/Hem/eKdn1VNEx7LUw+HuGfTV9uhWp6P1klkwdc7JbN?=
 =?us-ascii?Q?YRCYqArjD5cn8WQKZLCOhRLpW3zZGtFuXbqw5wB3GBF4BYrsHmCVsrijzkkL?=
 =?us-ascii?Q?RXEj28YFKs0pK5LoSP9Wo/ubWqEPxMgV6goXUP/HvGkSkXBzr+wLdlV5D9OF?=
 =?us-ascii?Q?7eXwuNxnIb4cB7ps9UOVM+ax4WMDtzHkiYvYkGH5Nju1uGhccjGlIf/3F52J?=
 =?us-ascii?Q?oZ28AFC/5dPFr99CsgMWYhzTjx6seEX2Zhj0dk6QIcfiPufT7ncJ+Ksyy1AD?=
 =?us-ascii?Q?EyAjWoWSET0v3R6nCtathrciqRTzJYiuvC20dPm9VnG/Sz2ZG4kul6LKmWgr?=
 =?us-ascii?Q?8RTvWZIijuGGil3FY0WcDHFygULiAoJa964ijDKFubyP0mBf8Pm/Rbe1Y5MO?=
 =?us-ascii?Q?yDhFAFLZp1xEgYcnid5Du6ohdXw+0BjgjM+P8JGvhSjDIkE7Gza62XvweenQ?=
 =?us-ascii?Q?aBEaR40HxB3nYk4Qww7e9S5xLig4avhtQqXDGGyVGosaoxSVyG7BAf1jqndp?=
 =?us-ascii?Q?MpMpX4CRzMsIqWl5AaMrXg13foAYNf29IMd57KWJS+nAIYyol37UAnPtCeuB?=
 =?us-ascii?Q?NrAJKMMxq5mskbeV55lK/f1vxuJ9Kvr1FluCQYbYOJdTSH6em4c+VHf6T6sU?=
 =?us-ascii?Q?dWhh9wRknIuUzYkQ3bnL+chqD6q+Fkp3V3f/IePc8kwqj/vEhV0gBzIJgXxx?=
 =?us-ascii?Q?4zzCIxUFJeuF0tX1glYFpkf3FIbHTCx3pepBA0Ig0Yhk358Hgv/hrqRLPpom?=
 =?us-ascii?Q?Qy+Xf4nlAQsqR4cOhxADtt/x65XVYhztbWecfQ8/LnCUEBFiGam7OzNzL3kv?=
 =?us-ascii?Q?dPcgmxze63/qvnl3VeVvzB0Muknae/iUGRXefXOQh3aFpRwWzeKxPoRhczl0?=
 =?us-ascii?Q?i+MRTFtuZn3+Uulm7NGMYuRAijTAPfnpSuPWjtwnCjyv8eO2lMhOITLmjsbX?=
 =?us-ascii?Q?sbvV3I+YgzccfoW3l8lhK9euqi7ptDiMTpZ4P+gwYD86866o9g+zLKSIw=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 0Eer/s5MVqms6Qnpn6pKi9LTmKYPuyrc+sj5K8qCJ52zfGxuuyZCcbHlwiKMmS0vzt5iSrA8SZzVopcX9pmnskqsK+Z6CLeX4tQueFFwOODuGvlUrByKoOBOplfWiH5Zi6Z4TL0IOGRlhsIfK7WiIX+VlUqHb2D38PVC8hOQL9VD3MXHqLcoWTXKS+pObWFSn4D+6rWRfUxMcPnVkn8YsZGLYaVZo1xlXO9tvduwz7ELqXTM6kJNn5qLeU7o7fhatiCWNcsPcCZNZXBIbhZLDshl/ryRsTLLQ1wjPwQQgrG6MIPDiHhDNhZK/fr7kqv+GS2HACoklvKk7PtV1y5WlBZZbeT1axnmlJvx2ItgoFjb11AD8IZ8BKoLqvz4yapng7aYhtDADItwbuWexvh4IFKmcHNCjSIDnxd8vD3Zz6E=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3755;6:Z6RND9mBHEcvg1Fq9gT4m12NMjXeSu43fcbsloUspBzt019tbSBmH4TQPvps4NYnEMx9mguhULYRg2gEz+UtFsme3CJMIqdNI7pZRbGE1E9eZ62KttlTNwot4JLpUfsnJAa4SNHiUNb6/z+OeR7CO+XAcqAzOf3jMj0jrbJfaQ4OWUuS+ZCN5YGT/PFEn4o/at6S7v7EQNaIhPmIfE7R+JduBr+guYB0GbhnzBm10GsyRxUhLUWOfaj/Zf+Tdsa/rQDIIdEuu62SyiIyt0O+vWS3+WP+MPN2qbpOS+P3Iw3f4rHtpy1cMjijI65BXdkewSZPsMqL7qxASGYKGt9WRUsvkfIroQzhJxv56HEqKkT3Oy/2tjYmhXh8ihZQZ2G2jKnyt37xWM0krHyeDdcn8cAZuCZ5U+ionKlEqRyVpmrGQazeGFzqN4vquQcc1Np/uRh02QpDw96IIpWMGGr3RQ==;5:HnTfOchObYwk8LmWnZ4PCQ1dbLm2sDRCaNDNNTGEurMC7cstf4/7fj0eaEM3y9FufJQjOqRYpsvu223NJMMcEPtt97zKCFBrCiRfur1Wc8XGYR474+BMeyIwbPjqPaHaHClufz+EM9XDOwJCkX8ogk2csygMkokmv0cOfaDd7LT453lBW/lwq9R7LNJcebCBAcA7BDUWO0evmNZdIOxOqw==;7:MyyBMaE8K3ZKr4Bl2RnIP58sjJEBidzOQcWcQEb3atyS7UxnCQMBEXdfvOJT739gtYzbsu3OuyXoL/UUtUVFU2wrbzJWWaLUe1RBkYFMgudIOWPkltddyWfGdFH/TWRUdpKaebF8h3qxq4VaOrDUxQ==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 04:31:31.0483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c79946bc-d7b9-440b-96dc-08d68fd9cc27
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3755
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 30, 2019 at 02:49:38PM +0800, zhangyi (F) wrote:
> We do not unmap and clear dirty flag when forgetting a buffer without
> journal or does not belongs to any transaction, so the invalid dirty
> data may still be written to the disk later. It's fine if the
> corresponding block is never used before the next mount, and it's also
> fine that we invoke clean_bdev_aliases() related functions to unmap
> the block device mapping when re-allocating such freed block as data
> block. But this logic is somewhat fragile and risky that may lead to
> data corruption if we forget to clean bdev aliases. So, It's better to
> discard dirty data during forget time.
> 
> We have been already handled all the cases of forgetting journalled
> buffer, this patch deal with the remaining two cases.
> 
> - buffer is not journalled yet,
> - buffer is journalled but doesn't belongs to any transaction.
> 
> We invoke __bforget() instead of __brelese() when forgetting an
> un-journalled buffer in jbd2_journal_forget(). After this patch we can
> remove all clean_bdev_aliases() related calls in ext4.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

				- Ted
