From: Ted Ts'o <tytso@mit.edu>
Subject: Re: EXT4-fs error
Date: Tue, 13 Mar 2012 08:14:12 -0400
Message-ID: <20120313121412.GB17538@thunk.org>
References: <CA+WnoXMqBAsbE_o=GYUObSJ8Hu4nzVmJt8Ru5ryeYk6nbaUJsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: manikanta <manikanta4u@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59117 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab2CMMOP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Mar 2012 08:14:15 -0400
Content-Disposition: inline
In-Reply-To: <CA+WnoXMqBAsbE_o=GYUObSJ8Hu4nzVmJt8Ru5ryeYk6nbaUJsg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 13, 2012 at 03:09:07PM +0530, manikanta wrote:
> Hi,
>=20
> Below are the error logs,
> <2>[ 4236.400030] [0: =A0 =A0 Thread-980:11795] EXT4-fs error (device
> mmcblk0p17): ext4_map_blocks:1304: inode #2: block 3900: comm
> Thread-980: lblock 0 mapped to illegal pblock (length 1)

You have a corrupted file system.  You need to run e2fsck on it (or
reformat it if there's nothing else that you care about on that
partition).

Block 3900 is probably (I'd need to look at the output of dumpe2fs to
be sure) overlapping with the inode table, or some other file system
metadata, and the system is refusing to write to the file system lest
more data be lost.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
