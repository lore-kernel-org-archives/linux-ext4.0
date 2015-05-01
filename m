From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 non-kernel standalone dev version for testing
Date: Fri, 1 May 2015 19:54:12 -0400
Message-ID: <20150501235412.GC9936@thunk.org>
References: <mhukt7$9ce$1@ger.gmane.org>
 <20150501141322.GA9936@thunk.org>
 <mi0gpq$mpk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <mi0gpq$mpk$1@ger.gmane.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 01, 2015 at 08:31:22PM +0200, U.Mutlu wrote:
> 
> Thx, but unfortunately the Makefile reports an error:

First of all, it's not necessary for you to build the whole setup if
you just want to use kvm-xfstests.  Just download the root_fs.img file
as described in the quickstart.  In fact, if you follow the quickstart
documentation I sent you **exactly** (which you will note doesn't
include trying to build things), it should be enough so you can at
least get something set up for testing generic ext4.  I will create an
updated root_fs.img that can be used for testing encryption in a few
days.


That being said, the build *should* have worked, but you need to send
me the full output of the make output if you want me to help you debug
it.  (i.e., run "make clean ; make >& MAKELOG", and then send me the
output of MAKELOGf.)  It would also be useful to send me the output of
this command line, so I can see what versions of the subcomponents you
are using:

for i in $(find . -name .git) ; do echo $i $(cd $i ; git describe --always); done

specifically, the quota tree recently got autoconfiscated, and so at
least at one point it wasn't building smoothly; doing a "(cd quota ;
git checkout 022aabf)" is a good idea.  Similarly the fio tree is not
necessarily always stable; it's sometimes a good idea to check out the
most recent release tag, instead of using the bleeding edge
development branch for safety reasons.  Here are the versions that I'm
currently personally using for the various subcomponents needed to
build xfstests:

fio	   	 fio-2.2.6 (Fri, 27 Feb 2015 08:30:04 -0700)
quota		 	   022aabf (Wed, 26 Nov 2014 10:22:08 +0100)
xfsprogs		   v3.2.2 (Thu, 4 Dec 2014 07:56:44 +1100)
xfstests-bld		   9fadb2d (Mon, 6 Apr 2015 18:38:24 -0400)
xfstests		   linux-v3.8-640-gfacff60 (Thu, 2 Apr 2015 09:41:15 +1100)


Finally, note that when the build is done, there are still a few more
steps before you can generate a root_fs.img that can be used with kvm,
and that it requires that you are using a Debian or Ubuntu system (and
I only really test on Debian).  The specifics of what you need to do
can be found in the do-all script if you really want to go down this
path ---- but I emphasize, this is all not really necessary unless you
want to do your own test development and/or improve the kvm-xfstests
test appliance.

If you don't, it's *much* simpler to just follow the quickstart
document I sent you very carefully, and just download the root_fs.img
file using wget as I described in step #1.

Finally, out of curiosity, what is your interest in testing/using the
ext4 encryption feature?  It's still very much early days, and so if I
know what you are trying to do, I might be able to provide more
assistance.  Please note that it requires a pre-release version of
e2fsprogs, and with all new features, it's not at the stage where I
would recommend that users use it for critical data until it has gone
through additional testing (and no doubt, bug fixing).

Best regards,

					- Ted
