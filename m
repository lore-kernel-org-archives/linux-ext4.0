From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fsck memory usage
Date: Thu, 18 Apr 2013 12:34:55 -0600
Message-ID: <968AF3AB-582F-4874-9689-FF5121DBB285@dilger.ca>
References: <CAEUQceh3Wm6LZpGQnXNjh0c9WbO8S70D5-KYjY8anup80WbLHQ@mail.gmail.com> <20130417230745.GC5401@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Subranshu Patel <spatel.ml@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48500 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3DRSe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2013 14:34:57 -0400
Received: by mail-pa0-f41.google.com with SMTP id kx1so1781422pab.0
        for <linux-ext4@vger.kernel.org>; Thu, 18 Apr 2013 11:34:57 -0700 (PDT)
In-Reply-To: <20130417230745.GC5401@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-04-17, at 5:07 PM, Theodore Ts'o wrote:
> On Wed, Apr 17, 2013 at 08:40:08PM +0530, Subranshu Patel wrote:
>> I performed some recovery (fsck) tests with large EXT4 filesystem.
>> The filesystem size was 500GB (3 million files, 5000 directories).
>> Performed force recovery on the clean filesystem and measured the
>> memory usage, which was around 2 GB.
>> 
>> Then I performed metadata corruption - 10% of the files, 10% of the
>> directories and some superblock attributes using debugfs. Then I
>> executed fsck to find a memory usage of around 8GB, a much larger
>> value.
> 
> It's going to depend on what sort of metadata corruption was
> suffered.  If you need to do pass 1b/c/d fix ups, it will need more
> memory.  That's pretty much unavoidable, but it's also not the
> common case.  In most use cases, if those cases require using swap,
> that's generally OK if it's the rare case, and not the common case.
> That's why it's not something I've really been worried about.

This is also where the "inode badness" patch would potentially help
out to avoid even trying to fix inodes that are random garbage, and
as a result the duplicate block processing would be skipped.

http://git.whamcloud.com/?p=tools/e2fsprogs.git;a=commitdiff;h=c17983c570d4fd87e628dd4fdf12d232cfd00694

I was just discussing this patch today, but unfortunately I don't
think the rewrite of that patch will happen any time soon.  Is there
any chance that the existing patch could be landed?  The original
objection to this patch was that it should centralize all of the
inode checks into a single location, but is there a chance to land
it as is?  I don't think the current changes in the patch are so bad
to mark the inode bad at the same locations that call fix_problem().

Cheers, Andreas


>> 2. This question is not related to this EXT4 mailing list. But in
>> real scenario how this kind of situation (large memory usage) is
>> handled in large scale filesystem deployment when actual filesystem
>> corruption occurs (may be due to some fault in hardware/controller)
> 
> What's your use case where you are memory constrained?  Is it a
> bookshelf NAS configuration?  Are you hooking up large number of
> disks to a memory-constrained server and then trying to run fsck
> in parallel across a large number of 3TB or 4TB disks?  Depending
> on what you are trying to do, there may be different solutions.
> 
> In general ext4 has always assumed at least a "reasonable" amount
> of memory for a large amount of storage, but it's understood that
> reasonable has changed over the years.  So there have been some
> improvements that we've made more recently, but it may or may not
> be good enough for your use case.  Can you give us more details
> about what your requirements are?



Cheers, Andreas





