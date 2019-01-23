Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA9BC282C0
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 05:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C3AB217D4
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 05:30:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="TovcpZ8S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfAWFao (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 00:30:44 -0500
Received: from mail-eopbgr800129.outbound.protection.outlook.com ([40.107.80.129]:9280
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfAWFao (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Jan 2019 00:30:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4dftK+to0zuPSyElCIdiq8XsCQLIN3mOkkNXXAIVlw=;
 b=TovcpZ8Sljn2bDm06iQZYS4qGdO4xU/OFLhBdsI21I6S1Ay7AZeNg2LyrQFwcfSHwYchxgxFJCDWlY4U0wazA6SpHkqvx8uBb9W33vw20tH+BuFnBCEvS8x+14P8O5p0ueuEUatRiOjgMoIKwESPbZetgstQRnkhq64d/sYR3+c=
Received: from DM5PR0101CA0014.prod.exchangelabs.com (2603:10b6:4:28::27) by
 DM6PR01MB3753.prod.exchangelabs.com (2603:10b6:5:82::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.16; Wed, 23 Jan 2019 05:30:39 +0000
Received: from BY2NAM03FT037.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::203) by DM5PR0101CA0014.outlook.office365.com
 (2603:10b6:4:28::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.17 via Frontend
 Transport; Wed, 23 Jan 2019 05:30:39 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT037.mail.protection.outlook.com (10.152.84.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.11 via Frontend Transport; Wed, 23 Jan 2019 05:30:38 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x0N5UZ3A012878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jan 2019 00:30:37 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 7EF037A4C0E; Wed, 23 Jan 2019 00:30:35 -0500 (EST)
Date:   Wed, 23 Jan 2019 00:30:35 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
CC:     <linux-ext4@vger.kernel.org>, <jack@suse.cz>
Subject: Re: [PATCH v2] jbd2: fix deadlock while checkpoint thread waits
 commit thread to finish
Message-ID: <20190123053035.GB8785@mit.edu>
References: <20181125083606.5273-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181125083606.5273-1-xiaoguang.wang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(396003)(136003)(2980300002)(199004)(189003)(106002)(90966002)(4744005)(75432002)(229853002)(8676002)(4326008)(23726003)(486006)(246002)(316002)(76176011)(11346002)(2616005)(26005)(2906002)(88552002)(336012)(86362001)(6916009)(33656002)(476003)(126002)(186003)(305945005)(446003)(6266002)(47776003)(6246003)(786003)(36756003)(52956003)(8936002)(1076003)(46406003)(97756001)(16586007)(103686004)(478600001)(58126008)(356004)(26826003)(54906003)(42186006)(36906005)(106466001)(50466002)(14444005)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB3753;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT037;1:lEOqyOFw5Xamae7czHsIQvWUtxwHU2WNLsQGEwMCOyyNSRmbU1eH+wdPn1a5aqmFcsPaVzg9cBVpMinaJ0F1ZMXVwq3uhQflIan1wiyp4Zvl+cKQhqpYNXbyyuvb1UWUW+felQmyiYbmshE0fyDMnQ==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e7befbd-feda-4211-dccf-08d680f3e8eb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:DM6PR01MB3753;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3753;3:b8cww225988DKJPqTsMOrVeZzdWp9X+FmEsBSR/VVQSmIxP+lwlt+yEmLd33oXbyh4jpkBotTBQQ6sjFws3L0YjVHBlnN4KRVBoLB3h2ctvRui+wIwgVyPYTnx2x7/4X2WMqNypMr3tFnNhqiQ7KLMtq+PZZWArNyRRgoi40T3m32RTKFAUT/sjP9SsCFoTJdb7fYgXBWNgJmidvO5BQG74ulZbnHODP2B1KC25gqn3Ng2TGNISYGNVo0bOWRW6G+Ja63VIVYRbBxV50Je+yEf3zwEuk5Oejz6mYxGteqJpR9tcQ7a3RYIahgOiQb1nW2SQ7za+qdf/ggbraITV6gAiLbXv+12yy0WeWJ8yfkfjb6zUzz8/d88tYWU0DqFl5;25:7xKO2i6sihSppwn4ZAc0SfiUIpDRya/SxkUBSJTsOaSVyZD2ZYfLD/zLtC0W4ljwDh56+/kgQa/70ZNLYFvCI6ELhvkB97rt7vEbbU2u+lCBtQBn0uv/H6nSrS2WbesQPnWqH5/t+zDHrcNLqpMUcIm4cV/x6bTJe/Jlp/ule4+l4/YMvwiidQp65r/8HLVYulTguxRve5fG6ihG70yyQbeeRWKxg7YYsKH9TsZCXB9C5bC3k6rBa8qqUyiXWrnw1PMm9c1LnhIfhscx+bwzk9keVjLjdZTNP3E5nDDIEGiX/oRSJfn1DxK514WeR2bWPlDeiCDVjW1Q+pr1iZqicA==
X-MS-TrafficTypeDiagnostic: DM6PR01MB3753:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3753;31:dnWRC1A0uv3BC3EkHl68+ebbbkIxAmRG7za66/W0+BCiy7tnNL0W3fRP1nrhsZcoQXMv/AZViU1Hb2bn7AXaFNwS1MPPP5kuNU+6wLH4o5Pi6/Rb7zQm15vr8hLoly86OX+egVSORBJZ9FM7/4ZJie2PO7mgaBojo7ywCA2cLCcdER4EqfEIG3r44n4iUO/WWy+mq90O3vdehSAfFQblxtW5TvgzTl1lM11nKdU0NU4=;20:/HWOl7spMc2pEBdjkUVS2cE74/rAYiqVXQn2uq/SUplwQ8J0nLZNi52kDV2yXOnKVDjiBJ+kv4YmJfctDiIU2Odtx/adDWe2vDs5zAn9iqdTirRT7ruLZtMr9MdnelzRK5w+ZbX9n6hoJ31wZjjFLfLzUVa0BkF3d02aoGeziPHs+ym0iG0E69W2gjuGWh9mj9jx4bRG6+FEf5w5TnYdhAlGDg7Uus3v9+ZHGet3GW0TM/YM6EYY0Sbq6Kx0dXOtzVivs2jhMW67L36UFYUaQR4eAqDkeryFk09cwz6wPjZaRad0NPE7t5reCBa4EggIOtYAkXV/s/HA6VsScgC47o4hQlktEtM2GIiwv39dEe1y6VsG3NWOYqJJ6cmqv/7hPmJskZi6uDgYxYcgiMU2R7+w9Ap2klKyVK4Y8mo+ClgyK2/uaAbG8oi6jnCspo63xP4KjC4MUBqQffyoT2QU3pRxVldTt7k/j6hfnt8abAIi8amZ2bY7bVSz07kedaNWxnl+o+erILKP6jxYVMgj/0VfneUF3UgMYQfslgUr1RoEKJJ2b86BVxqV1iQu8g0mi4r+biAlMjeHQdStSI/JA2BJ1kSNxoAD6vOets5hxQA=
X-Microsoft-Antispam-PRVS: <DM6PR01MB37532AFCC6CA460A6FA4118DB5990@DM6PR01MB3753.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3753;4:ZmMAflYre+GJ9o5Fb9v+BRz8cOsk8vOEf3t0cT2ooXPh9C7Cd/sMZyhKW3xg7VT4eNmy3ZfOaDYeOu2F9zNoc/yfSTJCDzTh3b8EMTYkvLNTaVo//hgrofQvSKm4bSJZj5uBUGn25KYNwH6ETEG7qkQQvSfTmNDshRDlTwYkciTdD5AH4aZfdHqdGCQoK5SGOLwMvGKKSj/koiQtVrMFdlKjkZWZIv1s7tesG109e2pAMa2z6pjg0hV3f5H8i/5zydSR8Eeed5TAWSEx8rMlKwdorXxjLlx4OnRqo9syF3gqiq+4O1Wpjw4NYVz4rEOw
X-Forefront-PRVS: 0926B0E013
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB3753;23:R+tfHsRw1FINzWGNVsX8564Nsx48gpfLfDBo8+g7z?=
 =?us-ascii?Q?q0GfWbMfT9TOt9u1OfHxfSf2864/nkl8c11iCG8R3LzR2C8JvoPgnTD97Js5?=
 =?us-ascii?Q?bhoF5DHAMO00N6LoI1O8A8K1hFYu5ghU1l9xHjlGxuaXjV1YbRAoQ9/7fCMF?=
 =?us-ascii?Q?wC/L6usVuY1y5txAknZEn8NPWXZ+3jlUee4jBEaGXw80r4GKPp2058GxhqMU?=
 =?us-ascii?Q?wnwmnf7+rBwbnQqHxSgoWbPv4tMTV4KSAT93fId91IzotJlgyY0GQnTnEnZM?=
 =?us-ascii?Q?hQDxaj1nm8Ow8lCTaCns1PyAto8QKuJTyElWc2927be3ojR+x9L/FrqySf5j?=
 =?us-ascii?Q?VF2W2nFITlEDOYH27JXT83UMzaMtqrvFmZoE3eXLRovY4hBgATVV/aaqyvM7?=
 =?us-ascii?Q?/Sh/JZ+g1NJYo7DgM0csy3eRbkCBCSL+f+FU29ZzdQnIW/20KSUa8v73SH/G?=
 =?us-ascii?Q?pqzRZFMAa1IzA6pv62fI89g8luJ+HauGNLlTsG0mR5tZGz8FrL7pp+ulbfhn?=
 =?us-ascii?Q?8A/uqeotPwHWzDliSmRG7zentaH7ObJK3xGwQSWtFwEH84U2n2qefIPj3HqT?=
 =?us-ascii?Q?n6oOybCawH0YzKrVMuFfXPAGv+3kTWQnLskklpbjUwiulamBR09AM8MVzMHP?=
 =?us-ascii?Q?gaU2iFFxFajvqWsBTTgEmEFehFjsJ9ELqVx+laBYY1lEyF1WEnb6CT1fX+BF?=
 =?us-ascii?Q?Bc3vG9Cnj+LpoA0CfnRJe0uXA6zegpO5oiGlC45UKXmbVRF7cfOp5cZg75hj?=
 =?us-ascii?Q?3l1vaoo18ZU3JO8gy/Gn2FSyI2AO59KkDR0/6bmpizpZocwlDZH82wsvt+wO?=
 =?us-ascii?Q?jgXDS9ZFVmHZJOuSDHPpldzk0ETzKpfOYmVG4ZQFC4/tkFOaBl6YVvvTQG06?=
 =?us-ascii?Q?fiwydpfd1815GO8aILQTmXUPSI/o1OlU24xXum1S85/IMeNzYgpMkm+hy9k4?=
 =?us-ascii?Q?oYSHTkirzicHUfmz4bXEWCKnmTA38C1s/ZG5v2Knq5MWgqr9s8MdoCoWfenO?=
 =?us-ascii?Q?mzwI2W07e8zR0GpvdEAyb30vx40XDwjf2j67Sca/FHSuMG5i/2Ez6eizi06O?=
 =?us-ascii?Q?TUDCRopm73mEkwegMOGoJ37A2jDwx0dEg27tUpw05DgNpgfhEQ3dxEeSYCtx?=
 =?us-ascii?Q?y68tNFFfT4R6xPLojyvJztiEHILASZvlxp2R9HWyN2js93o9p2uGRyUJ60I6?=
 =?us-ascii?Q?t2eUSjdo0W1lgbVss43UmppcUeqaLJExPPXP9AbtJoM/0vTXsHTH5xOKt6Vu?=
 =?us-ascii?Q?bxDgynpqyCdkPQQnP8=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: FxdTadwqGjt2MieUyulCkcIKbs3IaghrrvTJ1CqnN7eqMrgU01MLtx3FbZXbeQ9UOUkN+fAawXJpDs5h5BvA1nRN5l92plTLzCPl4Lz+IXVMPrOd3zi1EN90m3PjaZNLe4hMHvN4z3sCAutgvw32Z2e8MwBKXMpZXIWwZ8tczlxI31DJwZ3Ej9s7aOvW4jjagmXRsVs221kFpFvvQIpY4nSSKqwPEGCMnqbG0WcTawVFC1BO8t9oTVJ+wJP7DPFiTxHea6CXe7Xv68MHYOlwbT2S/7hHfpJl1P1kPrHyiHsaWkrZYRYYp5diIF0eJ7OuzoVP7YSfXyaQCMFuBFCuvSy3r6YmyL7Ew4LgRtn1/FpDbUpRgRB7zvNBEIKJxTjRY9NguQ+KT9UpgMrooUl3a+GNWGS0pwyHHy8mbK1QLGY=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3753;6:V89x4kBq+HrgeJk+OC+NtIkDuIf7fYKuRY93i52jk0xDTLisVRtvX4vhgAyLnP8IM2e6nQ3opFUGl5WMWj9UISJqks7QU2x9g0SQlEnXJEIZEc3kfQIg5W7sn+2X4bKLdxeM2FRGrrmSfGFotaWKSO33uuWN9kFYirDsLiJKy69enfuCLAigtgWdEBjB/GRyvbYnon+65H8qQzzApkaL8NbRIc/dub4q9Si8fgCSnYcMX/S5+EnUEncdlqrsyjYu+qenvvp92dP+WFFQNpF2rUQfWkVqCDsUrz7Eu4vMwNH3eRvCFgwlDE04e5YWwGHtq+mWJL3JYbF5gp+4JhAwjNTx4cMGX7m6OXirY8+93gSEUB2x6ab4HEyBGRo7h4XYx9DS/0eVBxvGPSaRRDXI3uoCjwgDLfdF+BEBGvIEK8gmJ4+ZBLNBJe/+iJRGtv1QUtGZ4LCmv0jnT1q4DxrONA==;5:JMHVFko/Jzh6H3L4CevtVOGMlS2caph1CQN1wpGtq/Xz0tWM2XXhSFDNv9YfE6i/dZMfrtYxLf30WsPzvhIKWORvI7ntEqD4kT23DhBuPMS24k3E2CZw7KEQLIGdcSPVFa4YxLeUGwZlJOE2fUkMWty1C1L+N7WC+vmCjfF3CuvTd7qFlPC8/p2IOJZjpFGqDDKJemrjkhm/DY3ncs/4zA==;7:VGNSdkZTToyjlKwbQQvWw+FHkX7XCWKfwm4cN3OGlIYoO9/P7J4tKkhTEdq5evvBi+/eHzQUaQ+Zz+D+NF7oQQN04jYJwBxu6g6XJYhYX8gw8cqe/ySGHAMjFPA16LgCLiYsmJUCu4va3Nk0saUk8Q==
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2019 05:30:38.9558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e7befbd-feda-4211-dccf-08d680f3e8eb
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3753
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Nov 25, 2018 at 04:36:06PM +0800, Xiaoguang Wang wrote:
> This issue was found when I tried to put checkpoint work in a separate thread,
> the deadlock below happened:
>          Thread1                                |   Thread2
> __jbd2_log_wait_for_space                       |
> jbd2_log_do_checkpoint (hold j_checkpoint_mutex)|
>   if (jh->b_transaction != NULL)                |
>     ...                                         |
>     jbd2_log_start_commit(journal, tid);        |jbd2_update_log_tail
>                                                 |  will lock j_checkpoint_mutex,
>                                                 |  but will be blocked here.
>                                                 |
>     jbd2_log_wait_commit(journal, tid);         |
>     wait_event(journal->j_wait_done_commit,     |
>      !tid_gt(tid, journal->j_commit_sequence)); |
>      ...                                        |wake_up(j_wait_done_commit)
>   }                                             |
> 
> then deadlock occurs, Thread1 will never be waken up.
> 
> To fix this issue, drop j_checkpoint_mutex in jbd2_log_do_checkpoint()
> when we are going to wait for transaction commit.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

Thanks, applied.

						- Ted
