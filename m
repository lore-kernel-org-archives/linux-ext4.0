From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: ext5
Date: Thu, 11 Feb 2010 22:41:41 +0100
Message-ID: <874olnih62.fsf@frosties.localdomain>
References: <20100210215028.GD739@thunk.org> <4B73931D.5000302@cox.net>
	<20100211064433.GF739@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ron Johnson <ron.l.johnson@cox.net>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:53297 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab0BKVln (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2010 16:41:43 -0500
In-Reply-To: <20100211064433.GF739@thunk.org> (tytso@mit.edu's message of
	"Thu, 11 Feb 2010 01:44:33 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Wed, Feb 10, 2010 at 11:18:21PM -0600, Ron Johnson wrote:
>> >We currently don't have any plans for an "ext5".  There might be some
>> >new features that might gradually trickle into ext4; for example
>> >there's someone who I may be mentoring who is interested in working on
>> >an idea I've had to add read-only compression to ext4.  (Actually, the
>> >design I've sketched out makes 90% of the work be file system
>> >independent, so it's something that could be retrofitted into other
>> >filesystems: xfs, btrfs, etc.)
>> 
>> I guess that means every file on the fs?
>
> No, I mean per-file compression, but a compressed file is immutable.
> This is basically what Mac OS X has recently added, and while I
> haven't looked at their implementation, Apple being one of those
> closed source companies and all, I wouldn't be surprised if they did
> things the same way.

Do that with fuse or like ecryptfs. That is nothing that needs to be
inside any FS and is far better to have as layer on top of the fs of
your choice.

>> Windows-like per-file compression would be darned useful in certain
>> circumstances.  Big mbox files, for example.
>
> The problem with mbox files is that some mail readers try to smart
> about how they modify them to avoid needing to rewrite the whole mbox
> file; mutt will seak to the middle of the file, write to the end of
> the file, and then trim off any excess space by using the truncate
> system call.  This is *hard* to support if the mbox file is
> compressed; you can do it using a stacker-style compression technique,
> but it's not as efficient, and it has a lot of complexity in the
> kernel.

You need a block based compression for that so that you can recompress
and replace blocks in any order. It also helps if you can have the
compressed blocks in random order so that you can put the block at the
end and zero fill the old location when it grows during recompression.

Otherwise you will be moving the compressed data around a lot to
accomodate changes in the middle of a file.

> The idea with read-only compressed files is that they are useful for
> large executables or large static files, where compressing them means
> that it takes less time to read them off of an HDD.

Or when you only have so much flash.

MfG
        Goswin
