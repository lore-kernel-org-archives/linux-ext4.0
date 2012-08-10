From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add max_dir_size_kb mount option
Date: Fri, 10 Aug 2012 15:59:07 -0400
Message-ID: <20120810195907.GA557@thunk.org>
References: <1344626638-31548-1-git-send-email-tytso@mit.edu>
 <50256322.9040409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44046 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab2HJT7K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Aug 2012 15:59:10 -0400
Content-Disposition: inline
In-Reply-To: <50256322.9040409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 10, 2012 at 02:38:10PM -0500, Eric Sandeen wrote:
> 
> Can the commit message also describe more about the problem: how bad
> it is, the root cause, and why it's so hard to fix properly?

The use case is going to be fairly userspace specific, but one example
might be if the log reaper fails to run for whatever reason, and the
log directory then proceeds to grow without bound.  And then when the
log repear *does* have a chance to run, if it happens to be in tight
memory cgroup, it then dies so the directory grows even larger, and
then when other processes try to access the directory, a readdir will
cause them to die because of their memory limitation, and hilarity
ensues.

You can fix this in other places in the software stack, but belt and
suspenders is good, and if there is no reason for directories to grow
larger than some set size, it's better to get a hard failure with an
ENOSPC rather than an funny failures caused by OOM's or slower and
slower performance.

> Please also update Documentation/filesystems/ext4.txt so people
> know for sure what the use & intent of this new knob is.

Yes, I'll do that in the next spin of the patches.

     	     	     	      	      - Ted
