Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630F1C4361B
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Dec 2020 05:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0974E23124
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Dec 2020 05:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725275AbgLPFCX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 16 Dec 2020 00:02:23 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38583 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725274AbgLPFCX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Dec 2020 00:02:23 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BG51Y5l026759
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 00:01:34 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0108F420280; Wed, 16 Dec 2020 00:01:33 -0500 (EST)
Date:   Wed, 16 Dec 2020 00:01:33 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 02/12] ext4: Remove redundant sb checksum recomputation
Message-ID: <X9mUrezG8HEYWq9K@mit.edu>
References: <20201127113405.26867-1-jack@suse.cz>
 <20201127113405.26867-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127113405.26867-3-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Nov 27, 2020 at 12:33:55PM +0100, Jan Kara wrote:
> Superblock is written out either through ext4_commit_super() or through
> ext4_handle_dirty_super(). In both cases we recompute the checksum so it
> is not necessary to recompute it after updating superblock free inodes &
> blocks counters.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
