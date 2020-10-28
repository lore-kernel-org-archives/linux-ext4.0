Return-Path: <SRS0=4fm1=EE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0B1C388F7
	for <linux-ext4@archiver.kernel.org>; Thu, 29 Oct 2020 02:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 248B32076B
	for <linux-ext4@archiver.kernel.org>; Thu, 29 Oct 2020 02:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgJ1Vd1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:33:27 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56515 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726045AbgJ1VdV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Oct 2020 17:33:21 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 09S3qEcA024296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 23:52:15 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 55ABB420107; Tue, 27 Oct 2020 23:52:14 -0400 (EDT)
Date:   Tue, 27 Oct 2020 23:52:14 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix double locking in
 ext4_fc_commit_dentry_updates()
Message-ID: <20201028035214.GO5691@mit.edu>
References: <20201023161339.1449437-1-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023161339.1449437-1-harshadshirwadkar@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Oct 23, 2020 at 09:13:39AM -0700, Harshad Shirwadkar wrote:
> Fixed double locking of sbi->s_fc_lock in the above function
> as reported by kernel-test-robot.
> 
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

Thanks, applied.

					- Ted
