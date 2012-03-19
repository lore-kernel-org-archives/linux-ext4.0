From: Tony Hoyle <tony@hoyle.me.uk>
Subject: Re: [dm-devel] can't recover ext4 on lvm from ext4_mb_generate_buddy:739:
 group 1687, 32254 clusters in bitmap, 32258 in gd
Date: Mon, 19 Mar 2012 23:06:50 +0000
Message-ID: <4F67BC0A.5000706@hoyle.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from medusa.nodomain.org ([81.187.6.161]:56778 "EHLO
	daniel.nodomain.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758607Ab2CSXQt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 19:16:49 -0400
Received: from daniel.nodomain.org (localhost [127.0.0.1])
	by daniel.nodomain.org (Postfix) with ESMTP id 4E9D4426E0
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2012 23:06:24 +0000 (GMT)
Received: from banana.nodomain.org (banana.nodomain.org [IPv6:2001:8b0:178:1:21e:52ff:fe75:1d4f])
	by daniel.nodomain.org (Postfix) with ESMTPS id 3B4804187D
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2012 23:06:24 +0000 (GMT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I looked at the changelogs for 3.2.x and couldn't see anything that
obviously related to this issue - hence posting on this (slightly old)
thread, since I can't find any followup.  I've downgraded to 2.6.32
(last debian kernel available, since they don't seem to keep historical
kernels around) for now, which is running solidly.

WIMPy <wimpy <at> yeti.dk> writes:

> written to (extended) while the rsync was running, which seems to be 
> a situation, where rsync causes a lot of stress. It certainly takes a
> hell of a lot of time.

I get it when I'm writing large files over nfs - exactly the same
symptoms as mentioned elsewhere in the thread, followed by nfsd going
into D state and things generally going downhill from there.

Started when I upgraded to 3.1.0 and continued up to 3.2.0.  fsck shows
no errors on the disk, but the logs fill up with
ext4_mb_generate_buddy:739 errors anyway.

> And a short repeat: I'm using an md, but no lvm.
> 
Same setup here - md, but no lvm.  Another non-raid drive doesn't show
the same symptoms, if it's any help.

Tony

nb:  Some logs, FWIW.  As mentioned above, fsck says there are no errors
on the drive:

Mar 19 20:50:52 goliath kernel: [ 1721.686880] EXT4-fs error (device
md0): ext4_mb_generate_buddy:739: group 21345, 32254 clusters in bitmap,
32258 in gd
Mar 19 20:50:52 goliath kernel: [ 1721.703397] JBD2: Spotted dirty
metadata buffer (dev = md0, blocknr = 0). There's a risk of filesystem
corruption in case of system crash.
Mar 19 20:51:38 goliath kernel: [ 1767.622399] EXT4-fs error (device
md0): ext4_mb_generate_buddy:739: group 21346, 32254 clusters in bitmap,
32258 in gd
Mar 19 20:52:18 goliath kernel: [ 1808.268856] EXT4-fs error (device
md0): ext4_mb_generate_buddy:739: group 21347, 32254 clusters in bitmap,
32258 in gd
Mar 19 20:53:29 goliath kernel: [ 1879.257332] EXT4-fs error (device
md0): ext4_mb_generate_buddy:739: group 21348, 32254 clusters in bitmap,
32258 in gd
Mar 19 20:54:45 goliath kernel: [ 1955.083019] EXT4-fs error (device
md0): ext4_mb_generate_buddy:739: group 21349, 32254 clusters in bitmap,
32258 in gd
..etc.  They don't vary much.  A few thousand of these in rapid succession.
