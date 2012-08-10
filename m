From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add max_dir_size_kb mount option
Date: Fri, 10 Aug 2012 17:58:11 -0400
Message-ID: <20120810215811.GA1137@thunk.org>
References: <1344626638-31548-1-git-send-email-tytso@mit.edu>
 <x49r4repkwj.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44057 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758991Ab2HJV6P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Aug 2012 17:58:15 -0400
Content-Disposition: inline
In-Reply-To: <x49r4repkwj.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 10, 2012 at 04:11:24PM -0400, Jeff Moyer wrote:
> 
> I have no idea what a reasonable number for this would be.  Can you
> provide guidelines that would help admins understand what factors
> influence performance degradation due to directory size?

Well, for example, if you have a job which is a 512mb memory
container, and the directory has grown to 176mb, an attempt to readdir
said directory will cause that job to thrash badly, and perhaps get
killed by the OOM killer.  If you know that no sane directory should
ever grow beyond a single megabyte, you might pick a max_dir_size_kb
of 1024.

> Finally, I don't pretend to understand how your mount option parsing
> routines work, but based on what I see in this patch it looks like the
> default will be set to and enforced as 0.  What am I missing?

Sorry, I sent out the wrong version of the patch.  The limit was only
supposed to be used if maximum directory size is greater than 0; that
is, the default is that the directory size is unlimited, as before.
I'll send out a revised v2 version of the patch.

I view this as a very specialized option, but if you're running in a
tightly constrained memory cgroup, or a tiny EC2 instance, or the
equivalent Cloud Open VM, it might be a very useful thing to be able
to cap.

Regards,

						- Ted
