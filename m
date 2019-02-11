Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57646C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1C752146F
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:07:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="v0MU5oIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbfBKEHU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 10 Feb 2019 23:07:20 -0500
Received: from mail-eopbgr760092.outbound.protection.outlook.com ([40.107.76.92]:38749
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfBKEHU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Feb 2019 23:07:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T55/htN10SUOZnHNTXg+RXyAnXqLuJ/uQ1Lnw8YCdRI=;
 b=v0MU5oIfMfDxj2B15shGN/EZUgW2cM4xWjlBLwLYvzhpdwB0LMc9h8M34b6QeOyOzzBcLlCNk9QiL+q/ONj+uwFoU9+7NJGB1UMWQb/cExjFlaIIPsMOXbET3uJf8t7gFTQRKMf0grfT92jNqlbqUMeP1WegURALsR3Xba4QYV0=
Received: from SN6PR0102CA0007.prod.exchangelabs.com (2603:10b6:805:1::20) by
 DM6PR01MB4489.prod.exchangelabs.com (2603:10b6:5:78::24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Mon, 11 Feb 2019 04:07:15 +0000
Received: from DM3NAM03FT020.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::201) by SN6PR0102CA0007.outlook.office365.com
 (2603:10b6:805:1::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.19 via Frontend
 Transport; Mon, 11 Feb 2019 04:07:15 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT020.mail.protection.outlook.com (10.152.82.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 04:07:14 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B47CP8017087
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Feb 2019 23:07:13 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 656D67A4EAE; Sun, 10 Feb 2019 23:07:12 -0500 (EST)
Date:   Sun, 10 Feb 2019 23:07:12 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Nikolay Borisov <nborisov@suse.com>
CC:     <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: Replace opencoded i_writecount usage with
 inode_is_open_for_write
Message-ID: <20190211040712.GD23000@mit.edu>
References: <20181211082355.19841-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181211082355.19841-1-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(396003)(39860400002)(2980300002)(199004)(189003)(16586007)(106002)(54906003)(1076003)(8936002)(336012)(126002)(33656002)(11346002)(476003)(2616005)(446003)(106466001)(58126008)(186003)(26005)(4744005)(356004)(76176011)(46406003)(8676002)(103686004)(246002)(50466002)(97756001)(47776003)(229853002)(88552002)(23726003)(4326008)(305945005)(2906002)(486006)(90966002)(6916009)(6246003)(6266002)(786003)(316002)(42186006)(36906005)(36756003)(75432002)(478600001)(26826003)(52956003)(86362001)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB4489;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT020;1:m/kG9NXIxrJT8AG3jEGu8/CCW3v0DTirwFIVsdHFRahDEcYaDKLSAWTSp5aR7QxzaMpEJ+dB8syjAu3W1vqBl5vRRyJGn/ZgNLJb/1dkdLaJ8cFg1flyJ65PIgPe7jIv3n68w5UduhKDbL0CY8Y3pJ3BTVYl26PqCQHnT84T0gI=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb77ca71-95a3-4e46-9992-08d68fd66825
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:DM6PR01MB4489;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4489;3:cqGTbmiMhedhPcVef1wBD+rFctp10OgTvFgpYBUH5nVwX/PkpjoFu4HKx7gn+hh/ZmDQ+H17vd+8wi+E2PiU+ltWsbMw8lEI8P5jXcPejB5uCU/s9jKQJ7R4WpILonjtRUAPyhCOYT44IUvKJrv1CsUMoZU8g9tWVxkA940vCNq5y+Q+Asnnx6HbvTTqmN+bkHf2Dd6g4segoA/Xq75oQ5vVcvANSWPd89lw03zRFBXME4UuEdVuX6RkkCVasSTJC4254TC8rcwr1ecF8M12eOAa5HdoXoLUbgm9HA9pIlZNbjqHw+/yHNGByrKnyG6I3W7fpCn3yFLrnJYSycV26E9r2APVG8sobQoTMs9ObhtiqFj3yH2oTmIcEzxT+kVn;25:ba2K5OKEeAN1OUTDZy5nKOshwpiVOvsAImRwfO3mdA9UpvW19NVb7PCfswKySl/sImKTLCOAypzAXwKWnxG4zj6q95ho0YFp3vAeqvWK+J/WTEn0NEZ2C5ZyHrxu3mnr8CHhlfvMQLqQOc9/fVa7xzq3N7cn04E4iw7u1yXHy63dVl2jAg04BhPm9IWdu6sLSe4J+y7N6fK6s4jwwbvQhGbavAh6Z0Y2iH/QP25SJAHUT/FC9bCUR9dj2EQYl9vnjyCcqUbGbzt/7HfR9yA/BXh1dAR2utJCXranrVqxY2p+EFp6omQQS9Gx8daDc5ZPPIjSwncaLF8RDa1yRkAMPw==
X-MS-TrafficTypeDiagnostic: DM6PR01MB4489:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4489;31:p4s/yWRbGlRCHJJTlTAm7NdMlQGnD6jLvoXSFGF9WwV0j5A8PPmL0COPJV8mmztaiUPtuJQDskxM6adWgYXwZvhgNddS6zsUxVxgFd2ONpCW25srkHop0OK/kbYxlKhYRqU4cwYI/mMs7U7P7qzLxQOkjmmUZkNTA2KhIkUQ0rTc8faLruh0wgoTImMqS11kl8IRBp+5vRpIXJA64iucZ4NLDbEax1YJnD9WfutKdM4=;20:0Dqj8y2w4SDVY4Kj/o2dtx+lnX82K/aNQyfjyWIIfbTAS/1WVKxmfDaIG06ewvIM10NIO/hdcxYhiAbkv+goyMWLmMXXSdZI4qERBtycOscxGeV+cAuD/SrTTqjGwj8Tbx8tFjI1KxuaGzn2pd15R4pnsGRRjqM/TrgVpyOce4VTGnTih0pnNFitkPqUopWy1nIiP7XXMvuYs2Zru+aMK3PTHfcuScguwy8QsM7G8VPRrumf+N1Tjo3EMpKjUwgiorz9L9N7CW+O/3bZohDDSlu0STzIVyoBy1ou7t2fOQ6zhkSZ514Mxr4rjFDl3eDmTfVd6H37UtY5tA7Kg+wubZAx0UHStl4Qtz206v1+/C4p6rXS1ajBWkVyRhsLzy+/5E+IMY/lJwKLEAOwzgL97FYD370RQVCwVmWwd1h+/b6fNY9YjJk7sCo8ayqyhswaKLC+rIdU7ohV/MkOFT3EP6q0POMbY0WcUAXW8kCBkh4UKRE6D60ufSN5E55LOVT5L9GqBvTNlEt8q/zmp5WwHWfPaXZQ81aLIoLZC+cAbf2uGKSthwuIYhZ6EhM/fuapjsGAZ3cluRb5sw/Yx2pbFHhGs51SMNTk79Pz0nt4IvA=
X-Microsoft-Antispam-PRVS: <DM6PR01MB44898E064D6F9E6E71F8C717B5640@DM6PR01MB4489.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4489;4:MUY7RvfXpHvZgEyPNhQGakCCVX4oXDH0h8diSll1Cu7hFqfe+UKu+EFwYL9Rp5JUZqTE+E4C5rgQr4ko/pjlbFap4hzrWv9ffbGTfzgxaj7aZIPOAKm7gOn9fyUqT4FVEdhpbxTnlq+KrQNfJR6ZXanj9UdF1T8vRJxiFqktbiCuLDQmcy0gVmkts4S23bw+jexZdTqOiBJaMofmDomEdxue8tezAwLNbKZnucKsP3Y9qAu8GGZ/jVToimD4cbfYrDHAuR4SS/vNvxFMWRAzMlM+Yv2m9uNKDDhvKYh3x9Q=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB4489;23:VYlvzy+P3XAFAX8/9nSiybilwxjWRDVdju90bOwij?=
 =?us-ascii?Q?D2e/gdGv1sZ0j+48rjBREBb78fHf/hNjzILJb11NcyeVwgMQHK4ihUL9WTIL?=
 =?us-ascii?Q?wezIKv/DoZFykfppfFaP0yPDdrk7CdB+AYFnms2LvxqjDubnDQp4IqeX2bK9?=
 =?us-ascii?Q?eybLkthWLQaOHogZPfdIdaNgEw4W5qwzJHu6u1atUMNwEih7wXX8e4l58Njw?=
 =?us-ascii?Q?bfZgcR8KwTqwu/AftQdyxM81xJ6NOuxFuCNlZ3zzhcctTmYmqO1wGEzbS1oV?=
 =?us-ascii?Q?Xm/6Txrnix/7ZBE1r8e+3RduV2pY7TB5zwqtBzhkH9oAfvQD6vZeZ2CiH3g5?=
 =?us-ascii?Q?iM78A6rL2VdJQQuNeJKs0HuesJ0cBmKI130cqrvAH3pub6goGmlWCd4LV5sM?=
 =?us-ascii?Q?ElhPMGWGiMejk5cZ/WBrSxa1yUAxIJJbgbTWpp+oOvR7SnXq8yY9tizt+rJP?=
 =?us-ascii?Q?DeY4KtYF7gfK6hwJt6YDO4Z3AA3A8EjPHxLoO/miFKV0hh4aU/JhaNPVkgX4?=
 =?us-ascii?Q?T/kRKjJRYFh0OfWcewjm1F3SedcFB1Y/zy6rcDtFMkHsS5e2Zfm1MUMimW9i?=
 =?us-ascii?Q?hTJAEee2g9HJt/yJ6agGyydrQn+ce7X5HkXpn5ZC3T84EmeVnG3kqTnz9tyJ?=
 =?us-ascii?Q?GI9kE++SXeMWImyqKhI7rR1kbOZe8wPU0Xbl8OTgeT11vESJ5obKLZJGRhdi?=
 =?us-ascii?Q?ppyVbccGTEIk/E++YVmvhYNI0Jfl5jCQLrM6uJ4tBhUgt3Z3L7X5rZdj9t1s?=
 =?us-ascii?Q?LgrYdcNTC4L51ZWQa4APYqIUeaJptVh4CPInpDHAJ1i3uvuZKty6+BgJrODr?=
 =?us-ascii?Q?au5wGbwLW+6SKGvAa8/ZnXRSHMcR4ppE33Bv3zv5VLfOoru3krlo4H2PwYuj?=
 =?us-ascii?Q?vBufbYK4qb7iki/Pc4e/mHFnhoKKf5fzuZYqYqu4VS4PTmh4z9xkWHhBXJxS?=
 =?us-ascii?Q?46qvsfwjdFglzdizCGdNtYj471c9YlluabwrrGPsuK9BOcjNULqM0DIi4W4V?=
 =?us-ascii?Q?3Ubw/zz0X+MKNR+7NWF+OFJFDYfgN45InRmWTOSk5qKNiS1CoyLjnoceRbuH?=
 =?us-ascii?Q?FLpvppvvRKnLEh0noKtGLXbGSfLfhoS5/+b+1WHMT7otduHoAfZgVe7HYzKo?=
 =?us-ascii?Q?y90wrgQ+6wTvylQI1XWn8AZB/Cvh26DNQYNAsvSE/pVcn+AXRS16xO8FdiBA?=
 =?us-ascii?Q?pdY/3+wB5zi4A6o067lXRSbRqsFQaz5FyypmWwaN0MUxADqtRF2pJZnSg=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: iZ0oL2wGtSU7mmYnOnS6K47wrXMJfge/nO0Qc7kgmgrxc9JakxX3WwW86d4K8VvzIgva7AbXRhS4Lju4puMhkrqgNknj0NO4XyLQvuDQ4iV+fgUy2wwlKhpMkgktt5cvxctbzVD2BLhraFV19GviKij1p5HkuOZq288/CMb/c+B7cTwpH9i+vPe5a2S8WW3CsO5SgVEYen2ce+D3Zr0cSX9x2c9yTx+QBIdNB4v4gd6LXeLCmDC7W5cBpOHtVaid/oUIDceVKAVi3jRHJAHbI5kgljPZkU66LGv2Q9YBSlYt4xIPEx4y2F+IF9ClgamZDjuIjq+h0z6W4pH0EksTAF6uudzPQpJfQpH11deIre2ww592gBaQ/31LDZYSj8A2Y3/cCy+We0Nxh02GjI+R0mmPoQDmeCdXzjz8L4DIMLo=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4489;6:YOt9kTjyllxwoKovxG/7Oy4I0fAnfKySgzYrY9jfcNylYf2HflSmZdpAjduSxAPHo30gfgBhXq+8hhuNG2+joz9jNrgjWAzXKHzhLU2elMOoL/8jDTwYhA8dzEgbg1W/x206vUZ/FpUutEGcrie05tD9uGA+0lveOofaxCnHlhtaNN3ywWNWYV6hr4ZLyDJp8IExi/8MENdK+s1SeR88XGC76qgFwb6KcXQ4Mt1tE4GQy63MI08WwsrIjW1F2YT+KLvVjbv3PdlJsh2zCJU8idWWmYHY1P/ME/xtyQ0smfFuioso2DnAY5BqGW4xn044ledetVWaSVc635NeADnwr7SRa9p6HZlta4pberMJJ/vjld2hntBCcbqUwpkz5Sr5VEPE2nOvf7l3PVN8yIkBDEPBZBlkTW3IqVZSRND2HDEgRMwbjlKg9mT6GlKbunnLaosdwtwLkvMfKlG6ehniKw==;5:VXn4kxVDP7FCCqTWYcOMe+QcpPZEoXu0aVC2iJ9yVQa9vvE0863a4cG6sjV7Medb/tYONjb1dYwfpeseJH4hmUGp6e1dZtM79LO0nqy8E0ZIHpU/L8Nin2UIMFdxWUNHON2XY681l+YcsCHzaJXoKv64jN3OjbF5zBwOORjEcZ+TuUVpvFOrkhkhBG+4BaB75EA/CI+fS+0XJIKyKXeQEA==;7:tuxwV++PRX/bz8VOTE6GSliI2G9BVwzZq1PG0deCTTBbT1wdxDoTKrRZ+kZ5fv79DhQ16yfdQBz8OLoUgEntpzqesInaE734MvfGQP1j2gNG/LogOUDLkOMPK5HA/T4qKOZ2iTAUd4Q+Gt1vtpLGFQ==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 04:07:14.9429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb77ca71-95a3-4e46-9992-08d68fd66825
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4489
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Dec 11, 2018 at 10:23:55AM +0200, Nikolay Borisov wrote:
> There is a function which clearly conveys the objective of checking
> i_writecount. Additionally the usage in ext4_mb_initialize_context was
> wrong, since a node would have wrongfully been reported as writable if
> i_writecount had a negative value (MMAP_DENY_WRITE).
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Thanks, applied.

					- Ted
