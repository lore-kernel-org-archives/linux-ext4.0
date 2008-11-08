From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4-fs error (device sda3): ext4_mb_generate_buddy: EXT4-fs:
	group 923: 18046 blocks in bitmap, 32768 in gd
Date: Sat, 8 Nov 2008 11:43:00 -0500
Message-ID: <20081108164300.GA8458@mit.edu>
References: <3d3ce57e0811080637k3de96b09q28abeb4ebea0463c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Roc Valles <vallesroc@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37636 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112AbYKHQnG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Nov 2008 11:43:06 -0500
Content-Disposition: inline
In-Reply-To: <3d3ce57e0811080637k3de96b09q28abeb4ebea0463c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 08, 2008 at 02:37:03PM +0000, Roc Valles wrote:
> I get the following soon after booting, each time I boot:
> [  245.033381] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
> EXT4-fs: group 923: 18046 blocks in bitmap, 32768 in gd
> [  245.033411]
> [  245.036258] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
> EXT4-fs: group 924: 18113 blocks in bitmap, 32768 in gd
> [  245.036275]
> [  245.038909] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
> EXT4-fs: group 925: 18000 blocks in bitmap, 32768 in gd
> [  245.038926]
> [  245.041258] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
> EXT4-fs: group 926: 18142 blocks in bitmap, 32768 in gd
> [  245.041274]
> [  245.043624] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
> EXT4-fs: group 927: 18026 blocks in bitmap, 32768 in gd

If there were subsequent boots, it's *very* interesting that that the
group numbers are sequentially increasing.  It's also interesting that
the number in the group descriptor is 32768 each time.  Andit's always
only one such error for each boot, right?

In addition to the data collection exercises we discussed over IRC,
could you try putting something which runs:

      logsave /var/cache/dumpe2fs.pre-boot dumpe2fs /dev/sda3

*before* the filesystem is mounted read-write.  (Logsave will save the
output of dumpe2fs and wait until /var/cache is writable, and then
dump the results out to the file).

Hmm... is there any chance that a rtorrent was in the middle of
downloading a file at the time when you shutdown the system?  If so,
try killing all processes which might be writing to the filesystem
(especially any rtorrent processes) before shutting down the
filesystem.  

Another question is whether mounting -o nodelalloc (on the previous
boot session) makes the problem go away.  These last two tries are
based on the assumption that the filesystem is somehow really getting
corrupted on shutdown, and since you have errors=continue, it's
getting silently fixed up in mballoc.c, and so it doesn't show up when
you unmount the filesystem and run e2fsck.  If this assumption is
true, that bogus free blocks in the superblock should show up in the
dumpe2fs, and it should also show up when you reboot via a rescue disk
and run "e2fsck -nfv /dev/sda3".

							- Ted
