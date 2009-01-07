From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Ext4 without a journal: some benchmark results
Date: Wed, 7 Jan 2009 13:19:07 -0800
Message-ID: <6601abe90901071319k41bd2ac4h1c2dc27ec174a3d0@mail.gmail.com>
References: <6601abe90901071129v3de159d4jcf3b250aac40d0eb@mail.gmail.com>
	 <20090107204739.GC4698@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:11920 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124AbZAGVTl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 16:19:41 -0500
Received: from spaceape11.eur.corp.google.com (spaceape11.eur.corp.google.com [172.28.16.145])
	by smtp-out.google.com with ESMTP id n07LJdAA017362
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 13:19:40 -0800
Received: from bwz8 (bwz8.prod.google.com [10.188.26.8])
	by spaceape11.eur.corp.google.com with ESMTP id n07LJaOE017048
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 13:19:37 -0800
Received: by bwz8 with SMTP id 8so194166bwz.12
        for <linux-ext4@vger.kernel.org>; Wed, 07 Jan 2009 13:19:36 -0800 (PST)
In-Reply-To: <20090107204739.GC4698@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

On Wed, Jan 7, 2009 at 12:47 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Jan 07, 2009 at 11:29:11AM -0800, Curt Wohlgemuth wrote:
>>
>> I ran both iozone and compilebench on the following filesystems, using a
>> 2.6.26-based kernel, with most ext4 patches applied.  This is on a x86 based
>> 4-core system, with a separate disk for these runs.
>
> Curt, thanks for doing these test runs.  One interesting thing to note
> is that even though ext3 was running with barriers disabled, and ext4
> was running with barriers enabled, ext4 still showed consistently
> better resuls.  (Or was this on an LVM/dm setup where barriers were
> getting disabled?)

Nope.  Barriers were enabled for both ext4 versions below.

> A couple of things to note.  If you were testing Frank's patches, I
> made one additional optimization to his patch, which removed the
> orphaned inode handling.  This wasn't necessary if you're running
> without the journal, I'm not sure if this would be measurable in your
> benchmarks, since the inodes that would be getting modified were
> probably going to be dirtied and require writeback anyway, but you
> might get sightly better numbers with the version of the patch I
> ultimately pushed to Linus.

I see the change you pushed; I'll integrate this and see if the
numbers look any different.

> The other thing to note is that in Compilebench's read_tree, ext2 and
> ext3 are scoring better than ext4.  This is probably related to ext4's
> changes in its block/inode allocation hueristics, which is something
> that we probably should look at as part of tuning exercises.  The
> brtfs.boxacle.net benchmarks showed something similar, which I also
> would attribute to changes in ext4's allocation policies.

Can you enlighten me as to what aspect of block allocation might be
involved in the slowdown here?  Which block group these allocations
are made from?  Or something more low-level than that?

Thanks,
Curt
