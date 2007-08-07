From: Theodore Tso <tytso@mit.edu>
Subject: Re: E2fsprogs git tree
Date: Tue, 7 Aug 2007 13:28:14 -0400
Message-ID: <20070807172814.GA21522@thunk.org>
References: <E1I7ukw-0001ht-T0@candygram.thunk.org> <46B89C92.5060302@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38781 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbXHGR2Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Aug 2007 13:28:24 -0400
Content-Disposition: inline
In-Reply-To: <46B89C92.5060302@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 07, 2007 at 06:23:46PM +0200, Valerie Clement wrote:
> Hi Ted,
> 
> I tried to clone the source tree but it failed.
> 
> The command "git-clone 
> http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git" failed with : 
> "error: Could not interpret tags/APPLE_UUID_SNAP_1 as something to pull"
> 
> The command "git-clone http://repo.or.cz/r/e2fsprogs.git" failed with: 
> "error: Can't lock ref"

What version of git are you using?  Make sure you are using something
which is at least git 1.5.x.

BTW, the better URL's to use are:

git clone git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

or

git clone git://repo.or.cz/e2fsprogs.git

The http walkers are *much* more inefficient.  I did try out git-clone
using the http URL's, and it works, but it's slow.  The other
possibility is that you have some kind of nasty http transparent proxy
which is corrupting the http protocol stream.  This is why the git
transport is seriously the much, much, MUCH better alternative.   


					- Ted
