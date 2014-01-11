From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstests failures in v3.13-rc7
Date: Sat, 11 Jan 2014 16:58:09 -0500
Message-ID: <20140111215809.GA10995@thunk.org>
References: <1389063428.2169.12.camel@ancientdefender.lm.intel.com>
 <CAGW2f1Hdv42u=yHoFVhmx72z88gyNUC4MbQQ0UGk8BceNNEbGA@mail.gmail.com>
 <1389233388.12789.11.camel@vverma7-desk1-amr-corp-intel-com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "jonernst07@gmail.com" <jonernst07@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"matthew@wil.cx" <matthew@wil.cx>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47604 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaAKV6P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 16:58:15 -0500
Content-Disposition: inline
In-Reply-To: <1389233388.12789.11.camel@vverma7-desk1-amr-corp-intel-com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 09, 2014 at 02:09:52AM +0000, Verma, Vishal L wrote:
> As an aside, when I installed e2fsprogs using simply 'make install', it
> replaced /sbin/blkid with it's own version (1.0.0), down from what I had
> (2.x). Reinstalling the util-linux-ng package brings me back up...
> (I had to modify the check script in xfstests to use the -p option in
> blkid to actually read superblock since ramdisks don't seem to make it
> into /etc/blkid/blkid.tab, and this wasn't there in blkid v1.0.0).
> 
> I quickly searched for a bit of history on the topic, and sounds like I
> should be using --disable-libblkid for configure. Tried that, and got
> some errors, the same as seen here:
> http://patchwork.ozlabs.org/patch/36491/

Did you do a full "make distclean" after you reran the configure
script?  This was caused by a left over header file, if memory serves
correctly.

If you used a separate build directory (i.e., "mkdir build ; cd build
; ../configure --enable-...") then just rm -rf the build directory and
then start from scratch.  If you used git, you can do "git clean
-xdq".  If neither of these apply, you may need to delete the full
source tree and then unpack the source tarfile again.

I'm open to patches to make this the transition between one set of
configure options to another more smooth, but given that I tend to
just do things like have multiple build directories, for things like
"build-coverity", "build-quota", "build-dietlibc", etc., it's not high
on my priority list to figure out why someone who fails to run "make
distclean", or deletes the full build tree, before running configure
with a different set of options, is losing.

					- Ted
