From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC V3] ext3: add ioctl to force 32-bit hashes from
 indexed dirs
Date: Mon, 1 Apr 2013 15:08:04 -0400
Message-ID: <20130401190804.GD22443@thunk.org>
References: <51546EED.8030507@redhat.com>
 <5154AAB4.2000701@redhat.com>
 <5159A8D5.1000204@redhat.com>
 <20130401181718.GB22443@thunk.org>
 <5159D03F.5000606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Anand Avati <avati@redhat.com>, Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57889 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759257Ab3DATIJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 15:08:09 -0400
Content-Disposition: inline
In-Reply-To: <5159D03F.5000606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 01, 2013 at 01:21:51PM -0500, Eric Sandeen wrote:
> > This would allow a bit more flexibility than just requiring that the
> > ioctl be issued just after the opendir(), and allow it just after a
> > call to rewinddir().
> 
> I guess I do wonder what real-world use that might have, though.

To be honest, I can't think of one.  And if the presumption is this is
just going to be a special case hack, maybe we shouldn't worry about
the general-use case.

Thinking about this some more, keeping this simple might be better way
to go.  It's not like we really want to be encouraging people to use
this interface....

What do you think?

						- Ted
