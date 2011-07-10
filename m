From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] ext4: Fix missing iput for root inode in case of all
 failed mount paths.
Date: Sun, 10 Jul 2011 12:11:52 -0700
Message-ID: <CAE0An6eJmfK0bZ-6pTXbxxx8CXVx1JMh_FnCvCDmOc97rNndcw@mail.gmail.com>
References: <AANLkTik8jweuA_kDfzY7H=wP-ikSSwdf-FF1NX09DDCT@mail.gmail.com>
 <032DF412-6B37-4EB7-A687-8216CB1E2BAB@dilger.ca> <AANLkTiku46htAypEN7QNN=UZuRETKGnHJQ8cxt3kYPJg@mail.gmail.com>
 <3828C477-0589-402A-8F71-9837FE8B0693@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	Yu Jian <yujian@whamcloud.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39513 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab1GJTMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Jul 2011 15:12:13 -0400
Received: by qwk3 with SMTP id 3so1580793qwk.19
        for <linux-ext4@vger.kernel.org>; Sun, 10 Jul 2011 12:12:12 -0700 (PDT)
In-Reply-To: <3828C477-0589-402A-8F71-9837FE8B0693@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 6, 2011 at 3:54 PM, Andreas Dilger <adilger@dilger.ca> wrot=
e:
> On 2011-01-16, at 11:05 AM, Manish Katiyar wrote:
>> On Sun, Jan 16, 2011 at 8:20 AM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>> Why not just put the iput() at failed_mount4() instead of spread ar=
ound the code?
>>
>> Thanks Andreas, Here is the updated patch.
>
> We are hitting this same problem due to ENOMEM on allocating some lar=
ge
> filesystem structures for 128TB filesystems. =A0However, when we were=
 going
> to add this patch to our patch series (until vendor kernels include i=
t),
> Yu Jian (one of our developers) noticed a problem with the patch.
>
> In the error path, the patch is doing:
>
> failed_mount4:
> =A0 =A0 =A0 =A0iput(root);
> =A0 =A0 =A0 =A0sb->s_root =3D NULL;
>
> but in fact sb->s_root is a dentry allocated by d_alloc_root(), so th=
e
> above code is freeing the inode, but still leaking the dentry. =A0Thi=
s
> is of course a lot better than before (no oops), but still isn't corr=
ect.
>
> The original problem appears to have been inadvertently fixed with co=
mmit
> 8aefcd557d26d0023a36f9ec5afbf55e59f8f26b, because ext4_clear_inode() =
now
> checks "if (EXT4_I(inode)->jinode)" before deferencing EXT4_SB() and =
the
> now-NULL s_fs_info. =A0jinode should be NULL during mount, because it=
 has
> never been opened. =A0I haven't confirmed this theory yet, however. =A0=
Manish,
> can you please give this a try with your fault-injection testing?
>
> It looks like we could revert 32a9bb57d7c1fd04ae0f72b8f671501f000a0e9=
f
> (this patch, leaving the two explicit iput() in place in case of a ba=
d
> root inode or dentry) and leave the VFS to clean up the root dentry.

Hi Andreas,

I reverted my original patch in latest Ted's tree and retried.
ext4_clear_inode() is fixed, but we still
panic in

#14 <signal handler called>
#15 ext4_sync_fs (sb=3D0x17d6ee00, wait=3D0) at fs/ext4/super.c:4191
#16 0x080d5214 in __sync_filesystem (sb=3D0x17d6ee00, wait=3D0) at fs/s=
ync.c:49
#17 0x080d5277 in sync_filesystem (sb=3D0x17d6ee00) at fs/sync.c:74
#18 0x080bc188 in generic_shutdown_super (sb=3D0x17d6ee00) at fs/super.=
c:282
#19 0x080bc236 in kill_block_super (sb=3D0x17d6ee00) at fs/super.c:856
#20 0x080bc3fe in deactivate_locked_super (s=3D0x17d6ee00) at fs/super.=
c:183
#21 0x080bc96b in mount_bdev (fs_type=3D0x8264974, flags=3D0,
dev_name=3D0x17d74ed0 "/dev/loop0", data=3D0x0, fill_super=3D0x81236f1
<ext4_fill_super>) at fs/super.c:831
#22 0x0811fc36 in ext4_mount (fs_type=3D0x8264974, flags=3D0,
dev_name=3D0x17d74ed0 "/dev/loop0", data=3D0x0) at fs/ext4/super.c:4820
(gdb) f 15
#15 ext4_sync_fs (sb=3D0x17d6ee00, wait=3D0) at fs/ext4/super.c:4191
4191		flush_workqueue(sbi->dio_unwritten_wq);
(gdb) p sbi
$1 =3D (struct ext4_sb_info *) 0x0


--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
