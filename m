From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix configure help text for quota
Date: Thu, 29 Nov 2012 08:55:27 -0500
Message-ID: <20121129135527.GA15535@thunk.org>
References: <50B504C4.6090504@redhat.com>
 <20121129040323.GA8029@thunk.org>
 <50B6F7B6.4050003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35745 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab2K2Nza (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2012 08:55:30 -0500
Content-Disposition: inline
In-Reply-To: <50B6F7B6.4050003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2012 at 11:50:46PM -0600, Eric Sandeen wrote:
> 
> Maybe then rather than fixing up all the configure stuff, I
> should have just removed the switch and turned it on.  Oh well.

I applied the fix to the maint branch (1.42.x).  Yeah, we should
probably remove the switch from the master/next branches.  Also on my
todo list is to rename libquota to something like libinternal, and
then move things like e2fsck/profile.c to libinternal (since we
currently share that code in mke2fs via a pretty ugly ad hoc
mechanisms, and having a static libinternal library would be a cleaner
way of handling things).

						- Ted
