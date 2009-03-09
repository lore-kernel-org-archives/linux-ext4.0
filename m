From: Karel Zak <kzak@redhat.com>
Subject: Re: uti-linux-ng libblkid
Date: Mon, 9 Mar 2009 11:42:54 +0100
Message-ID: <20090309104254.GC3278@nb.net.home>
References: <1235410733-4193-1-git-send-email-kzak@redhat.com> <20090309010833.GE5578@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49475 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZCIKnA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 06:43:00 -0400
Content-Disposition: inline
In-Reply-To: <20090309010833.GE5578@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 08, 2009 at 09:08:33PM -0400, Theodore Tso wrote:
> On Mon, Feb 23, 2009 at 06:38:51PM +0100, Karel Zak wrote:
> > Hi Ted,
> > 
> > here are two patches that allow to link utils from e2fsprogs with
> > external libblkid (e.g. the version from util-linux-ng).
> 
> Thanks, I'm starting to play with the builtin fsprobe libraries in
> util-linux-ng right now.  Some quick issues I've found right off the
> bat.  Automake is returning these errors:
> 
> configure.ac:8: required file `config/missing' not found
> configure.ac:8:   `automake --add-missing' can install `missing'

 Did you run ./autogen.sh script? (It outputs versions of all relevant
 autotoos, this output is useful for debuging.)

 Maybe I can prepare a .tar.gz snapshot with generated build-system.

> Also, the configure --help for --with-fsprobe is currently:
> 
>   --with-fsprobe          library to guess filesystems
>                           (builtin|blkid|volume_id), default is blkid
> 
> It would probably clearer if it read:
> 
>   --with-fsprobe=LIB      library to guess filesystems
>                           LIB should be builtin|blkid|volume_id,
> 			  default is blkid

 Good point.

> Also note there have been a couple of blkid fixes that have been made
> to e2fsprogs git tree, I'll look into getting those pushed to you.

 No problem, I'll pull from your tree. I think the missing fixes are
 the latests patches from February only. All older fixes should be
 already in my tree.

 Thanks for your feedback.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
