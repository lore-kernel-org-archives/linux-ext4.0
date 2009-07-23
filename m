From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Wed, 22 Jul 2009 22:05:17 -0500
Message-ID: <4A67D36D.20708@redhat.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>	 <4A64F37D.7020803@redhat.com>	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>	 <20090721215421.GM4231@webber.adilger.int> <1248304214.14463.17.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZGWDFW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2009 23:05:22 -0400
In-Reply-To: <1248304214.14463.17.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank Mayhar wrote:
> On Tue, 2009-07-21 at 15:54 -0600, Andreas Dilger wrote:

...

>> That said, we might need to have some kind of flag in the on-disk
>> inode to indicate that it was preallocated beyond EOF.  Otherwise,
>> e2fsck will try and extend the file size to match the block count,
>> which isn't correct.  We could also use this flag to determine if
>> truncate needs to be run on the inode even if the new size is the
>> same.
> 
> After chatting with Curt about this today, it sounds like this needs two
> things.  One is your flag in the on-disk inode, set in fallocate() to
> indicate that it has an allocation past EOF.  E2fsck would use this to
> avoid "fixing" the file size to match the block count.  Truncate would
> use this to notice that there are blocks allocated past i_size and get
> rid of them.  It would be cleared by truncate or by ext4_get_blocks when
> using the last block of such an allocation.
> 
> Does this make sense?  Have I missed anything?

I guess I'm not totally sold on the new on-disk flag; we can work out
blocks past EOF w/o needing a new flag can't we?

-eric
