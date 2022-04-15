Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF23DC433EF
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Apr 2022 14:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354607AbiDOOnh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Apr 2022 10:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354601AbiDOOng (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Apr 2022 10:43:36 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E998211C06
        for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2022 07:41:07 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 23FEf3BP030459
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Apr 2022 10:41:03 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4480915C3EAF; Fri, 15 Apr 2022 10:41:03 -0400 (EDT)
Date:   Fri, 15 Apr 2022 10:41:03 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Fariya F <fariya.fatima03@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: df returns incorrect size of partition due to huge overhead
 block count in ext4 partition
Message-ID: <YlmD/605jgGpxA6K@mit.edu>
References: <CACA3K+i8nZRBxeTfdy7Uq5LHAsbZEHTNati7-RRybsj_4ckUyw@mail.gmail.com>
 <Yj4+IqC6FPzEOhcW@mit.edu>
 <CACA3K+hAnJESkkm9q6wHQLHRkML_8D1pMKquqqW7gfLH_QpXng@mail.gmail.com>
 <YkMEtJkiR2Qktq9s@mit.edu>
 <CACA3K+iNFkLLuXJ7W5N70sVC+RVVszx-xVQojNUE8NqfWFuSVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACA3K+iNFkLLuXJ7W5N70sVC+RVVszx-xVQojNUE8NqfWFuSVg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 12, 2022 at 02:26:01PM +0530, Fariya F wrote:
> The e2fsprogs version is 1.42.99. The exact version of df utility when
> I query is 8.25.
> The Linux kernel is 4.9.31. Please note the e2fsprogs ipk file was
> available as part of Arago distribution for the ARM processor I use.
> 
> From your email I understand that below are the options as of now:
> a) Fix in the fsck tool and kernel fix: This is something I am looking
> forward to. Could you please help prioritize it?

Note that the patches that I just posted are against the upstream
kernel, and the 4.9 kernel is quite ancient.  In particular the last
patch in the series, "ext4: update the cached overhead value in the
superblock" is almost certainly guaranteed not to apply to 4.9.31.

Cheers,

					- Ted
