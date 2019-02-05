Return-Path: <SRS0=Sz5y=QM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FB6C282CB
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 22:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0124D2184B
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 22:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="dferPnIg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfBEWLB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Feb 2019 17:11:01 -0500
Received: from mail-eopbgr680122.outbound.protection.outlook.com ([40.107.68.122]:11573
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726742AbfBEWLB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Feb 2019 17:11:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3JkIdRTjP6/q7tV7wexIS7P+nPUB7P1roeQoX7aDdo=;
 b=dferPnIgPk8BXiB29/Cz2Ks8HbllgSJIbceB092NJhiQAT8Tc0y4W6Wkr9j1JGtvkfyMsFZRFmfawgxKZpfV89STdqnLgLno4QKoMQP8wo3QU/j/yeso9m4fmboQT4TkNnGIrzsk0rAnNMH11ICBBL6w5qC/zF50BTwVOm22Zsw=
Received: from BYAPR01CA0044.prod.exchangelabs.com (2603:10b6:a03:94::21) by
 BL0PR01MB4978.prod.exchangelabs.com (2603:10b6:208:62::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Tue, 5 Feb 2019 22:10:47 +0000
Received: from BY2NAM03FT063.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::209) by BYAPR01CA0044.outlook.office365.com
 (2603:10b6:a03:94::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.17 via Frontend
 Transport; Tue, 5 Feb 2019 22:10:47 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT063.mail.protection.outlook.com (10.152.85.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Tue, 5 Feb 2019 22:10:46 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x15MAhqe024837
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 5 Feb 2019 17:10:45 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 756047A4B1C; Tue,  5 Feb 2019 17:10:43 -0500 (EST)
Date:   Tue, 5 Feb 2019 17:10:43 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>
CC:     <linux-ext4@vger.kernel.org>, <adilger.kernel@dilger.ca>
Subject: Re: [PATCH v2 2/2] debugfs: output large directory size
Message-ID: <20190205221043.GA27318@mit.edu>
References: <20181214075054.47359-1-artem.blagodarenko@gmail.com>
 <20181214075054.47359-2-artem.blagodarenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181214075054.47359-2-artem.blagodarenko@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(346002)(39860400002)(376002)(396003)(136003)(2980300002)(199004)(189003)(4326008)(786003)(36906005)(54906003)(90966002)(316002)(42186006)(76176011)(88552002)(8936002)(52956003)(246002)(336012)(8676002)(4744005)(186003)(47776003)(36756003)(58126008)(106466001)(106002)(103686004)(11346002)(126002)(46406003)(2616005)(26005)(356004)(476003)(6246003)(2906002)(1076003)(16586007)(50466002)(486006)(6916009)(97756001)(33656002)(23726003)(86362001)(6266002)(305945005)(26826003)(229853002)(75432002)(478600001)(446003)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR01MB4978;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT063;1:/wROvG3a8wFTvJuRjJMpSd3W0qYCc/FfD+e6tNHvT5lQJRj3htaj9u9CNRTJdKAZrs+yfQs0XP3h4KbB8dJ0XQL9qr7Hp01zWOrwFCjbsE60oPY8PqyeVUa4FmvTzN5mC/lNQCq6M2hpJ5I29Z197Q==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acf8cccb-0ea6-46a6-43fa-08d68bb6c7bb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BL0PR01MB4978;
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB4978;3:cTkHNgARVm267tBpFVNDwXnB8GCfKG+NRejFGLOt2JTg9GnG+37Lz7MRIVLo+dvxQonPBvMQn7UES6bfG2Xb9SMZrpgWZJgWFFFvwOfkLpNyzQiNdGyO2Ia/lX3qX/YlGGVBoCuwk7vlPXsQrmUAhvN4FBDQnE70zRQY/hGHeWCYkpKXCebxVaChOLIYFOUqF0fqmpiaUg4qmcoWDE9jga4NYtPZN1+ezV402Wcaz8pBKQimxQacRm/9IYdzRJ3vuDePncYn80/Ftl7VFjNPvbXIq9xm8/BM15+kwFgP9ZA+g+XoX5UXVX/ii2+cMOngKsgkDnqbhXa0HOYZb1wuVK+/y/yPYkCjiMtWZRgidhj5U4vWdAZdO73rkbk7G9vv;25:6Y+QLN6XoPjA7wqx0uwKcC1pe70Aua+pwHSFi2yApUFkkJUeTKyyln6PAFDr5+reje8C7KNgixinTwKVfml+621iPVwZWpq89ctJayY5QETi+fp3GH9ax7JKmEMDIP5+i78vu1Gmw9hURToruyaYAVnAFxP2MEvQMKrAuvM5g286kxawLejjlKXZUXGf9H9fK1XgkwdWvxtjjq1iztsWCTjPwkoVZqM8x9q+1jtzyg8DCkjqLNcgS3i+6y7uBepQ/HPIEvSFdVkcx6r56Bafcm1RwL1c+BEVrNm9cH8r12vSFnc3EXz/UWdvCMYHFFf8HwxB43TVdyrK+749Ow+aaA==
X-MS-TrafficTypeDiagnostic: BL0PR01MB4978:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB4978;31:cPnJEDrTY/b0BQNtA9yBl9DTGfVVOGfFSEOV74TOEhJ9TGFXVec9a1e5GMSgPaf866fcXhCSRAoYo4urHAr5YEQIfuqPWoeGUCsX4pxfhiq2xYC45N+PBAsXs56qPYwr5FTPY4EgBzXTDrRNIUp/zbpZkPF8uLNNrG9uFZwoCwo/QmnKtXcIoG+bsUha/cGhPTcwAmj+Qdac3wZdL+8hvQx/xxQcwzuveQgAPDOvUYM=;20:ca1If6GinkfzCAM7vfu6D6mFzRlZkWonA3ABn/6M5Z7nrYld3wOeWtn+jVUjK4uHcJfypBRpM883UjHLmDCA6KVemZDPv0jjlPoHc/UcDvVtcDMdxlCH9GkHgsgP7YAinN0asvgBMpZsR3Z+JN9dn1ouuQKkwRbGrVPX5SLA9yrKOZH7u6efP5joktX8PzjUKUREZUaRvLW81i+SXrYEnG5IvOsefhKDdR5ZT3gAi5SATWnN1B33o/5oeCR5te//0whJyn7ZjIIQUpYR9Ht8Dldz1IteIK0fCdOOnk2wQwwtFFq4IPAnVg6DmzcuFE5vMIbLUaWZALA/0lkM+Ru86KPwg1ElTS47d6r5Zuxjn39nfHIRl+YmvEKvEzzG06WtQ5Q0ikTXSBQzAuR69IT1du3VYoSMhDCBrs4WYeyefur0IouNMrJjTAxXKhtI2666X2dvGSOeb2EtuA5kEpCL8kWubEfYVg7P57UhNa6MPmVsG4+Vi5QUrxMHkfVBTdAW4i5/A6eCuFObJUfC4HkLxK4oJntaSJflMOlR5iQkDcjZDRpc/zvhO8JmvLs0X/4RruJ3Xc1iDwQIKsUmUDLR11/dRNKuptd7uWRhIiwo9OI=
X-Microsoft-Antispam-PRVS: <BL0PR01MB4978C13742A1281ADF980CB8B56E0@BL0PR01MB4978.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB4978;4:Eugl2SCAcloAbVP1KBjOIf+dcs/R9YBOBL6q15Gn857KTiYa+KAgFK+kk5PvZNE3NRru2ntXFKm24vT34vRWPD8g8BOp1teDKItp6rXxYBn4xGeWPU4dm2w14L+338TvAgLrMnIILZyrJSo85xWvj5qBCtCbQyp1UAh0HkAgswZTD4ZrQ0s97HYMsxc+dlxhVlNywajZzwu7s35AJeqVXPTID8VIrKtF734MM+WpRX0B81wn9phe5yquJpMOKkvr3Qb9rUM9aGDdHLz0POof0QEWUyn5OWt2oYrU/B18GtoF/E4/U5u+zMoGtMIeYESY
X-Forefront-PRVS: 0939529DE2
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BL0PR01MB4978;23:3S0idEgRl4s76i/OV8Xnce5Tpey1gEdS+GF+R/sZR?=
 =?us-ascii?Q?hLZ//9WlEWruapZL8YSn4wJNXFXwceOCtEq2rFZJ30ZTwCs2FmeCjzZlq919?=
 =?us-ascii?Q?NqgE9B0nHIz53L5n7YyyBHlgUcDii51bXZEHHSBXo+3wHVEFUM8Y/jQdsUHr?=
 =?us-ascii?Q?L+RDMibtd/BYIVuR3crIXMOOpZHyxgV9q9q4GLm+bEiFkIDntsGOM9wS0oQI?=
 =?us-ascii?Q?K3lWvt+z2FZpUqY0zYBHbROuUWWUF4j2fPBi9i03emXlSUvxclXFKbc+gg0V?=
 =?us-ascii?Q?O632voH05uNXsG8RWKqqLsY3IO5mfkspiR/zOvucxKu2fTLZJtLXeoz5q6p9?=
 =?us-ascii?Q?4k9wMHlaQkbqezyTVBAkOQms3UiMQ2Ql4+nEimPBSjJuKQQ0zXarzhq/3KSa?=
 =?us-ascii?Q?P5FW++uv8f05+vE1hy1kXVrSbS5B2AWe9lvOeNNuZKnkwd84sM77GcpeoUqr?=
 =?us-ascii?Q?x1zkEBS17oouk8wrtug4M53dCuu1cbC6Pk5LbRtuNtVGSLxN0y2+cNph1rN3?=
 =?us-ascii?Q?84HynLVDzfOhpKMiOcnT8bjRcgGveQOnYni3jWugRzUHQQoM3iJaBCSZpZfL?=
 =?us-ascii?Q?/BuZ5oa8Tms2mazDyav78pOQ9YU3KJYbGjLPDNeprvGKhByiBUUd5LDadu7c?=
 =?us-ascii?Q?CA4liJYJozwdDwnPEMYxo5+RyIqi4R0sErMvqiZ30013OJqYON3guf2aOs5S?=
 =?us-ascii?Q?5HqJTcktLWApOgAEQ4VQ2wGHdx80PJ0G5RBz00/xs5faBE1ZrtDHRcU+usy/?=
 =?us-ascii?Q?DWypuyvDJge1dLyIG+aj3vdZCkkMqfhQXGcmeZbnv0jf5dwXEvydHQaSgEyw?=
 =?us-ascii?Q?p8Arbb5vQg9j0OWt8mWZi8In3bzWqeDXBPp9mP/Blgmub32FwFI43boDxqiH?=
 =?us-ascii?Q?72yi22X5GEO3Z2KLqwxlWNPSDcPgD+Wu32DZsozOeqZCu4TJIxAmXlZCofYC?=
 =?us-ascii?Q?FoIeeTclQ6IdLoUgSrQM7e7cgFKHLG+rH8HTBx50qmwGW080fdaomEwL3bfe?=
 =?us-ascii?Q?Zm9eO0SLKiiHrTI2R9xWdCmfm1EIsUoC8lUTPYK5quOPJQyZ4Ayo1BOu/wAW?=
 =?us-ascii?Q?HDVTvBYhntJK0eKGTxLgwq02uMg4/wETwiN7+uA4XsyfWnnHBl57Db8mT4gP?=
 =?us-ascii?Q?dNIC9bPPzVfh34QdfBy9PJ1u/6GpFSFP9IcqGOaQwPMPlqaUgFlcxh1Eu8ZS?=
 =?us-ascii?Q?Td8nVRScblf/prfMeXXxj75cy6iU/H6+YDwbaebEm3gpmTSpqyIH1vVkPiza?=
 =?us-ascii?Q?yW9qyZxxi3hs8KcvHg=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: qvrH0W86N2xRQ1iF9jzjNkk/GZqRDXKVQmLmdG2zoK1lEkyxjYII6N+JZ/sDqbtEEDMWqYsOModeHj2QGXMk8esJgENqQAlwABCYys1r7ErdpGkmR2HnnkiMl/3q5Uagdbq7ygWcj7ognHCe35RN84OGozd1u6sGLEdIUMsrP4TA33b7l3jhgc+hJ9KN9nXaQO29TUEwl4ZNV8GIR1ueXt1l2BxLKzfjvWoYlRPtqU1DbqOdpGYfveAzbWSfY7YiA2DjGMZ6Mb5+OrXFts/IH6Pa2CRTqWxSAlKT26GujoSwEopnhVzGzH08CBxkgeBgBiDEa8Fh6n7oNoxDtxpnBKXJWaKLeHBwA0JpEYhYwOWDniCXxLoxJ8JHASF0NjeL0bhZegCDmuDj5qH2DOKcQscKLzmQqHFdAlNlgzjgPRI=
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB4978;6:kqdrBIM//PprGEm4bAdYnuS67YNdI2cEfScDUMlRO7UC6zPLe/u3efcWrBK3v69xltO8F6kfUKJztlc9oeKm11sHqUHSvIlMXkEof4W93hSVoU3j2iCKilL1pLfsBNxtmX5wksiCfJAPW8Bk865u1LJNIaJdd5PcxADeQLFmLh84HCuZBLq2Rm5+l/9Ai60h7XUjpZXgXjpRU+IMhOWDvwwf9lkH5V7ogPSgawvasGSmtOUtxqYIltSzfuuikobDhxHO1FmrGJmN+mF9nfaWyjEQSi8cxx5vXCs5Fc8E5XzZIVlufqsZQ1kaBsd7tgLeQyI6N8BUo6Ua6d9rQQcHpHAtXz2Mo4TgofodXnpZVlkhr5Z7wwpaj/Ho/iOQ5czr6o7rJFJRPqXT0BuKx0eja7XHhS3DgfzyBMXNyfhkImjd/zMzzSyG+3+EXrOtIS/1ZToHLzMuJWPaC5cnhcD7pg==;5:/TaEidE7m07c6NDsGVNQXAsKexYdsM54mJJGk+sGCff0NASLLxXSmDdQPhZQEvuMAwL8SXTEOXtP/CkAF8GtoU51aPAR2Yvncq+l4htG72+pOTDL4lBXKtOMFlfFhA63pP6M7IUaQAYMUvkfgasYfSJfQT6cH35zHL7XvBP1kUXMaCB7VYbZb7cYnrjs0B4jM+yUG2SljdKus+Fy5DZAjQ==;7:bjAI//CxBLfVbJpvoVXzMJzEAeZfzkErOru8TJQ/T6F2pvcpsnPpprGF2iGgtkSNDinNjjRyMHvdlR09QNo2xLa3D9sceIwrDFOhIunCqL42njodaDEJEJaba2qSsL1i2vIsdzwQ9LynHIXEXEffPw==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2019 22:10:46.6447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acf8cccb-0ea6-46a6-43fa-08d68bb6c7bb
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4978
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Dec 14, 2018 at 10:50:54AM +0300, Artem Blagodarenko wrote:
> large_dir option allows to create directory with size > 2GB.
> debugfs utility outputs negative size value for large directories
> and ignores high part of directory size.
> 
> Fix debugfs to use high part of directory size in debugfs output
> and use appropriate output format.
> 
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Applied, thanks.

						- Ted
