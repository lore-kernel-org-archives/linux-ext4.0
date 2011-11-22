From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Support for ext4 hidden quota inodes in quota-tools
Date: Tue, 22 Nov 2011 18:51:53 -0500
Message-ID: <20111122235153.GA5167@thunk.org>
References: <20111122201206.GA5029@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aditya Kali <adityakali@google.com>, adilger@dilger.ca,
	dmonakhov@openvz.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56426 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab1KVXwG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Nov 2011 18:52:06 -0500
Content-Disposition: inline
In-Reply-To: <20111122201206.GA5029@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 22, 2011 at 09:12:06PM +0100, Jan Kara wrote:
> 
>   this is just a heads up that I've modified quota tools to handle
> quota files in hidden inodes for ext4. Current source code can be pulled
> from git repository at sf.net: linuxquota.git.sourceforge.net

Could you give a quick summary of what the functionality the quota
tools will have vis-a-vis the hidden inodes?  I assume things like
repquota will work.  But will quotacheck work?  Quite frankly I'd much
rather it didn't since then it might get confusing since some people
might try to do the evil thing of running quota check on a live file
system, with all of the races that might imply, versus using e2fsck to
check and update the quota files as part of the fsck process.

Also, I had hoped to have the model where quota tracking would be
enabled automatically when the file system was mounted, and there
would not be a way of disabling quota tracking except when the file
system was unmounted, so at least in theory the only way the quota
files could get stale is if the file system was corrupted or modified
directly via tools like e2tools or debugfs.  Presumably we'll be able
to enforce this by having the kernel refuse the quotaoff quotactl
request, but I just want to make sure the overall user experience
between the kernel support, the e2fsprogs support, and the quota tools
all come together in a way that's optimal for the sysadmin who will
need to use all of this stuff.

Cheers,

						- Ted
