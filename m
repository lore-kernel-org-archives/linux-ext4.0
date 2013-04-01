From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC V3] ext3: add ioctl to force 32-bit hashes from
 indexed dirs
Date: Mon, 1 Apr 2013 16:00:52 -0400
Message-ID: <20130401200052.GA24097@thunk.org>
References: <51546EED.8030507@redhat.com>
 <5154AAB4.2000701@redhat.com>
 <5159A8D5.1000204@redhat.com>
 <20130401181718.GB22443@thunk.org>
 <5159D03F.5000606@redhat.com>
 <20130401190804.GD22443@thunk.org>
 <5159E4AC.7050307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Anand Avati <avati@redhat.com>, Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57903 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759443Ab3DAUA6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 16:00:58 -0400
Content-Disposition: inline
In-Reply-To: <5159E4AC.7050307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 01, 2013 at 02:49:00PM -0500, Eric Sandeen wrote:
> 
> Urgh, I guess if we are adding an interface which will live "forever,"
> we may as well make it full featured & flexible, as long as the complexity
> isn't out of hand, and I don't think it will be in this case.  So I'm at
> least half inclined to go ahead & allow toggling it on and off under the
> right circumstances, even though it goes against what I think is my better
> judgement.  ;)

If you want to have a fully flexible interface, then we probably
should have a way to both get and set the flag.  And from there the
next step down the slippery slope would be to make this be a bit more
like a fcntl-style F_GETFL/F_SETFL style interface, so we can in the
future set and get other ext4-specific struct_file-specific flags.  :-)

I'll let you decide how far you want to go with this; I won't mind if
you keep it with the original KISS interface, but I also won't mind if
you want to create a somewhat more expansive interface.

Cheers,

						- Ted
