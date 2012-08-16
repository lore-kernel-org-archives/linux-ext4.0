From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: libcom_err DSO version bump needed for 1.42?
Date: Wed, 15 Aug 2012 21:47:35 -0400
Message-ID: <20120816014735.GA3781@thunk.org>
References: <k0h5eu$f6u$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44903 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab2HPBrq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Aug 2012 21:47:46 -0400
Content-Disposition: inline
In-Reply-To: <k0h5eu$f6u$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 15, 2012 at 05:48:12PM -0400, Brian J. Murrell wrote:
> I noticed when trying to upgrade my e2fsprogs RPM set from a 1.41.12ish
> release to a 1.42.3ish release only e2fsprogs and e2fsprogs-libs got
> upgraded and libcom_err didn't get upgraded despite there being ABI
> differences between 1.41.12 and 1.42.3.  This results in the following
> type of error:
> 
> # e2fsck
> e2fsck: symbol lookup error: e2fsck: undefined symbol: set_com_err_gettext
....
> 
> Since this addition introduces an ABI incompatibility in libcom_err,
> isn't the process supposed to be to increase the SO's version so that
> the tools find the proper version of the library and also so that it
> gets upgraded accordingly by RPM with it's autoprovides/requires bits?

There's a distinction which needs to be made between adding a new
symbol to a DSO, and making an incompatible chnage to the ABI of an
existing symbol of a DSO.  The former doesn't break any existing
programs (although you need to make sure you have a sufficiently new
version of the library for executables which use the newer symbols).
The latter does break previously existing programs that were linked
against the DSO.

Normally, we only bump the SO version in the latter case.

It is indeed up to packaging systems to do the right thing vis-a-vis
having the correct dependencies in their packages.  Debian/dpkg does
this automatically.  Note the current set of dependencies for the
e2fsprogs package in Debian:

Pre-Depends: e2fslibs (= 1.42.5-1), libblkid1 (>= 2.17.2), libc6 (>= 2.11), libcomerr2 (>= 1.42~WIP-2011-10-05-1), libss2 (>= 1.34-1), libuuid1 (>= 2.16), util-linux (>= 2.15~rc1-1)

It does this by maintaining a list of symbols and the version when it
was first introduced.  See the libcomerr2.symbols file, for which an
example can be found here:

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob;f=debian/libcomerr2.symbols;h=ce3b74a19d32ea9f43d67c976753e91ca113a894;hb=HEAD

Debian has packaging tools which will examine all of the symbols used
by the executables in a package, compare it against the .symbols file
for the library, and then determine the appropriate minimum version
needed for that library, and insert it into the package.  This is how
the e2fsprogs package automatically included a versioned dependency
for libcomerr2 1.42~WIP-2011-10-05-1 (since this was the first Debian
package which provided version 1.41.99, as specified in the
libcomerr2.symbosl file).  However, based on the symbols used from the
libss2 library, e2fsprogs only needs libss2 version of 1.34-1 or
newer.

If another package uses libcomerr2, but doesn't use the new
set_com_err_gettext() function, then the versioned dependency for that
package might be for an older version of libcomerr2.  And all of this
is done automgically by the Debian dpkg tools.  Cool!!

Unfortunately, RPM doesn't seem to do this automatically.  It looks
like you have to explicitly specify these dependencies in the spec
file.  Currently the e2fsprogs spec file for Fedora seems to mandate
that e2fslibs must match the version of e2fsprogs exactly, while any
version of libcomerr2 will do.

If we were to change the DSO version number, it would break older
executables that didn't use this new symbol, and given that the
dependency management in the RPM spec file is all horribly manual, it
wouldn't help you, since you'd have to manually adjust the dependency
in the spec file anyway.  So you might as well manually adjust it to
require at least the 1.42 version of libcom_err.

Anyway, this is a packaging bug, and Debian provides a worked example
about how this can be done completely automatically, without needing
any special handling by the release engineer.  Why RPM doesn't follow
Debian's lead by having an automated system is not something I've ever
understood (but there's a reason why I use Debian and not
Fedora.... and it's not just the abomination which is GNOME 3 / GNOME OS).

Best regards,

	       	    	     	 	     	   - Ted
