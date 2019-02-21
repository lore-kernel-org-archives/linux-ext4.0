Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641ACC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F240020818
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 16:33:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="xkRbIDX2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfBUQdc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 11:33:32 -0500
Received: from mail-eopbgr780133.outbound.protection.outlook.com ([40.107.78.133]:19154
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728310AbfBUQdc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 11:33:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7V36ufE6W9SM8GlwE4OCMn5Z1XbdhY+mw2/litdDOG0=;
 b=xkRbIDX2q8MM1rbozlXA8+icMtvBwPi4TQqTE4YsiO1rchpLJLSHbUk5wHM7Uge+luATG5LdozZfoTy/Ef2sajkh35QChdSvSnQT+xhGYuCpXOv0B9kUOwzdXob0yFoPdnQGK68YElosbY/Ko21ZLyx2xG6dbl9iD0NIM7BzTco=
Received: from BYAPR01CA0036.prod.exchangelabs.com (2603:10b6:a02:80::49) by
 DM6PR01MB4985.prod.exchangelabs.com (2603:10b6:5:59::29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.18; Thu, 21 Feb 2019 16:33:29 +0000
Received: from DM3NAM03FT022.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::209) by BYAPR01CA0036.outlook.office365.com
 (2603:10b6:a02:80::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1622.16 via Frontend
 Transport; Thu, 21 Feb 2019 16:33:29 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT022.mail.protection.outlook.com (10.152.82.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Thu, 21 Feb 2019 16:33:28 +0000
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1LGXPx3026654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Feb 2019 11:33:27 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 07E1C7A3F7D; Thu, 21 Feb 2019 11:33:25 -0500 (EST)
Date:   Thu, 21 Feb 2019 11:33:24 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
CC:     <linux-ext4@vger.kernel.org>, <adilger.kernel@dilger.ca>,
        <jack@suse.cz>, <miaoxie@huawei.com>
Subject: Re: [PATCH 2/2] ext4: fix compile error when using BUFFER_TRACE
Message-ID: <20190221163324.GC10245@mit.edu>
References: <1547100399-127915-1-git-send-email-yi.zhang@huawei.com>
 <1547100399-127915-3-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1547100399-127915-3-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(346002)(376002)(2980300002)(189003)(199004)(6916009)(58126008)(54906003)(36906005)(4744005)(5660300002)(14444005)(52956003)(476003)(486006)(103686004)(4326008)(8676002)(126002)(106466001)(2616005)(356004)(246002)(47776003)(6266002)(305945005)(6246003)(446003)(786003)(42186006)(316002)(106002)(76176011)(11346002)(1076003)(86362001)(90966002)(229853002)(336012)(2486003)(88552002)(2870700001)(36756003)(26826003)(2906002)(478600001)(26005)(23676004)(50466002)(186003)(75432002)(33656002)(8936002)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB4985;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 382ca59c-21ef-4157-a006-08d6981a4fb8
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4608103)(4709054)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:DM6PR01MB4985;
X-MS-TrafficTypeDiagnostic: DM6PR01MB4985:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4985;20:p36ROVqQ+8PwVNdGv83K85afnIfWFskW3rxYxr3Ip7TSl/VxxLt1X49uAqj6qyEa2M6CcMfiMUz9tL98wS5HqXH4lblI4Is+N4nu6fj5YQS72VABr4HKbAJNbqNsHRCOvy7Mkz3e5QsbkPFCuyOyBjHTz1GMtsIL3molNdYiy6HsYy/bTWc0nxknS450pGcjIsexrnbRngcTNWbXu+jnLTX7rYeZDRPCWCRG6vDaQ1M+jcbOVUsq2oq5LtSuKiJUjelpHCkFe0t+HRAPdv8USOa/XO0yfXHLn8Jqq4n6jjierX9pc8JwyNo6wNVn7CooImPrIXd0UfIoSstg8ssqR68TIJNECJNVRWMAKFNtK+SVHaqL9U3YoeNQbmlc7fSbm3pXyQsyp36MiJDNwwQ+cPRqtdVfYHY6hvg1MPvv2sq+2uT3FOavGsjp1lKtRja/AZ/aA69bwFWoBLNKmHmuKvD958AMsjZi51c5nI+0hQRXyyes69rr71SpcOgEEcebf06voQQO8nfefWEjBG4ebic8A7+Sien5ehZ3uHZ6nfJxkzTrPGzFvPIMlTR4/5AllaJRgCQ4dWTO6X6qbWPiZ6oVyazUXzWLOB0sDAPAULk=
X-Microsoft-Antispam-PRVS: <DM6PR01MB498535E918361C2FF897092CB57E0@DM6PR01MB4985.prod.exchangelabs.com>
X-Forefront-PRVS: 09555FB1AD
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtETTZQUjAxTUI0OTg1OzIzOjlHTGhzMCtZR0hZWXE4OGpMcmxjNlBxL1d1?=
 =?utf-8?B?TzdTcXkrNnpVaUQ5QkdtRWZvaC96V2VyOTJ0YUhsbXVOM2Z6YnBQMmhYcG1r?=
 =?utf-8?B?bVQwdkRvRHEvcUppTlhWMWMvd21EcEhQN2xveXYreUkrQkwvV0ZuTVJtaisy?=
 =?utf-8?B?SXBkSFVrbnZYelZFZmhFZTlCOWtsL2ZtcFEvN0JINzhvUUhJWDJPWXpXL1BY?=
 =?utf-8?B?R0x5TFljMTcva0x5WVV1OXpSL2I2ZTBqcjJrY010SHk0aGpzNDhuRDJ5alhD?=
 =?utf-8?B?aXNoYm1yWXQ5bjB6czJWbWVJRDJTZFNjYkljbkdHeXQ2S0IyUllXcERPS3Zr?=
 =?utf-8?B?QnRBRUQ3Sm1yaGtxZWFINE0xVUpSUnV2NC81Mk1qS0hYYysyekxRbUd0TS9x?=
 =?utf-8?B?S09EV1lNNXlEQTQ0Z3lQZlltK2xYMHkxckkyMGtVU1FaVi9iRGpmSG9KKzFD?=
 =?utf-8?B?cVYydTdGZExkRUIrTW1WdFhTRmxyYjc3WFhSOG5Id2ZlL05rTFZsRVFBaXZk?=
 =?utf-8?B?eVh5eXN3cGFFd2UrUzFoeUxCNG9hV0Y4VXo4M0t6S1hseTJSSEdDdnV3VWtB?=
 =?utf-8?B?Wi8yNE9pb05tLzQvTzhBckdzcGlxaFVJQlJuRG9XaEtaYm1jM2ZwRnhCa2wy?=
 =?utf-8?B?Q3BXZllmOWtUNWtZR0FrbUY4SnhjZUw0QXJzdW1yTU1GcDBwZ3cwOCtVV1RK?=
 =?utf-8?B?S0xyK2lBY2h5WmNYcTFYY0hkcGl1dUdzaWUzRmJYeWdxS2ZvRHBBaVljbmhS?=
 =?utf-8?B?STJxZzVjWDlvdEhiWElwTTZGT3JHSmhzME81UHBMRGtibXkwd2E2Y2g1UVd5?=
 =?utf-8?B?cDhCMUF6aUVPTWNnQUtyWlhkUnpWMUtZQThrZmJyWnVDWUJCUWRyTGVDL1R5?=
 =?utf-8?B?RUxGUGdyY1hmWnBjaURtT0Q1aTNPZHRRTWcyVk4yRjhrS0sxRXl4ZGJlQkNR?=
 =?utf-8?B?THVET21zRmw4aTFCYVlabmJzTnhWU3pWUXdDNXNPcnBpSkZDV3VneGVLUEVX?=
 =?utf-8?B?Y2FKcDlES2FwTmZzRU1raUdEdm1BTExpZFRRbjJjU29ac1hWR0lTYTlLYTRU?=
 =?utf-8?B?b3h2YWdrN1U5U1lrekZZYnRkOWUwQm0reE15Y2VnTkZXWERIMmFtSG5qczA1?=
 =?utf-8?B?Z3lnalFsaVBXQ1JKTzcrY2R4OHhYcHdTOGh5cjZXalh0QVVnNjhNS2t5ZGty?=
 =?utf-8?B?RUcxWG83RTZZTldmWnQ0M3dmYkVhSDRocFZ2WjJMVGw3K3o5WThaRzByalpJ?=
 =?utf-8?B?NkNNM2F2bFRObmNVNXZqNnBlTWNEN2lqRnpqZFlpSkV0R0J0cXhsemxzd3Ra?=
 =?utf-8?B?b2FpMEcxaXYwcDI0dEhrd203QnZtM0d6U3FESlNoTkpYQ05ITEJpQVExTFpB?=
 =?utf-8?B?U09kRGMzTXQwajZlWUNFdU45a1U4NTJVR1VuT1VhZWhSeks2a1EyM2t6Q2g5?=
 =?utf-8?B?VWpyOFJwQ2xMNmhhUE9xaGlMaGZ0dVRhWmtnWnh3cUs4WFFaQ3hzSzFVck9j?=
 =?utf-8?B?VjgwMVltYndmK0ZRZEU0c1BxV2t1TzdQVHZpRWVvTVlOQVJ3dEpKWGpMUHhV?=
 =?utf-8?B?VVRjam94ZVNyMHJmM0l3d2FuOGlSNkNRWlNpZU1xY1l3dVRlbU01cmVmL0lo?=
 =?utf-8?B?aEdPUHAwdFROb2FRRzBRcGtONDIxZnU1T3cyY3M2Tnd6aGp0elB0TjR0TVhH?=
 =?utf-8?Q?FjzclCK/OkK3sT5UUN3ZU1xo7YjqMg1nTmWQBo5?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: n1ToAe2mHX10YumNSAMOHcWuuiFuWCMo8KrcSIl94Sfgjt5wHg37hl8Rhk3EbvRPmn30/Mcxq3JzShQyygutsHWAWp5Q8yAg4/pshoX2UhwIi5QGlevEFAodOn5jcBJ53+sXA5+IWGkLLkcefyQapuApNTsk622cf77Fz9ExU06eKK01PRJrBgsM/NnyMpfsC7djqyM4tSU5fXqllcgAxc6ojecv6Q6eJ3hR2D/4/Om7LYKeXeqohG6ZpklGWAtXau2JFa7zWOyDABqQBRbaiZ3llA/JmMT2zP16Djh4W882JCooZFYQumDUgETSUfpzizK/5hNP8RWKyd2j6+R8URblFLQE66ViP58F5SxdKDuuJvR4tFtuSS9EnCamcAmTYdo0GHbZt5EC3Pj8eyzLh5JA8oVjeucUa9hDIhD8xSY=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2019 16:33:28.8311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 382ca59c-21ef-4157-a006-08d6981a4fb8
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4985
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 10, 2019 at 02:06:39PM +0800, zhangyi (F) wrote:
> Fix compile error below when using BUFFER_TRACE.
> 
> fs/ext4/inode.c: In function ‘ext4_expand_extra_isize’:
> fs/ext4/inode.c:5979:19: error: request for member ‘bh’ in something not a structure or union
>   BUFFER_TRACE(iloc.bh, "get_write_access");
> 
> Fixes: c03b45b853f58 ("ext4, project: expand inode extra size if possible")
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Thanks, applied.

						- Ted
