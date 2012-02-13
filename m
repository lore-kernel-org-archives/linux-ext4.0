From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [SOLVED] (was "Re: Restoring filenames from partly damaged
 ext4-filesystem")
Date: Mon, 13 Feb 2012 10:51:46 -0500
Message-ID: <20120213155146.GA17061@thunk.org>
References: <6D9A985A8374004AA880FD5D70B2D3C449AE04494A@ABGEX73E.FSC.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Maar, Roberto" <roberto.maar@ts.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47298 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab2BMPvt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 10:51:49 -0500
Content-Disposition: inline
In-Reply-To: <6D9A985A8374004AA880FD5D70B2D3C449AE04494A@ABGEX73E.FSC.NET>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 13, 2012 at 11:00:21AM +0100, Maar, Roberto wrote:
> Everyone has a good backup, and no one destroy its files and file systems.

If only that were true.  :-)

Of course the developers who can do a good job writing recovery
programs are smart enough to do regular backups.  This is why tools
like extundelete and ext4magic generally don't get a lot of volunteers
to help with documentation and development.

But you'd be amazed how many people contact me, or the ext4 list, or
the ext3-users list, asking for help, and who obviously had _not_ been
doing regular backups.  :-(

> 
> One of the problems of ext4magic, of course, no English documentation.
> But at the moment is the one man show, and my English is a disaster. 
> The world would laugh at it. I need some help for translation. 
> Proofread, for a native speaker with technical understanding a few minutes work,
> for me ...
> We'll see, I try

Well, I can certainly call for help, and see if there are folks who
would be interested in helping you with the translation and
creating/improving the English documentation

And now that I know about it, I'll certainly be pointing people at it.

Thanks for creating it!

						- Ted
