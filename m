Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DAFC4361B
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Dec 2020 15:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0770723975
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Dec 2020 15:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgLQP5Y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Dec 2020 10:57:24 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56203 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726488AbgLQP5V (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Dec 2020 10:57:21 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BHFuU3h011911
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:56:31 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 74268420280; Thu, 17 Dec 2020 10:56:30 -0500 (EST)
Date:   Thu, 17 Dec 2020 10:56:30 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org,
        harshad shirwadkar <harshadshirwadkar@gmail.com>
Subject: Re: [PATCH 3/8] ext4: Protect superblock modifications with a buffer
 lock
Message-ID: <X9t/rpL3HQb4+ecl@mit.edu>
References: <20201216101844.22917-1-jack@suse.cz>
 <20201216101844.22917-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216101844.22917-4-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Dec 16, 2020 at 11:18:39AM +0100, Jan Kara wrote:
> Protect all superblock modifications (including checksum computation)
> with a superblock buffer lock. That way we are sure computed checksum
> matches current superblock contents (a mismatch could cause checksum
> failures in nojournal mode or if an unjournalled superblock update races
> with a journalled one). Also we avoid modifying superblock contents
> while it is being written out (which can cause DIF/DIX failures if we
> are running in nojournal mode).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
