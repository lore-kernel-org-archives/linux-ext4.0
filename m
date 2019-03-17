Return-Path: <SRS0=DZYj=RU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1260AC43381
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 21:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D22492082F
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 21:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfCQVT1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Mar 2019 17:19:27 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60577 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726936AbfCQVT1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Mar 2019 17:19:27 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2HLJMg1024156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 17 Mar 2019 17:19:23 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A5ABF420AA8; Sun, 17 Mar 2019 17:19:22 -0400 (EDT)
Date:   Sun, 17 Mar 2019 17:19:22 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Burke Harper <go88team@gmail.com>, linux-ext4@vger.kernel.org
Subject: Re: Should Never Happen: Resize Inode Corrupt
Message-ID: <20190317211922.GC23356@mit.edu>
References: <CAB5bDOiUNd_-5FTrCL0vEs_6UUqi=xKkQeH0hWL256i7p=0Kkg@mail.gmail.com>
 <48911DBD-B419-4C61-8F53-6CB41C304985@dilger.ca>
 <CAB5bDOiGPiOmupPepWjNnV7e1xL0wgaA4bY243rfkvSDCanAOA@mail.gmail.com>
 <CB5B81C1-C1C8-4A19-8062-89B2B50C4F65@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CB5B81C1-C1C8-4A19-8062-89B2B50C4F65@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 16, 2019 at 12:57:57PM -0600, Andreas Dilger wrote:
> You could kill e2fsck and disable the resize_inode feature?  There is a different resize mechanism available now (meta_bg) that doesn't need it.

It looks like the file system was previously 36T and you were trying
to resize it to 51T.  Is that right?  The resize_inode feature should
not have been present at all; it's not valid for file systems > 32TiB.

The resize2fs in 1.42 is more than a little bit buggy when dealing
with large file systems > 32TiB, and it sounds like there were some
problems dealing with the transition from file systems smaller than 32
TiB (where the resize_inode still works), and file systems > 32 TiB
(where we use a new style of on-line resizing, called meta_bg.

Hopefully that's because you used an old 1.42 resize2fs when you
resized it up to 36 TiB, but we should test to make sure it's
currently working correctly.

Similarly, e2fsck shouldn't be even trying to deal with the resize
inode if the file system size > 32 TiB.  (Or to be more
accurate/pedantic, when the max. block number no longer fits in a
32-bit integer; although if someone is using a 1k or 2k block file
system on a file system that larger, they have other problems.  :-)

So yeah, the first thing I would use debugfs to clear the resize_inode
feature:

debugfs -w /dev/md0
debugfs: features ^resize_inode
debugfs: clri <7>
debugfs: quit

And then run e2fsck -f /dev/md0.

					- Ted
