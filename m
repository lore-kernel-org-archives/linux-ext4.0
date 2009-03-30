From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Mon, 30 Mar 2009 07:47:47 -0400
Message-ID: <1238413667.30488.2.camel@think.oraclecorp.com>
References: <200903291928.14451.bzolnier@gmail.com>
	 <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu>
	 <49D03AE1.8070009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:32367 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZC3LsO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 07:48:14 -0400
In-Reply-To: <49D03AE1.8070009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2009-03-29 at 22:22 -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
> >> As long as we keep the call there this is probably good, but after
> >> talking w/ Chris Mason, I think the call is extraneous anyway and should
> >> probably just be removed...
> >>
> > 
> > Yes, I agree, but it takes a lot of digging to be completely sure of
> > that it's safe to remove it.  Interestingly, it was you who added the
> > patch which added the call to blkdev_issue_flush():
> 
> > commit d755fb384250d6bd7fd18a0930e71965acc8e72e
> > Author: Eric Sandeen <sandeen@redhat.com>
> > Date:   Fri Jul 11 19:27:31 2008 -0400
> 
> 
> Yes, it was.  Although I got the idea when hch pointed out that SuSE did
> this... thanks to Chris.  It's come full circle.  :)

Grin.  I'm not sure the I_DIRTY checks alone are enough to decide that a
commit is required though.  I think the inode could be clean but still
have metadata that needs commit.

-chris


