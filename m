From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: enable acls and user_xattr by default
Date: Thu, 24 Feb 2011 12:49:14 +0100
Message-ID: <20110224114914.GD23042@quack.suse.cz>
References: <4D5ED705.7010902@redhat.com>
 <20110221134642.GC6584@quack.suse.cz>
 <4D629C78.60600@redhat.com>
 <20110223173152.GM2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44438 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1BXLt0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 06:49:26 -0500
Content-Disposition: inline
In-Reply-To: <20110223173152.GM2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 23-02-11 12:31:52, Ted Ts'o wrote:
> On Mon, Feb 21, 2011 at 11:10:16AM -0600, Eric Sandeen wrote:
> > 
> > Well, I did this initially because Ted & Andreas seemed to want it ;)
> > 
> > I think the idea is, we should move to deprecating and removing the options
> > altogether.  Is there any advantage to having them?  And the first step
> > to deprecating them might be to change the default.
> 
> Yeah, part of the whole goal is to reduce the number of mount options,
> since they have really gotten out of control.  Each mount option is
> another adds more to the test combinatorics nightmare.
  Yes, I definitely agree with this.

> So basically, the question is how much value does the mount option
> add?  In fact changing acl's on and off can in fact cause surprises,
> since the posix acl's are designed to be safe when going from the
> noacl->acl case.  That is, the additional information in the posix
> acl's are designed to take away rights, but not add access rights.
  I agree it may cause surprises although it's not true that ACL's remove
rights. Rather on contrary ACL's can only give additional rights (i.e. you
have 600 file + user foo can also read it) thus noacl->acl transition might
be insecure if you have some old unwanted ACL's pending.

> But that also means that if you have a file system that had ACL's to
> restrict access rights, and then you mount it without using the acl
> option, users who aren't supposed to have access to the file might
> find themselves with access.
  As I write above it's the other way around but that's not a point I would
be afraid about. It's more that admins might run without user_xattr and
ACL's e.g. because their arguably stupid audit app is not able to handle
them properly. Suddenly they become enabled because of the kernel change,
users, can set them, and later the admin finds things are broken. So I'd
at least warn that the default is changing if (no)acl,(no)user_xattr
options are not used during mount.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
