From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= <flvazquez@uvigo.es>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Mon, 30 Mar 2009 22:01:16 +0900
Message-ID: <49D0C29C.1060307@uvigo.es>
References: <200903291928.14451.bzolnier@gmail.com>	 <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu>	 <49D03AE1.8070009@redhat.com> <1238413667.30488.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:54810 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZC3NBV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 09:01:21 -0400
In-Reply-To: <1238413667.30488.2.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chris Mason wrote:
> On Sun, 2009-03-29 at 22:22 -0500, Eric Sandeen wrote:
>> Theodore Tso wrote:
>>> On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
>>>> As long as we keep the call there this is probably good, but after
>>>> talking w/ Chris Mason, I think the call is extraneous anyway and should
>>>> probably just be removed...
>>>>
>>> Yes, I agree, but it takes a lot of digging to be completely sure of
>>> that it's safe to remove it.  Interestingly, it was you who added the
>>> patch which added the call to blkdev_issue_flush():
>>> commit d755fb384250d6bd7fd18a0930e71965acc8e72e
>>> Author: Eric Sandeen <sandeen@redhat.com>
>>> Date:   Fri Jul 11 19:27:31 2008 -0400
>>
>> Yes, it was.  Although I got the idea when hch pointed out that SuSE did
>> this... thanks to Chris.  It's come full circle.  :)
> 
> Grin.  I'm not sure the I_DIRTY checks alone are enough to decide that a
> commit is required though.  I think the inode could be clean but still
> have metadata that needs commit.

Chris, I have just sent patches that attempt to fix both ext3 and
ext4 while also adding a per-device sysfs knob tu disable
write-flushes. A previous version of this patch set added a new
generic mount option but comments from Christoph and others
convinced me to turn it into a per-device tunable. Could you take
a look at the patches?

Bartlomiej, I have just noticed that I happened to be working on
patches for reiserfs and xfs similar to the ones you sent earlier
this week. I picked some bits from your submission so I took the
liberty to add your signed-off to my patches. Could you take a
look at them and let me know if you are confortable with that?

Latest patches: http://lkml.org/lkml/2009/3/30/100
Beginning of the sub-thread: http://lkml.org/lkml/2009/3/29/28

Best regards,

Fernando
