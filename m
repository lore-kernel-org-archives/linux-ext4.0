Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E6CC282DC
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83067213A2
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfDGCN5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 6 Apr 2019 22:13:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49749 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726184AbfDGCN5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Apr 2019 22:13:57 -0400
Received: from callcc.thunk.org (225.sub-174-209-4.myvzw.com [174.209.4.225])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x372Dlnj018862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Apr 2019 22:13:50 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id EB00E421A1E; Sat,  6 Apr 2019 19:27:17 -0400 (EDT)
Date:   Sat, 6 Apr 2019 19:27:17 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190406232717.GH18897@mit.edu>
References: <20190401070001.GJ1173@magnolia>
 <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402045519.GK1173@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 01, 2019 at 09:55:19PM -0700, Darrick J. Wong wrote:
> 
> When Ted is done laughing, I really would like to consider something
> like this to solve the problem of grub-style bootloaders requiring a
> lease on the blocks underneath a file with a term exceeding that of the
> running kernel.
> 
> We can probably skip the harsh synchronous writes in favor of fsync on
> close, but we would need to keep the critical component of checkpointing
> the journal on fsync and syncfs.

At least for ext4, we don't need to add anything new, since FIFREEZE
force a journal checkpoint.  So we could try to get a patch into grub
which causes update_grub to open each kernel that it finds, and calls
fsync(2) on it, and then for all file systems where it finds a kernel,
it can call FIFREEZE and FITHAW on it, and that would be that.

That's not guaranteed to work for all file systems, of course.  So the
right answer may be to define a new IOCTL which causes all file system
to do whatever log truncation is needed so that grub will do the right
thing.

					- Ted
