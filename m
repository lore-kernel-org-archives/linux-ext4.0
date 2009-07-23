From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Thu, 23 Jul 2009 09:27:02 -0700
Message-ID: <1248366422.27509.1.camel@bobble.smo.corp.google.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
	 <4A64F37D.7020803@redhat.com>
	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
	 <20090721215421.GM4231@webber.adilger.int>
	 <1248304214.14463.17.camel@bobble.smo.corp.google.com>
	 <4A67D36D.20708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:58271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZGWQ2Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 12:28:16 -0400
In-Reply-To: <4A67D36D.20708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-07-22 at 22:05 -0500, Eric Sandeen wrote:
> Frank Mayhar wrote:
> > On Tue, 2009-07-21 at 15:54 -0600, Andreas Dilger wrote:
> 
> ...
> 
> >> That said, we might need to have some kind of flag in the on-disk
> >> inode to indicate that it was preallocated beyond EOF.  Otherwise,
> >> e2fsck will try and extend the file size to match the block count,
> >> which isn't correct.  We could also use this flag to determine if
> >> truncate needs to be run on the inode even if the new size is the
> >> same.
> > 
> > After chatting with Curt about this today, it sounds like this needs two
> > things.  One is your flag in the on-disk inode, set in fallocate() to
> > indicate that it has an allocation past EOF.  E2fsck would use this to
> > avoid "fixing" the file size to match the block count.  Truncate would
> > use this to notice that there are blocks allocated past i_size and get
> > rid of them.  It would be cleared by truncate or by ext4_get_blocks when
> > using the last block of such an allocation.
> > 
> > Does this make sense?  Have I missed anything?
> 
> I guess I'm not totally sold on the new on-disk flag; we can work out
> blocks past EOF w/o needing a new flag can't we?

It's on-disk because e2fsck needs it to know when not to extend i_size
to the actual allocated length of the file.  Were it not for that we
could easily solve the fallocate/trucate problem with an in-memory flag
only.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

