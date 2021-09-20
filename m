Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054C0C433F5
	for <linux-ext4@archiver.kernel.org>; Mon, 20 Sep 2021 02:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D136260F4A
	for <linux-ext4@archiver.kernel.org>; Mon, 20 Sep 2021 02:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhITCmJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 19 Sep 2021 22:42:09 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42029 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231642AbhITCmJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Sep 2021 22:42:09 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 18K2ecGo029501
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Sep 2021 22:40:39 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8FF4915C3752; Sun, 19 Sep 2021 22:40:38 -0400 (EDT)
Date:   Sun, 19 Sep 2021 22:40:38 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Richard W.M. Jones" <rjones@redhat.com>
Cc:     Eric Blake <eblake@redhat.com>, linux-ext4@vger.kernel.org,
        libguestfs@redhat.com
Subject: Re: e2fsprogs concurrency questions
Message-ID: <YUf0plXwP/WZ7YJJ@mit.edu>
References: <20210917210655.sjrqvd3r73gwclti@redhat.com>
 <YUazQg9TtlZZm10H@mit.edu>
 <20210919123523.GA15475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919123523.GA15475@redhat.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Sep 19, 2021 at 01:35:23PM +0100, Richard W.M. Jones wrote:
> Are there structures shared between ext2_fs handles?

Sadly, no.


> I mean, if we had two concurrent threads using different ext2_fs
> handles, but open on the same file, is that going to be a problem?
> (It sounds like it would be, with conflicting access to the block
> allocation bitmap and so on.)

Yes, there's going to be a problem.

If you have two separate ext2fs_fs handles (each opened via a separate
call to ext2fs_open), they will not share any structures, nor is there
any locking for any of the data structures.  So that means you could
use a single ext2s_fs handle, and share it across threads --- but you
need to make sure that only one thread is using the handle at a time,
and you can't have two file handles open to the same inode, or read an
inode twice, and then modify one, write it back, and expect the other
inode will magically be updated --- because they won't be.

Fundamentally, libext2fs was not designed for concurrent operation.

I suppose you could use fuse2fs, and then having the clients access
the file system via the FUSE interface.  That might be more efficient.

    	 	    	     		 - Ted

