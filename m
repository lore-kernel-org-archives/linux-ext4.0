From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Ext4 patches for the next merge window & Enhancements in 2.6.25
Date: Sat, 5 Jul 2008 22:15:23 -0400
Message-ID: <20080706021523.GE20240@mit.edu>
References: <bb33bcf20807051202s305d2c68oae814c2c54a82697@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ltp-list <ltp-list@lists.sourceforge.net>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
	Julia Lawall <julia@diku.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Jose R. Santos" <jrs@us.ibm.com>, Jan Kara <jack@suse.cz>,
	Aneesh Kumar <aneesh.kumar@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Frederic Bohe <frederic.bohe@bull.net>,
	Valerie Clement <valerie.clement@bull.net>,
	Andreas Dilger <adilger@sun.com>,
	Alex Tomas <alex@clusterfs.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Subrata Modak <tosubrata@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33541 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbYGFCSS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 22:18:18 -0400
Content-Disposition: inline
In-Reply-To: <bb33bcf20807051202s305d2c68oae814c2c54a82697@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 06, 2008 at 12:32:54AM +0530, Subrata Modak wrote:
> Hi Ted & Others,
> 
> EXT4 has seen major enhancements in 2.6.25 and i can see few more
> enhancements for the next stable tree. I would like to know whether EXT4
> team has developed organized/automated test suites also to test EXT4
> features before releasing the patches to LKML. Apart from the normal
> fallocate() syscall test cases in LTP, we do not have any specific test case
> for the EXT4 file system. May i know if you have some thing to offer to LTP
> (http://ltp.sourceforge.net/) under GPL, or, any future plans to develop
> test cases as well.

We are using automated test runs via IBM's internal ABAT system; the
main thing we are doing is using various LTP and other filesystem
benchmarks as stress tests, so we don't have any _new_ tests suites
per se.  The main thing which we have automated is the setup so that
the various test suites are run in a variety of different ext4 mount
modes and with different ext4 features enabled/disabled.

My understanding is that this goes beyond the scope of what the LTP
supports, since it tends to be very specific to the configuration of
the System Under Test.

This is an area where I suspect if the LTP wanted to expand into, it
would be very useful; however, I would suggest doing it in a
filesystem independent manner.  Essentially at an abstract level, you
want to be able to iterate over a series of filesystem types (i.e.,
xfs, ext4, ext3, btrfs, etc.), and for each filesystem type, it would
supply a set of mkfs/mount options, and a script for creating and
mounting a filesystem with that set of mkfs and mount options, and
then LTP would run a series of generic filesystem tests and
benchmarks, and then the filesystem would be unmounted, and the next
set of mkfs/mount options would be used, etc.

Essentially ext4 is a generic POSIX-compliant filesystem.  It has some
extentions for acl's, extended attributes, etc. --- but these
extensions use the same interfaces as those found in ext3 and xfs (and
presumably btrfs as well).  Given that the bulk of the POSIX
compliance is done in the VFS, it is highly likely that most of the
components of a functional test of the POSIX interfaces (i.e., such as
you might find in the LSB test suite) will pass; a few are implemented
in a filesystem layer, so it's good to run those tests --- but that's
not the big deal.  The big deal is doing a stress test of the
filesystem to test for potential deadlocks, etc., when the system is
under serious load.  So the sort of testing which will be useful for
ext4 (or any filesystem, really) is what happens when kernbench is run
in the background at the same time as bonnie, or postmark, or other fs
benchmarks.

Something else that would be great to automate is simulating I/O
errors, but unfortunately this would require root privileges and
probably kernel patches (I don't think error injection via device
mapper is in mainline, for example).  This is something we haven't
done yet, but it is something that we definitely need to do, in order
to make sure the filesystem handles media errors in a graceful
fashion.

So the bottom line is that we don't have any *code* in terms of actual
test suites to contribute to the LTP.  It would be great if the LTP
was interested in solving the much more generic filesystem test
framework problem, but it may be that this is out of scope of the LTP
and it is something which should be done as a separate project.

Regards,

						- Ted
