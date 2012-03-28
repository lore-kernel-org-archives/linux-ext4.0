From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: backup of the last group'descriptor when it is the 1st group of a meta_bg
Date: Wed, 28 Mar 2012 10:08:39 -0600
Message-ID: <BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca>
References: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48500 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2C1RH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2012 13:07:28 -0400
Received: by yenl12 with SMTP id l12so885258yen.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Mar 2012 10:07:27 -0700 (PDT)
In-Reply-To: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-27, at 8:47 AM, Yongqiang Yang wrote:
> Hi Ted, Andreas and List,
>=20
> As Andreas pointed out last year, if the last group is the 1st group
> in a meta bg, then its group desc has no backup.
> With meta_bg resizing inode is useless,  I had a thought that we stor=
e
> a backup group descriptor of the last group in the resizing inode=EF=BC=
=9F
> What's your opinions?

The main difficulty of referencing a backup group descriptor from the
resize inode is that it may confuse tools that are trying to modify
the resize inode.  Also, it is more difficult to access the block from
userspace, since it would need to read the inode and use an extent to
reference the block beyond 16TB.

What about storing the 64-bit block number in the superblock?  This
should be safe for older e2fsprogs that understand META_BG.  At worst
the new backup group descriptor will not be updated on a resize by
older e2fsprogs, which is no worse than not having a backup at all.

I would suggest to put the backup group descriptor in the last block
of the filesystem.  This would be in the 0th group of the metagroup.
If the metagroup grows to have a second group, then this block is not
needed anymore, and if both the primary (at the beginning of the group)
and the backup (at the end of the group) are corrupted, then there is
little chance that the data in this last group is good either...

Actually, if the backup is always stored in the last block of the 0th
group (which is itself the last group in the filesystem), there isn't
even a need to store this location in the superblock.

Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
