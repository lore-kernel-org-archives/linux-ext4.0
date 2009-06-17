From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: write only core inode in update_path()
Date: Wed, 17 Jun 2009 16:36:30 -0500
Message-ID: <4A3961DE.2050507@redhat.com>
References: <429929.18438.qm@web43515.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: number9652 <number9652@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54182 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZFQVgb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 17:36:31 -0400
In-Reply-To: <429929.18438.qm@web43515.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

number9652 wrote:
>> number9652 wrote:
>>> --- On Wed, 6/17/09, Eric Sandeen wrote: right way to fix it,
>>> however.  I am concerned
>> that I may have
>>> basically broken write_inode_full on any inode with
>> extents.  For
>>> example, there is another call to write_inode_full in
>> extent.c that
>>> might exhibit this same problem.  I think the
>> right fix would be to
>>> return to reading the full inode into memory in the
>> extent_open
>> 
>> If this is the case (that it's broken now), then we really need 
>> something in the regression suite to catch it - all tests pass in
>> 1.41.6 ....
>> 
>> -Eric
>> 
> I was too general in my statement above about what it broke.  I think
> (didn't test) if a program follows this path: 
> extent_open(...,*handle) write_inode_full(...,handle->inode,...) that
> it will read uninitialized memory in write_inode_full.  It seems
> clear that all previously written code assumes that this path is
> valid, and fixing all that to not assume that would seemingly be much
> more than just what your patch fixes and require more time to test.
> If you only use read/write_inode_full, everything is still okay.
> 
> I think that in this case, even when only using the handle to read
> the inode, we want to have the full inode available (by
> handle->inode) so it is possible (for example) to check the file
> creation time with the returned handle structure.

Seems reasonable to me ...

FWIW, I have Yet Another Case where resize is corrupting the larger
inode, even with this fix and/or my fix.

Still digging into it, sigh.

-Eric
