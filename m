Return-Path: <SRS0=ZSF4=YJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C34ECE599
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Oct 2019 21:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 028152168B
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Oct 2019 21:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbfJPVhA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 16 Oct 2019 17:37:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39591 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729033AbfJPVhA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Oct 2019 17:37:00 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9GLauvJ005521
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 17:36:57 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C9B30420458; Wed, 16 Oct 2019 17:36:55 -0400 (EDT)
Date:   Wed, 16 Oct 2019 17:36:55 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 08/13] ext4: fast-commit commit range tracking
Message-ID: <20191016213655.GH11103@mit.edu>
References: <20191001074101.256523-1-harshadshirwadkar@gmail.com>
 <20191001074101.256523-9-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191001074101.256523-9-harshadshirwadkar@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Oct 01, 2019 at 12:40:57AM -0700, Harshad Shirwadkar wrote:
> With this patch, we track logical range of file offsets that need to
> be committed using fast commit. This allows us to find file extents
> that need to be committed during the commit time.

We don't actually need to track when data is modified in the page
cache, which is what this commit is actually doing.  We only need to
track newly allocated blocks, at granularity of the logical block
number.

That's because we only need to force out newly allocated blocks to
make sure we don't reveal stale data when we are in data=ordered mode.
And it also follows that we don't need to track logical block ranges
and submit inode data in data=writeback or data=journalled mode.

In the case where the user has actually called fsync() on the the
inode, we do a data integrity writeback in ext4_sync_file, and that's
independent on the fast commit code.

But if the file is being modified using buffered writes, or if an
already allocated block is changed, and the file has *not* been
changed, we don't need to write out those blocks on a fast commit.
For example, in the case where we are the fast commit is being
initiated via ext4_nfs_commit_metadata() -> ext4_write_inode(), we
only care about submitting data for the newly allocated blocks.  And
that's what we want to track here.

Hence, all of the callers of ext4_fc_update_commit_range() here are in
the wrong place.  (Also, they are calling ext4_fc_update_commit_range
with byte offsets, when the function is expecting logical block
numbers, but that really matter, since the existing call sites need to
be all removed and replaced with new ones in ext4_map_blocks().

       	       	   	    	     - Ted
