Return-Path: <SRS0=C+hA=QO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE3EC282C2
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 16:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C1012175B
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 16:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="Vz4rqXHg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfBGQGF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:06:05 -0500
Received: from mail-eopbgr740120.outbound.protection.outlook.com ([40.107.74.120]:19534
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726319AbfBGQGE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 7 Feb 2019 11:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hJnmc5d2LJTP3LrtKCDOMheKvv08mkrtB2p3fGdw/8=;
 b=Vz4rqXHglOH9335U1Kr4770fNpU+/FENYU2zKeZD4+GK7d6fmhphCSGrZWideo9WRdM06CIuiwndnJ0Uy+wT9krPlThBRmMd8lgZJjRgPcJ7zstrrH+jKPAaCS7pvPMcDUPqlr6zWmM1orH3Y3wvOZvQL7K8w2vWkPaIfMcJ85s=
Received: from SN6PR0102CA0014.prod.exchangelabs.com (2603:10b6:805:1::27) by
 BYAPR01MB4982.prod.exchangelabs.com (2603:10b6:a03:79::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.19; Thu, 7 Feb 2019 16:05:59 +0000
Received: from BY2NAM03FT042.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::203) by SN6PR0102CA0014.outlook.office365.com
 (2603:10b6:805:1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.19 via Frontend
 Transport; Thu, 7 Feb 2019 16:05:59 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT042.mail.protection.outlook.com (10.152.85.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Thu, 7 Feb 2019 16:05:58 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x17G5tY3028751
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 7 Feb 2019 11:05:57 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CC2FD7A2DEE; Thu,  7 Feb 2019 11:05:54 -0500 (EST)
Date:   Thu, 7 Feb 2019 11:05:54 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     Ross Burton <ross.burton@intel.com>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v2] create_inode: fix copying large files
Message-ID: <20190207160554.GB7387@mit.edu>
References: <20190201183247.8148-1-ross.burton@intel.com>
 <20190201185950.GC10211@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190201185950.GC10211@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(396003)(346002)(2980300002)(189003)(199004)(106466001)(46406003)(47776003)(6916009)(6246003)(229853002)(88552002)(2906002)(246002)(4744005)(6266002)(8676002)(486006)(76176011)(52956003)(86362001)(356004)(476003)(33656002)(336012)(54906003)(8936002)(58126008)(126002)(186003)(446003)(106002)(50466002)(36906005)(36756003)(23726003)(16586007)(11346002)(26005)(1076003)(2616005)(26826003)(75432002)(103686004)(4326008)(97756001)(786003)(316002)(90966002)(305945005)(478600001)(42186006)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB4982;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT042;1:ZRajhy8ngWHiw/hZAthMRrYo9UO5Ex8fKAmhO1BnTS3UrZL5EZpa0jQmndpT3XZXVgnwRghiQ3xDBHJTopon5L66DRfLYxsC+4YuLFQNYk1hQ0d7Nu4QRhnIdsAbwEC4p2D8SDxRW7HeqxZPHuqIloUgPstrG5pcaki3QmMERGU=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bb1838f-2be0-4ae4-2176-08d68d162641
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BYAPR01MB4982;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4982;3:NhNapB5Qzr4jg5iKBDrFGNOs/2SLGqIxn7DeE37h68U5Se0dyoFeK9LnFUvMiKAvobrPEh3MG/N8ivbVzvu4ch702NsH8dSpJwU1cR2KnMejBFY20lEUIMiZ/9/5UwPf5gwxJ4pL+n9svKXQzw2rVBqUFn7r6YsO9Lw1LhSxT7LXrI4WiC4ark6fWfo+UhBcCZyVWwqQlhLqG2QiyP908Xck4SURtvg5Nwj1Whyh36nbxKvsSmX//f6viow6cAKaAz1MFepPZk9VfgLYJCr4ChGF/MqoCvQLZEqIe++lcwGf6hTNjpzwTYgmIEIbB2sMsPFeSpdAiJf9UJeQJ2YkIwHe8tsQdXtVRB9XLMJsMZCQ/QxxHSHDgkujrQCVtjx+;25:IMAhfQdb18Bx+SDK9BbBwq1J3H2UgLn8oYsWLlBSCuWycMY11m70GAb+acXDANxmkW8Ll3yqn5PlOIHyybOFG5afcI5Dn3Uh/2EOLWpHZ8Qv1KjD2TiGRjhycejuYbNTazSKORg9HGs39uaNKCJHupFMQV3RGfKXkfXi5kY90hXO6l9FEW4QfU1z4tIhh+j+zBRkj3w0Lxsan2yuS8NptIcuvbF1ZE9tN+hGP6yQvLuU8yYXr2f5CObbsGx9Q10vCQ4AgU1NBbPXrJf6Qtp08C70Wfg/EwvStq+WEIZvm9B1UZmlPXx8ov8Lpdu4qsoDPryItP4F3aJDhsRuzCtnHQ==
X-MS-TrafficTypeDiagnostic: BYAPR01MB4982:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4982;31:GoZkFqf3tZQRjgRQi4sWFPejR2Junh6x1hnlgfc9yjnBcj7kP1t+v9UyDqA4o6ard8OJxdIzQFupItLvDFvQ+4q76g7Du22sj4tgsVaqpEaVcv6MorL+BPHKrSH9v/ej+5kHuXKN316+H4LgdxsL5zFv5txnHXBRFcIt2/A+UYl1r4zmjEVG9Bjg4ZJbA6Pyke+lUHy4EyQ7G/B/iYb9DpQWy5Upibj46YOlcrXCnUU=;20:NSadDlA4epYcL9jXaZ5cM61cTIsq1vob0MkLh84Ib+BWD9VZNQNma7Hiqj5o92E8TbjtFjAJD4/px44IJLF4l5Q5RBiOSllRUnZ809FFGR8QfbvF6sBAuwecHUWvglrifKfxY/51GNdo4n+lQmu256ajmCosokCCnj1f14UT30GYvnrpVncEjE5O1+sdsrR2jvzvRcFA6qArFEB+YyxpWOath67fnFPLdODrZDAzKKEdE2Mw8HDcyfDhsMFLF5czdAIMFOj4qdS7O0QYCDwMVCCtod87RE66g5wqNjN1/JhuQUtUFg0bhcDC4vK2GfDn486xbqDRTQHF/Kzr54gc+8ZpaKxHUSAqgpSqrncvcwGtxgLlu+HVwiEqZ4dj+KluoNiH4dSmGuqFPzneii2HFBuLcY7E4N9YUeaQigl2pbV79x1pFkJs8uKWb4CkMsQ4nzvBtojzKgJnWD0Q+59HOHgKtn/W7lDER7TkR/FnA/EYvhlrnV/XqOA7mobC7+RovdUDpWibbonAHLOZ1W7N/4xgkhnFxg3fJ4RlNRkYxakhIf+38eGIRF1gYAU1YgOiYBodSTTES06CaSyhLX4kmz/ugJgO3YLW2hUIBpUZe0E=
X-Microsoft-Antispam-PRVS: <BYAPR01MB49824D978BB7231BFDB95204B5680@BYAPR01MB4982.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4982;4:QEJBYlbz/NjC7wGCT1v37sOge307LPB8KLkapGqOhdRP6x0Vb80BGLvlUChTmmelJQCkEjI5YiprSNGjgSjW2hhwTx8ckBXJvapY+ZwQrcoQM5ufZFfZnuamHA0dujchGHFwfifpLeWdY8FPqR8TIzcwM9vU05h4ql+X6fRQ/BSTQS+/OwaDvDXVPK4x/UMtDIz+R3OsvjZWJNlFHI+mBWm8O4JPmQJlQTeR9pNES5GFVw8xW3BxsfVA7wlZVxc+kGgkwy4JWNYmr4+klkAd1SMYZ84qigPtXUFyqffB844=
X-Forefront-PRVS: 0941B96580
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB4982;23:UY4YFYxj/YQ2WRZ6DxtsrRwyHi4vAkqNfTOFTg/ZZ?=
 =?us-ascii?Q?EUE7e0Dfh496LNOszpWxdMKPmU9YmP6Y6j3EmkNkoef+fla0GPbj9i1w6vkx?=
 =?us-ascii?Q?sG5SUnVITYdJtzDl9RBoO2ZR1l6GfJwNM9dNbi26FC2HO6lXi/tshRoK2cm7?=
 =?us-ascii?Q?mOiDd4wqySLvan9PmtJZrJPGtThbzLU/Vg90ITxIR7X8j6Gh0qgfETUup8UG?=
 =?us-ascii?Q?CDURwBwZvYsEfjjgE4T/wRpxvNQ4lDm8eodl2L9fE5Wf4ob6MRAcJUoRaMLo?=
 =?us-ascii?Q?ddAkwxi7zVsD0hGZrdlXDLa8lX6re4/jS2Hh/J5v8I2z3TytcMlHbOQwOtHH?=
 =?us-ascii?Q?tMEELQdU0s/PaYgG0WAKkXvaAUU/1SL/Nj5PMSliKAzZIqgYf2UkUVP5a/CS?=
 =?us-ascii?Q?Il0hdI7sfnR7/C4EGO/ThEuV/knFob+DeBalcnMSSy1u5HxQ0ieuS8vOrvoi?=
 =?us-ascii?Q?ZuRcrKCHwlyzAXlB3wgMAky3f6JpXjjoImtRjPV7MsMiLYn1GHwSXnigaWFV?=
 =?us-ascii?Q?+V2klwMQOPO+ETVvnTXl/RhJ1LgoiVXOnQ0mSV/t6jiP2dQ+B6tEWk8DV1ZK?=
 =?us-ascii?Q?DEwsBNU4OqQjHoJ6tdlaJUWVWo3daJXLxUt1huZU7+A0KZnVa1dtJX7/RfSN?=
 =?us-ascii?Q?Z43HUfKk0TuGNoJ6qXbDoy+aZEzkkC+ozCzr37d7o3ibAB9EwNHNoFGHs+Kh?=
 =?us-ascii?Q?+0SudtW/ArKXpYazmlbNdYdkjZ/x2cpUbC+0bsTuBoRbxKxYQTVwYJSorAsE?=
 =?us-ascii?Q?AcvsDhrSTEioEB7+hdKS/iCQX028wp8TmTM2Oy84/JnCY5zzlSxet//rujhe?=
 =?us-ascii?Q?Ecg/55WDFSsQks8g12t5hKMDihFESoxfOBi76/8910z+25IWANU7VKzQ1c2E?=
 =?us-ascii?Q?JdmOzMUeUa47pXWurEfKcmU863S54W9sYml7MKmR2ALveKbn12aMS1MTCKmf?=
 =?us-ascii?Q?XVDFhw7OkLSo7Qxhxggkc9HN/bHGm4SK1ILtygPRSKfYv5OShobQsBH3w+eK?=
 =?us-ascii?Q?yCRArXuOsPY07/A2SQzSNAtFxX7ExvHOIT2Dmxk+o/18Prbqk9ahf4A8d4ty?=
 =?us-ascii?Q?MJDT3quGOWQUzqMzPod25jHPeOoL0vuxXI9cG16aTjP2VkFPBAxWwo8UY5dG?=
 =?us-ascii?Q?TgazfqQqW/0dk2h1s5bhRo8uPJ/MS+92oAqOaIxtVaIEffZiBiynH9SJu1KW?=
 =?us-ascii?Q?EHACVAurh/wx0nzEwR2gsQcmHTfEiqbNDB5rfNtPRurtRWHG+AAhtPHM6KjL?=
 =?us-ascii?Q?V4wxdGjf8Fi43ymUtU=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: i8LE4PbjTGQNLjk2k4UMe1TdV7rBpPdJJM1Lhk56vseus2AhhNmbXSjzrQl7/ZtqL6D0o6lb6HcAOiLh7y5qAEkdlShxASqCbHq4hBWWjnXDvF+o4h9TsjwDfWONauIXvFsbd2sR7DIxu9PYDHFuf1Tw+eNy9RdKXQiKns5R3BK/AgZjZb5UTjIN1IRYJJEF2bsT2jPrtn++PXjAcNFNew9XMiGc/7XvjsE4GavwpeNfMLfQqgi69tRKvthE04WPo8YsQAzJ603HW3G8MSUlca8GiwX65JrJUVMejfBtXbz+9/L44v+WHaj3IwXMjpCqY7tFh9OhkMihjFQ4QGuxwV2a77g/FGNF8F+EjhrHBdZlNANXJi8qBXrNVaA/WsG1UFj4rMIE7NLwDNnp12+n59Y2c3SFGqP+NejqRQrgAQo=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4982;6:c+8aheY1FVxG9LPxucV4NV6mhCE/CWsHm2klguGDgxGsw3+T5Z3LsKpGAGu/N6TCWM30uWXNYnCzxqSzi9KWhdc7sSM4yCVKI2jEXOOVSMx6LrbBApnJwwKxNkB782UpXtQ6lDbZZ2/x6hWMtdNF3BB89JZJ5e46m1lwBFEsMmZZ6E1Pggqw+3suUTA7wv6YHOZEfBgNBduYbhgANanb6fxarPle89yHujv+IPiG4k+9IUJHM65gIBKRILugKBMzDYqwQM8sKTUS1/jO4AXHZaAgr/1EnkETpE02U02sZvoyzPErSav5/roZadb/AYJ1noSyrxDU4COzm1gBEaxhPiYLFagJ28cWqJ8nmmYH2/0iVRAT7BOb7C0uhsT92mB5oHaN5kknDvKbgJX6fDzR7xTbefjPnx3yx0RZAk9fiD/Vwpxeb87Z9fW5V/kJSrJ3MlhdOrW+y7aLTLPid9QxSQ==;5:D5l8PH42h4JEmLzmpsoCba10PzVivSMZ49LJzIbNIchF3zkO4+jYxKNb522xSbZivbOjBIcW1m28DNshe688LuUeA3cvvS+HpFrLrtbGjt577Z+ODuiRLA0dLh+XdxukzUXe5QQCmXBuGA5jWEk7PVWjS8waYxvxLdGpIqm1uyQ1u9psnAITMH6Dt8bmn/mbgyodbIys1+M10D8LTpwAYA==;7:kAap2tHXaGzi6acGwjq+LbADRKdIWAskiys+rCyClb5XNNif/b2aYinjVhN3jKH2wFDTElZ83EJZEeW6J/dScoyAeCoRm4MXyEAy1sH0K+WBoRC7Q1oRtelj4mhSeweMeYu/PQDyvWgK+5ZW7k1C4g==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2019 16:05:58.5710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb1838f-2be0-4ae4-2176-08d68d162641
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4982
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 01, 2019 at 10:59:50AM -0800, Darrick J. Wong wrote:
> On Fri, Feb 01, 2019 at 06:32:47PM +0000, Ross Burton wrote:
> > When copying large files into a ext filesystem at mkfs time the copy fails at
> > 2^31 bytes in.  There are two problems:
> > 
> > copy_file_chunk() passes an offset (off_t, 64-bit typically) to
> > ext2fs_file_lseek() which expects a ext2_off_t (typedef to __u32) so the value
> > is truncated. Solve by calling ext2fs_file_llseek() which takes a u64 offset
> > instead.
> > 
> > try_lseek_copy() rounds the data and hole offsets as found by lseek() to block
> > boundaries, but the calculation gets truncated to 32-bits.  Solve by casting the
> > 32-bit blocksize to off_t to ensure this doesn't happen.
> > 
> > Signed-off-by: Ross Burton <ross.burton@intel.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
