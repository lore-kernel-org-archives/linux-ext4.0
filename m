From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 00/25] e2fsprogs: Misc cleanups & fixes
Date: Fri, 16 Sep 2011 19:49:32 -0400
Message-ID: <20110916234932.GZ16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <4E73BF52.4090704@redhat.com>
 <20110916220540.GC16246@thunk.org>
 <4E73CD3D.2060601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54862 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab1IPXte (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 19:49:34 -0400
Content-Disposition: inline
In-Reply-To: <4E73CD3D.2060601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 05:27:09PM -0500, Eric Sandeen wrote:
> 
> sounds like a plan ... though too bad that's One More Thing which
> must be done prior to a 64-bit-capable release :(
> 
> by the way, any plans to put a new -WIP-tagged tarball anywhere?

Sorry, I hadn't gotten around to sending out an announcement yet.
Since kernel.org is down, I've gone back to using the old sourceforge
distribution method:

http://sourceforge.net/projects/e2fsprogs/files/e2fsprogs-TEST/1.42-WIP-0916/

As always, the tarball is GPG-signed, and the git tag is als
GPG-signed, from these two sites:

	git://github.com/tytso/e2fsprogs.git
	git://e2fsprogs.git.sourceforge.net/gitroot/e2fsprogs/e2fsprogs

BTW, I already know that the 0916 release is broken on big-endian
machines.  A Debian developer filed a FTBFS bug in hours.  That's
fixed on the next branch that I'll be pushing out shortly, along with
your patches.

						- Ted

