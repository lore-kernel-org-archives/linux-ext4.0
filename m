From: Andreas Dilger <adilger@sun.com>
Subject: Re: Add
	ext4__allow_read-only_mounts_with_corrupted_block_group_checksums	patch
Date: Wed, 16 Jul 2008 03:29:14 -0600
Message-ID: <20080716092914.GR6239@webber.adilger.int>
References: <3.0.6.32.20080715193126.0242c9a0@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58498 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbYGPJ3R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 05:29:17 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6G9TGcE004765
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 02:29:16 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4300B01E9NUP00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 16 Jul 2008 02:29:16 -0700 (PDT)
In-reply-to: <3.0.6.32.20080715193126.0242c9a0@pop.west.cox.net>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 15, 2008  19:31 +0000, Gary Hawco wrote:
> Just recompiled 2.6.26 with the newest snapshot (15-July 2008/2310GMT).
> uninit_bg had been enabled.
> 
> To test kernel I did: tune2fs -O ^uninit_bg /dev/sda6 to remove uninit_bg
> feature.
> Was prompted to run e2fsck on system.
> 
> Rebooted and e2fsck saw errors and did a forced fsck without having to
> reboot. All is well thus far.

You shouldn't really have rebooted at that point, just run e2fsck on
the filesystem to clear the checksums.

> Then I did the reverse: tune2fs -O uninit_bg /dev/sda6 to renable uninit_bg
> feature.  Again, I was prompted to run e2fsck on system.

Again, you should have just run e2fsck on the filesystem without rebooting,
in order to update the checksums.

> Rebooted. This time I got a kernel panic that started with:
> EXT4-fs: ext4_check_descriptors: Checksum for group 2 failed (10368!=32990)
> EXT4-fs: group descriptors corrupted!

The kernel thinks the filesystem is corrupted, so a full e2fsck needs to
be run.  However, e2fsck is probably sitting on that unmountable filesystem.

> I was under the impression that the newest patch would handle this or am I
> mistaken?

We probably need to allow the kernel to mount the filesystem read-only in
this case in order to run e2fsck.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

