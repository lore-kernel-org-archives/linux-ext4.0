Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191C9C282C3
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 23:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C58D3218A2
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 23:22:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="UOs34Gpr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfAXXWu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 18:22:50 -0500
Received: from mail-eopbgr760114.outbound.protection.outlook.com ([40.107.76.114]:19270
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727845AbfAXXWu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 18:22:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djSrmwAtaZEb/oB1ac3LWb9UPaS9RgkcpMaYEeTfghk=;
 b=UOs34GprFnpV+G9pQFDP46WoNoBdAqQK6Ktghrk58oWvztaYhY23Msjqt24KmU1sLl05ECffBjU3SMyuQrZmQZEXAxfbVsCydWsAFP6xc76QqKfrLoF3mVNCskLtWru8/gJOIVRUCDoSnqKSW5+iRN0JJ1wGw3DN1mhsWAvi2Og=
Received: from BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) by
 SN6PR01MB4493.prod.exchangelabs.com (2603:10b6:805:e1::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.18; Thu, 24 Jan 2019 23:22:45 +0000
Received: from BY2NAM03FT059.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::204) by BYAPR01CA0016.outlook.office365.com
 (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1537.27 via Frontend
 Transport; Thu, 24 Jan 2019 23:22:45 +0000
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT059.mail.protection.outlook.com (10.152.85.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.11 via Frontend Transport; Thu, 24 Jan 2019 23:22:44 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x0ONMbhc001805
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jan 2019 18:22:38 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id ADB187A4C59; Thu, 24 Jan 2019 18:22:37 -0500 (EST)
Date:   Thu, 24 Jan 2019 18:22:37 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        <linux-fscrypt@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: Proposal: A new fs-verity interface
Message-ID: <20190124232237.GH8785@mit.edu>
References: <20190110051500.GA32361@mit.edu>
 <20190114234101.GQ27534@dastard>
 <20190123051017.GA8785@mit.edu>
 <20190124212544.GS6173@dastard>
 <CAHk-=wh7jq6U3+ou_FDujB-ipg9JcJAGSjEQ_niCwLG313x6UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHk-=wh7jq6U3+ou_FDujB-ipg9JcJAGSjEQ_niCwLG313x6UA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(39860400002)(396003)(2980300002)(189003)(199004)(97756001)(36906005)(106466001)(33656002)(76176011)(90966002)(8936002)(6346003)(16586007)(316002)(786003)(305945005)(58126008)(47776003)(8676002)(42186006)(26005)(54906003)(229853002)(50466002)(486006)(336012)(75432002)(93886005)(246002)(36756003)(186003)(106002)(446003)(476003)(11346002)(46406003)(126002)(6916009)(23726003)(1076003)(478600001)(2906002)(26826003)(6266002)(88552002)(86362001)(6246003)(356004)(52956003)(103686004)(4326008)(2616005)(14444005)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB4493;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT059;1:qxCJi7xWvkV+/HP3uRPBt0B6iVjmg/cX+Rg2aVfym83Y7oYxOYhdOUNk+A82YGMBFcQcNWR6EyHaFcAnkz0iAwShNO5cdHVWNK4/KzI2TPxSHU/bQYkqXTj8RqD4ZFQeoPMhI89omjs8fZ6oV+UzIA==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f81eac02-5d82-4214-4082-08d68252d881
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN6PR01MB4493;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4493;3:3iBijP8XJYl1Xw50OGpiPadzvG0f5z5aBHODkP3+0o5lyL9+1Pw5QymP1+aZTzokUvs9Mgs9kaHRuXPKvfPL88cQRj7bQo8DidU5fM77vrlDmINvdaONLuYOmQ3bz2ILA480vcr59ZsaKgmncJhLakAIdgydKYz55PEfinCWmuN14KpOcaPLyps4QCEM2JwdmrwFKDTqkW+LOKDi4kNVbp/JCgJ7o3obg6m+mXmSQ6XKfyXpEdOS6h8NUIgblMhuspRqyEnQ0a86RD8a/11JgsEyh6vCDaVNl4x0cIoiUg7lRvCJwsV/c4W8pRgPjBTJ/5iiYrsHl4NekDeHVrDZE/ve2soMOluebXQPLu5PziwS2VwWMbDUWh2diWOUzsEz;25:G8h6P3zw2zBNjxY3AUsIkDcnNlhcym3AJjhaa3q07OYTsZDugfQ/+zNDFdRu9RPt1BwxWIK8wlssNibctKkyAir6ZXlvRmmVKVpFItvw30RkucZGoCpISXejhPFX5c2jclm6/KdsZ2loS1jm9esYFF37yfVpWyGl7mcGEJ5ZNzglIt9ykwQcY7ovMvqch2d0rF0MJSMfMQ2znjNIZf5pUSWAYv0mYs3vkFPoShVSI6SZ1YXi2Y4lnhnzBZ/weH7ceCb8d0+3XIRrHQJ+00nPybrDbIGGCTIOHqXqSSH2Pk05hWc5FYNBqlFxPBHLfAIG4tHVMW+9hSWWnQBR1KIb0Q==
X-MS-TrafficTypeDiagnostic: SN6PR01MB4493:
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4493;31:fpOW6c4stKKw4yVF3Onafk9RAWgu14VkA8K3XkxeMGLx6RISCXvKSD8+cJ45LQCqWGng76fupV7+1W0Y9vkEQd/P1GCOlEpRbi2FnL1+OLFb8GxCN52gYO73g7GjZbftuX0z9fwdrliEZzejoy/MXVkns3VOeWas1J2IyqqBiPPBKv+tUkWXqJlbvm1sB0tdVoVUqyx0CR40cxcDr4TxmEGy3jeG/jgVDRmA8Cgub+E=;20:UT8Bh98LinXPKlIv856YIh/ICPku7DqsOcrpBZOyBTx7f+jQHF9ehxBgu5tpYadsAeICVyCHt30G6qQEmkUBU0uDkzXUIKN99L0N3KtPLQoWDByspbBpc6316+X0My8VXwkh+Yt/e1od/uNTS+LgL/KNhzpDNl+ZAlAbJ3MsFWMtfK5OUwPr/D4LpJaJjNe1RGniR/wRdNcvIQf6/FODg3oAiUnpW2CT1ub/mwrPmXbux9MTP3na/TYli5llUPCXOLsF/nAdt9QW7FJXVnp8/ZsoCdDKPHQ6gZ28BCwwJs33C4wqxZposhTPPDUlPvkLMbyxfv/fEZa66W7IaRdLWgJpGpfjBxIpAKeWADANPP7pXrk7anWRUSEiqwe2t5g760aE8bIqKTg+F8RLw+ZR+GvQ8tZg7HjT/K4GB1wpM3dWEVpyWuYWvKR+4pv51twQO0aQ6/X8ybdS8yU72LJTr0vjpxBI375UyZJfvC8JVdC2Ltb27wAgKOtKIfKiB8uBDFvjsjIJWtlCiFUZw4gaJShFxxxZVPchfhC5TNS9eSTwj5nwRhCMpWD7nINw2w/H2Je9Ggrgi6AhGQQp18e20wXiuSJc+vNf7pWarLD3SFo=
X-Microsoft-Antispam-PRVS: <SN6PR01MB4493D9D56BC388832ADE783BB59A0@SN6PR01MB4493.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4493;4:02h+0qzfhDlJHYvcX/HyWpUAbCJuJEqPE8t/8MJwZmA2k7wssyopkBiYpI9zzjLHDg2oexAQbaHI0437ulwnYFWHklU0C2V8CAdVOifzs15U+JE3eQKjjDUP8r+fvrToj/mTdryIijHUSAR2saJTMw3ob/S7VSbFEahwWNoSV3Fgq6acJyCk3JXGuTDWjSDeCDgrOLkC0+4+NYqbcOR4fhKfoUYn1BE5y3XXYhoCFhLr/0Zh7c255VJXNoZXq3UX6ZA5xka/GYo/1doiatzFEFPk87LMHN4Htv3vXV8evfdOppayIGpfazRBQabr6/77
X-Forefront-PRVS: 0927AA37C7
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB4493;23:c6Op9Fr1eTyCL2pKuZwrMVBbh+XmTn5gchpzMSbWg?=
 =?us-ascii?Q?1t8pKtogiaOS0p5bpJDSGoNS/jvrD8PZOfzz8kANCAnxxLXRoNVX3nIfQ2ps?=
 =?us-ascii?Q?bGOdqwiRA437ZrC81Pm8k16Sm5H1TV1ZCA5LIUBvOT3/ztGaS3pQG1zT19Yo?=
 =?us-ascii?Q?JbOHBXCPVrzSfQFesNeT3Zw7dQaDjE8BmsPCtAmBTiqp6/KgXNh8/hicOaEJ?=
 =?us-ascii?Q?oJbdxathwBj1FRPFiYnk5Q451/A4mYdlzX+1sdyxdzPOVhamgdDvQIVH3v1Z?=
 =?us-ascii?Q?EZYuHG6sC21FBYLYMdiH3DewDObat4KBDnVmOvgXFtRfJMqoVyi8OWuay+Pw?=
 =?us-ascii?Q?bpjdHBCLyQcNkxteHk4530db2DKT9tJKbaC6XqKAPEk0701uIg+0Waybwz0D?=
 =?us-ascii?Q?LXt+BI6B5Gu0b4rESL6sn3sS0cMeFL/6H1J51q65adhHYTmlpReIgf2HKG9s?=
 =?us-ascii?Q?z0imYv4Llni+Xrb3ANoSV5pHgawZJXrLikDxGXz7ycYU04U2P2nWTOof+Z26?=
 =?us-ascii?Q?pVnE+9dvfbBWm01+w68DYQn+H9A4yh9ID13jbEyk77ksMsACs68hU6Ynb5AO?=
 =?us-ascii?Q?895jewzu/2YaEiQMx6y3iJAB2biDvXWdyVpSpaQSIK7i6MSvi3tBqlrsTJgQ?=
 =?us-ascii?Q?syKawSNMme5B57gm8TTsQyf8WY77l+57OkmqbG83gcpTXMULgjecsTffO/PA?=
 =?us-ascii?Q?2fNCs3zM9pgObStbHriFNvXcPWeaEV2ytWoY/DI6Ctx+jaZCUCAS+y+64ODc?=
 =?us-ascii?Q?kZPEeFIgl2zu39LiGsyyje0yzFEgNuBNgyrgj9HoC7VrgzE8IBJpKUz/ZFyY?=
 =?us-ascii?Q?NJUT/aGy656woub4iorCQrbA31w/GMNUmj1eX6QW8JjxGDKD4nCt3uNy2Lsp?=
 =?us-ascii?Q?Fk/PWY/p+8Z2V16l/d+9w8WlD2xBf5QfH4k5dxOyaB7kQBySPYvQ8nBJ/Z4r?=
 =?us-ascii?Q?UiqIYnvf8c0sBW5uCUpSWzMR4n1ec73WILAQs6jeR2naHlbKy+luwGNC6ue5?=
 =?us-ascii?Q?y+henLWdI6/yBdaGcs/J7RnjjgyE7ASgflEJzLJabW6du4mt7M4YXHvJ+9pD?=
 =?us-ascii?Q?AfdPCUiuMPWR9GJ2hGJzawHzKulwcEcGi6LJsJnQyu/lcSni2bJW2uF4P608?=
 =?us-ascii?Q?0rz2YxCtaAvm1sBcO1sCHhwtjRNm7rKXgOusWYuWZhIy32Ma7/8TW7kh6OM2?=
 =?us-ascii?Q?t1dqg79AsUIAC1XKanIh1dds5tMX9H5ZnwK9qwTw3L+3mzwqS/n8+8NNlRAP?=
 =?us-ascii?Q?97SnUheEDctC6zLxl8MehHS1zw/1xt4mp79JwQq?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 8m5cn4nqn8BF8ot78znUV5q7LFTUHD861hkxsUn/h1csfTyeC4thaax8WcLB9fFN/Uopd9ZYz2bWIWm/99niOqGWRgzuabz5Ir07NtmrJ7uMwhPFwF8Rv0GzvuDSKJZr++bACK0xGmQBVTct913lgfbQ7O8MIxR34DOXSGGF0OvnmQszaj6NinSt/8LUCSDamrasCovxRmZ9/e5PwiuudZ0DO+c3gOiS2bgYjPV7M3AoW9uemCW9cqy+1o4YInQNkl21n3WjYBXYgH5/85RW6EZu4EpXiL7moDr0nAleknNlm8Y+ZIEfXlS4cltZCDUj5utruE/qWEaL4plECs03XryRybiJvL7iPyWd/u4WUlOVqPtIh0Q9QiohId6EPL4UPmFPer4lzqYvmHWDB76cZadrN93UMXXrinmRK1r5DJA=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4493;6:2q0nuFyiy5Y7WYEpxLeiECp236uXjftKTPihvFf7eN9N9HmuuUPaQaYhDTwRsF+e1NUh+HkmCYWz0mOexnRDmxKbIoLMdfcG7tRpdzMHLOtgdb8jGbnI5+iO8wzgADBaYwks7erFT/1EYfepbOVoa37GfCnL/xiujXow9XOU4IkG66OB6HlxwMyr2fOdhbCmen+vc6uKOq0KUD4caCSB95HPMrjidebEF1u9xM+Ho/sv9wA31o1UCWBncEoSc5kzDyUmfVsh6RqjC3H4ZghS2Ofa9CRUPBAEJ3KA++qnT0tLUt0qnqPZ9HGs7xS4AindKUj1Z5OhThHtBnArDZWtN+SDt9ItcO2KcJ9RFYWzp/UNofppni9V0KWpgIdAogEWshnVwR/LpPRRVLTf1T3B1ZiWKQJw0QtPaMyLkW9pliLQDn3skhcN+n5h5CyO2DZ/FztBDBo+4fDJ4y62V7OT1g==;5:Szv0PdqIm4koh1m4cU2odBwagK7BMw+kyFPeaFd+rNS1P7gkRihvryBdd7NEmEWLuu7cyT0hYpwSUfnsqWV6i1uR3TCzPspEwSDJDQjLZfjhVAPBgxzxwcjuD6+SKa2uwbZFGexC9K3+Ppb6UcsGwnSRc+Qqf7LZ8k0lcoES0v/k5FBYZe5lfDLoTuVk/kYuEjUBKtxieHwX57HiRXizUA==;7:9ePMF8xc78dddlGhNSVZKyib8yp+zeUnPyN98bw1akd9omfZwa6a7tcp5M5XHEGntlSP7F/HdgHxUgPvYIP0Fzo4+vLf55MY0Xk0AlRZLQutgI4oRoXrmNLBCJMCiQaN+9dQdRreRP5vt7RYLLy/bQ==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2019 23:22:44.6876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f81eac02-5d82-4214-4082-08d68252d881
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4493
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jan 25, 2019 at 10:40:31AM +1300, Linus Torvalds wrote:
> 
> I _assume_ (but it's exactly that - just an assumption) this whole
> design decision comes from basically having a transport layer that is
> entirely unaware of the merle data, so the data  is brought in some
> entirely traditional way that can only transfer regular file contents
> (ie tar/zip/ar kind of thing, but presumably actually just in the form
> of an android APK). And then the new interface is just a way to
> "convert" that into the actual final security model.

How the transport layer is going to send the merkle data is really
unrelated (e.g., it's not necessarily going to be at the end of the
file data).

> One thing that is also unclear to me is whether that "secure" model
> needs to be stable on disk (ie is this considered an actual write that
> *modifies* the underlying filesystem, and the merkle tree data ends up
> being associated long-term and over reboots), or whether it would be
> acceptable to just have it be a temporary "view" of the file where the
> filesystem itself can be read-only, and all that happens is that now
> the merkle tree is associated with that file as long as the filesystem
> is mounted (or until it is disassociated).

It's the first.  We need to keep the Merkle tree and associated
metadata information (which might include a PKCS 7 digital signature)
permanently associated with the file.  So it has to be stored in the
file; it's associated metadata.

> Maybe this was answered in some of the earlier email threads that (at
> least for me) were then somewhat overshadowed by the merge window work
> and the holidays. So it's possible that I repeat myself. But I do have
> to say that I think I'd *still* prefer this to be something more like
> an xattr, and that maybe we'd be better off actually improving out
> "write to xattr" interface or something.

The main issue is that for a 129 MB file, the Merkle data is going to
be a Megabyte.  So using a set/get interface, ala our current xattr
interface, seems awkward.  Also, currently for most file systems,
xattrs are limited in size to around 4k to 32k, and most xattrs
relatively small (e.g., SELinux labels, ACL's).  So even if we used
the xattr interface, for many file systems, for something that might
be 1 megabyte (for a 129 MB file to be protected by fs-verity), it
would almost certainly be stored in a different location than other
xattrs.  So similarly, changing our attr interfaces for big blobs,
when the vast majority of xattrs are small ones, doesn't seem to be a
great use of time.

The other thing I'll point out is that file system developers
generally have frowned on using setting xattrs having magic side
effects, since that would mean making the xattr set/get interface
acting more lke an ioctl.  When we make an file to become fs-verity
protected, it does have a side-effect of making the file immutable.
That's not a huge side-effect, but that's another reason where it
feels like the xattr interface seems like the wrong effort.

> I understand that you don't want to load the whole merkle tree into
> memory, and that is the reason that you want to point to some "stable
> on disk" area, but the hole punching does seem to be a particularly
> nasty part of it. It would be much better to have the merkle data in
> some place where it doesn't then need to be hidden again, no?

It's not really a "hole punch", but we are moving the data around.
That's because Dave Chinner and Christoph demanded it.  The original
approach was to put it at the end of the file, and then hide it.  If
the question is "why hide the metadata", it's because it's metadata.
We certainly don't want to make it be visible as part of the file
stream.

We could store the metadata somewhere else --- for example, we could
store it in another inode.  But inodes have overhead, and that would
mean using two inodes for every fs-verity protected files --- and we
don't need all of the other metadata (mtime, ctime, etc.) for the
Merkle tree.  So that's how we got to where we were.  I think the
approach of storing it using the same extent tree where we map logical
block numbers to physical block numbers make a lot of sense for ext4
and f2fs.

It seems that some file system (which may never even implement
fs-verity) their developers hate that particular approach.  So that's
where the suggestion of using a separate file descriptor to convey the
Merkle tree data to the file system came from.  It wasn't my first
choice.

						- Ted
