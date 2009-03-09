From: Theodore Tso <tytso@mit.edu>
Subject: Re: uti-linux-ng libblkid
Date: Sun, 8 Mar 2009 21:08:33 -0400
Message-ID: <20090309010833.GE5578@mit.edu>
References: <1235410733-4193-1-git-send-email-kzak@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44158 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZCIDPn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Mar 2009 23:15:43 -0400
Content-Disposition: inline
In-Reply-To: <1235410733-4193-1-git-send-email-kzak@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 23, 2009 at 06:38:51PM +0100, Karel Zak wrote:
> Hi Ted,
> 
> here are two patches that allow to link utils from e2fsprogs with
> external libblkid (e.g. the version from util-linux-ng).

Thanks, I'm starting to play with the builtin fsprobe libraries in
util-linux-ng right now.  Some quick issues I've found right off the
bat.  Automake is returning these errors:

configure.ac:8: required file `config/missing' not found
configure.ac:8:   `automake --add-missing' can install `missing'
disk-utils/Makefile.am: required file `config/depcomp' not found
disk-utils/Makefile.am:   `automake --add-missing' can install `depcomp'
libs/blkid/src/Makefile.am:17: Libtool library used but `LIBTOOL' is undefined
libs/blkid/src/Makefile.am:17:   The usual way to define `LIBTOOL' is to add `AC_PROG_LIBTOOL'
libs/blkid/src/Makefile.am:17:   to `configure.ac' and run `aclocal' and `autoconf' again.
libs/blkid/src/Makefile.am:17:   If `AC_PROG_LIBTOOL' is in `configure.ac', make sure
libs/blkid/src/Makefile.am:17:   its definition is in aclocal's search path.
libs/blkid/src/probers/Makefile.am:5: Libtool library used but `LIBTOOL' is undefined
libs/blkid/src/probers/Makefile.am:5:   The usual way to define `LIBTOOL' is to add `AC_PROG_LIBTOOL'
libs/blkid/src/probers/Makefile.am:5:   to `configure.ac' and run `aclocal' and `autoconf' again.
libs/blkid/src/probers/Makefile.am:5:   If `AC_PROG_LIBTOOL' is in `configure.ac', make sure
libs/blkid/src/probers/Makefile.am:5:   its definition is in aclocal's search path.

Also, the configure --help for --with-fsprobe is currently:

  --with-fsprobe          library to guess filesystems
                          (builtin|blkid|volume_id), default is blkid

It would probably clearer if it read:

  --with-fsprobe=LIB      library to guess filesystems
                          LIB should be builtin|blkid|volume_id,
			  default is blkid

Also note there have been a couple of blkid fixes that have been made
to e2fsprogs git tree, I'll look into getting those pushed to you.

   	     	       	    	      	      	    - Ted
