From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: Ext4: deadlock occurs when running fsstress and ENOSPC errors are seen.
Date: Wed, 16 Apr 2014 10:30:10 +0530
Message-ID: <CADDb1s3HYDvb51Ngrwk82gkpbUWg1bRo7kaUmbGRmb0g_9JKgw@mail.gmail.com>
References: <CADDb1s2RvN_S+abFXCe4ZhZPKZgP_PiocJdpiLzRC_Se5sgVVg@mail.gmail.com>
	<20140415124743.GD3403@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Theodore Ts'o" <tytso@mit.edu>,
	Amit Sahrawat <amit.sahrawat83@gmail.com>,
	Jan Kara <jack@suse.cz>, darrick.wong@oracle.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140415124743.GD3403@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks Ted, for the detailed reply.

We could not retain the original HDD =E2=80=93 on which we got the issu=
e. In
order to replicate the problem we did steps like this:
1)	Make 250MB partition
2)	Format the partition with blocksize =E2=80=984K=E2=80=99
3)	Using dumpe2fs =E2=80=93 get the block group information
Group 0: (Blocks 0-32767)
  Checksum 0x89ae, unused inodes 29109
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-15
  Block bitmap at 16 (+16), Inode bitmap at 32 (+32)
  Inode table at 48-957 (+48)
  26826 free blocks, 29109 free inodes, 2 directories, 29109 unused ino=
des
  Free blocks: 5942-32767
  Free inodes: 12-29120
Group 1: (Blocks 32768-58226) [INODE_UNINIT]
  Checksum 0xb43a, unused inodes 29120
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32783
  Block bitmap at 17 (bg #0 + 17), Inode bitmap at 33 (bg #0 + 33)
  Inode table at 958-1867 (bg #0 + 958)
  25443 free blocks, 29120 free inodes, 0 directories, 29120 unused ino=
des
  Free blocks: 32784-58226
  Free inodes: 29121-58240
4)	Corrupt the block group =E2=80=981=E2=80=99  by writing all =E2=80=98=
1=E2=80=99, we had one file
with all 1=E2=80=99s, so using =E2=80=98dd=E2=80=99 =E2=80=93
dd if=3Di_file of=3D/dev/sdb1 bs=3D4096 seek=3D17 count=3D1
After this mount the partition =E2=80=93 create few random size files a=
nd then
ran =E2=80=98fsstress,

fsstress -p 10 -n 100 -l 100 -d /mnt/test_dir

and we get logs like before the hang:
#fsstress -p 10 -n 100 -l 100 -d /mnt/test_dir
seed =3D 582332
EXT4-fs error (device sdb1): ext4_mb_generate_buddy:743: group 1,
20480 clusters in bitmap, 25443 in gd; block bitmap corrupt.
JBD2: Spotted dirty metadata buffer (dev =3D sdb1, blocknr =3D 0). Ther=
e's
a risk of filesystem corruption in case of system crash.

EXT4-fs (sdb1): delayed block allocation failed for inode 26 at
logical offset 181 with max blocks 2 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D51
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D9
EXT4-fs (sdb1): i_reserved_meta_blocks=3D1

EXT4-fs (sdb1): delayed block allocation failed for inode 101 at
logical offset 198 with max blocks 1 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D43
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D1
EXT4-fs (sdb1): i_reserved_meta_blocks=3D1

EXT4-fs (sdb1): delayed block allocation failed for inode 94 at
logical offset 450 with max blocks 1 with error -28
EXT4-fs (sdb1): This should not happen!! Data will be lost

EXT4-fs (sdb1): Total free blocks count 0
EXT4-fs (sdb1): Free/Dirty block details
EXT4-fs (sdb1): free_blocks=3D25443
EXT4-fs (sdb1): dirty_blocks=3D36
EXT4-fs (sdb1): Block reservation details
EXT4-fs (sdb1): i_reserved_data_blocks=3D12
EXT4-fs (sdb1): i_reserved_meta_blocks=3D2


=E2=80=A6
EXT4-fs (sdb1): error count: 3
EXT4-fs (sdb1): initial error at 545: ext4_mb_generate_buddy:743
EXT4-fs (sdb1): last error at 42: ext4_mb_generate_buddy:743
=E2=80=A6
Yes, we are running this on ARM target and we did not set the time
before running these operations. So, the time actually corresponds to
date -d @545
Thu Jan  1 05:39:05 IST 1970
date -d @42
Thu Jan  1 05:30:42 IST 1970


Yes, we are running kernel version 3.8 and applied the patches from
=E2=80=98Darrick=E2=80=99 to fix the first looping around in ext4_da_wr=
itepages.

As you suggested, we also made change to mark the FS READ ONLY in case
of corruption. The changes are;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c0fbd96..04f3a66 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1641,8 +1641,10 @@ static void mpage_da_map_and_submit(struct
mpage_da_data *mpd)
                                 mpd->b_size >> mpd->inode->i_blkbits, =
err);
                        ext4_msg(sb, KERN_CRIT,
                                "This should not happen!! Data will be =
lost\n");
-                       if (err =3D=3D -ENOSPC)
+                       if (err =3D=3D -ENOSPC) {
                                ext4_print_free_blocks(mpd->inode);
+                               mpd->inode->i_sb->s_flags |=3D MS_RDONL=
Y;
+                       }
                }
                /* invalidate all the pages */
                ext4_da_block_invalidatepages(mpd);
@@ -2303,6 +2305,36 @@ out:
        return ret;
 }

+static void ext4_invalidate_mapping(struct  address_space *mapping)
+{
+       struct pagevec pvec;
+       unsigned int i;
+       pgoff_t index =3D 0;
+       struct inode* inode =3D mapping->host;
+
+       pagevec_init(&pvec, 0);
+       while (pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG=
_DIRTY,
+                                 PAGEVEC_SIZE)) {
+               for (i =3D 0; i < pagevec_count(&pvec); i++) {
+                       struct page *page =3D pvec.pages[i];
+                       lock_page(page);
+                       spin_lock_irq(&mapping->tree_lock);
+                       if (test_bit(PG_dirty, &page->flags)) {
+                               printk(KERN_ERR"INO[%lu], i(%d)\n",
inode->i_ino, i);
+                               radix_tree_tag_clear(&mapping->page_tre=
e,
+                               page_index(page),
+                               PAGECACHE_TAG_DIRTY);
+                               spin_unlock_irq(&mapping->tree_lock);
+                               clear_page_dirty_for_io(page);
+                               goto unlock_page;
+                       }
+                       spin_unlock_irq(&mapping->tree_lock);
+unlock_page:
+                       unlock_page(page);
+               }
+               pagevec_release(&pvec);
+       }
+}
static int ext4_da_writepages(struct address_space *mapping,
                              struct writeback_control *wbc)
@@ -2419,6 +2451,14 @@ retry:
                        ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_star=
t: "
                               "%ld pages, ino %lu; err %d", __func__,
                                wbc->nr_to_write, inode->i_ino, ret);
+
+                       if(ret =3D=3D -EROFS) {
+                               ext4_msg(inode->i_sb, KERN_CRIT,"This
is probably result of corruption"
+                                                "that FS is marked RO
in between writepages\n");
+                               /*Invalidate mapping if RO encountered
during writepages */
+                                ext4_invalidate_mapping(mapping);
+                                invalidate_inode_pages2(mapping);
+                       }
                        blk_finish_plug(&plug);
                        goto out_writepages;
                }

After making these changes, as soon as there is corruption =E2=80=93 th=
e FS is
marked RO and all pending DIRTY writes are cleared. So, the hang is
not seen.

But we have a doubt about the possible side-effects of this code. Can
you please provide your inputs on this? It will be of immense help.

Thanks & Regards,
Amit Sahrawat


On Tue, Apr 15, 2014 at 6:17 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Apr 15, 2014 at 01:24:26PM +0530, Amit Sahrawat wrote:
>> Initially in normal write path, when the disk was almost full =E2=80=
=93 we got
>> hung for the =E2=80=98sync=E2=80=99 because the flusher (which is bu=
sy in the
>> writepages is not responding). Before the hung task, we also found t=
he
>> logs like:
>>
>> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1493,=
 0
>> clusters in bitmap, 58339 in gd
>> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1000,=
 0
>> clusters in bitmap, 3 in gd
>> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1425,=
 0
>> clusters in bitmap, 1 in gd
>
> These errors indicate that the several block groups contain have
> corrupt block bitmap: block group #1493, #1000, and #1425.  The fact
> that there are 0 free blocks/clusters in the bitmap indicate that the
> bitmap was all zero's, which could be the potential cause of the
> corruption.
>
> The other thing which is funny is the number of free blocks/clusters
> being greater than 32768 in block group #1493.  Assuming a 4k page
> size, that shouldn't be possible.  Can you send the output of
> "dumpe2fs -h /dev/sdXX" so we can take a look at the file system para=
meters?
>
> How much before the hung task did you see these messages?  I normally
> recommend that the file system be set up to either panic the system,
> or force the file system to be remounted read/only when EXT4-fs error
> messages are reported, since that means that the file system is
> corrupted, and further operaion can cause more data to be lost.
>
>> JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). T=
here's
>> a risk of filesystem corruption in case of system crash.
>> JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). T=
here's
>> a risk of filesystem corruption in case of system crash.
>>
>> EXT4-fs (sda1): error count: 58
>> EXT4-fs (sda1): initial error at 607: ext4_mb_generate_buddy:742
>> EXT4-fs (sda1): last error at 58: ext4_mb_generate_buddy:742
>
> The "607" and "58" in the "at 607" and "at 58" are normally supposed
> to be a unix time_t value.  That is, it's normally a number like:
> 1397564866, and it can be decoded via:
>
> % date -d @1397564866
> Tue Apr 15 08:27:46 EDT 2014
>
> The fact that these numbers are numerically so small means that the
> time wasn't set correctly on your system.  Was this a test system
> running under kvm without a proper real-time clock?
>
>> When we analysed the problem, it occurred from the writepages path i=
n ext4.
>> This is because of the difference in the free blocks reported by
>> cluster bitmap and the number of free blocks reported by group
>> descriptor.
>
> Yes, indicating that the file system was corrupt.
>
>> During ext4_fill_super, ext4 calculates the number of free blocks by
>> reading all the descriptors in function ext4_count_free_clusters and
>> store it in percpu counter s_freeclusters_counter.
>> ext4_count_free_clusters:
>> desc_count =3D 0;
>> for (i =3D 0; i < ngroups; i++) {
>> gdp =3D ext4_get_group_desc(sb, i, NULL);
>> if (!gdp)
>> continue;
>> desc_count +=3D ext4_free_group_clusters(sb, gdp);
>> }
>> return desc_count;
>>
>> During writebegin call, ext4 checks this s_freeclusters_counter
>> counter to know if there are free blocks present or not.
>> When the free blocks reported by group descriptor are greater than t=
he
>> actual free blocks reported by bitmap, a call to writebegin could
>> still succeed even if the free blocks represented by bitmaps are 0.
>
> Yes.  We used to have code that would optionally read every single
> bitmap, and verify that the descriptor counts match the values in the
> bitmap.  However, that was expensive, and wasn't a full check of all
> possible file system inconsistencies that could lead to data loss.  S=
o
> we ultimately removed this code.  If the file system is potentially
> corrupt, it is the system administrator's responsibility to force an
> fsck run to make sure the file system data structures are consistent.
>
>> When searching for the relevant problem which occurs in this path. W=
e
>> got the patch-set from =E2=80=98Darrick=E2=80=99 which revolves arou=
nd this problem.
>> ext4: error out if verifying the block bitmap fails
>> ext4: fix type declaration of ext4_validate_block_bitmap
>> ext4: mark block group as corrupt on block bitmap error
>> ext4: mark block group as corrupt on inode bitmap error
>> ext4: mark group corrupt on group descriptor checksum
>> ext4: don't count free clusters from a corrupt block group
>>
>> After adopting the patch-set and performing verification on the
>> similar setup, we ran =E2=80=98fsstress=E2=80=99. But now it is resu=
lting in hang at
>> different points.
>>
>> In the current logs we got:
>> EXT4-fs error (device sdb1): ext4_mb_generate_buddy:743: group 1,
>> 20480 clusters in bitmap, 25443 in gd; block bitmap corrupt.
>> JBD2: Spotted dirty metadata buffer (dev =3D sdb1, blocknr =3D 0). T=
here's
>> a risk of filesystem corruption in case of system crash.
>
> OK, what version of the kernel are you using?  The patches that you
> reference above have been in the upstream kernel since 3.12, so I'm
> assuming you're not using the latest upstream kernel, but rather an
> older kernel with some patches applied.  Hmmm, skipping ahead:
>
>> Kernel Version: 3.8
>> Test command:
>> fsstress -p 10 -n 100 -l 100 -d /mnt/test_dir
>
> There is clearly either some kernel bug or hardware problem which is
> causing the file system corruption.  Given that you are using a much
> older kernel, it's quite likely that there is some bug that has been
> fixed in a later version of the kernel (although we can't really rule
> out a hardware problem without know much more about your setup).
>
> Unfortunately, there has been a *large* number of changes since
> version 3.8, and I can't remember all of the changes and bug fixes
> that we might have made in the past year or more (v3.8 dates from
> March 2013).
>
> Something that might be helpful is for you to use xfstests.  That's a
> much more thorough set of tests which we've been using so if you must
> use an antique version of the kernel, that will probably be a much
> better set of tests.  It includes fsstress, and much more besides.
> More importantly, there are times when fixes are identified by the
> xfstest failure that has gotten fixed up in the commit logs.  So that
> might help you find the bug fix that you need to backport.
>
> For your convenience, there is a simple test framework that makes it
> relatively easy to build and run xfstests under KVM.  You can find it
> here:
>
>         git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git
>
> See the documentation found at:
>
>         https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/REA=
DME
>
> for more details.
>
> I hope this helps,
>
>                                                 - Ted
