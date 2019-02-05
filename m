Return-Path: <SRS0=Sz5y=QM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8815C282CB
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 22:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A324B2184B
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 22:10:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="ngouOUaB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfBEWKg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Feb 2019 17:10:36 -0500
Received: from mail-eopbgr740130.outbound.protection.outlook.com ([40.107.74.130]:34797
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726742AbfBEWKf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Feb 2019 17:10:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3W4/3XYkuOdesFi22n2VAsYVpS+DXBzIs72CzAUQE8=;
 b=ngouOUaBBXypx4E+PukzFRW5DudxIGoIXtHeXUquSD21fEQNsL5w7+2qJf2cPgwZQ+ttOxxVTpaAocwvna6MbF1M+ybtUay1HTZoDrzxhgTnCXCrTSgb9ZoUpu/OMt8r8qio9CdQ/IrSz1lMROGYws5TWKzaemjdlPe4eD1FSNE=
Received: from DM5PR0101CA0027.prod.exchangelabs.com (2603:10b6:4:28::40) by
 BN8PR01MB5586.prod.exchangelabs.com (2603:10b6:408:bd::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.17; Tue, 5 Feb 2019 22:10:30 +0000
Received: from CO1NAM03FT064.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::208) by DM5PR0101CA0027.outlook.office365.com
 (2603:10b6:4:28::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.17 via Frontend
 Transport; Tue, 5 Feb 2019 22:10:30 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT064.mail.protection.outlook.com (10.152.81.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Tue, 5 Feb 2019 22:10:29 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x15MARkm024763
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 5 Feb 2019 17:10:28 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5EEF57A4B1C; Tue,  5 Feb 2019 17:10:27 -0500 (EST)
Date:   Tue, 5 Feb 2019 17:10:27 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>
CC:     <linux-ext4@vger.kernel.org>, <adilger.kernel@dilger.ca>
Subject: Re: [PATCH v2 1/2] e2fsck: allow to check >2GB sized directory
Message-ID: <20190205221027.GA27263@mit.edu>
References: <20181214075054.47359-1-artem.blagodarenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181214075054.47359-1-artem.blagodarenko@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(396003)(2980300002)(199004)(189003)(2906002)(336012)(8676002)(229853002)(1076003)(246002)(26826003)(476003)(58126008)(446003)(54906003)(11346002)(86362001)(478600001)(4326008)(75432002)(486006)(88552002)(2616005)(52956003)(126002)(106466001)(8936002)(46406003)(50466002)(103686004)(6266002)(6246003)(76176011)(90966002)(106002)(26005)(47776003)(356004)(305945005)(33656002)(97756001)(42186006)(16586007)(23726003)(36906005)(786003)(186003)(6916009)(316002)(36756003)(558084003)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR01MB5586;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT064;1:WD5U4vKq9pkfy99N3xRIM0bOfOCZ/qhR7rR/keyJgSHtDjbP21iSJWSG3NFeduLPu8S+0a4rAhA02nt34SO10xLj30oPkLADJDOVabESKvyoYEmWcJhyfJFfz+n8LxWN2UB8uMtqVxXuo8Xr+ZElrg==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5011c002-dd79-4730-7585-08d68bb6bd97
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BN8PR01MB5586;
X-Microsoft-Exchange-Diagnostics: 1;BN8PR01MB5586;3:tsenOCzyU3KgcLhxfi6PX46uVVrS0+NXTJPx21pLiyycUA3dWTOJ8XyrhH9Xe6XsRFm0W0OfxFFRlMYdKA2lznGEIyBpZqxjvhCqD0XgbCKEBCRFf3td//6B9/MUfUtmIUx/BAHZHqbLc2zI3UIO8lmtK03IxKAtwjmjVuZNn0RpkFhFPnyQqduDjkk094AtmkUteJAAkFb/vDkvHJtRfeCORa6tyFg2EMwtqpLzQHKucNjEC2B7x5KjAtPRnJLtinXzuNjSPUXTFBAyr4RwOmsYsxVCGeMnjjEmVXDtdtWChndSqvG3hBLw21u3i/qzs8o0n+cn60AzjSnW7/LzwLeWAbHnNJIS92DSYM16wgb5ltF5cPJXJI2+6OTr51GD;25:wM+wXK1mRe5v49kb4hdhn4fcHdUbJNRYlNlNF2YEb+/6R0RLirfEIFI/tmiW4goek9k5wEVSSZ1mzrFv8to9+6YOSKmzxA5x1AkYgIdIZko+pJ8SLSjf7ylSgcEyKKr/ZSoUOeVZyxxmj/wSalPqkKvJNncXif1M1K39vIrDz7yl/aeUZshpZbfddEZEuradxdRb0/p4J/X1iqvuRjlNl9kh4LABdY1Hn120KwRyIcrkAqKnFQ7hsRkFf1QMjcgWzALFhQMVVUSGGYWETpNEoVOBK1EMEmol9AsrCSf3+l3xYP3DyhADZhNX1JOqYjZeXSLNfD9d3Fa8vj5fJL1P2w==
X-MS-TrafficTypeDiagnostic: BN8PR01MB5586:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BN8PR01MB5586;31:gSauDNXPttlEK+898FIz4uEsGAOBSV6uBhTASdAAlbkX5cjNsJ1smDfdJyhmHDKW++7BUkNvHbe6BHSi/BtPaabwQWByltANZZcNed7CTUfGsxOZ+l3vyYFj5C/Wm6If34e6vLeg5zUjGrVf+edyzh7hi0Uzi1A52/kE8yjxSDw3w/3Vt58LfgoJf1PCzcHiHt2gdbvueWFuz5WFM9Zi0/f+z0T7vTTOpJgOHWFrLtY=;20:hZ+xRL0lOmJnIiMIgbzrpPeGmmd2s7xHwB/Xicbf7W8zwIPtnJ0wFLvgnia5X449yaaHET8/1xpr48cN4QX7yeqDI6vjbx3N5iIbdIBCcPquS0wk++9pt1THU3lsN/DW02pFi6tm2Jt+ac58hUil8yyfaPtUek2kgx89wS2yELGus+dorFVvBTAT1Lyg+f4YADB6Xzhalt2c3BieOt+edFIuFOneMK06vvcKyHKjH5A8bCeKrWEhryI/9EvD//SokhiIsEX2AY+l2VRbXdILQ7VroOHOOEI30aHOnqNiQApFV4q/0Jkqyt+KKSwiSjWoRKyiR+b2FlSppYWpUg3UEACrLXPWuUiAM2GYLHZP4y/GrQGNOJAWVD0rjE/J9BOqWoxeo8csdupQ8Xrk1LWXyuyhMTK2D+/qpNzeCLByFuCpfgbRf7IpjoPxBtxm0V8Nuw0pHlicnWONh12z3qwGcEmWq7daudIllpyYJvYJKWPCxyJ6/bZ5XwE6R87iG3XEeIRyYm1YAdxaBD782vbH0Ydlh/uSWWwyrGR5nmuy6Pm6glboOjhcQLKhxs7PJ2xzhfHNOQgZ7X5q9u1hGFPd5hydWPvRCOiJfPXcTfTrITY=
X-Microsoft-Antispam-PRVS: <BN8PR01MB5586FD11CED890A0C0C4E92AB56E0@BN8PR01MB5586.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BN8PR01MB5586;4:KkAFy3+1fE89fCJId0scuuf9yeDtCzXxYpZmXN/+bVPqKxVacS//t3IdWW9n0NOYgobujw30tWlbYyZcLi8m8a8igTYMJV8sr4CfHyl64jbuQWWm+pfGn02DyprrLp4kAP4kJ6RL0oEdHMIkABInzgKDju6Cgt+HqeR8ByWFcu/WKSrRuRa/MtPeAoYX37S8/PXO+pExKvHiIVpidOdy4CrWbKko7hec8SiAo3BKm/iMMGx9x1i4PG/HFKFhGc81DpEFO+MXDoqHfa1kRMHPZxGMesVvjNmDH41YiTFlb8bCRmoit20ANM/Tuwr9uIol
X-Forefront-PRVS: 0939529DE2
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN8PR01MB5586;23:6UI9Bf6+Oc0FuzmweAnptvdKzIVENYt8eH3FZ1nsh?=
 =?us-ascii?Q?1qX0AXT3aSv7RGcyLRGAt1VeVvZnED5HktQcY5UaTCIssLFgGXeATmTwdakx?=
 =?us-ascii?Q?6xqR041e9W18vL5OweBKQGJNlW/18DmCQ9fky/w0/Ztn35XybhIfyQJzhmyv?=
 =?us-ascii?Q?qPGeFjc+P5MP611kQ/1a9wRyYMkIs/30yWxDF8eOrqatR9JHpVG/pQmXM0Te?=
 =?us-ascii?Q?/ekKykDuxHcNFntq/3fCE/U3zZZN9obvd78mRQQ4iNqTYM25qVEb50SnLtXQ?=
 =?us-ascii?Q?uFnPKSJjbuuEk6sxJOyy92nr8dvAxGoLxoVnOuaGjWEqPyyKA+GfbJVNZS7p?=
 =?us-ascii?Q?HPgw0GMCFv/bcZxWc1Ii/a0hsIONNygp3oFhLXhUyx7yJsvmyGq9zyk7cHPv?=
 =?us-ascii?Q?TmwjIGG+jMONyZQ09nQd2GmvfgOxDKHy+mWqPpgkulKAE/y4+eq25M+oCQOo?=
 =?us-ascii?Q?lfjQRvuo8HeI7thncaHvyQQJTJ5ylRetZPEGSbJSZd8nnlpfPnai4b0+um+8?=
 =?us-ascii?Q?xLZt0VVVi0ZGVryjhPKJA1BC4HgsqOJexPMPonH6P9++qfT0X9Y+yPB3+MTP?=
 =?us-ascii?Q?lv13M2LrggrF6hF4FIf2tGk1cqhy42zA94l7NrVrSUSZxPZ75xUrV0UdTWkN?=
 =?us-ascii?Q?zhCYpbV9K0tVBAptYIL2eyHIoSuyhRWaz6mrYjJl5lU5pVrdEv9zH0xicLT7?=
 =?us-ascii?Q?ygo3nEcqS7HOobbHUvf1ZD6W0gSE/juQ3zf7vOcTMNSpU50lP5m8OUT02mP8?=
 =?us-ascii?Q?qKtD0bNZN1NSS0DXH1GV2PKE5s7Cjf6WxS1Kge4Apuv4xbR8BvtXeZyXGD0K?=
 =?us-ascii?Q?KLe9kEYH23MmMG0Q0hzlmQ0NeOMTvfSYTkmecO7iUEa6hdlu6f61fOIUtxtg?=
 =?us-ascii?Q?tx1dQyvU6zq2sxOoZW0bCTtjSn8AjYmAqob1STsUUAZpGQgn4MUpywypZIlT?=
 =?us-ascii?Q?HRXAncQSrRUdqVpSdBvt/6QZ2yjaIv2iMiDFzUpBJCEO+JsLqL0xfUrbniUE?=
 =?us-ascii?Q?WRyLCt0HDE4m3X21MJ+yG+UDOJPtA6f7RFUddk0p6c+4VoK3ja3Mm10xXB05?=
 =?us-ascii?Q?+sfo18OSdsPfjYHBN0AizbnnmbaTTjb6SFZSMmAGWehGnQXmr8g+QUmwZ27t?=
 =?us-ascii?Q?DCLZh6XyRNMh50Tx7FKEQkRXilnuKrdGrC5setnYjzoe3PcPJbxbJ+labofM?=
 =?us-ascii?Q?kSlo2c6YTy3+Dr5gw9qJ52axAWBt0z8ZWd1Z4excXPmUJldHzEKgZK1PdKsT?=
 =?us-ascii?Q?EVA1CmzyFe2YMNDOII=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: pkeBPPebG1HHKYpPLHgzHtRrXrZE2nqqJlGC0HBMoD+t7aEQSSciVwzKuC1pO50d6hH75udAPxTfTf87B2HFr0tkb2x6dDR76nfXTeRZUYjzVppvr57gXR//yO5EjZYNKLAd3f4e0tLkcgloLxFp3j64DIQ9yb6e36cQrmLkPSgp8J6FpBFoR6ZDnVbU6ZzfWW/RxIZo7dn5AlAKMtV0cHKR4TcQY5EnVUeOlhGXKJdOMgcgDcjKBgsjCO4B7t6nmsDtpQ/ZzePPrJ98tKbGubJNKbarSSi8gD8R/iROIRdKAfylNc/g+9Wl2aHvxgTqPr1vMI33lvE2x4MQgOnTlYn90J+q6W1PCLvkfRalekpl+d3FVzXzL4+S+3/66P9G5V8m3jZwKpHYNoyv9gIb13ElACPe0XgTPFG0QKxg1fw=
X-Microsoft-Exchange-Diagnostics: 1;BN8PR01MB5586;6:rtgHQphS1ekSO8unAhRf+b1piydZDdeTtvsxacDweHwxfm8adu1ITjX9eMHskCvID3oXaYnCV1K7lPmlBDqiwkopXIUv3nFQ+j8yq33jpdG+LE4080bLp/SU57xV3OXQ1DyKMWK2XN1B7K2NS7OqHektESnbQrMTwKtt4UxDya0my4r4h2RLQsNyNInTw9M5zwdT1E3DLwwxQ4XivQciZ3dc1wtJ1O6ain9pe0UG5OES+MuKuvmw8tRSDhpVnZmzyasi6z70W1t0miAr1Ix8gSal8VdjGToHg099mVX07mSz3tynFAsuL/af80dc9wcNz3f8dKW17KcAe1aLP4OoQAW8NF9VKbnqzeeTICbGOAN6HKv58Cb+67EGILAyFiXCXMqc8KvCT68BCaOfMEz7wUEks/emXFPsURjUlbX5on5AM+M4ACJioABwXDXa+GFnZHXryMPFBnO2t2HEygV3Ng==;5:r4lISZc2q1LEWrVNaYPvmk6QQj8SOPtWiviiq998I49SygnTb4oNBPxaZ8gaal6Rv17/znffchuuMX824hpaV9D4xfG5XaG1r9pk4Jv9HH7wvKdKZK/PAJ/P3vrnpvXig7vInKuuK4Zv2Y5XGc6Zvm1qU/cJpgu23MAxFE0nkJNNtAh1GJFv9tUs09uUusWXaR3m3xULjnkbmauGToYFiQ==;7:mgYAjHmv4O/oCVyaosBlVXzcpw+YFBW+RMUoPV+g3vLU6RRxe4ydPFnHiXP17uWYBMeFsQ87U2mE1sI5YbX5Nku8Hx2yp7Qms4gjVekhRRi+zcgBiRAi8bhMmKFa+RSJWyOcKIqXd+4qyWrWlXvg6g==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2019 22:10:29.6088
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5011c002-dd79-4730-7585-08d68bb6bd97
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR01MB5586
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Dec 14, 2018 at 10:50:53AM +0300, Artem Blagodarenko wrote:
> After large_dir feature has been added, e2fsprogs is
> ready for directories > 2GB, so we can remove e2fsck
> directory size check.
> 
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Applied, thanks.

					- Ted
