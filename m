From: Xiang Wang <xiangw@google.com>
Subject: Re: [PATCH, RFC -V2 1/4] ext4: Add configurable run-time mballoc
	debugging
Date: Tue, 11 Aug 2009 11:15:53 -0700
Message-ID: <d5ca277e0908111115g4274b419g490bc453eaf6e1bd@mail.gmail.com>
References: <1249874635-24250-1-git-send-email-tytso@mit.edu>
	 <1249874635-24250-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Alex Tomas <bzzz@sun.com>, Curt Wohlgemuth <curtw@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:30031 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZHKSQC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 14:16:02 -0400
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id n7BIFwHr028327
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 19:16:00 +0100
Received: from yxe32 (yxe32.prod.google.com [10.190.2.32])
	by wpaz13.hot.corp.google.com with ESMTP id n7BIFtu6012092
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 11:15:56 -0700
Received: by yxe32 with SMTP id 32so13572508yxe.6
        for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 11:15:55 -0700 (PDT)
In-Reply-To: <1249874635-24250-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I tried to apply this patch to our kernel, but I encountered some
problems in building the kernel:

=46ATAL: fs/ext4/ext4.o(.text+0x24f2d): Section mismatch in reference
from the function exit_ext4_mballoc() to the function
=2Eexit.text:ext4_remove_debugfs_entry()

Looking at the code, the problem seems to be that, exit_ext4_mballoc
calls ext4_remove_debugfs_entry. And ext4_remove_debugfs_entry has the
"__exit" annotation while exit_ext4_mballoc does not. I tried removing
the "__exit" annotation from ext4_remove_debugfs_entry and it builds
well.

I am wondering whether you have seen any similar problems.

Thanks,
Xiang

On Sun, Aug 9, 2009 at 8:23 PM, Theodore Ts'o<tytso@mit.edu> wrote:
> Allow mballoc debugging to be enabled at run-time instead of just at
> compile time.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0fs/ext4/Kconfig =A0 | =A0 =A09 ++++++
> =A0fs/ext4/mballoc.c | =A0 81 ++++++++++++++++++++++++++++++++++++++-=
-------------
> =A0fs/ext4/mballoc.h | =A0 16 ++++++++--
> =A03 files changed, 80 insertions(+), 26 deletions(-)
>
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index 1523046..d5c0ea2 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -77,3 +77,12 @@ config EXT4_FS_SECURITY
>
> =A0 =A0 =A0 =A0 =A0If you are not using a security module that requir=
es using
> =A0 =A0 =A0 =A0 =A0extended attributes for file security labels, say =
N.
> +
> +config EXT4_DEBUG
> + =A0 =A0 =A0 bool "EXT4 debugging support"
> + =A0 =A0 =A0 depends on EXT4_FS
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 =A0 Enables run-time debugging support for the ext4 fil=
esystem.
> +
> + =A0 =A0 =A0 =A0 If you select Y here, then you will be able to turn=
 on debugging
> + =A0 =A0 =A0 =A0 with a command such as "echo 1 > /sys/kernel/debug/=
ext4/mballoc-debug"
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 68cde59..2c81240 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -22,6 +22,7 @@
> =A0*/
>
> =A0#include "mballoc.h"
> +#include <linux/debugfs.h>
> =A0#include <trace/events/ext4.h>
>
> =A0/*
> @@ -743,7 +744,7 @@ static int ext4_mb_init_cache(struct page *page, =
char *incore)
> =A0 =A0 =A0 =A0char *data;
> =A0 =A0 =A0 =A0char *bitmap;
>
> - =A0 =A0 =A0 mb_debug("init page %lu\n", page->index);
> + =A0 =A0 =A0 mb_debug(1, "init page %lu\n", page->index);
>
> =A0 =A0 =A0 =A0inode =3D page->mapping->host;
> =A0 =A0 =A0 =A0sb =3D inode->i_sb;
> @@ -822,7 +823,7 @@ static int ext4_mb_init_cache(struct page *page, =
char *incore)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bitmap_uptodate(bh[i]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh[i]->b_end_io =3D end_buffer_read_sy=
nc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0submit_bh(READ, bh[i]);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug("read bitmap for group %u\n", =
first_group + i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug(1, "read bitmap for group %u\n=
", first_group + i);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* wait for I/O completion */
> @@ -862,7 +863,7 @@ static int ext4_mb_init_cache(struct page *page, =
char *incore)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((first_block + i) & 1) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* this is block of bu=
ddy */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(incore =3D=3D N=
ULL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug("put buddy for=
 group %u in page %lu/%x\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug(1, "put buddy =
for group %u in page %lu/%x\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0group,=
 page->index, i * blocksize);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0grinfo =3D ext4_get_gr=
oup_info(sb, group);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0grinfo->bb_fragments =3D=
 0;
> @@ -878,7 +879,7 @@ static int ext4_mb_init_cache(struct page *page, =
char *incore)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* this is block of bi=
tmap */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(incore !=3D NUL=
L);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug("put bitmap fo=
r group %u in page %lu/%x\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug(1, "put bitmap=
 for group %u in page %lu/%x\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0group,=
 page->index, i * blocksize);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* see comments in ext=
4_mb_put_pa() */
> @@ -922,7 +923,7 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_g=
roup_t group,
> =A0 =A0 =A0 =A0struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> =A0 =A0 =A0 =A0struct inode *inode =3D sbi->s_buddy_cache;
>
> - =A0 =A0 =A0 mb_debug("load group %u\n", group);
> + =A0 =A0 =A0 mb_debug(1, "load group %u\n", group);
>
> =A0 =A0 =A0 =A0blocks_per_page =3D PAGE_CACHE_SIZE / sb->s_blocksize;
> =A0 =A0 =A0 =A0grp =3D ext4_get_group_info(sb, group);
> @@ -1851,7 +1852,7 @@ int ext4_mb_init_group(struct super_block *sb, =
ext4_group_t group)
> =A0 =A0 =A0 =A0struct inode *inode =3D sbi->s_buddy_cache;
> =A0 =A0 =A0 =A0struct page *page =3D NULL, *bitmap_page =3D NULL;
>
> - =A0 =A0 =A0 mb_debug("init group %u\n", group);
> + =A0 =A0 =A0 mb_debug(1, "init group %u\n", group);
> =A0 =A0 =A0 =A0blocks_per_page =3D PAGE_CACHE_SIZE / sb->s_blocksize;
> =A0 =A0 =A0 =A0this_grp =3D ext4_get_group_info(sb, group);
> =A0 =A0 =A0 =A0/*
> @@ -2739,7 +2740,7 @@ static void ext4_mb_cleanup_pa(struct ext4_grou=
p_info *grp)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kmem_cache_free(ext4_pspace_cachep, pa=
);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (count)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug("mballoc: %u PAs left\n", coun=
t);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug(1, "mballoc: %u PAs left\n", c=
ount);
>
> =A0}
>
> @@ -2820,7 +2821,7 @@ static void release_blocks_on_commit(journal_t =
*journal, transaction_t *txn)
> =A0 =A0 =A0 =A0list_for_each_safe(l, ltmp, &txn->t_private_list) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry =3D list_entry(l, struct ext4_fr=
ee_data, list);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug("gonna free %u blocks in group=
 %u (0x%p):",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug(1, "gonna free %u blocks in gr=
oup %u (0x%p):",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry->count, entry->=
group, entry);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_mb_load_buddy(sb, entry->=
group, &e4b);
> @@ -2855,9 +2856,43 @@ static void release_blocks_on_commit(journal_t=
 *journal, transaction_t *txn)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_mb_release_desc(&e4b);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 mb_debug("freed %u blocks in %u structures\n", count, c=
ount2);
> + =A0 =A0 =A0 mb_debug(1, "freed %u blocks in %u structures\n", count=
, count2);
> =A0}
>
> +#ifdef CONFIG_EXT4_DEBUG
> +u8 mb_enable_debug __read_mostly;
> +
> +static struct dentry *debugfs_dir;
> +static struct dentry *debugfs_debug;
> +
> +static void __init ext4_create_debugfs_entry(void)
> +{
> + =A0 =A0 =A0 debugfs_dir =3D debugfs_create_dir("ext4", NULL);
> + =A0 =A0 =A0 if (debugfs_dir)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 debugfs_debug =3D debugfs_create_u8("mb=
alloc-debug",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 S_IRUGO | S_IWUSR,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 debugfs_dir,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &mb_enable_debug);
> +}
> +
> +static void __exit ext4_remove_debugfs_entry(void)
> +{
> + =A0 =A0 =A0 debugfs_remove(debugfs_debug);
> + =A0 =A0 =A0 debugfs_remove(debugfs_dir);
> +}
> +
> +#else
> +
> +static void __init ext4_create_debugfs_entry(void)
> +{
> +}
> +
> +static void __exit ext4_remove_debugfs_entry(void)
> +{
> +}
> +
> +#endif
> +
> =A0int __init init_ext4_mballoc(void)
> =A0{
> =A0 =A0 =A0 =A0ext4_pspace_cachep =3D
> @@ -2885,6 +2920,7 @@ int __init init_ext4_mballoc(void)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kmem_cache_destroy(ext4_ac_cachep);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 ext4_create_debugfs_entry();
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> @@ -2898,6 +2934,7 @@ void exit_ext4_mballoc(void)
> =A0 =A0 =A0 =A0kmem_cache_destroy(ext4_pspace_cachep);
> =A0 =A0 =A0 =A0kmem_cache_destroy(ext4_ac_cachep);
> =A0 =A0 =A0 =A0kmem_cache_destroy(ext4_free_ext_cachep);
> + =A0 =A0 =A0 ext4_remove_debugfs_entry();
> =A0}
>
>
> @@ -3042,7 +3079,7 @@ static void ext4_mb_normalize_group_request(str=
uct ext4_allocation_context *ac)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ac->ac_g_ex.fe_len =3D EXT4_SB(sb)->s_=
stripe;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ac->ac_g_ex.fe_len =3D EXT4_SB(sb)->s_=
mb_group_prealloc;
> - =A0 =A0 =A0 mb_debug("#%u: goal %u blocks for locality group\n",
> + =A0 =A0 =A0 mb_debug(1, "#%u: goal %u blocks for locality group\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current->pid, ac->ac_g_ex.fe_len);
> =A0}
>
> @@ -3232,7 +3269,7 @@ ext4_mb_normalize_request(struct ext4_allocatio=
n_context *ac,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ac->ac_flags |=3D EXT4_MB_HINT_TRY_GOA=
L;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 mb_debug("goal: %u(was %u) blocks at %u\n", (unsigned) =
size,
> + =A0 =A0 =A0 mb_debug(1, "goal: %u(was %u) blocks at %u\n", (unsigne=
d) size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned) orig_size, (unsigned) start=
);
> =A0}
>
> @@ -3281,7 +3318,7 @@ static void ext4_mb_use_inode_pa(struct ext4_al=
location_context *ac,
> =A0 =A0 =A0 =A0BUG_ON(pa->pa_free < len);
> =A0 =A0 =A0 =A0pa->pa_free -=3D len;
>
> - =A0 =A0 =A0 mb_debug("use %llu/%u from inode pa %p\n", start, len, =
pa);
> + =A0 =A0 =A0 mb_debug(1, "use %llu/%u from inode pa %p\n", start, le=
n, pa);
> =A0}
>
> =A0/*
> @@ -3305,7 +3342,7 @@ static void ext4_mb_use_group_pa(struct ext4_al=
location_context *ac,
> =A0 =A0 =A0 =A0 * in on-disk bitmap -- see ext4_mb_release_context()
> =A0 =A0 =A0 =A0 * Other CPUs are prevented from allocating from this =
pa by lg_mutex
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 mb_debug("use %u/%u from group pa %p\n", pa->pa_lstart-=
len, len, pa);
> + =A0 =A0 =A0 mb_debug(1, "use %u/%u from group pa %p\n", pa->pa_lsta=
rt-len, len, pa);
> =A0}
>
> =A0/*
> @@ -3484,7 +3521,7 @@ void ext4_mb_generate_from_pa(struct super_bloc=
k *sb, void *bitmap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0preallocated +=3D len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count++;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 mb_debug("prellocated %u for group %u\n", preallocated,=
 group);
> + =A0 =A0 =A0 mb_debug(1, "prellocated %u for group %u\n", preallocat=
ed, group);
> =A0}
>
> =A0static void ext4_mb_pa_callback(struct rcu_head *head)
> @@ -3619,7 +3656,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_con=
text *ac)
> =A0 =A0 =A0 =A0pa->pa_deleted =3D 0;
> =A0 =A0 =A0 =A0pa->pa_type =3D MB_INODE_PA;
>
> - =A0 =A0 =A0 mb_debug("new inode pa %p: %llu/%u for %u\n", pa,
> + =A0 =A0 =A0 mb_debug(1, "new inode pa %p: %llu/%u for %u\n", pa,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pa->pa_pstart, pa->pa_=
len, pa->pa_lstart);
> =A0 =A0 =A0 =A0trace_ext4_mb_new_inode_pa(ac, pa);
>
> @@ -3679,7 +3716,7 @@ ext4_mb_new_group_pa(struct ext4_allocation_con=
text *ac)
> =A0 =A0 =A0 =A0pa->pa_deleted =3D 0;
> =A0 =A0 =A0 =A0pa->pa_type =3D MB_GROUP_PA;
>
> - =A0 =A0 =A0 mb_debug("new group pa %p: %llu/%u for %u\n", pa,
> + =A0 =A0 =A0 mb_debug(1, "new group pa %p: %llu/%u for %u\n", pa,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pa->pa_pstart, pa->pa_=
len, pa->pa_lstart);
> =A0 =A0 =A0 =A0trace_ext4_mb_new_group_pa(ac, pa);
>
> @@ -3758,7 +3795,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b=
, struct buffer_head *bitmap_bh,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0next =3D mb_find_next_bit(bitmap_bh->b=
_data, end, bit);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0start =3D group * EXT4_BLOCKS_PER_GROU=
P(sb) + bit +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le32_t=
o_cpu(sbi->s_es->s_first_data_block);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug(" =A0 =A0free preallocated %u/=
%u in group %u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_debug(1, " =A0 =A0free preallocated =
%u/%u in group %u\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsig=
ned) start, (unsigned) next - bit,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsig=
ned) group);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free +=3D next - bit;
> @@ -3849,7 +3886,7 @@ ext4_mb_discard_group_preallocations(struct sup=
er_block *sb,
> =A0 =A0 =A0 =A0int busy =3D 0;
> =A0 =A0 =A0 =A0int free =3D 0;
>
> - =A0 =A0 =A0 mb_debug("discard preallocation for group %u\n", group)=
;
> + =A0 =A0 =A0 mb_debug(1, "discard preallocation for group %u\n", gro=
up);
>
> =A0 =A0 =A0 =A0if (list_empty(&grp->bb_prealloc_list))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> @@ -3973,7 +4010,7 @@ void ext4_discard_preallocations(struct inode *=
inode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 mb_debug("discard preallocation for inode %lu\n", inode=
->i_ino);
> + =A0 =A0 =A0 mb_debug(1, "discard preallocation for inode %lu\n", in=
ode->i_ino);
> =A0 =A0 =A0 =A0trace_ext4_discard_preallocations(inode);
>
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&list);
> @@ -4078,7 +4115,7 @@ static void ext4_mb_return_to_preallocation(str=
uct inode *inode,
> =A0{
> =A0 =A0 =A0 =A0BUG_ON(!list_empty(&EXT4_I(inode)->i_prealloc_list));
> =A0}
> -#ifdef MB_DEBUG
> +#ifdef CONFIG_EXT4_DEBUG
> =A0static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
> =A0{
> =A0 =A0 =A0 =A0struct super_block *sb =3D ac->ac_sb;
> @@ -4227,7 +4264,7 @@ ext4_mb_initialize_context(struct ext4_allocati=
on_context *ac,
> =A0 =A0 =A0 =A0 * locality group. this is a policy, actually */
> =A0 =A0 =A0 =A0ext4_mb_group_or_file(ac);
>
> - =A0 =A0 =A0 mb_debug("init ac: %u blocks @ %u, goal %u, flags %x, 2=
^%d, "
> + =A0 =A0 =A0 mb_debug(1, "init ac: %u blocks @ %u, goal %u, flags %x=
, 2^%d, "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"left: %u/%u, right %u=
/%u to %swritable\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned) ar->len, (u=
nsigned) ar->logical,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned) ar->goal, a=
c->ac_flags, ac->ac_2order,
> @@ -4249,7 +4286,7 @@ ext4_mb_discard_lg_preallocations(struct super_=
block *sb,
> =A0 =A0 =A0 =A0struct ext4_prealloc_space *pa, *tmp;
> =A0 =A0 =A0 =A0struct ext4_allocation_context *ac;
>
> - =A0 =A0 =A0 mb_debug("discard locality group preallocation\n");
> + =A0 =A0 =A0 mb_debug(1, "discard locality group preallocation\n");
>
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&discard_list);
> =A0 =A0 =A0 =A0ac =3D kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
> index c96bb19..28abb02 100644
> --- a/fs/ext4/mballoc.h
> +++ b/fs/ext4/mballoc.h
> @@ -37,11 +37,19 @@
>
> =A0/*
> =A0*/
> -#define MB_DEBUG__
> -#ifdef MB_DEBUG
> -#define mb_debug(fmt, a...) =A0 =A0printk(fmt, ##a)
> +#ifdef CONFIG_EXT4_DEBUG
> +extern u8 mb_enable_debug;
> +
> +#define mb_debug(n, fmt, a...) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 do { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((n) <=3D mb_enable_debug) { =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk (KERN_DEBUG "(%s=
, %d): %s: ", =A0 =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __FILE_=
_, __LINE__, __func__); =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk (fmt, ## a); =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 } while (0)
> =A0#else
> -#define mb_debug(fmt, a...)
> +#define mb_debug(n, fmt, a...)
> =A0#endif
>
> =A0/*
> --
> 1.6.3.2.1.gb9f7d.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
