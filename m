Return-Path: <SRS0=E3Xq=SZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659B2C10F03
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 15:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10011206BA
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 15:06:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="ap+rHjm7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfDWPGY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Apr 2019 11:06:24 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:34990 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727673AbfDWPGY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 23 Apr 2019 11:06:24 -0400
X-Greylist: delayed 1940 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2019 11:06:23 EDT
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3NEQxEO008326;
        Tue, 23 Apr 2019 15:33:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=jan2016.eng;
 bh=arkhTlxL/xq6hHs8zOa3vPqV/+YR/QoM8F0pg/cukSE=;
 b=ap+rHjm7bB9xDNr+gszLXDj9SMelEbJNQJ3GdyMufwrnX/llvzNLjBzeRV5QV5gKyzs5
 XgMJ5u0s24EhjV5jblwgZlXMrJk03wvb03IiK+/SBKVmXwFzrMa4zguRdtF0KMFraOyz
 0hDRUeZp0nhMDLUL67twDp+liulr5I2PaBykIhA0n2D/Jpt7WVG+y2+MbFVmljwXPWco
 LxUcquqqTbroNFw7F/2Gkj95eFgMcMEQIDjX3zQ/S4cWAGolureQf7GEG+KEFLagZL7P
 QG1WkdpLU1m/YPv5IFYCNIl0ox7mPK2cx2xrV+1utEmVGtv8Uhth+00dwb87dujcJYBw 4A== 
Received: from prod-mail-ppoint3 (prod-mail-ppoint3.akamai.com [96.6.114.86] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2s22fk8h2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Apr 2019 15:33:56 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x3NEWDJd015195;
        Tue, 23 Apr 2019 10:33:55 -0400
Received: from email.msg.corp.akamai.com ([172.27.25.32])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2ryxrurcfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Apr 2019 10:33:55 -0400
Received: from USTX2EX-DAG1MB2.msg.corp.akamai.com (172.27.27.102) by
 ustx2ex-dag1mb3.msg.corp.akamai.com (172.27.27.103) with Microsoft SMTP
 Server (TLS) id 15.0.1473.3; Tue, 23 Apr 2019 09:33:54 -0500
Received: from USTX2EX-DAG1MB2.msg.corp.akamai.com ([172.27.6.132]) by
 ustx2ex-dag1mb2.msg.corp.akamai.com ([172.27.6.132]) with mapi id
 15.00.1473.003; Tue, 23 Apr 2019 09:33:54 -0500
From:   "Banerjee, Debabrata" <dbanerje@akamai.com>
To:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: bad mount opts in no journal mode
Thread-Topic: [PATCH] ext4: bad mount opts in no journal mode
Thread-Index: AQHU8LB42sqXQo7D8EG2I+INPmkeGKZJ8oiA
Date:   Tue, 23 Apr 2019 14:33:53 +0000
Message-ID: <2C6C280A-9716-4F96-A999-CDFBD0153F61@akamai.com>
References: <20190411214917.1899-1-dbanerje@akamai.com>
In-Reply-To: <20190411214917.1899-1-dbanerje@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.18.0.190414
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.19.40.193]
Content-Type: text/plain; charset="utf-8"
Content-ID: <95061BCC4913BC42A12E73C7F7B66B95@akamai.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-23_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904230098
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-23_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904230098
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

cGluZz8NCg0K77u/T24gNC8xMS8xOSwgNTo0OSBQTSwgIkRlYmFicmF0YSBCYW5lcmplZSIgPGRi
YW5lcmplQGFrYW1haS5jb20+IHdyb3RlOg0KDQogICAgRml4ZXM6DQogICAgY29tbWl0IDFlMzgx
ZjYwZGFkOSAoImV4dDQ6IGRvIG5vdCBhbGxvdyBqb3VybmFsX29wdHMgZm9yIGZzIHcvbyBqb3Vy
bmFsIikNCiAgICANCiAgICBJbnN0ZWFkIG9mIHJlbW92aW5nIEVYVDRfTU9VTlRfSk9VUk5BTF9D
SEVDS1NVTSBmcm9tIHNfZGVmX21vdW50X29wdCBhcw0KICAgIEkgYXNzdW1lIHdhcyBpbnRlbmRl
ZCwgYWxsIG90aGVyIG9wdGlvbnMgd2VyZSBibG93biBhd2F5IGxlYWRpbmcgdG8NCiAgICBfZXh0
NF9zaG93X29wdGlvbnMoKSBvdXRwdXQgYmVpbmcgaW5jb3JyZWN0LiBJIGRvbid0IHNlZSB3aHkg
dGhpcyBvcg0KICAgIG90aGVyIGpvdXJuYWwgcmVsYXRlZCBmbGFncyBzaG91bGQgYmUgcmVtb3Zl
ZCBmcm9tIHNfZGVmX21vdW50X29wdA0KICAgIHJlZ2FyZGxlc3MsIGl0IGlzIG9ubHkgdXNlZCBm
b3IgY29tcGFyaXNvbiB0byBkaXNwbGF5IG9wdHMsIGFuZCB3ZQ0KICAgIGFscmVhZHkgbWFkZSBz
dXJlIHRoZXkgY291bGRuJ3QgYmUgc2V0Lg0KICAgIA0KICAgIFNpZ25lZC1vZmYtYnk6IERlYmFi
cmF0YSBCYW5lcmplZSA8ZGJhbmVyamVAYWthbWFpLmNvbT4NCiAgICAtLS0NCiAgICAgZnMvZXh0
NC9zdXBlci5jIHwgMSAtDQogICAgIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0pDQogICAg
DQogICAgZGlmZiAtLWdpdCBhL2ZzL2V4dDQvc3VwZXIuYyBiL2ZzL2V4dDQvc3VwZXIuYw0KICAg
IGluZGV4IDZlZDRlYjgxZTY3NC4uNjNlZWYyOTY2NmUwIDEwMDY0NA0KICAgIC0tLSBhL2ZzL2V4
dDQvc3VwZXIuYw0KICAgICsrKyBiL2ZzL2V4dDQvc3VwZXIuYw0KICAgIEBAIC00MjM4LDcgKzQy
MzgsNiBAQCBzdGF0aWMgaW50IGV4dDRfZmlsbF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNi
LCB2b2lkICpkYXRhLCBpbnQgc2lsZW50KQ0KICAgICAJCQkJICJkYXRhPSwgZnMgbW91bnRlZCB3
L28gam91cm5hbCIpOw0KICAgICAJCQlnb3RvIGZhaWxlZF9tb3VudF93cTsNCiAgICAgCQl9DQog
ICAgLQkJc2JpLT5zX2RlZl9tb3VudF9vcHQgJj0gRVhUNF9NT1VOVF9KT1VSTkFMX0NIRUNLU1VN
Ow0KICAgICAJCWNsZWFyX29wdChzYiwgSk9VUk5BTF9DSEVDS1NVTSk7DQogICAgIAkJY2xlYXJf
b3B0KHNiLCBEQVRBX0ZMQUdTKTsNCiAgICAgCQlzYmktPnNfam91cm5hbCA9IE5VTEw7DQogICAg
LS0gDQogICAgMi4yMS4wDQogICAgDQogICAgDQoNCg==
