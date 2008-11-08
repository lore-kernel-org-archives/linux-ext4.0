From: "Roc Valles" <vallesroc@gmail.com>
Subject: Re: EXT4-fs error (device sda3): ext4_mb_generate_buddy: EXT4-fs: group 923: 18046 blocks in bitmap, 32768 in gd
Date: Sat, 8 Nov 2008 19:30:02 +0000
Message-ID: <3d3ce57e0811081130r3101b721m548d18c7da9f4bbb@mail.gmail.com>
References: <3d3ce57e0811080637k3de96b09q28abeb4ebea0463c@mail.gmail.com>
	 <20081108164300.GA8458@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:23303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYKHTaE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Nov 2008 14:30:04 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1589133fgg.17
        for <linux-ext4@vger.kernel.org>; Sat, 08 Nov 2008 11:30:02 -0800 (PST)
In-Reply-To: <20081108164300.GA8458@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hmm... is there any chance that a rtorrent was in the middle of
> downloading a file at the time when you shutdown the system?  If so,
> try killing all processes which might be writing to the filesystem
> (especially any rtorrent processes) before shutting down the
> filesystem.
Zero. I carefully quit rtorrent everytime I reboot, including this
one. If I ever forget to, I'll notice right away the moment I start
it, because it'd rehash everything.

I forgot to menction something that might be key, which is that a few
reboots ago, I couldn't reboot (reboot wouldn't finish) until I forced
it with with -f and another parameter which makes reboot not sync
before rebooting. Doing a sync in another terminal never finished, so
the FS got stuck somehow. The error might have started appearing
immediatly after that.

> Another question is whether mounting -o nodelalloc (on the previous
> boot session) makes the problem go away.  These last two tries are
> based on the assumption that the filesystem is somehow really getting
> corrupted on shutdown, and since you have errors=continue, it's
> getting silently fixed up in mballoc.c, and so it doesn't show up when
> you unmount the filesystem and run e2fsck.  If this assumption is
> true, that bogus free blocks in the superblock should show up in the
> dumpe2fs, and it should also show up when you reboot via a rescue disk
> and run "e2fsck -nfv /dev/sda3".

I'll do the later at next opportunity, also the other thing we discussed on irc.

>                                                        - Ted
>
