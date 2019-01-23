Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC88CC282C0
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 05:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62EC821019
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 05:10:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="khJ0uO1v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfAWFK0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 00:10:26 -0500
Received: from mail-eopbgr760124.outbound.protection.outlook.com ([40.107.76.124]:57216
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725899AbfAWFK0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Jan 2019 00:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3bsVHaaperwFmH6hi+4t8BA+XpCmkizRZJUeRoqkKM=;
 b=khJ0uO1vZv+hiYw65nEP1WInLSlxKhbFxPve7LaDPRDuPM9BEcFCJzlJUfuuleu/aLVNeaiCu+XKPFdvSS6lQMKMOGPomVL6dmVp0J51ZQMFi1opZrDwLmzr8Z9NNoXNxi0g5LOqI0+pJXTYPvW3MO6XlN5jXGhw9MT32Tz/4hI=
Received: from DM5PR0101CA0030.prod.exchangelabs.com (2603:10b6:4:28::43) by
 CY4PR01MB3207.prod.exchangelabs.com (2603:10b6:903:e5::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.31; Wed, 23 Jan 2019 05:10:21 +0000
Received: from CO1NAM03FT029.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::209) by DM5PR0101CA0030.outlook.office365.com
 (2603:10b6:4:28::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.16 via Frontend
 Transport; Wed, 23 Jan 2019 05:10:21 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT029.mail.protection.outlook.com (10.152.80.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.11 via Frontend Transport; Wed, 23 Jan 2019 05:10:20 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x0N5AHWT008632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jan 2019 00:10:18 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 4A4047A4C57; Wed, 23 Jan 2019 00:10:17 -0500 (EST)
Date:   Wed, 23 Jan 2019 00:10:17 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Dave Chinner <david@fromorbit.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        <linux-fscrypt@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: Proposal: A new fs-verity interface
Message-ID: <20190123051017.GA8785@mit.edu>
References: <20190110051500.GA32361@mit.edu>
 <20190114234101.GQ27534@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190114234101.GQ27534@dastard>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(39860400002)(136003)(2980300002)(199004)(189003)(106466001)(478600001)(88552002)(47776003)(26826003)(229853002)(2906002)(75432002)(786003)(316002)(16586007)(58126008)(42186006)(36906005)(36756003)(76176011)(33656002)(54906003)(106002)(356004)(186003)(1076003)(6916009)(26005)(103686004)(6266002)(6246003)(8676002)(52956003)(8936002)(4326008)(97756001)(336012)(50466002)(23726003)(126002)(486006)(90966002)(446003)(11346002)(476003)(2616005)(46406003)(305945005)(86362001)(246002)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR01MB3207;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT029;1:AGAz6G7AQkn5j7oNp31IcLQhLryW1xFthlMxEC1U3hidimqzUTLohsp6l3BrZevYaGhhVXAyTufhAeYKHn6bDVbeFfQRqkcJe4TxsU5BsJf/nXRbmJy10i0nz+85og3zNqad4p7rChrmidGNvgPhUw==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88fb6446-0661-4b44-1ce1-08d680f112f0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:CY4PR01MB3207;
X-Microsoft-Exchange-Diagnostics: 1;CY4PR01MB3207;3:mrkso58CPd12KUj4zVt7cOB+ShJlouNzgKLtuaA2/ZVSu2SB4J1wEemcmyncx/YOESnWYUYg6V3yI941ruDl/mqLeBL46t2w8TDqzI4Vvkmak7jWHlArBE8LFn67gx4HWRbv9p1kc43UX7ZaywaSjw47c/oPPElX6z9e12DW2uJNq/pFg3t9nUBFoSsIk/HdRipPiGiSTL38r6fNcirRgys8jQipWCT7j8C0diIOnHKavovFft6SCgc5T3HoKCn0Lsq1CN0594H+Z0P1ZaIHgi+j6cg9tPdNKR1cwD8v7S2GJMEzvKlt8DLYuRV7HDaGsx1hVpdJo7diPE/InQpANmMVlcqCIvRLarin8G8Gv2XeLbRmM8W+L32HAPQ9fGyE;25:q7g4BbgkFvUppZfedemhv3IrXMw1rdM9+5IQbyVSVE8GrJ8rlmqCNNj1qVuTzH/VKZ4vwoqha1lO8xIGDAHSplEq136pvrtdyw5CzAynuEZ6nkqpj08C8bhrlpCsg6dEMySp6WdXof6s9JSAI4z3APbiY99X7SzS1Mx33JnVPuS17k91peM26iSAAMfXjdO0A3E0MrMrui3a72gSjkpd/HwbpyJWpjtJfp0VCVdcNhPi1zEaompBnut5rYuwkPL1VJAjIUsT72K9TTKjZt1XvdLUYXBhYmuwKVcJS3J6A/Tvs9NhRDWhMJeCpKDIZT1V8mruOPzj7JGzHXd4wxfWQw==
X-MS-TrafficTypeDiagnostic: CY4PR01MB3207:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;CY4PR01MB3207;31:zaq+f8NDOv1R4NOXExbr6wCaSjinqbibFahyc4r9jrmDyGDjTdUbCyM52GK8cmkhMbTBKrqwc2b6ETwNbrvWcgxOhEgCt9bYvebX7uzmVkESDMAHp7XD4AGiVCFdZMdo0GDinY/JLRnmF/XCMaC8jwqQEQ/ZPruQqXej+p+1LjnvcEXHwwPTks0sLm+n9iIvWneS8QZ9P32kyhVpF0pP8ndNegsvs6zOJY960GtCnkI=;20:W7mxYenBXMAztUl3Bjq49j4cR+JCzzqbsYYJWtfSfpsO7LQtx0HpCteAKqVweYYBjtcXMDUrE/Rnt7br5WGJDIUifPlMBEBat3NXkbZjGUXUSUzx0B8RyIbFnB2aHG5YD91Eh/dY/5fwuDsIaH8Jo94AyQtoktXLZctf6apCZUj+B4OGzm+lqiag8+HoKmmzb9lccfsWED1j7WcblWJ2ap0W7MpUDRO2iuNMjWPKE/1NaexGrRW5MUZAIzZ5Z0EUHDzOClzWnQePIjEZnNtee/7ex/BZ739eAodxOj2aCO4uwQ74NmOSGDPQxREGbUaO87u0m2Kdy7Rz4x6MnRrf12xQ743GkBJJtT+Ww2XyBAxIh2LIRNaKnx5k0OCaoac1GkF3abKLd/PPHeS21qrov9vefDVT8ajEWQXcuTTASStzPl3lMnrN+sgA6MxUxftmkAo7CG9uLdBX5BHdpgD/dDSEpGCZLMxFeNCNxYqXDCz0B67MknMi7ddgjjjEH7ZDH9qVslmnHuxeWZrh3DbpCT1mC4DcVsiC6cuii/I7msp6abB9UsE/Wdg936W9VJ3wW2dZHHbphUCulalLFlu9Il1cOTZcamAsWM69msmUzf4=
X-Microsoft-Antispam-PRVS: <CY4PR01MB3207B366716F46A25ED5F86EB5990@CY4PR01MB3207.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;CY4PR01MB3207;4:Yh2Pqg2CtZ16NQShGGuXRCJpirHvA1CXkwdEzoeeVzhdYQeC/RAoPNaM/bXuzDb9CmDg9xOAKciJ3/fF8E4B4k6FHfexa/CWyrpx1RQM8qXQl4pDrHq6LGMGvPfAS5mfWsxxTaY/Dj668AmuV2xuclg/5LFKhr8GRqPkLRp/R3FowCay7TjzcyakAgpw13rTVMD8Tj/SWRLOD4/z++KApxvrd3n6kyG3xPUlxhPiCKpQXggpsjqPP+QIFI1zQ0muU5h5DORF1bLgvcMyoySHSCNJOXLpy98V8Fw0phbFLNo=
X-Forefront-PRVS: 0926B0E013
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;CY4PR01MB3207;23:abewcdh0DLaU2NImyq/C8G8aRVh+8cHWFsk4ibMd+?=
 =?us-ascii?Q?2AlMUCP3GNJA44JNV0D8bg0yqSJTzNHLufLYEkTglfXsZIHRan+npWegeuzn?=
 =?us-ascii?Q?kCvFBE+ZKmUtcu1wEYIzAc8/GnO4O/jYM1ZUzhphecMx0SKLtJAetythAaqQ?=
 =?us-ascii?Q?qREAQSJuJ6OH42cCpCXq4J0amKEfAo2rddWrfBqIISnkqJyve0kasUJ1RlaM?=
 =?us-ascii?Q?GEm8J/KhqUL4enmjlMTXWSGkpf2ThNxVaULJxA6Z6rO8vqcH2/9LbDCIOEhq?=
 =?us-ascii?Q?oYRO51nR4McsLm7Di8+U1VtwBopEeNxkjo+pwZUGe1bKG6gMH46vMMEPnQkQ?=
 =?us-ascii?Q?j9MlCePoAybVUbbbyB7cYRHVwWtKzGpc+mKkzroj25G7V/4ThoEX3ICBvQT6?=
 =?us-ascii?Q?B2BDwxaEHlp0cF968K21pfZPnp9BYQ6KFdAfHy7R9YCyy7aZfhp8aM72E5Nh?=
 =?us-ascii?Q?owZtx1Oz2zZWVTiRgu1l9azcWK2HgW1mF168ujUwInhQvolL/yjAUWU7MqSm?=
 =?us-ascii?Q?b3wpDkGz1hTzfkQAqCGen3WwNbIU7HNBRg9iEa5aBFNBy75a0JDF9N9Junij?=
 =?us-ascii?Q?JVBQC9VN5bm05bcMSfRbxsGqeUOFWdsFamgJei6KOn1eYdCVkS/hEKNgMFvU?=
 =?us-ascii?Q?c1T0KyH8V0/oHAiRdPGmqgAdw3woakfDbyUQQJ7t0pqBJVSoa000Sh8JAXsU?=
 =?us-ascii?Q?cS9b7+/rYHf0JcNBKTxoR5tDmmGc3P+UNXSGeAn4faMFWnCgB41qtPoRQo5Z?=
 =?us-ascii?Q?6wAqXDtA4pIOIe0ZNJoEXVRqtS5YLejmdwveDVVvnp4TsWmnLEjwlQTjwjgm?=
 =?us-ascii?Q?IiT3Rqqt3vUsjHoc7sDkAZPDKmweHqfknqUIzLZ2MFafm7Ije9TI7UjmxIUg?=
 =?us-ascii?Q?fW4K+cdumtZgOYBPL2tFcn/wZjZ6sVjFQVYgB3mRvrJW8a1RDjKN6vOX+nik?=
 =?us-ascii?Q?ui9beUXjQ3dPgM6GnLHxMyH6uSuHU5xToZDsjubeIf82HR1FxHwvmVlNEDNM?=
 =?us-ascii?Q?QAUFN2GcZYzlVeH789YI8XJvE184YWHJlK1Z65Nk6aU9fgQ7r3Tq4Q3eWVC9?=
 =?us-ascii?Q?T+ATkUEJKerV8kU2ntzCojJqtNbw9Vr9eA0Yct0Gdgyf1iwXJImvibTvF7Uh?=
 =?us-ascii?Q?a1CEMNClmlp++YOmMNjMWoPShUaSPDmSLa1HCeTvBrvTmVk6FNUFbDObR1Sy?=
 =?us-ascii?Q?qml1IGiji7K6gsVduXSREN1VfAnk3NowGdb?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: RDtFoIm8r072I4Mi354mdb6oi9syY4zoELczEcGAueeJ3VsKjVOn7UTuJ+UnKzFUPBUtrZUoZfjmCDevRJHO4H7ehv0W2eVVTNj9vSBED/tVhva1yKp7pgmJdGkKHMxziNlSdynBPpK2JqfrdbexcMjoM/Uyw6Bn7UG611NPQh4keEWQ4rMJ6Tm9PwhEZHyK+6n6/KGlmy3cl7oqExtp35F1iomESWjzQrU0dOXIAfKhahSnJIKk68+Qf0bfY4BAyE3ApcHSuZibdV3ctcTQNgAGeFF5heIcq7GDsVDsh7qyBLggpcW/B3bbPjlIYZEUNy3Raj5rnEjI+ipZ8zeGnv7u/Loqb7Ifn822cMD41S7mnBbwn2ITNSJZrg87aq/xXul8bYwB8zgTw5m8kFrrYvcEdK43OE4IYzObhIoBrbc=
X-Microsoft-Exchange-Diagnostics: 1;CY4PR01MB3207;6:AKjgg10/2oM6jGmiAUeergsWBTF0hG+kVHPyV25R8gLzNJRLZXBnBw+yOrqwjIZt4EgAsLnjUfMpQa4hMQclVRJdqFgpRZVkbK4V7C7OECMZvEbQEK+o2oPlT1AHkyFSrRDvNT5DokmDtXyKGbjf1AmyWRcdNhMkhnnyMIllu3F/Mr4IZZXdHC7zR85mV+cK1djkLsZel9WrpS3g7lFvNeWYsOu5SDUCU4kqzaGcA9VwmwjLYi2wXpMPGBpqeM+PBkE72rGy5T5pZPW0weaZ9f3/LFqpMsnd4fi0inuk0P2FobA2T2tXxfeA/qpmGjMIyytLG9jDjf0l4G2CXxj7aWKCT0IEaBAZklYrdRnNEFAxqnkQt7ZtkwXWMPGVqpmL1nH+YPw1krReND8Mrzd7cvz1LXxpLz6+JL/JjbzoQODY6RjeIb1Euo2sMWWuGEOQfBg9Zt6/Yw1wYvGIDma6LA==;5:yFhZKzlXTOMjBiwcVjI8NgdqbuuNurSOeAvxW22XNU/eCwlVQGgCkFQGY1SMa4ZLcaaWVmdWIMrmyCIZrv6Xej35h230ntAHcS2J//zNdY88k2/uFx1apYcCbtTdo2ONlGYf3vFD5kJt6LZQpjFgmPZ8aiVuXHxw07W/pDcj3MTfRIU/xMSFv8McFSykfStBo2FEIcaU8i77BnXTlwZtdQ==;7:lxSVhzv8H88UhZMrAgN2RR+ntRyhNvsDLg+5c0KqzvT1IVyMdnIOLcxgjlUigh/6f3HEpCBuVarSjD36oXB/HcYqQsduLkduIfCB0bsizH64yhA3VIbGCXieWiZokoKOZHOfk1NW56VubcWiIvatxg==
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2019 05:10:20.6922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fb6446-0661-4b44-1ce1-08d680f112f0
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR01MB3207
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Apologies for the delay in getting responding; I've been on vacation
last week.

On Tue, Jan 15, 2019 at 10:41:01AM +1100, Dave Chinner wrote:
> > int ioctl(fd, FS_IOC_ENABLE_VERITY, struct fsverity_arg *arg);
> > 
> > struct fsverity_arg {
> >        int fsv_donor_fd;
> >        u64 fsv_offset;
> >        u64 fsv_size;
> > };
> > 
> > fsv_offset and fsz_size must be a multiple of the file system block
> > size.  If the ioctl comples successfully, as a side effect the
> > donor_fd will have a hole punch operation on the specified range.  In
> > other words, the equivalent of operation of fallocate(fsv_donor_fd,
> > FALLOC_FL_PUNCH_HOLE, fsv_offset, fsv_size), and the file specified by
> > fd will be protected using fsverity.
> 
> makes no sense to me. What's in {offset, size} and why do you need
> to call this on that specific range? If it is the equivalent of a
> hole punch, then why wouldn't you just use FALLOC_FL_PUNCH_HOLE?

This is how we transfer the metadata (e.g., the Merkle tree plus a
header block) from userspace to the file system.  In the original
interface, the verity metadata was appended end of the data file, and
then an ioctl would transfer the metadata to the file system.  For
ext4 and f2fs, we actually store the fsverity metadata after the data
blocks and simply adjust i_size visible to userspace so the metadata
blocks are "invisible".

You objected to this interface, because it was too tightly tied to the
implementation used in ext4 and f2fs.  So what Darrick suggested is
that it could be conveyed by passing the metadata via a second file
descriptor.  The offset and size specifies where the metadata can be
fetched from the second file.

As in the original interface, the metadata blocks are "consumed" by
the ioctl, so they disappear from the second file, as if
FALLOC_FL_PUNCH_HOLE.  It's not that they are deallocated; the blocks
in question are simply getting transferred to inode which is being
protected using fs-verity.

> Can you please write the man page for the interface so that the
> description of what it does and how it should be used is crystal
> clear and doesn't assume the reader knows "what darrick proposed"...

I can do that, but I'd like to make sure we have general agreement
approach first.

Cheers,

						- Ted
