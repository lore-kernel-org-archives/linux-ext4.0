Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD19C282C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 17:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E1F6222C2
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 17:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="likcoE1o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbfBLRYl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:24:41 -0500
Received: from mail-eopbgr710095.outbound.protection.outlook.com ([40.107.71.95]:30528
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730324AbfBLRYk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 12:24:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsaWWwC33EDt3XWsQXQihHBj8ubo9TCD1/f3InnQY3E=;
 b=likcoE1ovqwplLbC33CTDURoNIeVHhVujSzQFOUlBdNdWNCwaNnz60M58u32KoyiFTmKQFdEew45Bu4V84VoCsl3h42TGusdtH4QW3WEiuHpHmT8bXqAkSNsUaHpOXkpBgblUByeOK/uOiGZhXvOVoREA/eufEXV7/5K4tjgZfs=
Received: from CY4PR01CA0024.prod.exchangelabs.com (2603:10b6:903:1f::34) by
 CY1SPR00MB23.prod.exchangelabs.com (2603:10b6:600:1::27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Tue, 12 Feb 2019 17:24:37 +0000
Received: from BY2NAM03FT038.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::207) by CY4PR01CA0024.outlook.office365.com
 (2603:10b6:903:1f::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.19 via Frontend
 Transport; Tue, 12 Feb 2019 17:24:37 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT038.mail.protection.outlook.com (10.152.84.170) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Tue, 12 Feb 2019 17:24:36 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1CHOYlt018808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Feb 2019 12:24:34 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C64C97A4EA7; Tue, 12 Feb 2019 12:24:33 -0500 (EST)
Date:   Tue, 12 Feb 2019 12:24:33 -0500
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
Message-ID: <20190212172433.GT23000@mit.edu>
References: <20190207031101.GA7387@mit.edu>
 <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
 <1549807615.12743.109.camel@linux.ibm.com>
 <20190212053123.GR23000@mit.edu>
 <1549976812.12743.225.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1549976812.12743.225.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(396003)(2980300002)(189003)(199004)(2616005)(6246003)(103686004)(36756003)(6266002)(7416002)(8676002)(336012)(126002)(476003)(76176011)(23756003)(86362001)(486006)(93886005)(229853002)(52956003)(4326008)(14444005)(26826003)(356004)(106002)(316002)(786003)(54906003)(246002)(478600001)(58126008)(75432002)(36906005)(6916009)(42186006)(90966002)(88552002)(2870700001)(8936002)(50466002)(11346002)(446003)(106466001)(33656002)(47776003)(186003)(26005)(1076003)(2906002)(305945005)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1SPR00MB23;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT038;1:d2T2z2fgonn1qMXMRWX1s2gYk1DGE1tHH8aSuzelqkjbn43ySnUX7KZazjgR0aai8yZKO2TDsnxrqGRHphA7mhCa7kI6GJdE5c7jIncepuHiUrbBTm/cEXrXOZvEBuLcPqEOBMxIRh73R9B/yCLTvw==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c25df7a8-6dea-432e-bf45-08d6910ef6ab
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:CY1SPR00MB23;
X-MS-TrafficTypeDiagnostic: CY1SPR00MB23:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;CY1SPR00MB23;20:8OUPw6v9zNGKgGH6+2KVeHUqAOwamDMBq+rnWnXg4WHTf4rxRp+vvUh0ulWqtGDPO9TbFDMdEYY9Ze3cJrlSlOv6Y7PunR6xpKrkIyYBFYYe2DdLfOS0798vmS2j8gdRuLaVrc4J7pCq7yIzD7buOBLSsz19OZLbaWbA2h0i7tDVtYiZcJ+XVbX5IxeAPSoaRkkrWvmtjjWyb3EKnr9dNTKNlTxy2AOvYwU1nriB1y0pJApxEf00UCSXS3Fwo3ZqUW8NT82gXLAKQtKQn2mmRr60Was65qUddEl/K5Y4lCOAorZFseHKQVggXbUf0PMpY29ej0CA9pyFrLRoeVgH+24IBO/eB16amasEn/mS8p642o+Dw7rL35xMDwlo2f9bVy9xJhE3ma1+P12c6uEBVq8KItl5xBtefLOkWTuRrmgS/4tewSjFRiT9iLwY+SLcD6lJm87oWcOhmcGuVCu4Wmpd6QM7EfnZ8cEnYty+Xv1Ol27P4ykO36odKDBmTRWbXm2gd5xc3fUgE/4TUekBxJ3CvAtZt7nrkCB4Mx2aMr7roAnEGOFvrj58MHcT4osNLjfdlS9cDvSyg2ZbP6prwqKuwqwFaTGGfFfjp0cdf84=
X-Microsoft-Antispam-PRVS: <CY1SPR00MB236A070A8A9A3DF048315DB5650@CY1SPR00MB23.prod.exchangelabs.com>
X-Forefront-PRVS: 0946DC87A1
X-Microsoft-Exchange-Diagnostics: =?iso-8859-1?Q?1;CY1SPR00MB23;23:qyDigX7y93/4xROP0cOYn5Qon/Q2Pnh7j1aCXapA?=
 =?iso-8859-1?Q?PqanfhBz1SAcuEtNSm3pqnvy/FwMqshA/A/WxeN0iXfkRQHj3iIk+EXBDD?=
 =?iso-8859-1?Q?K2AA/B3VKqCqv0Duc/xAINInyBCSIXBkddBxRe1NIiS3RZaBNNweOxEz5r?=
 =?iso-8859-1?Q?ghCWb5y7ZUsyVDImb+nnq8SDEDt6x90ZdLjNk+IryEqKtXj9zQmCEvSmUc?=
 =?iso-8859-1?Q?TilCMsI/EgFm84SULJBia2s36TYAvBJH77F3gISIPtBdEUjwZzC8gp2vzT?=
 =?iso-8859-1?Q?suotfzwhOC24vGEsr1iw/tjWZ2AtBv3hXnafm1+mbnK1LuAiVDkkE72wzZ?=
 =?iso-8859-1?Q?WS3jz/iGA7Fd6xHkIOLFHZvFJ6TLjPBoYns7Z6CXoFcVQM2+H9vtW+2+jq?=
 =?iso-8859-1?Q?S8/73pOF4yuJJ/sxgLnnuptZ5S9XyhXoLM5D02isnnVHmYq3eNbFqBKlrZ?=
 =?iso-8859-1?Q?xDaR10vQuh5tPd3sNjz5udmLAxkM/IymRY2dJ5qYxzqxDhrcQoaYnE+AsS?=
 =?iso-8859-1?Q?G5Y+DbGZ+RXjvbIG4sQr0UGifYXx3nw6lFkJuFr1T1f2o2dsqHzBdmANYv?=
 =?iso-8859-1?Q?zr97uGQSAlVRiD4UgE4N0t+/Rb2su4unFQRiIkqZjhqkzDUAT7jeyx+M+V?=
 =?iso-8859-1?Q?ZPU7GesEfYQYZZwRRkuNf+BPiCFLcUoIx3N6LQS32pkTwzrWVojLXKhwSL?=
 =?iso-8859-1?Q?/w6dO2/9KqAClS0zeyzo1sa0hEBO3DfelYFZARh+lQAmPDUDgN6QwZUiJf?=
 =?iso-8859-1?Q?JdhjL8jayGlvePpnZ5+LTTZf9ISpc3hKbjcH7+hNCFp7AHhuJQKKGJps1f?=
 =?iso-8859-1?Q?wnlbkWf1aNFO76woBxLZY90luTnb1QHe8NV4rMOAuTfAP8HpP27z44vtFG?=
 =?iso-8859-1?Q?aJqGS2XTxCveaXvTo3fXfSovsggZpVPiR8IXTHdu+Fu+2EAjyEs+Texscr?=
 =?iso-8859-1?Q?EOdPFP98NIu9WFmXuYX6uRFtqjnQ+zjmBld9y4Ms7p35s0LiFqGf4EXwXY?=
 =?iso-8859-1?Q?nHuX45nTsRiQ3NT0cg49HfDKKazqyQkuZxdW7XqgB4IoJFNuwg7n3zOJWN?=
 =?iso-8859-1?Q?2u0J64ZgybraeLutbDlirAnhlSglED6t89I31YAsNui/+KxWdUZ4s6juaw?=
 =?iso-8859-1?Q?eQalvULkbjCxRgeg8rB48RNC7j39vGSgZvZh/5taJ2nNZpr2BiHIF0tjHz?=
 =?iso-8859-1?Q?14M+fjmOGTbas38PI2xrzamguac9dxI93XuPDwuWM7Sd//dR0kP1KqGwHA?=
 =?iso-8859-1?Q?/ckteekn5oARtQBUE7S+c1/dcHY+8oxWmFpiyd4Yi9Gm+oo4H1nDnRVx05?=
 =?iso-8859-1?Q?Q=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: fpKCesXNIhHGvEszaNU+gDdURE0SH2tkS84xMksyMQms3Y2xr0ClHHNFRQmDcJitH7MNX3JW00ZxVkWVWAm33xOcA0a71I/2FtSIsQ4aMltQK2Agf6TubK3CZL8L6YBfGnycOZVmT63qifQC0QTqtRfR6vdWq0MkkL/02ssn6sYSUiKTfSCDRO1QOpj2YFNU3YjXiwOG815TPZHPvw8O5hLpW6vdm8KaHgvK54H7YUtitIueMITzB9D8Yg1D5F1Qw2lJQzZ1Ih01HlJENB/GDSL75F7q45TRRY4872g1Dssnr9W7IMmr/Gzq5jKLCwnFf431jPUP2NFhHrggtgVRhgQbzztKuLNrDH5Nh7ZV2U2sYCHcFlt6X+QKPN8CT+TjonpTTGneX3H1g4kzbKili2e54NN4WlxXFUZgVPoQm+c=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2019 17:24:36.9420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c25df7a8-6dea-432e-bf45-08d6910ef6ab
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1SPR00MB23
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 12, 2019 at 08:06:52AM -0500, Mimi Zohar wrote:
> Yes, I understand that your primary goal hasn't changed.  Linus was
> suggesting "the interface be made idempotent" to support "filesystems
> that don't actually have any long-term storage model for the merkle
> tree.  IOW, you could do the merkle tree calculation (and
> verification) every time at bootup".  In that context, I asked whether
> the Merkle tree file hash would be for every file on the filesystem or
> not, and how to identify those files.

I have no idea; *we're* certainly never going to use it in that mode.
Until we have a use case, answering your questions about when the
Merkle tree hash would be calculated, etc. is not something I can do.

If IMA wants to use it in that way, let's talk, and we probably can
drop everyone off the cc line.  But there's a limit to much work the
open source community can expect to extort out of people who are
trying to get a feature upstream.  If it's very closely related, and
it's a small amount of work, that's a no-brainer.  But past a certain
point, it's a completely new feature, and it stops being fair....

> > > The existing file hashes included in the measurement list and the
> > > audit log, are currently being used for remote attestation, forensics
> > > and security analytics.
> 
> Again, the context for this comment was Linus' suggestion "each level
> of the merkle tree needs to have a hash seeding thing or whatever."
> Up to this point, I had assumed the Merkle tree file root hash could
> be used as an identifier, similar to the file hash.  With his
> suggestion, it sounds like the Merkle tree file root hash would be
> system dependent, making it useless for the above usages.

Yeah, I have no idea what Linus was talking about there.  The only
thing that really makes sense is that if you don't have any
file-system place to store a seed, you don't use a seed for the Merkle
tree, and for a given set of bytes, the Merkle root hash is the same.
So it's basically an expensive to calculate crypto checksum, as I said.

If that's helpful to IMA, we need a crisp set of requirements and
expectations of how IMA would use it.  And this includes, as I
mentioned in my other e-mail, questions like how long do we keep the
Merkle tree pinned in memory, how it would be used (I assume it would
be something called from IMA's measurement hook, but maybe you have
other ideas).  Bottom line --- I need *you* to answer the questions
that you posed.  :-)

Once we get the requirements, we can figure out how we can architect
something sane --- but adding this extra feature is going to be a lot
work, make no mistake about it.  One of the other things we will need
to figure out is how to hook into other file systems's readpages
model.  There's no standardization here, since file systems don't even
have to use the page cache!

So my strong preference would be to get the base fs-verity feature in,
and then we can look into how it would be extended for this new,
completely different use case.  And hopefully, the people who would
benefit from this new use case, would be willing to contribute some of
the engineering effort to make it happen?  :-)

					- Ted
