From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: backup of the last group'descriptor when it is the 1st group of a meta_bg
Date: Mon, 2 Apr 2012 13:04:17 +0800
Message-ID: <CAGBYx2ap2UFyvjuFr=BH1NfeeCZrQn93w0mtCtOje_TsmixnTA@mail.gmail.com>
References: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com>
	<BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57723 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2DBFER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2012 01:04:17 -0400
Received: by obbtb18 with SMTP id tb18so1620215obb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Apr 2012 22:04:17 -0700 (PDT)
In-Reply-To: <BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 29, 2012 at 12:08 AM, Andreas Dilger <aedilger@gmail.com> w=
rote:
> On 2012-03-27, at 8:47 AM, Yongqiang Yang wrote:
>> Hi Ted, Andreas and List,
>>
>> As Andreas pointed out last year, if the last group is the 1st group
>> in a meta bg, then its group desc has no backup.
>> With meta_bg resizing inode is useless, =C2=A0I had a thought that w=
e store
>> a backup group descriptor of the last group in the resizing inode=EF=
=BC=9F
>> What's your opinions?
>
> The main difficulty of referencing a backup group descriptor from the
> resize inode is that it may confuse tools that are trying to modify
> the resize inode. =C2=A0Also, it is more difficult to access the bloc=
k from
> userspace, since it would need to read the inode and use an extent to
> reference the block beyond 16TB.
I meant we store the backup group descriptor in resize inode itself
rather than store it in data blocks, so it does not need an extent at
all.  However, the inode is corrupted, we need patch e2fsck to let it
understand the resize inode.
>
> What about storing the 64-bit block number in the superblock? =C2=A0T=
his
> should be safe for older e2fsprogs that understand META_BG. =C2=A0At =
worst
> the new backup group descriptor will not be updated on a resize by
> older e2fsprogs, which is no worse than not having a backup at all.
>
> I would suggest to put the backup group descriptor in the last block
> of the filesystem. =C2=A0This would be in the 0th group of the metagr=
oup.
> If the metagroup grows to have a second group, then this block is not
> needed anymore, and if both the primary (at the beginning of the grou=
p)
> and the backup (at the end of the group) are corrupted, then there is
> little chance that the data in this last group is good either...
>
> Actually, if the backup is always stored in the last block of the 0th
> group (which is itself the last group in the filesystem), there isn't
> even a need to store this location in the superblock.
Now we have 2 solutions, the 1st one is storing backup group
descriptor in resize inode itself while the 2nd one is storing backup
in the last block of the 0th block. Both need patching e2fsck because
older e2fsck does not work.  The 1st one's patch to e2fsck is much
more complicated, because only one group descriptor is stored in
resize inode itself, but the e2fsck's code reading/writing group
descriptor block. so I like the 2nd one.

Yongqiang.
>
> Cheers, Andreas
>
>
>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
