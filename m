From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in	ext4_statfs()
Date: Sun, 08 Nov 2009 16:09:40 -0600
Message-ID: <4AF741A4.9060907@redhat.com>
References: <4AF4A429.7090507@redhat.com> <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com> <20091108214804.GC7592@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370AbZKHWJl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Nov 2009 17:09:41 -0500
In-Reply-To: <20091108214804.GC7592@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Nov 06, 2009 at 05:26:51PM -0700, Andreas Dilger wrote:
>> If the choice is between adding a proper transaction here, or not
>> doing this at all, I'd rather just not do it at all.  Of course, I'd
>> like to work out some kind of compromise, like only updating the
>> superblock when there is already a shadow BH that is being used to
>> write to the journal, or similar.
> 
> In practice, the superblock is never going to modified in normal
> operations, unless a resize happens to be happening.  Since we already
> force the superblock summary counters to be correct during an unmount
> or file system freeze, we really only need this so that it's correct
> after a file system crash.
> 
> I don't think people generally end up calling statfs() all that
> frequently, so it's not clear how much adding a 30 second throttle
> would help.  Maybe we should just not bother trying to update the
> superblock at all on a statfs()?

for now maybe that's better....

But don't we journal the superblock sometimes, not others ... for 
example write_super -> ext4_write_super -> ext4_commit_super does no 
journaling of superblock modifications. ext4_orphan_add, however, does. 
  This would likely lead to trouble w/ the debugging patch ... though I 
didn't see it ... ?

So I was premature w/ this patch, I think.

Maybe we could unconditionally do the copy-out in 
jbd2_journal_write_metadata_buffer() ...?

-Eric

> Hmm...
> 
> 						- Ted

