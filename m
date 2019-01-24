Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E215C282C3
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 05:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 379C421872
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 05:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="RjBP4lut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfAXFDp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 00:03:45 -0500
Received: from mail-eopbgr790102.outbound.protection.outlook.com ([40.107.79.102]:23527
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725290AbfAXFDp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 00:03:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3tlDxmdx+JzghOAGQHPUDok0lifhnPQk5MmedI4jJ8=;
 b=RjBP4lutpDnmNEeSBZPhuPmNFHWZpTlhd+vAWXX6V/qy9M5zGv9+nOiNYv8JzBglG6eymxXrsn8WWAw7pkffzTdh0RbAheP5V+55U0GwQJe7d7OAW+kJMO5B7QKOz4mxctwPCTfXk0UMguD/LA34a5/J/MYcVWCR/jfBe7HFSxU=
Received: from SN2PR01CA0056.prod.exchangelabs.com (10.174.0.24) by
 DM5PR01MB3212.prod.exchangelabs.com (10.172.189.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.29; Thu, 24 Jan 2019 05:03:40 +0000
Received: from CO1NAM03FT021.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::208) by SN2PR01CA0056.outlook.office365.com
 (2603:10b6:800::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.16 via Frontend
 Transport; Thu, 24 Jan 2019 05:03:40 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT021.mail.protection.outlook.com (10.152.80.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.11 via Frontend Transport; Thu, 24 Jan 2019 05:03:39 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x0O53bVg014994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jan 2019 00:03:38 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 42A627A4CC2; Thu, 24 Jan 2019 00:03:37 -0500 (EST)
Date:   Thu, 24 Jan 2019 00:03:37 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Guenter Roeck <linux@roeck-us.net>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [f2fs-dev] [PATCH] fscrypt: remove filesystem specific build
 config option
Message-ID: <20190124050337.GD8785@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <20190110233230.GA23953@roeck-us.net>
 <20190111010116.GG149637@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190111010116.GG149637@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(376002)(396003)(2980300002)(199004)(189003)(47776003)(2906002)(246002)(26005)(186003)(4326008)(476003)(23726003)(2616005)(6266002)(305945005)(36906005)(36756003)(75432002)(14444005)(46406003)(486006)(50466002)(8676002)(126002)(1076003)(88552002)(106002)(446003)(33656002)(6246003)(561944003)(229853002)(6916009)(786003)(11346002)(42186006)(316002)(106466001)(76176011)(8936002)(478600001)(58126008)(86362001)(336012)(97756001)(356004)(26826003)(52956003)(54906003)(90966002)(16586007)(103686004)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR01MB3212;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT021;1:zoO4mknj7ddd6H3wVF+IIaelQBFUeBAM5I/9flglwCUV8GcMfzEtXdlFoMO6jYsxuH2R4UtxtgsBjJXXPrVvsR22k0drE63Isjt+6OBtfym61Deg59VAyZshcCBV9NvY1MzXJrZEBU4dijMnQRNwquBQ2kurM0PcdSD41s4geqY=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: becf0508-049a-434a-6347-08d681b94e67
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:DM5PR01MB3212;
X-Microsoft-Exchange-Diagnostics: 1;DM5PR01MB3212;3:MgavT3J5vksxOTSLhqpNAo2mnozvqvvuXv9fG+dOAEKdgZS5+uRxp0S+h2qGHh8eXirO+yv9nX1FShqVFDatiKntg86pap8roNB6Y7viFFcqQ080ff9wc9mu+N/wf6p1tgLbtPuqq8ndyHxkQ/wOOdloIrGKBwIDCErBUGzO1z6GtS8FkR5327LcT0cQ3fWq/vybAN34+S098EAd3mXJXNkwAgDykY0aPwyTIXyZXJqA1izPLBftZM0sK9iRMzPTTMY6Bjg5T27uTyl2vfkBYp52FbXJfBOV5dF9invWb5v6Z6W8MET5kIVJ/Ydo914xqz0eZlPssQ7o1Pt0Orv89QgaME9lQYTz6SWUIVvuHVSOUyWdo1vxnUWy4MVko4wq;25:jFtrvM0xfeJpFDKSue9RWyRYEks1JXXEnk3J93NhXaRJyyJ+uAyml/nzGHc9ZVN+yuLSUeRzT+MFZCysRJIhNIBEiPi/Xs8WZTRAN25PzVXuPwVx7/QcAndOS9zf8pp4r33NGityiYpvEA2ljwLzIkKMSEfvxw5yu3q2FoPYjWwgdbOS12vHB6SEVy/wg6BzemTLsNnf32CFb+Ebmbm542qjjUW/LfUG9c7qLL6fF2woeW0DkbWiWfwEK4hoR5GwomXFT9khVxcZ2KfkOidL3Ly5te9qtpXCtJx5woxID/juCTzSvPqXBop4gnbBQszGJ0pVGOLTmIWMfJAFnaRGUw==
X-MS-TrafficTypeDiagnostic: DM5PR01MB3212:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM5PR01MB3212;31:yETStcBiVCdvX3bOS+Hkt+FnDTuuYlE9pgZtatsPTHflHqEG/PYM5sUMFDyNiRO+sdloQoXIZrM/p0C1w+kqFmxOAxKS4AwaxslHS9PI1MMQ67DLM4vZiLupk/+1Z0AdRXHFsr5l/zHseOnAhXJ8ZvIT7hOK9UCdz1F6h+7j4f5IJLqBJykJRCetCQvGnCjTV/b2e7ia0JJkQZcq1gesAaXCPuHVpCewwZi6cf9EqU8=;20:VGrpJoM0oVJ8xZucFsf7cJupu+iVflGon7BPdfNx2UuoUdl4re7tuDMvGhpHV0koe2Ji9sPH90AYCmaERn2Y2WOgm86knQRzWoRrZ4da3NF/XEt66I2EAi6gZ6XtLrDAAq1GkuzUjUr+J2gkKFnvQ19s55c57G1i8LkpC7db2rT/05CiNo8mnCu4nRePlAZQaGKIbYFBNxNdr5D+eOTN6ie37Jm+UILCD44y3XHx7fYlSJHErviTELY1b3tjH7dcTxH1u5dhfczG09FqjDZ4k5oPC8Y88CFosTHBptde2fIz98MD0HaG38rBI02SqZuZTgi82H6o9Dn6ChA1BDf25qV0XhrWjbro2hpEY0oDNNQokTEbVdE7CUlsVPLzzEOr6Xbz8VU+T0FQuve71PNiq4e6BTTzr1QMVO9FdIPvA9dI3csKx++zdUurzhCmcujo9POWK5HQ4qE1O5PRASzI26TTIes5QPUw032MHw+G81D13rb7wJPErUUe8tMB0yqj6pkMH1z/PuV4mCzBWbfv5lFV8IVNwlNr4krvu+iG23xCD9cuwprrxPq0DbNIDmdzgKt75XntKdOFaKzY5nQCzzMLvee5vyBp9vzdUj60+WQ=
X-Microsoft-Antispam-PRVS: <DM5PR01MB3212C539062B7209EAA08E93B59A0@DM5PR01MB3212.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;DM5PR01MB3212;4:QmdFOWghYZgK0k13loDAKgK0fRUEte6Ko5soYZ4nXvD94iTPfH+RDdGv6v00kwwTcVIXXw6p9j4QbcuIcL4/pSPNeUpqwLzdpr+K45gAqlE8j0Lb7lTmuuqHSNhYDAZ1ajjstESuLQH2/qvF7CMK+JQA5qNC9ao9iF22wOHWqqa7flqUNDDdggkb51JcP0Xlac8Vj0TbWaNfWMm6VDrblELUEcFYxvBM37HlPRjUlmmOEj9AscOuuZm1fPYCPBij62B/D8RnhSOtk7vY0nwM+P+Ljz9XwO40fEu+EN+PSeSgTiq4gFZC2hfiwqsBkJF6
X-Forefront-PRVS: 0927AA37C7
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM5PR01MB3212;23:QdlcMwFdQk3I3UxWyZ/GYw9QfmoDlTYs/iBqWU30j?=
 =?us-ascii?Q?pbnghOoVuVTGbK18G4iHXet4l8+QE30ZcXGgKhknuVeM8/scf8yFYVXZoO8L?=
 =?us-ascii?Q?JRBEwwydXpVt/oUb01pUZGg5lw4VtXvwh2+ZerMiR2HJkFarJdHsnGKu2hkK?=
 =?us-ascii?Q?nggYuj7PlXKqH2efhQXTrW1MYOdB76yhSDU4OvV7ifZHQZsiCee+axdYSIvs?=
 =?us-ascii?Q?PMbfARvPPf7EGPvN3bq9FpMiehf45BLnUHn/tLiLNs6xoyyjzvSWRw6f+ujT?=
 =?us-ascii?Q?AFjp/asFHkJFnvH+y4nWBti1hR8qLPELYMUDhWA+WzmsN8JN2uVgrdGEiOvz?=
 =?us-ascii?Q?keUeU2r7Vz693LlGSXZvB8ll+HKIifmlyv45VqLZ5p/Wsvg9AoJ9r/jgoIk8?=
 =?us-ascii?Q?vZtysMsqF678uWTdPaDyPwqv2GiCiHTO6rnL+R4bmrdc5sO26mFx5cNasQGY?=
 =?us-ascii?Q?gipW8wMDjKIGo61Rz+IWEIr+ot8PoENeLMw0J8+9YgEJvreaRX2fZZcLZE5T?=
 =?us-ascii?Q?4vk8eg1Nn+laq1be1PwdTCRtnfpXkWIr8mOBlpzXdDMRwkN0LxjEcMTn9VnX?=
 =?us-ascii?Q?JXTu7FKIwMV+300qG/Bvu5i8BiAbmiteBY8k9t6m+Ddh7iOzMNPjLL5lkmBT?=
 =?us-ascii?Q?yHWbn0OYbkKFMfz3ULmXOEbShzzl8DmkSqaIOkad6hxH7M84XTs/ovcRA74p?=
 =?us-ascii?Q?zms26+p4RXUf2C1pK1I5SVnrZKD9kF1psCudhF57lF8dSbsS5bAT0M5gYkVH?=
 =?us-ascii?Q?Zn0dzPoA9LoyHUlg2MR5X3eYh5DjBNQVuleC7/X9n0p/OjCg6mNcFpWqCHR7?=
 =?us-ascii?Q?BimVTFr5tT1hW/IgTkGFGOjQp6I2uoKRNfwb9NcfHwkEM45v4H5Pfk5Mb7ja?=
 =?us-ascii?Q?z+PzHwenMAiP/L7tdt4reddisUb9qXPbZ00VUHl1pull0nRCqAIkGHNY6j7b?=
 =?us-ascii?Q?7bzLHpPGzdnlV9Wo6DCS4Psg5k9i4DD4M4dSMcS8hQNxBB0ubWTLf0NSLSb5?=
 =?us-ascii?Q?8wYPR+NkOISH8G76jy7WOwq69VmD2MYig7IXb/wtsayUJcpSEpxCnwVSM50g?=
 =?us-ascii?Q?r+hak8n4zp0vOhcZanjLmLiQoNkmsHQ9cnZ8/X1Pk3xLCC+7WkejlDcfKzoZ?=
 =?us-ascii?Q?ATu+0bsiBtc8YMSk1HPpwPxaBEw1xW8Pz6UZvNBE193qVJo7ZL4vms/+Tm+j?=
 =?us-ascii?Q?Yaxm5hYnX4yK19ORi+eYugpL7T89aTPrveXUuFQJOzjP+pZIqG2WvNEmyyvc?=
 =?us-ascii?Q?qgCh7IG7EM17D4kSzo=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: vuR9LY2n+kChfAyccR8+BLE7Egm6RFWNoRdkF87KqhnA9WOxtQy/v4IiNvF90whKjZcwm7FW4PP9971qBoq6+vN99DbKz0Kpf4xfj1Bpsd/xtTAFGVUzoLMoZmQxj4qZA8kfquKZQUvmEXIRQ4yq9yMCGekgGtFNmDcKzSd3KEQIzMziaovfMLm5eY//VDl1oRHGcZQmXacASgMKoBx7kEyhBeamddU2RkVXWRJrVPnElAf9nNqYcLyZY+ML1DIufdMxqEHUEp6KXNSzWMed54nj8ASTFrbA2N1Z/RR8xb8FKRok0Rqv/usM2COUeVWwiGLBmDh48HHAIMZduBD64qPiDG+giYTmMvATWoC3IT4TvKyGKjXUdIPfxyP66F8B8omJNCdO+ivST3oLIwdaHKPaSPewk+tc3z/ldhXvgPM=
X-Microsoft-Exchange-Diagnostics: 1;DM5PR01MB3212;6:t5FudkXkXfo12HP8tztx40cQ+ScROH58Y+krIWn3cU9zPbgyrf+ipjFqHrw5M8Ak0gVFfQBiNmG79xEcCT7em4QhkirVwgtGEQYdv6atpbz8U0NsEFnUSY5kHvOAzlekeFln93XAi3gZU90iX5JMNFgwHwKFr2n7hrE4bcBJYFAkNa+uf2IRlRDC9V9eBXO6VTcain9HRnnM+xOy1enwS9tHnq1Uy7ieqy3vloPI5GNiPtD/K9WbxZh5Spl6EwMrPZrQ6owMO2X6KEEktJgrDGWBAFfC4R2T4vgIMA0CbNaEGznjhdJvUJWf7+1KxsEw5pWS+YqXmiREY00qzzHUBH5EtoV7one6XowJCTSjYxrIjU4aPEfVCsY+Gj9cTYpS9w4UNz9bPzjPK7qM0YIH8ZGIFPguXu8oPktnSQCGXUu31rAWtGSRxbP6WyGpm+Glhzo0qwAYjS13yUQozTrJaw==;5:y0cEGoUAIGeMROyBZEGVMuTIqgQCE3XsTSN5MXTjrnFr6bcUIgWhf6HcMBj8WvZIP/wR5/aG352c9uBnPUAiod+gkQckhzHDxeTeXrwoM8FKk2myfXAni+82ZbJ+HJmzPwV7swEU+N7Pk8nQkFKiOtjhmM1hOtZf82oEdBJ1ZiPN5i90d8GdattMcfPhZDbjz0wqPYnSZpVJn/pQQmJNAQ==;7:qO1CtBISCeP83yVfo4ltCRdiCxc6KTYwrWkWRpYch5dkVTMjiT56+lB8ZltdoW+xuCjgRHMamdVe4KdhDdJpS0l2i3DYGFvGTATHys7X/cfg5oUdCtPGNy5wfxXamOrX9SbHkdIyIyqJx1mUJfdYOQ==
SpamDiagnosticOutput: 1:99
SpamDiagnosticMetadata: NSPM
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2019 05:03:39.8835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: becf0508-049a-434a-6347-08d681b94e67
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB3212
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 10, 2019 at 05:01:17PM -0800, Eric Biggers wrote:
> 
> Indeed, Chandan Rajendra sent out a new version of the patch which fixes the
> problem (by removing the 'select BLOCK' from fs/ubifs/Kconfig), but it never
> made it into the fscrypt tree and hence never made it into linux-next.
> 
> Ted, what you are planning to do with the fscrypt tree following the fsverity
> discussion?  IMO, we should keep the fsverity stuff in its own branch, separate
> from any fscrypt changes.  As a suggestion, in the branch "fscrypt" of my
> linux.git repo [1], I applied just these four patches on top of v5.0-rc1 and
> resolved the conflicts with them no longer being on top of fsverity...

Sorry, I was on vacation last week and I've been catching up on things
this week.  I've reset the master branch on my fscrypt.git tree so
that it has what you have on your fscrypt branch, rebased to 5.0-rc3.

Also, as we had talked about earlier, it probably makes sense to set
up jointly maintained git tree for fscrypt and fsverity.  My proposal
is that we set up a new fscrypt.git tree, at
/pub/scm/fs/fscrypt/fscrypt.git, that would be owned by the "FSCRYPT
group", with group membership being ebiggers, jaeguk, and tytso.
We'll have to figure out ways that we can jointly update the git tree
without stepping on each other, probably using a group chat.  Does
that sound good to you?

					- Ted
