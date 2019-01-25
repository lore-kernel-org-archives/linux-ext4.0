Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89592C282C0
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 05:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32C98218CD
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 05:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="WBqMti6t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfAYFMf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:12:35 -0500
Received: from mail-eopbgr750107.outbound.protection.outlook.com ([40.107.75.107]:47196
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbfAYFMf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 25 Jan 2019 00:12:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JsKGI8tO2R+cjr/+uCvoiUoE+6cnrQwypp+HJJJn/M=;
 b=WBqMti6tXekywf5ELl3F7ThvXswtoBWrAbaINxWfdP5pfVKT49O5MWKqiiNIVFhHD39CFEtAar9donZntg4NeuX3v+yxqX+xzqJhp0F4DLury6Dt/Ey7Fus8gHgLmTcqFuJW8LostBxkbjyIs9mYT0n0P+jKi7Qr4MswJhJy3aE=
Received: from BL0PR0102CA0013.prod.exchangelabs.com (2603:10b6:207:18::26) by
 DM6PR01MB3755.prod.exchangelabs.com (2603:10b6:5:82::20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.16; Fri, 25 Jan 2019 05:12:30 +0000
Received: from CO1NAM03FT020.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::208) by BL0PR0102CA0013.outlook.office365.com
 (2603:10b6:207:18::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.17 via Frontend
 Transport; Fri, 25 Jan 2019 05:12:30 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT020.mail.protection.outlook.com (10.152.80.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.11 via Frontend Transport; Fri, 25 Jan 2019 05:12:29 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x0P5CR0Q025643
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jan 2019 00:12:28 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6E0817A4CC1; Fri, 25 Jan 2019 00:12:27 -0500 (EST)
Date:   Fri, 25 Jan 2019 00:12:27 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     <harshadshirwadkar@gmail.com>
CC:     <umka@cloudlinux.com>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: shrink directory when last block is empty
Message-ID: <20190125051227.GI8785@mit.edu>
References: <CAD+ocbwgH6bHrPqB0ERM2YA703nASqRzLYCu-eJQn1uFgh1ivg@mail.gmail.com>
 <20190123183245.154246-1-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190123183245.154246-1-harshadshirwadkar@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(136003)(396003)(2980300002)(199004)(189003)(23726003)(50466002)(90966002)(229853002)(76176011)(356004)(6916009)(6246003)(6266002)(246002)(36756003)(33656002)(8676002)(8936002)(47776003)(36906005)(16586007)(26826003)(42186006)(316002)(786003)(46406003)(58126008)(54906003)(478600001)(86362001)(52956003)(106002)(305945005)(4326008)(39060400002)(126002)(26005)(486006)(11346002)(446003)(476003)(2616005)(2351001)(106466001)(336012)(103686004)(14444005)(2906002)(75432002)(88552002)(97756001)(186003)(1076003)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB3755;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT020;1:MdKrykIWGep6yAy0WuoN7kdrUTI8pD3BQSYNGoYDu+UtU5JFq7mLNdtg1TY13I1YJ81W+VeI8COqUT9wi09/oKK8NsrBJQQAJD31JRdLHcbSG7AizTM7LtRAWDEE/Z5EPI80j8AjnYmZXj7Ngbi5AFa4vrzQ0Ix6EvIfC8H3r8E=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 531e812e-18f8-4f16-6817-08d68283b490
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:DM6PR01MB3755;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3755;3:XXLDtLdG330AyzHdj8qXI2RLCRJJPuXS0mIPWYjobJuoI9j0ZSa0us+vDMkkkHcVxfy+yjy3Ehdaq5ZD8MZIsTP4pGV/GAa2bh3cb6oiQ6FVA5MK8EerWY9dCHBoZJE/jsI7t6lR40uvyBrq9DCsDS/dFXQb8tn/7rBoJjoDZ20pkaXyY4uV1biW99fsDwS4NEgPHtLcvlVgumEpot7fapMhMNA8CfttukOmGYBO9yRbhQEWwHWdTVzQKMMu1CxGqTxDNGscSxaLj77uJwWlRKLsxeNsa7DBy22P7HBr3m7USKt6LyDalJ5pxv50wHp/kyiengSdqk9kdWlf3NSe9kGpaeVmIDkyCkhu30flHKT0nhsUhVE8osec+MZ0C9Cn;25:98cfcU/IPIZKzUIqdZTn5L1VGpB1qJqGbeHBoDXdcpEUWT1L5fo7VT8kc3COfjjfPdMo9a+LTmGpTk5mn2c62YEQQ6TV6bMjk9RSrB9V5UVBaevY0wHnpcpmusiIfrezTSWPkrbonhNHdEYDUVyeRjl1zf6F0F7Y7lu9+rHpbqCQhAS5+E66QIhonLf/V03NznX0RCScQAbKyd5Vy0ps2dS9nXgIZ/nws5JDPB3bGIdZkmYiIzsHIE0NmNhurqnfqAqFy603Al+ndev9IqdYVw/G69Gy1Jbmkt3432pqQE4tcZ6dF9OudR4M9Zmj3ZGN5o/wdckTU15q5HjwJRUPdA==
X-MS-TrafficTypeDiagnostic: DM6PR01MB3755:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3755;31:AzQ1EKF/yCcBTnFUguHhSKQ8Ddq5UGwk348+FnkR+N/iAvRRQgfx3/xpUz72p1GR+NoIK0AJU5byXINU9+b7K0GU8I0GN6oWbwlnRyYHGdWaMN21f4BGBnNBa7CEe6nTAi3lrBCiq6pdzrJ4Y+G31MC/wuQxVN/pr6tqArB6l6O4ieMjRdykazBHLHp+59zJk5iZAyOrDKUvqEh0jzzVAVO91UOsMPT9rzukBx0OwxE=;20:E431G+a4uNcPwGFI72Bv1C1uGNu1THG22EXJ0ddRdgbsjHA4ftNtl9AVSMIHeA6iAzThWCuYAuBqEa/Kv8UfYVme3ROVe22Pz1U1YJokAb2l+N+CZTvRBabXwnf6lQ/YJIwZHVHddr4c517X9pHXbx6GWSoG9V2A8e1KjKZTQ+3HJmLe6BVntQpfL8k8Z7W7CvFFSgkv9Sb50vUVoYzQAb1k4nY7/I3pFghmrNWX6fohG/X8R+w+myjScWv02EW74zI3RzWcVjDhYmkjTmht8T1GkcVbmkPAnPFNKHtzrXICbBC/ZSXGKS4IwnFzpItDrYB1l0Sy9nw+0KdIrhNe7kwKFeYaSwtiQ5xvmO3mmA8Knp+P/skQKkGIOGksJWgSAx+A+Fscfunhd3HC7pg4rXyROMFjuBKUF3HbpsXTrAvwofhXN6Sblq+0032YZlJa95Cs0KVsZ7lPj2l+w8K9y3hz8rlnC+0ZPbUYvRs9LNp/2cgdnIq9e4mzD67DQEVsoonWFlB8OWK2ExOqXzZKXiaHELkZ+80glVeMG2FzYvdqmJs86aeEFszAChgXqajolGqF+PGeHpknfEdJVKtEBR6HZu1Nhe3bfjsE9nIUS+U=
X-Microsoft-Antispam-PRVS: <DM6PR01MB37551FE98D1D557BFB013333B59B0@DM6PR01MB3755.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3755;4:4f/IjyGBS364pMjCvSULu30Hm4ueprUIU3Z4W+RE3xrC6Rh95gFIdJMdKCC64kL4DvVcZSu2kdRRKuPYEFRESGgi+j/3mYu93UxM0hOuXFnrDMX+YsNDzPyl1VFNjZbjJxILMfDrCntOLspX0uSZAF0mP5haouxj9zPrSS9pvLjgD3rRJvbJMaptDPteTTNyWIgCe1r1Z3HtpCmCjBG0pd/nqph5pO/MzpTyq86bGfSvfeTgDuqSpqQBF5OuCdD71Gg1GGCuX8KIsFy2rqPbxSsVs/gAr9OpFCleuxVyzdxew3oht9k86MqzYZN9646Y
X-Forefront-PRVS: 0928072091
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB3755;23:t/H9dvaPajT+LqtlORPsAyvj5fp5EzSw14aCiKhK/?=
 =?us-ascii?Q?XBGr6OlusLksDUT8h0JLIkjxNiYbjdr719WORhuAKCbimQAPMVPhGGd7J80J?=
 =?us-ascii?Q?OUGq3okw0v9HcjlNvEfhwcqEyIfirISfKlxYHQAIlFuRKYNnJHzgd3P9P/tY?=
 =?us-ascii?Q?9WNxhvHhNVODaKn7zPRCjERKANStud5pzCGE6adPdXAk+Z11qy+UysG7LTPI?=
 =?us-ascii?Q?6Iw4k9y0hKyH7eGozP+q1U8tUKI2VJDeRA/rZvPNEC557xfrqQavUJDkBucn?=
 =?us-ascii?Q?KA3DTJf+BQDm5JFTZl7ynwrZhnU2qC66/3Mm0tl1YiVqRVt6ieTwIyt6MJJm?=
 =?us-ascii?Q?wRfI8wJxhUlPNq2snes34T6lp3xd3wLyXK993wT5FGLsGVjwTj8UYbICUDh3?=
 =?us-ascii?Q?TB7obCFlLDe4+23wDndpjkaXri/frcU5jHk33kTBXa5cirWxJmafj1YxoDR3?=
 =?us-ascii?Q?VOk5derode6XsVSmq57x7kdHT7WKamAzuVkhrF5YZvDgFmjQlPrALh3vIH0N?=
 =?us-ascii?Q?J7E8h5PMKfhdj7ynRmyKRsVfmLnZaOqNtIJeCHhvXBgA6uzN06DB3g95tZ84?=
 =?us-ascii?Q?nEtelrjtcfQx8yul0poz/DkJtZ3gdRREVKJDg8HgN+r26dXG318Eo5GpR/Sr?=
 =?us-ascii?Q?WK5Bd9yafTh9D3DQcA7wuhr02xkCN/Sq6GrOyJu4hxXjg7Me4OvLu6loVG2N?=
 =?us-ascii?Q?3WLNViDmA+DHFJTGek/ZRUU+KHjqNlTycK7C+HOTnv3dcSj5tajPGgxb7bTJ?=
 =?us-ascii?Q?MHeICB75F6mdZV8FC+XJSgEVvt6PeuBbw/GakYydn5jWGBsO6Xuf30Pqy2kf?=
 =?us-ascii?Q?2kMoPPNpbFpp/32x2FohaPrq7DrDfIPeE2EZzS6wKgg3HSYlSpuVTTIak/Th?=
 =?us-ascii?Q?wy/VzcDYqmRnJYeu45SF6RSwrSzO+J4x5kfe7y12tLpJZuG8+SuY9tNIuWUI?=
 =?us-ascii?Q?TZBe92ec10n8UhAlap36LjezcFup3bM4BAC5OlJqaaBKRuYWkNT/T7L8NlEv?=
 =?us-ascii?Q?2Szx72gKvNSagAT8B6JrT5bEWgloq+4kYCXQm1ckM45a9tnzmc+O9deiUV5V?=
 =?us-ascii?Q?p+dvUU0efFbGn+GMV9EQPMDssygl3ZGMQiYkGECI0+euzCfvuSF2XXwZ61p/?=
 =?us-ascii?Q?QhMf8FZI9CEu29KBMkKYrsazVXBje7kUuGu6xQPp6Tt5VEgZAhdIlRVyMUZP?=
 =?us-ascii?Q?qSg2rK0Jpy+LpLL8GKTSYorMPpqfyJBbWEGUvHbbhdfmz0SUdmVxYNg0bi3k?=
 =?us-ascii?Q?HXru/sG/8r1XSOaEmMbOLvEbOq5I2ilT/9VBvpZ?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ox2E+0ruXMTN4ycPdWTP7FJbIbk1uXIWmIHTdBMQTwADC4F83kPwhTG2sWKUS8vyoXW/GE+MEizubtzS0Oi7lr3h6NNa9L/d4I8bz0dC5vQmI6bxFgmphFSaTgiwi62gmUWWd2qhRBuiU/bx4HykASwadmM5r7IWackTDylLyr43QZE96eQROLb4S9QiyGC2qFxalDM2kgKdVhAirE9h5n0dHte3tQ5a+ooxUxyiH+EMEfUq4tGDqLsVbiuXVD8aHIgay3Z0NmiHtqzqyQorugpn9sd3mTfrMoIIy2Ws5qpSWltCBG8QiQYBzCVau4VaK+fQb9oaRCJa85DPuOdKY0XU1/89MF1tGXRHjzQxEnYECzdgDG+fCfqwywDWzuw1G/2d2rTV3LbUaoex3/PUm3gQJsUV88vasE3jbWmFZfw=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3755;6:WavdPhK5wCWaoTiq4wyEEKVyPEkdZY9bGKlRNeB4GSGMKek1LZD39f5a+P0cQoBdVvC58EhmcMYp/2dKV4EfXXA/3pomtmRZngq+bB5xcOUZomIbp8yjxOMffnEiWt3BP09CmaIP0TZWYDGHZPu/G9UQXIizY24AXD8iuTovJfVd9xMjKvF4f79btUpU4ifxUqNTC46wJnGmKUDrVeGbqKeTwKjXpgJraKWlr0IRAWQ5YJ2SuBNBulPIq13lmZqIqaIY8Du6DVDjd/QVXegk6WQLGD6o/8rWSel9TBeqj3HAMYN30qyGnFCuYfA8tdnQlWGFeBTh1xLNNP3/eVndrEVpQ8woIU+Hg/JE53GyDnKEzn4OkZxdrR3oScgcQytQgD65DUlc5hlZsQ9mxO/WObO/HgwEPoJeeGoj7aC0Mc/zPQXvXjFTno5//B3W7Wk9aGds+XNh2XpGGsrAxj2L6w==;5:ZVQbZjeC9yG7rWP/hDmXK0QEK5J1yqKbofgw7CSVxDBQmmyD4V3Tv05UPEteZq1lXb/tC7/j2adNueribBoDQQyP2thZw2ljnr5BC+1LH5tyu97zVsNTIzss17Vk672qlADYEdMO45fGmWIzF1u+n9nA3FcHy3CrszE1WYtqwykrDBbPb4bTxvBZ0c4c1/caLtvXJXn/314HFNMVr1KPYw==;7:C9FzgWxfJXLKC1slLUAaiOQ1dWUM5vGMDgaq9ikuDZlGutGllNnJNIgrwBGE8IIMv4aNShXWMdc07JVqp4rPP+ETMIOlNSn7B0mSfDC8wATWpQaMAGOUXsBBopZnNkCzi8Q472OqXVMAP9SlnhcHbg==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2019 05:12:29.7130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 531e812e-18f8-4f16-6817-08d68283b490
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3755
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When you send a new version of the patch, it's good add [PATCH -v2] to
the subject prefix.  What I will usually do is run:

	rm -rf /tmp/p; git format-patch -o /tmp/p -1

and then edit the resulting patch in /tmp/p/0001-* before sending it
out via:

	git send-email --to=linux-ext4 --in-reply-to=<msgid> /tmp/p/*"

where I have an the following entry in ~/.mail_aliases:

alias linux-ext4 Ext4 Developers List <linux-ext4@vger.kernel.org>

Or you can use the subject-prefix option for git send-email and
git-format-patch.  I usually call git format-patch explicitly, since
if you are going to comments explaining what changed between the v1
and v2 patch (after the --- line), I'll needed to do that anyway.

> @@ -380,6 +381,7 @@ static void ext4_dirent_csum_set(struct inode *inode,
>  					   (void *)t - (void *)dirent);
>  }
>  
> +
>  int ext4_handle_dirty_dirent_node(handle_t *handle,
>  				  struct inode *inode,
>  				  struct buffer_head *bh)

Extra blank line added above?


> @@ -797,7 +799,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
>  	dxtrace(printk("Look up %x", hash));
>  	while (1) {
>  		count = dx_get_count(entries);
> -		if (!count || count > dx_get_limit(entries)) {
> +		if (count > dx_get_limit(entries)) {
>  			ext4_warning_inode(dir,
>  					   "dx entry: count %u beyond limit %u",
>  					   count, dx_get_limit(entries));

This was added because ext4_dx_delete_entry() can end up leaving an
interior node with no entries, right?  So this change stops the
warning from triggering.  The problem is after the warning, we fall
back to a brute-force linear search of the directory; and this will
happen if the file system is subsequently mounted on an old kernel
that doesn't have this change.

We have two choices here.  The first to simply not remove the last
directory block if it will result in an empty interior node.  That's
not particularly satisfying, but it's probably the simplest approach.
The other thing we can do is to try to remove the interior node; but
that gets tricky, since we now have to edit the parent node (and if
there is no parent node, handle the case of the now-completely empty
directory).

We also have to figure out what to do with that interior node.  We
can't just deallocate it, since that would leave a hole in the
directory and that could trigger the ext4_error_inode() call in
__ext4_read_dirblock().  So we would need to leave it as an "fake"
interior node which looks like an empty directory entry (in case of
the fallback to linear search option), but with soomething that makes
it clear that it is an orphaned interior node that can get garbage
collected or reused as a leaf block later.

The second choice is the right one, but it's more complicated.  So we
may want to leave that to a future patch, and keep this change small
and simple.

> @@ -1309,6 +1347,14 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
>  	return 0;
>  }
>  
> +static int is_empty_dirent_block(struct inode *dir, struct buffer_head *bh)
> +{
> +	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)bh->b_data;
> +
> +	return (ext4_rec_len_from_disk(de->rec_len, dir->i_sb->s_blocksize)
> +		== dir->i_sb->s_blocksize);
> +}
> +

You should also check to make sure de->inode is zero.

> @@ -1502,6 +1550,10 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
>  	frame = dx_probe(fname, dir, NULL, frames);
>  	if (IS_ERR(frame))
>  		return (struct buffer_head *) frame;
> +	if (dx_frame) {
> +		*dx_frame = *frame;
> +		get_bh(dx_frame->bh);
> +	}

This should happen at the end of ext4_dx_find_entry(), and only if it
returns success.  On an error case, we should not fill in dx_frame and
bump the refcount on dx_frame->bh.  Otherwise, unless the callers are
very careful to remember to remember to call brelse(dx_frame->bh) in
the error case, or else we'll have a buffer head leak.


Module these issues, it looks good!  What sort of testing have you
done with this patch?  I recommend using gce-xfstests -g quick before
you send out a patch for review, just to save yourself (and me!) time.

Thanks,

					- Ted
