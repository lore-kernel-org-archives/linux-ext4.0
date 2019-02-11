Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E60C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F1A12146F
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 04:49:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="wy3cJsW9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfBKEts (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 10 Feb 2019 23:49:48 -0500
Received: from mail-eopbgr790098.outbound.protection.outlook.com ([40.107.79.98]:54192
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfBKEts (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Feb 2019 23:49:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vKdMgIYToZ0kS883QBsHAr6WwXeHEtbWtUsXwe0pBw=;
 b=wy3cJsW9lwn+Z5U3Gdbj5YebCNv9KqvlaES3qp1McOOQ4Emf+e1Rnf7n4V6zkbDX46eCd5puJcdVTwzRXOJYxwPbZfeishJHkXm/+oaWUz5tC6DfjIMEVl6aGLHvz6slZVv417qXzaQYEVw09WanA0mkCsdv8Zoa6nqULnpxGAk=
Received: from BN6PR0101CA0009.prod.exchangelabs.com (2603:10b6:405:2a::22) by
 BYAPR01MB4487.prod.exchangelabs.com (2603:10b6:a03:98::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.19; Mon, 11 Feb 2019 04:49:43 +0000
Received: from DM3NAM03FT029.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::204) by BN6PR0101CA0009.outlook.office365.com
 (2603:10b6:405:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.17 via Frontend
 Transport; Mon, 11 Feb 2019 04:49:42 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT029.mail.protection.outlook.com (10.152.82.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 04:49:42 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B4neq0027383
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Feb 2019 23:49:40 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E58E97A4EAE; Sun, 10 Feb 2019 23:49:39 -0500 (EST)
Date:   Sun, 10 Feb 2019 23:49:39 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
CC:     <linux-ext4@vger.kernel.org>, <jack@suse.cz>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
Subject: Re: [PATCH v4 4/4] ext4: convert ext4_split_extent() to return
 requested length
Message-ID: <20190211044939.GH23000@mit.edu>
References: <1548830980-29482-1-git-send-email-yi.zhang@huawei.com>
 <1548830980-29482-5-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1548830980-29482-5-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(39860400002)(396003)(2980300002)(199004)(189003)(23726003)(476003)(1076003)(88552002)(4326008)(36756003)(246002)(33656002)(6266002)(8676002)(6246003)(126002)(2906002)(11346002)(46406003)(90966002)(2616005)(486006)(103686004)(75432002)(8936002)(47776003)(26826003)(446003)(478600001)(97756001)(86362001)(76176011)(52956003)(14444005)(6916009)(106002)(786003)(42186006)(356004)(316002)(36906005)(106466001)(50466002)(16586007)(58126008)(4744005)(336012)(54906003)(26005)(229853002)(305945005)(186003)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB4487;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT029;1:5lzlu5aQePED0RDVQXK92SBfUXb39g7Lr1mjijHQobIYMUieZ9RIGqH5c6p3F6xZuUxE3TOCB0Wn7XffByuEk4GtIodR53GRyF6lL2h778JBU3fULiBz6qEYLS9KG1eGMZiJ4f4mrquJqveXI4Ub4pS5ufcuCH7TT9o6Ytv5rcM=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e37689ce-b4f4-4e05-cdb1-08d68fdc5688
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BYAPR01MB4487;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4487;3:4MTtM3t3oAMAd1VoKpigtsuDM8tSCyxFQpQNzardn0XW46cH0H5dRk2CJWmmT2MA+kGwPX82MpTf3dyRVasEFcbu1uTgj82xLmu/tkfVeu07yRtcMn1pw8YDm1+PxDjne7LVzIjrJMpk7JlP3LtCWt6spNH179MbvpcQxpe54kuzYAo4IxcZe8DDg+jPPiZfGjKVNr5zoOhO85hJjyrwFPFAGWFAxLzCj+FPWqzfOoNV+pUZkXvOKJBDB0LR2QK+V066X5mFLlur36sStw4sVv6QJIXmnDl6FddYRiUisWy4Bq0jP4fhGXtzdLF+pdwc6JhG9kfjP/xO+bKGpH/1f+38IxHJzQFO54SBR5vNBlmRB1+B1uqGugHwMzrMxK2w;25:AslT2aO81nTxS2qfZHatMdNsFjG7SkMUtIZGRy4u/lCx5EqNlrl49nTCFItxf6IpKGHBCQixvjVJCEHFm9tFpGYkunSxAREu2Z/J8w8eaPvbhOUhhYzosKXY9qX0u3rl2JQ3dQDOorI3R9uPw26SE+L29hv8tnrMutSPQG78e6WTgFg3f3sIGmyfn/2yhCgd+0CfpwgyPaMcdAKv0ETxGe8AkcrkkAVMyWeo5VAVaOpZo0tYFtng43NBBoJFbbuoyImM22+MaixxlgT/zPesvD8FK18P3hMrczMqa0COXLcGNTJtxDdmx4hg8bFe/jGxxp8eOXX/MKkcBdXJ8YvY3w==
X-MS-TrafficTypeDiagnostic: BYAPR01MB4487:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4487;31:nCu5fA7YZ2XuwbSGfDJzusRI/lQyVBPOlJUrnIiSqKgjwuLHID4uetaqd4RFRdlIKKn5uOrpc9nxNY2fIpl1bywRWBJtPqBQkoFbd17lZ27rYa2D24tISNI/lRrw/dvbyKGqtlSrSj69vgyCaTVDd1g3dZPCrqHLInh76RjOJfvW8OuRyFS5Sr1nwkpgjk6VEW3Gwk304IA4Kp+Yf1mAcDR8FGQzoJe6opxp9rvfdnE=;20:S9ckj9DiKk2X9pZ9RhaJmdYLsJroEMmvZnwheiwCV/iL7AUhEoD/CjqWCCE3U0vAs/Ld9CALBK1n0pTaD/qKFgvtvCA03j3qrjv0MULDhCP4zAyodwolQYWprJOfxaxFBHrlSNK6n2G39yV8mv5dSrazUYqtJ/+Hdxpb3W446dfVHVE+GX9sc40YosjqqA+4/F943E/iMBFP6J7BMMZLiQsmsJkERNX4JSnemXW39S1pim53jnJ9150KSZdnBSibOXrmZrkMY+sSMF2WKoT/Zf1zrItgpRJ1Y5h5cEr3N3C3DUc6z3dz2xElMF8nYZGYNelda5+Yb6Q7/V5993PwZzFoDityg580WQLVQuPN2WIWkEPmNjDZVJ8hr8VS/CtNQDWgSCJBFDfWryImuuNFh9rlS2LA8+jEqBWiC988jesh6r17MvmQAMxJ4z1K/GZhIgwy0ZbfMQJqTYXgN2XX3bVJWN+vL4AhZ2xRJHdKP1MK65jsNyAJU/5Ao5yFCBT3pAAgmgIs7ai5WkXE2obXIcTjcxHItHPGRE0s8Nu+39TM0e+LdIW7q5NLcgxrV3okWPUEDZO0Gzm8+p5+JK+nAzRk9dbCPDCgl0kdUylT9lw=
X-Microsoft-Antispam-PRVS: <BYAPR01MB448721E7007615A193CBB5FEB5640@BYAPR01MB4487.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4487;4:BPINqo3qkpEdBYP7v4pt9JkKSshjyOCLziW81MixPbMFbZP7L/N/rRgu/+rrxMulLPmTvd56OiER2nAAFz8rlxAgQDtJmAAJ+VYMJuvW2OjhpqDn/5natahx2HMlQGpYiT/KjZPiKSzBRm+fvXAAZef7B/HqRi+2z/YAFWduyeoioaEY4ali/tjbr30XsgYIQAqTTobCU1gsBm0dNpRx87BefUMOt5d1J+Bb3feZmhPu+oMYCTCJO2mc89JcoveiPu5w4kid/5dHIYh/yoYmnYN3FxFLjC351ylA40qN9Yc=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB4487;23:lp2n10SikFeJr3xLSPKwtq20eLVcXPXX6kXR6hUzk?=
 =?us-ascii?Q?fbh2zTAev9Q8XW9djGcETKY/YYcl/CasnWuL9a/S75W/+WkDDxf6kxJAgJLZ?=
 =?us-ascii?Q?sCAaew0Kw85p/CFDIVvfKPTjwzV6gvb17BxwpGzWnWcHGm7QMDayRFKcWBE1?=
 =?us-ascii?Q?GufjCiNslZExASI4IjHFURxZxGbRnDsq/5qUQSWAzCBYkbHuJD0KcwcsRxeH?=
 =?us-ascii?Q?UeH8Dd2FFiLgPQZWWQGYq05zrrsSMq0kOJRMZ4oly7GW3KYnbNip5cfYg2Ss?=
 =?us-ascii?Q?ZyBRrdQyF2lZJSu0TC5PZSl5i7k/OsSm51ZlOP1KqNfu5lU8+hXG6CpnCJeY?=
 =?us-ascii?Q?jeL0vw+GUMpsqbsRXHtR0dl/3An7RPY4AwAaBhYmloEeT8Gs/6AOqKHcNhEz?=
 =?us-ascii?Q?uyPZemhubjn9PNynXSoWunbRvBSr2ALdcSeaE0/LeBPCj45sFuZEInm/AAaU?=
 =?us-ascii?Q?L5QU9I/S5SkekBugB2Sij0c7n8Z6taS3c22WeUsjRCC2BRgpZYoQW4OkJHdT?=
 =?us-ascii?Q?AIBvMjvPWFHPuoUDvYFUb1V+Em6dGqKvQy5Dc12m9PmRc0N0ityhY39PGvCM?=
 =?us-ascii?Q?m/aypDloKD6DY0NDWW8Dbihks9MqFKNJ2PcDxy/fnLGUZ3JsdY4MgCq8UVN1?=
 =?us-ascii?Q?CVEAQVKKnN91Ub2ED9ZIVlWPcrIFJvsHRW1wqsj2jDzls8AUVTMV0tFBCbLT?=
 =?us-ascii?Q?6yCh/wTvM3pR1p8LvH2ecL9xBa/JCh+c25XvhgAHsfacUv4BNZMiNFjvlhCS?=
 =?us-ascii?Q?B5OLCl9rcurs5CXqfRGq7tE0tAU15QfTuaHERCdpwWKTfYGdtSX6ykCIz7uV?=
 =?us-ascii?Q?KUdg7+X8PZww6xoqWCORDneLuyArNoZaoXk5EYzsOP7P3vxYaakI+dU0nR+d?=
 =?us-ascii?Q?SZTDMe6qk6Ju2r3cG9YL7kseooljiSMuTQ6jJBKYoAmhY9vED+H+vsJpenr8?=
 =?us-ascii?Q?SakiOp/mAvoyvdE2fcHmsX42b33JCDySRW7PnlygoyB4SAkVMUuwXvFdriSM?=
 =?us-ascii?Q?0mI7DtSkVkF+3k7qf7tdkX2MU1wAu4aajiIXirACEbkFBhEqL0lYJ0DLotN9?=
 =?us-ascii?Q?6z7Tt1o/kJVkkozGiag7jwYJZMHZqJ552PD5otpuJKAmO0IEuVR9+58Z74XC?=
 =?us-ascii?Q?RlHesMiA3iig7QNAO98h9gI8WLt5ydF3WzX8bZyqZ6qOEx52U2g5NUSBKgAn?=
 =?us-ascii?Q?ADVLAT+lFbcX1hdu8PnZcSvxZa5/r9lYf5LFpNaNpfABT4pzxuREd7/s3JW5?=
 =?us-ascii?Q?Sa/T3v/Og2yb32I49M=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: uqHmTQ24LkepTvSBxseFD+U56Q4qlJAkEQnzzQivZYOPrHSesVkZfVBdTOdIt2PZASjJvEpswX7s7xkDfcMYv8/iPzJgxkyJY9j+/5yxdxKC/5kYbGwLct7RFxnxniWXO5KUXNAU5lsZ+w9aJQ32ces3Sq1JGwSx/4xG3BsfbfB1IjHl97rjnSTKzh3gDWO5PgXts90/EB0HwhGKw08DZbU6kHmq12gTCx0YfW/F6epZrWfoT/J58GD8AR9y2Qq7E/ITzgHi6A5JK12+PUdE40Tan7IRTTbDUds7xhb6iqCtOWZTHA3aH+MPsyj75aJD7zqjmK6SoUBdgoRiIWFFXqO367zchFFC8vubTLjwzQ2N+yHMUekpcpwEiWuMrV/DsCUL0hwRigfY4NQUgNg+jeI5ZgLV803/8yuOSGd2uzM=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4487;6:DQimw9WNg8Igq2OXNwnPrxdBhgEeg42IhFUm8/OvMUABTyEmpA1OhpQW/sU26s6qfB2pexw+AmZeFcX+4C0ikFDUu+2T/e+/UQGOxmeGK1jHJ01fmQHN4A3D6zurXdNvOZ3T2csmqP/vYk6islgGuFDgVEu7VMSJvEDNrzLqFZpsOX0Qp1fM7URLw6deb0OifaIXgOjngfOkxupio02xNpnZ0TXP7iQ2wKmdAhOwsR7lfbLtiOM03Su+8KlueNEcYhmA21435IqKGgBVqH+MliUVj6Z5MuBjCFe2A4RMKz4u3ZFUYbQP23ccSzitR8BCOIoI1zR4j9Jk9vPm+pYPqMUpRomZPvkwf4pHqK0fFTwWPlSe3ZJVM2WP2sJVmz4gQ8oIoNnemca9i0gHlnWRIbhCWpX+s9z/rObj2TReSOj/faOLvld9JOLS1NEYhRrhtjhpwTS2xEUdtGzM8D2ThA==;5:lpGpw6+EpFsG/Jq4HWGWivlZSUHEOHspNfY1L068BxGh/vmEkx8XafNL8Cg/TUpRNpHho3wWXuOlreCsnJ8fuEr44BMEEwCANLNv2mI6hhbaiQ9s55QaS93Ed3vb6tooOyQrsAoH0520GfNF+tT29RLhsBnP8Od3HGzhWjf1HyWIIbA1nh4VBrbnG13U1unG/9ZXilfuu4+/5seQ2mPOuA==;7:I0z2fznFH3So/HT3h4GpQovHKnMoaVUnLJnqRl5qUqb7ltZKJKuxAZzYXjOrQul4bSZ26dXCwhNsnNRRWbDpaOutMXHps/OshT6Jj/Lr4T4dydKLWmXxOZsEVpPlnRWe6+I9h6DTKnA21WSOlZFraw==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 04:49:42.1562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e37689ce-b4f4-4e05-cdb1-08d68fdc5688
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4487
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 30, 2019 at 02:49:40PM +0800, zhangyi (F) wrote:
> After we remove clean_bdev_aliases() calls which used to unmap extra
> blocks in ext4_ext_handle_unwritten_extents(), return extra initialized
> region in ext4_ext_convert_to_initialized() is no longer needed, so
> in order to simplify logic, this patch convert to return the requested
> size instead.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
