Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C269DC282C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 05:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 830F720863
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 05:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="pGuyBuYb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfBLFbc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 00:31:32 -0500
Received: from mail-eopbgr700130.outbound.protection.outlook.com ([40.107.70.130]:44746
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725778AbfBLFbb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 00:31:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ba2D0I7h1cpFA4lnj3ZNrLF59yXFh/+Y9uUx0MgJwIg=;
 b=pGuyBuYbfrFYzNq/AsMtJe5oZYGcaeEqJiHcYBNIHNMqnsmhytD5jcH1nrbniJVu+teHBqsl1kL1pniYlAIlrrZtYIJhS6HrS6ec7/0O5Fp50w4NQeHMN6sNUnREntnIJZqP+LkAqoxrwOLfJC1hJ2kRvd8Xe8VUEWoeTcQxqxk=
Received: from DM5PR0102CA0003.prod.exchangelabs.com (2603:10b6:4:9c::16) by
 BL0PR01MB4483.prod.exchangelabs.com (2603:10b6:208:81::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Tue, 12 Feb 2019 05:31:27 +0000
Received: from BY2NAM03FT020.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::207) by DM5PR0102CA0003.outlook.office365.com
 (2603:10b6:4:9c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1622.16 via Frontend
 Transport; Tue, 12 Feb 2019 05:31:27 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT020.mail.protection.outlook.com (10.152.84.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Tue, 12 Feb 2019 05:31:26 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1C5VOjm026933
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Feb 2019 00:31:25 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id EF4167A4F02; Tue, 12 Feb 2019 00:31:23 -0500 (EST)
Date:   Tue, 12 Feb 2019 00:31:23 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        <linux-fscrypt@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Proposal: Yet another possible fs-verity interface
Message-ID: <20190212053123.GR23000@mit.edu>
References: <20190207031101.GA7387@mit.edu>
 <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
 <1549807615.12743.109.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1549807615.12743.109.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(346002)(39860400002)(2980300002)(43544003)(189003)(199004)(476003)(75432002)(106466001)(186003)(36756003)(336012)(486006)(126002)(86362001)(2616005)(90966002)(103686004)(7416002)(23756003)(446003)(6916009)(52956003)(11346002)(26005)(4326008)(47776003)(356004)(229853002)(8936002)(305945005)(8676002)(2870700001)(786003)(88552002)(2906002)(33656002)(246002)(6246003)(106002)(26826003)(54906003)(42186006)(478600001)(50466002)(6266002)(58126008)(316002)(1076003)(36906005)(76176011)(14444005)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR01MB4483;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT020;1:Kbyd9veaEUvVUX9c8qP+GrmVPBNM0coTcRcs7jI0ZzdjH8YcwnfE6O7Hu9gXKV0LTiM2dfuc5c3JvSAbZjqMfBAHOQwRCVTG2l4xx0xeeA2ztYNkz1dKeIcJ78e0ud+olMAk3S8j5LZD5HSl8RpZgU5R4bhwCPboi8M0i7xegoM=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cb733c0-0fcd-4de5-6b92-08d690ab55dc
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BL0PR01MB4483;
X-MS-TrafficTypeDiagnostic: BL0PR01MB4483:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BL0PR01MB4483;20:Dskp6zz3n80j6PQW+PThcd+TCfiu7Ge8Qx1ztrmO4NwZLtWm6k9nApj/90V9Jx3zSZrCkUbdk+yhIeT/EOMotKbPbmyZyuagy07+h/rCN04gkNLczgwuAqwkdsKfnXWSkm4OShNbTv3efnVpGiipPRhGcdZXfMtGlCHunZMq8AXgD5vfXu9/66lPpoDuVRp7O3acLQD3JzDWZqpPqzNsfKAFzskybV3/pWqWZmvFHvISVF/mmltN5jpigZQpXh8vGT97wE257pyik2O1DY5wfArL9zKx+2ZCc+uvNWEeW+AlpcoHCbSoPRvlLksHN/oP+pEW3DWPorKNGxfddtCW+RrWFnDRtxXoB5VoUEpwKIMfkvNU4BQd4fNRpz0Au3AUaMHdQH6HznRU2fbhc7RdpA7xyVELxDfbAE2Ni0tjOkchWRKjyRJh5a9wPoHd1wJ6sq5hn++rv2rpMG5Tpc9uv3PYGS83sJp2LCFaSeWE005myo2IoIRS9sWnAWVQZEPuAIAWQssKKQppxhkMwHMGrMTk2ekp0NTy1RO8tKNd+MSqjpGvitDgcst36p5R3IWYmc7eaqBhkUG+ydhU7L+D1pDPugTOkZ7SGhbqkKpv+5Q=
X-Microsoft-Antispam-PRVS: <BL0PR01MB44834238061BC4CBE38AD740B5650@BL0PR01MB4483.prod.exchangelabs.com>
X-Forefront-PRVS: 0946DC87A1
X-Microsoft-Exchange-Diagnostics: =?iso-8859-1?Q?1;BL0PR01MB4483;23:S93gRYJpl73FFIBogfU3mVt5GhHTqZ0RgY0uN/g?=
 =?iso-8859-1?Q?1UY/9NcNZc8LI9WvrDXevkdsc/C71KzGUIamLhiXtiKz0RjWBf7J6EWWZy?=
 =?iso-8859-1?Q?7VPrJbRk3KmbYRo38KHzogzQFBrHYT5nv9KN/Eo3STWZZQjP/xRC9YfDmn?=
 =?iso-8859-1?Q?EcK1PJvFFBEdZyh3sT/WhP4mgz54LNW+oSe7EWiVmhtDunxyzawkvbJfDG?=
 =?iso-8859-1?Q?41QlPh6Bq6SdAmX/jiIMGA2f3reP5CdiFd86slzFX6LVL6J55XL8lnx8wL?=
 =?iso-8859-1?Q?Xwjn9rrYxoxJvJnT+6Iro843wO/XMwJkrngX94d/HwFzebyudW/717QVPD?=
 =?iso-8859-1?Q?+QuAxNDKCTKpdSFEe92XxQrI3AoZnRqVV8yUI//3URWRQaLW+5yqgWhhsd?=
 =?iso-8859-1?Q?XskcasWGfaiW2YgDOx+sPGF7KgGCnxmHn1ucAxVbcuw9aLxjFFWzH2y6aW?=
 =?iso-8859-1?Q?/9pnfyqSQ+kKlZPOQUs4AB/uPMwo+ALZEF3boKZFhQO2MXWCPKFShdnAwW?=
 =?iso-8859-1?Q?1o4CLjQsXGp4OxIziOUxz6HMxlzA+JnIOMXXO6JK8qTt9F3EuIo8YCTRF4?=
 =?iso-8859-1?Q?HJs5HcRYzqxI+to21IpOqGdyPl22d+58ByYQUKYvoe1DvY0HY3Gly3zxmf?=
 =?iso-8859-1?Q?XRBhgvHYdiHkDK9plEhnTHN0Ov9jE5ESQywGtEyJY81AKYP4hvB631NT5u?=
 =?iso-8859-1?Q?MAOWd394bH9uE3qKaoOZfa7mntCpqjMcbRDZyfF/tKGT4ulOeqv71WsBzC?=
 =?iso-8859-1?Q?nCmJDZdPlHksWhgj/fH5p+ZSW36nfwnZJSWegeh7vAA8edCbQJ6WGURjfR?=
 =?iso-8859-1?Q?+ObojuabYtNy1a3AJhr4B2FP7AzqK5CsW0O74hsEtlFQI9IxbB7wlIlhuF?=
 =?iso-8859-1?Q?yXFKq9meWG1nYetS82vBOdqpN3v2B8b+BY/HSPXTVdqHNHdYjXJ9WnuaE8?=
 =?iso-8859-1?Q?yJ0+EHuzGKMczESqmSl8waoVgT0DaJcimOM8tsjknMX8c11eivsi62Y89f?=
 =?iso-8859-1?Q?2QB1HwXFGePvRWgR0G/7IYKbVDfgNVcp96meGov80uCyNCIqZSw96+8mAx?=
 =?iso-8859-1?Q?KS7XvklU47a83MXH5Dm5PluLzswp8KTbryB2rT7cMcDQRT8djioftOdcAj?=
 =?iso-8859-1?Q?UgqQGLiI8gwBmvnU56QtO29rPn1KebuUPpn1UMvUhq57H67PoZLMKliTjQ?=
 =?iso-8859-1?Q?ZDIAPRw8NIDYojdmqHt4BWC59jafKjuGuiYnPE4oegXLaVzOFZzBvUEK2I?=
 =?iso-8859-1?Q?dzcRnFnQTqtqDR/ppuy1Vx6mDo/fukk/WIT7lwA=3D=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: lYDrwaHbvktZGYpZlqUtmDbPiRo0nKt6SLxG1rCNIITtDoDCw4d3fEK3rOcvcVy8R8D7Zm8sVdFEprhsWX21YWR5ZUn8ymeYQi4QR3SgXZGA6cAd81X7YtyvIB2eiU617jC8j093RjYMc2aThMBtEVYAox3efWs99voNlXrTi6Nh5Fqof89pVlKspIq1Nr8wFHmonZRmUI3GzABkzTNEKyegQ5fRLxfmsuPtqO4mFykfedU4hXWMnSxlVwg1XgNp24khs3TFXIZniEol79+lGNxKQQhQysLnPcoAXVeU9S8SbS31a+xpytwkTsZHUtf1vn0kkageMrqHUGT6jiKMHA2A0s+f07NojoFbWJkAiMPHiUpUv+QeKyn2Q2r+qKYv7fF5w1Qb2MqEB3dousC715gwPvDdZaBMaOWDcibyStc=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2019 05:31:26.9661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb733c0-0fcd-4de5-6b92-08d690ab55dc
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4483
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Feb 10, 2019 at 09:06:55AM -0500, Mimi Zohar wrote:
> For which files will the Merkle tree be created?  Is this for all
> files on a per file system basis?  Or is there some sort of "flag" or
> policy?  The original design was based on an ioctl enabling/disabling
> a flag. In this new design, is there still an ioctl?

So for our first use case, it will be used for "privileged APK files"
in Android.  You can think of this as a "setuid binary", effectively.

The Merkle tree hash is digitally signed and provided by the App
Store.  It is *not* calculated on the android device.  So not all
files will have Merkle trees, because storing the android device won't
have access to the signing key.  The enforcement is done by the
userspace code which is loading the privileged APK (the application
loader).  If the APK is privileged, then it must have the Merkle tree,
with the root hash matching the digitally signed hash.  Otherwise, the
application loader will refuse to load it as a privileged "root"
application.

For Android, the policy enforcement is done in userspace (should the
APK be privileged), because userspace loads the APK.  We just let the
kernel take care of verifying the blocks as they are read, and that's
done by fsverity.

If we wanted to do something similar with all setuid executables, that
would have to be enforced via some kind of LSM (e.g., a SELinux
policy).

> The existing file hashes included in the measurement list and the
> audit log, are currently being used for remote attestation, forensics
> and security analytics.

IMA has a very different set primary use cases than fsverity.

As you have pointed out, forcibly dragging the entire file into the
page cache to measure it can sometimes result in performance
improvements.  So there may be system administrators that would prefer
having the entire file measured up front.  On the other hand, if the
binaries/APK's are gargantuan, and not all of the file will be used
(perhaps there are translation files, audio/video assets, etc., that
aren't used most of the time), then only verifying the blocks that are
used will be a better approach.

I've never thought that fsverity should replace IMA or vice versa;
they are optimized for different things.  If it makes sense in some
configuration for IMA to use the fsverity Merkle tree root hash as a
measurement, it's easy enough to set up the hooks so they can be
provided to IMA for its use.  This might be the easist way to
integrate with SELinux, for example.

Regards,
						- Ted
