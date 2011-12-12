From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/2] ext4: avoid hangs in ext4_da_should_update_i_disksize()
Date: Mon, 12 Dec 2011 11:28:21 +0800
Message-ID: <CAGBYx2Y3WUc1m0BvTyrDcEyh0TTeLriWGA3YjgKcGoW=s8PYnw@mail.gmail.com>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
	<1323656828-24465-2-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33487 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1LLD2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Dec 2011 22:28:22 -0500
Received: by ggdk6 with SMTP id k6so569396ggd.19
        for <linux-ext4@vger.kernel.org>; Sun, 11 Dec 2011 19:28:21 -0800 (PST)
In-Reply-To: <1323656828-24465-2-git-send-email-aarcange@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrea,

I can not figure out why ext4 hangs.  Could you explain more on hanging=
?

Thanks,
Yongqiang.

On Mon, Dec 12, 2011 at 10:27 AM, Andrea Arcangeli <aarcange@redhat.com=
> wrote:
> If the pte mapping in generic_perform_write() is unmapped between
> iov_iter_fault_in_readable() and iov_iter_copy_from_user_atomic(), th=
e
> "copied" parameter to ->end_write can be zero. ext4 couldn't cope wit=
h
> it with delayed allocations enabled. This skips the i_disksize
> enlargement logic if copied is zero and no new data was appeneded to
> the inode.
>
> =A0gdb> bt
> =A0#0 =A00xffffffff811afe80 in ext4_da_should_update_i_disksize (file=
=3D0xffff88003f606a80, mapping=3D0xffff88001d3824e0, pos=3D0x1\
> =A008000, len=3D0x1000, copied=3D0x0, page=3D0xffffea0000d792e8, fsda=
ta=3D0x0) at fs/ext4/inode.c:2467
> =A0#1 =A0ext4_da_write_end (file=3D0xffff88003f606a80, mapping=3D0xff=
ff88001d3824e0, pos=3D0x108000, len=3D0x1000, copied=3D0x0, page=3D0\
> =A0xffffea0000d792e8, fsdata=3D0x0) at fs/ext4/inode.c:2512
> =A0#2 =A00xffffffff810d97f1 in generic_perform_write (iocb=3D<value o=
ptimized out>, iov=3D<value optimized out>, nr_segs=3D<value o\
> =A0ptimized out>, pos=3D0x108000, ppos=3D0xffff88001e26be40, count=3D=
<value optimized out>, written=3D0x0) at mm/filemap.c:2440
> =A0#3 =A0generic_file_buffered_write (iocb=3D<value optimized out>, i=
ov=3D<value optimized out>, nr_segs=3D<value optimized out>, p\
> =A0os=3D0x108000, ppos=3D0xffff88001e26be40, count=3D<value optimized=
 out>, written=3D0x0) at mm/filemap.c:2482
> =A0#4 =A00xffffffff810db5d1 in __generic_file_aio_write (iocb=3D0xfff=
f88001e26bde8, iov=3D0xffff88001e26bec8, nr_segs=3D0x1, ppos=3D0\
> =A0xffff88001e26be40) at mm/filemap.c:2600
> =A0#5 =A00xffffffff810db853 in generic_file_aio_write (iocb=3D0xffff8=
8001e26bde8, iov=3D0xffff88001e26bec8, nr_segs=3D<value optimi\
> =A0zed out>, pos=3D<value optimized out>) at mm/filemap.c:2632
> =A0#6 =A00xffffffff811a71aa in ext4_file_write (iocb=3D0xffff88001e26=
bde8, iov=3D0xffff88001e26bec8, nr_segs=3D0x1, pos=3D0x108000) a\
> =A0t fs/ext4/file.c:136
> =A0#7 =A00xffffffff811375aa in do_sync_write (filp=3D0xffff88003f606a=
80, buf=3D<value optimized out>, len=3D<value optimized out>, \
> =A0ppos=3D0xffff88001e26bf48) at fs/read_write.c:406
> =A0#8 =A00xffffffff81137e56 in vfs_write (file=3D0xffff88003f606a80, =
buf=3D0x1ec2960 <Address 0x1ec2960 out of bounds>, count=3D0x4\
> =A0000, pos=3D0xffff88001e26bf48) at fs/read_write.c:435
> =A0#9 =A00xffffffff8113816c in sys_write (fd=3D<value optimized out>,=
 buf=3D0x1ec2960 <Address 0x1ec2960 out of bounds>, count=3D0x\
> =A04000) at fs/read_write.c:487
> =A0#10 <signal handler called>
> =A0#11 0x00007f120077a390 in __brk_reservation_fn_dmi_alloc__ ()
> =A0#12 0x0000000000000000 in ?? ()
> =A0gdb> print offset
> =A0$22 =3D 0xffffffffffffffff
> =A0gdb> print idx
> =A0$23 =3D 0xffffffff
> =A0gdb> print inode->i_blkbits
> =A0$24 =3D 0xc
> =A0gdb> up
> =A0#1 =A0ext4_da_write_end (file=3D0xffff88003f606a80, mapping=3D0xff=
ff88001d3824e0, pos=3D0x108000, len=3D0x1000, copied=3D0x0, page=3D0\
> =A0xffffea0000d792e8, fsdata=3D0x0) at fs/ext4/inode.c:2512
> =A02512 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ext4_da_should_upd=
ate_i_disksize(page, end)) {
> =A0gdb> print start
> =A0$25 =3D 0x0
> =A0gdb> print end
> =A0$26 =3D 0xffffffffffffffff
> =A0gdb> print pos
> =A0$27 =3D 0x108000
> =A0gdb> print new_i_size
> =A0$28 =3D 0x108000
> =A0gdb> print ((struct ext4_inode_info *)((char *)inode-((int)(&((str=
uct ext4_inode_info *)0)->vfs_inode))))->i_disksize
> =A0$29 =3D 0xd9000
> =A0gdb> down
> =A02467 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < idx; i++)
> =A0gdb> print i
> =A0$30 =3D 0xd44acbee
>
> This is 100% reproducible with some autonuma development code tuned i=
n
> a very aggressive manner (not normal way even for knumad) which does
> "exotic" changes to the ptes. It wouldn't normally trigger but I don'=
t
> see why it can't happen normally if the page is added to swap cache i=
n
> between the two faults leading to "copied" being zero (which then
> hangs in ext4). So it should be fixed. Especially possible with lumpy
> reclaim (albeit disabled if compaction is enabled) as that would
> ignore the young bits in the ptes.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
> =A0fs/ext4/inode.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index fffec40..63f9541 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2508,7 +2508,7 @@ static int ext4_da_write_end(struct file *file,
> =A0 =A0 =A0 =A0 */
>
> =A0 =A0 =A0 =A0new_i_size =3D pos + copied;
> - =A0 =A0 =A0 if (new_i_size > EXT4_I(inode)->i_disksize) {
> + =A0 =A0 =A0 if (copied && new_i_size > EXT4_I(inode)->i_disksize) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ext4_da_should_update_i_disksize(p=
age, end)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0down_write(&EXT4_I(ino=
de)->i_data_sem);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (new_i_size > EXT4_=
I(inode)->i_disksize) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
