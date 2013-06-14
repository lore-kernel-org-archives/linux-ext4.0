From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: /dev/disk/by-label missing after upgrade to 1.42.7
Date: Thu, 13 Jun 2013 21:26:00 -0400
Message-ID: <20130614012600.GA3220@thunk.org>
References: <CADzUK1+bAEXgXag+frRJBBH8A0rgbu-YUHOp0KG9jNJ_a0OG2A@mail.gmail.com>
 <CADzUK1+D2NJ3WC4jz-HKHQGyF7GGKGytLnA=bvGHsL5iNa-hMw@mail.gmail.com>
 <51BA3B3B.9090508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Autif Khan <autif.mlist@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57828 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab3FNB0J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Jun 2013 21:26:09 -0400
Content-Disposition: inline
In-Reply-To: <51BA3B3B.9090508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 13, 2013 at 04:35:55PM -0500, Eric Sandeen wrote:
 
> ubuntu isn't using blkid from util-linux?

Ubuntu and Debian does use blkid from util-linux.  I'm guessing Autif
compiled e2fsprogs by hand.

For the record, what I recommend for people who are using debian or
Ubuntu systems (of whatever vintage) is:

tar xvfz e2fsprogs-1.42.7.tar.gz
cd e2fsprogs-1.42.7
./debian/rules
fakeroot dpkg-buildpackage

This will build .deb packages that are suitable for whatever version
of Debian or Ubuntu (including really ancient ones before blkid was
moved to util-linux) you happen to be using.

> That's really where it's maintained these days, a little surprised that
> blkid's still in use from e2fsprogs, though I don't know my ubuntu
> releases.  Maybe this is Crufty Crow?  ;)
> 
> Fedora has been building w/ --disable-libblkid for quite a while,
> just FWIW.

I plan to change the default for libblkid before I release 1.43.

      	     	       	   	       - Ted
