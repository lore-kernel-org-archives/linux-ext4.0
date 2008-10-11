From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 42/42] ext4: Rename ext4dev to ext4
Date: Sat, 11 Oct 2008 18:58:26 -0400
Message-ID: <20081011225826.GD12662@mit.edu>
References: <1223525160-9887-36-git-send-email-tytso@mit.edu> <1223525160-9887-37-git-send-email-tytso@mit.edu> <1223525160-9887-38-git-send-email-tytso@mit.edu> <1223525160-9887-39-git-send-email-tytso@mit.edu> <1223525160-9887-40-git-send-email-tytso@mit.edu> <1223525160-9887-41-git-send-email-tytso@mit.edu> <1223525160-9887-42-git-send-email-tytso@mit.edu> <1223525160-9887-43-git-send-email-tytso@mit.edu> <48F122FC.6040107@goop.org> <48F12427.5090801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60240 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754669AbYJKW7f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 18:59:35 -0400
Content-Disposition: inline
In-Reply-To: <48F12427.5090801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 11, 2008 at 05:09:43PM -0500, Eric Sandeen wrote:
> 
> Yep, we've discussed that and I think it'll get added.
> 

It did get added in the final version that I pushed to Linus (and was
accepted into mainline this afternoon).  It's enabled via a new
Kconfig option:

config EXT4DEV_COMPAT
	bool "Enable ext4dev compatibility"
	depends on EXT4_FS
	help
	  Starting with 2.6.28, the name of the ext4 filesystem was
	  renamed from ext4dev to ext4.  Unfortunately there are some
	  lagecy userspace programs (such as klibc's fstype) have
	  "ext4dev" hardcoded.  

	  To enable backwards compatibility so that systems that are
	  still expecting to mount ext4 filesystems using ext4dev,
	  chose Y here.   This feature will go away by 2.6.31, so
	  please arrange to get your userspace programs fixed!

I've submitted a fix which fixes things for klibc's fstype program
(which is needed because Debian and Ubuntu apparently use klibc's
fstype in their initrd) to the klibc program.  There was also a bug in
blkid which prevented the automatic ext4dev->ext4 fallback from
working correctly, which Eric has fixed and which will be in e2fsprogs
1.41.3 (to be released very shortly).

The only other problem may arise on distro's that depend on vol_id for
mount/fsck, but I've been trying to convice distributions not to
depend on something where you have to reboot before freshly made swap
partitions and filesystems are can be resolved via LABEL= or UUID=
(seems rather too Windows-like for my taste, but whatever), and at
this point I'm reasonably certain that Debian, Ubuntu, Fedora, and
RHEL will all do the right thing, and I've given up on the rest;
they'll see the light eventually.  :-)

						- Ted
