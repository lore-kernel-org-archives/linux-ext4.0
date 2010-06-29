From: Hsuan-Ting <acht93@cs.ccu.edu.tw>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Tue, 29 Jun 2010 21:41:08 +0800
Message-ID: <AANLkTilF4XRqY43GRLxqKRsPeaiCL22C2SafzoypcSSH@mail.gmail.com>
References: <AANLkTilD3D2QOXi1b7oXT2uFBx_vuO803HOX4JJXfWG0@mail.gmail.com>
	<20100621170556.GB6843@thunk.org> <AANLkTimN1pMUlpoVbQe1ueL_LiorWqPNgpEfRBNrbEp0@mail.gmail.com>
	<AANLkTimJVDB4hqCeD2dPBAD8krJScgiBP8-3sBmRaFB1@mail.gmail.com>
	<B76CA57A-4379-494C-8DC6-DE041F2A4555@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45550 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab0F2Nla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jun 2010 09:41:30 -0400
Received: by ewy23 with SMTP id 23so337434ewy.19
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jun 2010 06:41:28 -0700 (PDT)
In-Reply-To: <B76CA57A-4379-494C-8DC6-DE041F2A4555@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

  I've follow your steps, fill nearly the whole filesystem before resiz=
ing.
After resizing and do fsck, the files seems OK.
My test steps is as following:

1. build a linear raid ( 1 X 2TB disk )
2. fill nearly the whole filesystem
(copy 133 * "test folders" to this volume,
 test folders include "kernel source" + 10G HD video + pdf files + smal=
l video)
3. grown the linear raid to >16TB (10 x 2TB)
4. do resize ( resize -fpF /dev/md2 )
5. after resize the "df" result isn't correct, and it will occur error
when "rm" files
("df" its "Used colum" show "114.3M", actually it must be "1.5T")
("rm error" I add after these steps)
6. do "fsck.ext4 -yvf", then "df" is correct
7. copy 30 * "test folders" again to fill new space
8. Do some roughly verification, the content of files and
rm command  seems OK:
(roughly verification: "diff -r" to compare one test kernel source
with original, play video and open pdf files)

Now I'm doing "llverfs -l" and run a script to recursive do "diff -r"
for verifying all
test kernel souce. If it occurs error, I'll update later.

If you have any new idea of these error(df and fsck) or any opinions,
please let me know.
I'm still trying to find these error root cause.

Thanks.


"rm error":
[511874.472848] EXT4-fs error (device md2): mb_free_blocks:
double-free of inode 16391's block 66051(bit 515 in group 2)
[511874.483885] Aborting journal on device md2-8.
[511874.488741] EXT4-fs (md2): Remounting filesystem read-only
[511874.494928] EXT4-fs error (device md2) in
ext4_reserve_inode_write: Journal has aborted
[511874.503288] EXT4-fs error (device md2) in
ext4_reserve_inode_write: Journal has aborted
[511874.511791] EXT4-fs error (device md2) in ext4_ext_remove_space:
Journal has aborted
[511874.520125] EXT4-fs error (device md2) in
ext4_reserve_inode_write: Journal has aborted
[511874.528676] EXT4-fs error (device md2) in ext4_ext_truncate:
Journal has aborted
[511874.536581] EXT4-fs error (device md2) in
ext4_reserve_inode_write: Journal has aborted
[511874.545186] EXT4-fs error (device md2) in ext4_orphan_del: Journal
has aborted
[511874.552786] EXT4-fs error (device md2) in
ext4_reserve_inode_write: Journal has aborted

2010/6/26 Andreas Dilger <adilger@dilger.ca>:
> On 2010-06-25, at 04:33, Hsuan-Ting wrote:
>> My test case:
>> 1. build a linear raid (1 x 2TB disk)
>> 2. mkfs.ext4, mount it and"echo 123 > test" to
>> touch a test file.
>> 3. =A0grown the linear raid to >16TB (9 x 2TB + 1 x 1.5TB)
>> 4. do resize ( resize -fpF /dev/md2 )
>> After resizing, the content of the test file is correct.
>
> This is mostly unsurprising, since there is very little chance that t=
he single file is corrupted by a resize. =A0Better would be to fill nea=
rly the whole filesystem (e.g. llverfs, previously posted to this list)=
 and verify the file contents after the resize.
>
>> But "fsck -nyv" will get the following error:
>> I think maybe I should modify "ext2_ino_t" type from
>> "__u32" to "__u64".
>> Maybe this modification will fix many overflow issue.
>
> No, this will completely break the ext2/3/4 on-disk format. =A0What y=
ou need to make sure is that when resize2fs is resizing the filesystem =
that it limits the total number of inodes in the filesystem to 2^32-1. =
=A0I guess that means the groups beyond the 2^32nd inode will have no i=
node table at all, which is a bit strange, but something that we need t=
o expect in e2fsck.
>
> I guess the alternative would be to allocate the inode table, but we =
couldn't (yet?) use those inodes without significant work to support 64=
-bit inode numbers. =A0Probably the first step in that direction would =
be the "dirdata" patch that we have to allow storing extra data in dire=
ctory entries.
>
> Cheers, Andreas
>
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
