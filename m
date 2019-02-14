Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	DKIMWL_WL_MED,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D79EC4360F
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 08:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D3C8222B6
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 08:15:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=datadirectnetworks.onmicrosoft.com header.i=@datadirectnetworks.onmicrosoft.com header.b="yf0wYwOD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394478AbfBNIPB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:15:01 -0500
Received: from mail-eopbgr680056.outbound.protection.outlook.com ([40.107.68.56]:43360
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388919AbfBNIPB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Feb 2019 03:15:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=datadirectnetworks.onmicrosoft.com; s=selector1-ddn-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8hLBKRJamyZqScDilbE4u81aZcLP4GrbfZbCU3L3+A=;
 b=yf0wYwODgv+W6zL8lkRkrqa8m/kDE0FUse8nywyEWwJwuxY7HS7Ngt7mzpTnW66jYYLWOK1+6qNOcROthZV5LS/3QXTffsxoh5g7Fin5eCVU3i8m8HnO17TvBlnZ4kT04e5d+9uidwBGhcVLcY2sjQ9UcKzF3dJV2b8EpogeeGI=
Received: from BYAPR19MB2758.namprd19.prod.outlook.com (20.178.237.91) by
 BYAPR19MB2901.namprd19.prod.outlook.com (20.178.239.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.16; Thu, 14 Feb 2019 08:14:56 +0000
Received: from BYAPR19MB2758.namprd19.prod.outlook.com
 ([fe80::c8ee:a264:81ec:695a]) by BYAPR19MB2758.namprd19.prod.outlook.com
 ([fe80::c8ee:a264:81ec:695a%5]) with mapi id 15.20.1622.016; Thu, 14 Feb 2019
 08:14:56 +0000
From:   Wang Shilong <wshilong@ddn.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fs@vger.kernel.org" <linux-fs@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>
Subject: =?gb2312?B?tPC4tDogW1JGQyBQQVRDSF0gZXh0NDogYWRkIGxpbmsgZmlsZSBzdXBwb3J0?=
 =?gb2312?Q?_for_{GET,SET}XATTR_ioctl?=
Thread-Topic: [RFC PATCH] ext4: add link file support for {GET,SET}XATTR ioctl
Thread-Index: AQHUuQbtcSZ2bGsxYUW1RE6Z4prppqXIu4kAgADqqYCAADLcgIAVJxhh
Date:   Thu, 14 Feb 2019 08:14:56 +0000
Message-ID: <BYAPR19MB2758BDB15262B0333504B70ED4670@BYAPR19MB2758.namprd19.prod.outlook.com>
References: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
 <20190131034106.GJ4205@dastard>
 <20190131174059.GA10211@magnolia>,<20190131204301.GK4205@dastard>
In-Reply-To: <20190131204301.GK4205@dastard>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=wshilong@ddn.com; 
x-originating-ip: [36.62.207.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac7b3895-7b08-4014-ac61-08d692548150
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR19MB2901;
x-ms-traffictypediagnostic: BYAPR19MB2901:
x-microsoft-exchange-diagnostics: =?gb2312?B?MTtCWUFQUjE5TUIyOTAxOzIzOk14OW8xTG12WXltUkdpWkoxVnVSMXpSREFl?=
 =?gb2312?B?R21MUzVMV2NGUVdGc0pXWksxelpPS3ZyU2N5akZBci9KTmJjbjhwZ3J4YWdF?=
 =?gb2312?B?bC96OXc4UGZoeUVuNndJTjJZQlBYYmZ3SWpha2d6YmNRekhPNzhtWitDK25R?=
 =?gb2312?B?L2t1SXFCK05hVnNxM2dUdE14VzRsVzFqTVZaWUdjcEpzU2ZrdjF5NFlWT0VO?=
 =?gb2312?B?Z0lKdnFRaFFGK3dGZEJXTFhOTjVtVjFCRHZUNFc4WGFtL01xbXJHR3lhNnFD?=
 =?gb2312?B?OWN5ZVFQWUtLQ0VqTW1ZTi9Va0lHNFpBM0ExMm9hbC9SL1NBRmRDNHJxdDV0?=
 =?gb2312?B?M3VVS1c4VHdVSWw1TDJrU0NZWUMzUkdDY0NZUFdidG9BaDNBeEwxOEo3QkVa?=
 =?gb2312?B?LzdEVU5haUprdkNCdWQ5QXRlc25uTE9tTGYyQ0d6OWI5OFRRUmRTNFdYQklT?=
 =?gb2312?B?VXRRd2t3dWdWb05QaGNZbXovOWVzWWhWOVNibm0zUjltdEdNQUdnVkNWNnBF?=
 =?gb2312?B?NklNU25XYTZzWjkzcXNzdGFKM3hRTllXYmZxbTNYRWh4QU93Z0d5bWd5a2Ru?=
 =?gb2312?B?K3hLS0w1SGlSUFgxVGF6R2djN0xZbm56M244UW95U1FlWTFFV04xSEU1akJp?=
 =?gb2312?B?ZWdYSzRRU1NpZnU2QXB1Z1dRVytzTFNGVGhEVDZ4Wk42UWtPeWcyZmlscmRQ?=
 =?gb2312?B?Z0dqM2tQUFJ2dTVhN1ZrTTVxQVowRHQ0UThJT3hQclVSUmZQSWdPMVFrNEFM?=
 =?gb2312?B?RXB3SW04VXUzREk1MUVNaEdYbVVGdVFLNW92ZU5GV1Z5M2YvVFpnUU1TOVhC?=
 =?gb2312?B?Z2pVTU0zL21DOXFHVzZKRnpHVi90bTFKbnV3MFNKS2lFZ1NaMzI4eTN1NzlV?=
 =?gb2312?B?YUd5TjBsYW52LzlRRW55OVhaWm1BeEduRDFLUDhUdUsrVnZCMTRlOXcveloz?=
 =?gb2312?B?b3kvbWN5eFBGV1JkOGpuTTd4TkVGUXFzWXZqWnFvOTJiYVU0Q0JJVXNKYmI1?=
 =?gb2312?B?T054KzVDWGJQU0tFaml0YXhZSDNORU1KTktzSDZDNGhld0hoNUNGWUZGS2JY?=
 =?gb2312?B?dkVsSzFIZDBwVDJnVkNVWXE2eHQ1NmlsNXRoUHBPRWtzS0oxRFpzNnBLYnNj?=
 =?gb2312?B?cHZOV2krZytyVEQ2QUhXZ1VIandjVjMrNTYrdFhqb0s4eEFYTDRuWVBGa3Ro?=
 =?gb2312?B?OHB0M3o2UmdXUFZ0dVBGQkhLYnQzMkgyYkd2Q3ozNnkrNEhUbHNVUmtjaFBa?=
 =?gb2312?B?NUdkWVE4MlZMSnN2WTd3VyszK3hHNkRKdk9uOTNKSUZaSXRCZ2p6a0hEa2Zs?=
 =?gb2312?B?cDZ3dVVCUXIwUXhSVVUxUTlxYlNKL2M3cjRyelZWY1g3SFBFRGNrSWJldE9j?=
 =?gb2312?B?OUtaVlNTZTU3N3RZUjlkT0RVRGhDd1VXcm44ZkZhbEJBUEM0dWFncWRVUVhw?=
 =?gb2312?B?M0pWeTZQUS9zRzd2THBYRVpvcWgvc25DZkc2TWliTkQ3c0NTQTI0bmowUVZi?=
 =?gb2312?B?RTdzaDZiS0sycGFHWGJvaVU4eCt5YWx0dTBMd2I4cGZXSEZ2Sm9iaTFIL3Vp?=
 =?gb2312?Q?IwJ15s+o2d8C7S89BVxr9pX9dzPKjUlBvCibNaTlF64Y=3D?=
x-microsoft-antispam-prvs: <BYAPR19MB29018B1ED9F2DFC304665A92D4670@BYAPR19MB2901.namprd19.prod.outlook.com>
x-forefront-prvs: 09480768F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(39850400004)(366004)(199004)(189003)(224303003)(4744005)(68736007)(186003)(25786009)(446003)(106356001)(11346002)(76176011)(6436002)(486006)(478600001)(105586002)(476003)(53936002)(99286004)(14454004)(8936002)(7696005)(86362001)(305945005)(55016002)(54906003)(9686003)(316002)(256004)(110136005)(81166006)(4326008)(7736002)(93886005)(2906002)(81156014)(97736004)(3846002)(33656002)(66066001)(6116002)(6506007)(71200400001)(102836004)(71190400001)(74316002)(26005)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR19MB2901;H:BYAPR19MB2758.namprd19.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ddn.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: l4IaWR7ICKALp4N6Jm2RZlyrkLrKvZKrZ2ikplzwvqJccPPRetSu5w2UMKprUDjtNm1zEVdwtss9O+fxEp/5tzLfRyT0EtGHdfxCROh+ZatsNYyYDzBFLiCiAd0tHlatvHDhHWq2wgHEas2rnCCVqhXh9YSP43252AO3h3L8s9vjEGgjDEARfPRW4U2p+H0JJ9k7AOfR2/hb5Nq/d3NXuUEa5LUo9/LBapF+2HlwkYvCGoKM9n9FwaLhsWehD+/OmN/yqrTFo3s0uPqQLvg/WUeSRiKzdMqM9MlkmoBbxS+o6vTKk6t4cJ5yQHLrUqXxCFdnlSe+jJQVlFXc6CVTf0mZ2l2ebaQXMVWEq+HSBvClCJGf47SdIeMNPZcIwobUe/RkGwj5aNAF2I5En9T1ceh9ySjrOJvs/smabnijThU=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7b3895-7b08-4014-ac61-08d692548150
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2019 08:14:56.2899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR19MB2901
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

SGkgRGF2ZSwgRGFycmljaywKCiAgICAgIFRoYW5rcyBmb3IgZ29vZCBzdWdnZXN0aW9ucyEKQXMg
bXkgdW5kZXJzdGFuZGluZywgd2UgY291bGQgbW9kaWZ5IAoKZG9fZmNob3duYXQoKSB0byBjaGFu
Z2UgcHJvamVjdCBJRCBpbnN0ZWFkIG9mCmdyb3VwIGlkIGlmIEFUX0ZDSE9XTl9QUk9KSUQobmV3
IGZsYWdzKSBwYXNzZWQgaW4uCgpCZXNpZGVzIHRoYXQgd2UgYWxzbyBuZWVkIGEgbmV3IGZsYWcg
QVRfRkNIT1dOX1BST0pfSU5IRVJJVC4KdG8gc2V0L2NsZWFyIGluaGVyaXQgYXR0cmlidXRlcz8g
CgpBbmQgZm9yIFByb2plY3QgR2V0LCB3ZSBtaWdodCBuZWVkIGV4dGVuZCAnc3RydWN0IGF0dHIg
eycKdG8gaW5jbHVkZSBwcm9qZWN0IGlkLgoKV2hhdCBkbyB5b3UgdGhpbms/CgpUaGFua3MsClNo
aWxvbmc=
