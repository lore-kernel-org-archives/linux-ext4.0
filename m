From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: E2fsprogs git tree
Date: Tue, 7 Aug 2007 12:39:56 -0500
Message-ID: <20070807123956.45a36bfa@rx8>
References: <E1I7ukw-0001ht-T0@candygram.thunk.org>
	<46B89C92.5060302@bull.net>
	<20070807172814.GA21522@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:49445 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762259AbXHGRpZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Aug 2007 13:45:25 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l77HjOYU011457
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 13:45:24 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l77HjO3c256394
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 11:45:24 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l77HjNXE002045
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 11:45:24 -0600
In-Reply-To: <20070807172814.GA21522@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 7 Aug 2007 13:28:14 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Aug 07, 2007 at 06:23:46PM +0200, Valerie Clement wrote:
> > Hi Ted,
> > 
> > I tried to clone the source tree but it failed.
> > 
> > The command "git-clone 
> > http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git" failed with : 
> > "error: Could not interpret tags/APPLE_UUID_SNAP_1 as something to
> > pull"
> > 
> > The command "git-clone http://repo.or.cz/r/e2fsprogs.git" failed
> > with: "error: Can't lock ref"
> 
> What version of git are you using?  Make sure you are using something
> which is at least git 1.5.x.

I get the same error as Valerie when using version 1.4.4.2.  The same
version worked a couple of weeks ago when using the http URL.

> 
> BTW, the better URL's to use are:
> 
> git clone git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
> 
> or
> 
> git clone git://repo.or.cz/e2fsprogs.git

This seems to works fine using my older version of git.
 
> The http walkers are *much* more inefficient.  I did try out git-clone
> using the http URL's, and it works, but it's slow.  The other
> possibility is that you have some kind of nasty http transparent proxy
> which is corrupting the http protocol stream.  This is why the git
> transport is seriously the much, much, MUCH better alternative.   
> 
> 
> 					- Ted

-JRS
