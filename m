From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [f2fs-dev] Consolidated file encryption interface/semantics?
Date: Tue, 12 Jan 2016 11:21:20 -0500
Message-ID: <20160112162120.GA30329@thunk.org>
References: <56943319.9080802@nod.at>
 <20160112074756.GB35051@jaegeuk.granlibakkenguest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Weinberger <richard@nod.at>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	andreym@codeaurora.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48877 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbcALQVb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2016 11:21:31 -0500
Content-Disposition: inline
In-Reply-To: <20160112074756.GB35051@jaegeuk.granlibakkenguest>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 11, 2016 at 11:47:56PM -0800, Jaegeuk Kim wrote:
> 
> Actually, I tried to prepare this quite long time ago [1], which was stuck
> that moment unfortunately, since I needed to wait for how AOSP finally treats
> with this feature. At some moment later, I couldn't even follow up every ext4
> changes into this patch set, since the feature was not quickly settled down in
> AOSP rather than what I expected.

Yeah, unfortunately the feature didn't end up landing in M because
there was an ARM/Android specific bug that couldn't be found using
xfstests running on x86 (this is why I detoured to port xfstests and
xfsprogs so they could build against bionic C library; I'm still
hoping to find someone who is willing to help create an adb-xfstests
system ala kvm-xfstests and gce-xfstests which fastboots the kernel to
be tested and then launches the tests and collects the results using
adb, by the way).

In any case, I did finally find the bug, but not in time for the M
release.  So if you take the latest ext4 crypto bug fixes from
upstream and apply them to the AOSP versions of the Nexus 9, Nexus 5X,
and Nexus 6P kernels, and then replace AOSP version of e2fsprogs with
the upstream e2fsprogs (use the master or next branch, and run the
script ./util/gen-android-files to create the Android.mk files), and
finally then change the fstab file in the 
aosp/devices/<manufacturer>/<model>/fstab.<model> file and change the
mount options so instead of "forceencrypt=/dev/block/platform/..." it
uses the mount option "fileencryption" for the /data partition, this
should allow you to build an AOSP system image that should work well
enough to demo / test the kernel features.

Some of the future work that I have planned or in progress:

1) Patches that allow userspace to move / backup a set of encrypted
files from one file system to another without having access to the
key.  Dmitri asked for this as a feature request for desktop/laptop
uses of ext4 encryption, and happily it turns out there is a reason
why this would be useful for Android as well.  These patches have been
floated on the ext4 list, but I don't yet have support for moving /
backing up symlinks, so these patches won't be landing during the
current merge window.

2) Work to allow IP blocks that have line speed encryption engines,
such Qualcomm (as evidenced by the patch they tried to send for
ecryptfs at https://lkml.org/lkml/2015/11/9/660), but one which is
done in an upstream acceptable way, which means plumbing the crypto
support through the block layer in a way which is SOC vendor agnostic.
(Probably using a similar mechanism to how we tie DIF/DIX information
to a block I/O request.)  I'm hoping Qualcomm and possibly other SOC
vendors will be willing to work with me so this we can have something
which is upstream acceptable (since I don't plan to accept a patch
which adds some random, hacky, function pointers to code that only
lives in a BSP kernel).  This may be a useful thing to discuss at the
in Raleigh at the LSF/MM workshop in April, assuming I can get
representatives from the relevant SOC vendors to show up.

> But, now it seems that there's no strong reason to postpone this work any more.
> If Ted doen't mind, I'd like to investigate all the diffs between ext4 and f2fs
> first.

Sure, if you could help with this I'd greatly appreciate it.

There have been a number of improvements and optimizations since the
last time you sync'ed the f2fs code with ext4, but I'm sure you'll see
that as you look at the various commits.

Regards,

					- Ted
