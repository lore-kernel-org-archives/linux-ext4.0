From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: enable acls and user_xattr by default
Date: Wed, 23 Feb 2011 12:31:52 -0500
Message-ID: <20110223173152.GM2924@thunk.org>
References: <4D5ED705.7010902@redhat.com>
 <20110221134642.GC6584@quack.suse.cz>
 <4D629C78.60600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50631 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab1BWRb7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 12:31:59 -0500
Content-Disposition: inline
In-Reply-To: <4D629C78.60600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 21, 2011 at 11:10:16AM -0600, Eric Sandeen wrote:
> 
> Well, I did this initially because Ted & Andreas seemed to want it ;)
> 
> I think the idea is, we should move to deprecating and removing the options
> altogether.  Is there any advantage to having them?  And the first step
> to deprecating them might be to change the default.

Yeah, part of the whole goal is to reduce the number of mount options,
since they have really gotten out of control.  Each mount option is
another adds more to the test combinatorics nightmare.

So basically, the question is how much value does the mount option
add?  In fact changing acl's on and off can in fact cause surprises,
since the posix acl's are designed to be safe when going from the
noacl->acl case.  That is, the additional information in the posix
acl's are designed to take away rights, but not add access rights.
But that also means that if you have a file system that had ACL's to
restrict access rights, and then you mount it without using the acl
option, users who aren't supposed to have access to the file might
find themselves with access.

So changing things to have acl's on by default just seems to make
sense....

						- Ted
