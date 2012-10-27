From: Theodore Ts'o <tytso@mit.edu>
Subject: Testing ext4's journal via simulating a reboot via KVM
Date: Sat, 27 Oct 2012 04:01:27 -0400
Message-ID: <20121027080127.GA12045@thunk.org>
References: <87objupjlr.fsf@spindle.srvr.nix>
 <20121023013343.GB6370@fieldses.org>
 <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508AF3FA.4020506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>, Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57949 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab2J0IBe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Oct 2012 04:01:34 -0400
Content-Disposition: inline
In-Reply-To: <508AF3FA.4020506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 26, 2012 at 03:35:06PM -0500, Eric Sandeen wrote:
> 
> Out of curiosity, when I test log replay with the journal_checksum option, I
> almost always get something like:
> 
> [  999.917805] JBD2: journal transaction 84121 on dm-1-8 is corrupt.
> [  999.923904] EXT4-fs (dm-1): error loading journal

I tried to reproduce your findings, using my kvm setup.  I've pushed
the changes that I am using here (see the kvm-autorun and kvm-xfstests
directories):

   git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git

Using both the kernel tree as of my last pull request to Linus, as
well as v3.6.3, I was not able to reproduce a failure using this:

./kvm-xfstests -m nobarrier,journal_async_commit,journal_checksum fsstress

<wait until fsstress has started running for 10 seconds or so, and in
  another window>

killall kvm

I then built a version of e2fsck using the configure option
--enable-jbd-debug, and then ran e2fsck with the E2FSCK_JBD_DEBUG
environment variable set to 3.  (This allowed me to confirm that the
checksums really were getting set.)

Running e2fsck -f on the underlying volume, I could see that checksums
was in fact properly set, and the journal replay completed
successfully.  I tried this multiple times, and it worked every single
time.  This was with me killing the kvm while fsstress was running so
there was over 300 transactions that had to be replayed.

Eric has said that he was able to see journal checksum failures which
caused the journal to abort using his setup.  It's very interesting
that I could not (no matter how many times I tried, and with
variations on the mount options).  It makes me wonder if there is some
difference with how dm-snapshot was working versus simply just killing
the kvm process --- could it be that dm-snapshot wasn't taking a
consistent snapshot?  The fact that KVM is seeing valid checksums
would imply that the file system layer is (at least) sending valid
data to the disk.  Why dm_snapshot is not seeing valid checksum is
definitely an interesting question.

Eric if you can build a version of e2fsck with --config-jbd-debug
enabled, that would be useful since you'll be able to see how much the
expected and real checksum vary with each other.  Maybe that will tell
us something...

						- Ted


P.S.  One other interesting thing I discovered is this.  Using debugfs
-R "logdump -a", I found the following:

Found expected sequence 20587, type 2 (commit block) at block 5302
Found expected sequence 20588, type 1 (descriptor block) at block 5303
Dumping descriptor block, sequence 20588, at block 5303:
  FS block 23 logged at journal block 5304 (flags 0x0)
  FS block 1 logged at journal block 5305 (flags 0x2)
  FS block 1157 logged at journal block 5306 (flags 0xa)
Found expected sequence 20588, type 2 (commit block) at block 5307
Found expected sequence 20589, type 2 (commit block) at block 5308
Found expected sequence 20590, type 2 (commit block) at block 5309

Note the sequence of what appear to be completely empty commit blocks.
I'm not sure what fsstress is doing which is causing e2fsck to issue
empty commit blocks, but as far as I can tell, they are completely
pointless.

I tried running "debugfs -R logdump" on my root file system, and I saw
a few cases of empty commits, but at a much reduced rate.  Still, if
we can figure out how to stop the jbd2 layer from creating these empty
commits, it would certainly optimize things a bit.

