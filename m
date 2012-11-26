From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: How to run xfstests against multipath disks on SuSE?
Date: Mon, 26 Nov 2012 14:43:40 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211261442490.18234@localhost>
References: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	xfs@oss.sgi.com
To: Ryan Wang <openspace.wang@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab2KZNns (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 08:43:48 -0500
In-Reply-To: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 26 Nov 2012, Ryan Wang wrote:

> Date: Mon, 26 Nov 2012 08:00:05 +0800
> From: Ryan Wang <openspace.wang@gmail.com>
> To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
> Subject: How to run xfstests against multipath disks on SuSE?

Maybe cc xfstests developers as well ?

xfs@oss.sgi.com added to cc.

> 
> Hello,
> 
> I tried to kick off xfstests on multipath device, e.g I set
> TEST_DEV="/dev/mapper/mpatha", which is a symlink
> to "/dev/dm-0". I run mkfs on mpatha beforehand.
> 
> When I run "./check 001", it said:
> "
> common.rc: Error: $TEST_DEV (/dev/dm-0) is not a MOUNTED ext4 filesystem
> "
> 
> The I checked the script common.rc, and found that it uses
> df to determine the filesystem type and it uses the realpath
> "/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
> shows "devtmpfs" instead of "ext4" for /dev/dm-0.
> 
> I run "mount" and found that devtmpfs is mount on /dev/ on opensuse
> ***by default***. Even though  I run "mount -t btrfs /dev/dm-0 /somedir",
> df still showed devtmpfs.
> 
> Any ideas to kick off the xfstests?
> 
> thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
