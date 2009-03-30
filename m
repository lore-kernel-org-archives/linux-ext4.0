From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Sun, 29 Mar 2009 22:25:21 -0400
Message-ID: <20090330022521.GB13356@mit.edu>
References: <200903291928.14451.bzolnier@gmail.com> <49CFB33A.9020406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59633 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZC3CZ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Mar 2009 22:25:27 -0400
Content-Disposition: inline
In-Reply-To: <49CFB33A.9020406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
> 
> As long as we keep the call there this is probably good, but after
> talking w/ Chris Mason, I think the call is extraneous anyway and should
> probably just be removed...
> 

Yes, I agree, but it takes a lot of digging to be completely sure of
that it's safe to remove it.  Interestingly, it was you who added the
patch which added the call to blkdev_issue_flush():

commit d755fb384250d6bd7fd18a0930e71965acc8e72e
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Jul 11 19:27:31 2008 -0400

    ext4: call blkdev_issue_flush on fsync
    
    To ensure that bits are truly on-disk after an fsync,
    we should call blkdev_issue_flush if barriers are supported.
    
    Inspired by an old thread on barriers, by reiserfs & xfs
    which do the same, and by a patch SuSE ships with their kernel
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Mingming Cao <cmm@us.ibm.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

When we remove it we should add a comment noting why it's not
necessary.

						- Ted
