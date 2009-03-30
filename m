From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Sun, 29 Mar 2009 22:22:09 -0500
Message-ID: <49D03AE1.8070009@redhat.com>
References: <200903291928.14451.bzolnier@gmail.com> <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43420 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZC3DWU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Mar 2009 23:22:20 -0400
In-Reply-To: <20090330022521.GB13356@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
>> As long as we keep the call there this is probably good, but after
>> talking w/ Chris Mason, I think the call is extraneous anyway and should
>> probably just be removed...
>>
> 
> Yes, I agree, but it takes a lot of digging to be completely sure of
> that it's safe to remove it.  Interestingly, it was you who added the
> patch which added the call to blkdev_issue_flush():

> commit d755fb384250d6bd7fd18a0930e71965acc8e72e
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Fri Jul 11 19:27:31 2008 -0400


Yes, it was.  Although I got the idea when hch pointed out that SuSE did
this... thanks to Chris.  It's come full circle.  :)

-Eric
