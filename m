Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E0B3A48D9;
	Wed,  2 Sep 2026 10:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788343844; cv=none; b=UGaGB2L5qk5U1OPtrMVWM4qHxML6i2oZ+QNmYY3fLA8x9HSXFfcwBFJOVxIWGztr/30eUTObAX/TFTfMMYPN4NS7EAvaI3iZTakBbejTra5+AWmmKZBgcwvVt8JPtZTanBJzja+y52dWWPDYyiohruW8cl5V9y8TmCfmlF4HONI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788343844; c=relaxed/simple;
	bh=S2Fgo2+0uDUQRVnyX93VSUZe+ONxffN7rdt7J6o3miY=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=Wzon0ieGKLVhOYh5PA6KPA1NjP5dmTY28XODY7prdcYyW90IFWpdq4T9DxRVkrSXM2140blzrTrJlQkOuJcH25pZFTcdo1x8dqwShkkPOXbsb+Pii0pg88G+ks2dG26ecdA4pJUlsZQgTevuqKMKjvXzUh4vq0vSfQsA42JjseE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.helo=mail.mainlining.org; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.helo=mail.mainlining.org
Date: Wed, 02 Sep 2026 11:09:15 +0100
From: Bradley Morgan <brads@mainlining.org>
To: ruanjinjie@huawei.com
CC: adilger.kernel@dilger.ca, akpm@linux-foundation.org,
 andriy.shevchenko@linux.intel.com, bcrl@kvack.org, brauner@kernel.org,
 jack@suse.cz, kees@kernel.org, libaokun@linux.alibaba.com,
 linux-aio@kvack.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux@rasmusvillemoes.dk, ojaswin@linux.ibm.com, pmladek@suse.com,
 ritesh.list@gmail.com, rostedt@goodmis.org, senozhatsky@chromium.org,
 sforshee@kernel.org, tglx@kernel.org, tytso@mit.edu, viro@zeniv.linux.org.uk,
 yi.zhang@huawei.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_1/8=5D_user=5Fnamespace=3A_Use_acq?=
 =?US-ASCII?Q?uire/release_for_nr=5Fextents_synchronization?=
In-Reply-To: <20260902074805.398540-2-ruanjinjie@huawei.com>
Message-ID: <0303FE1D-8F56-4C18-87DA-9C3BBF2D43AE@mainlining.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 2 September 2026 08:47:58 BST, Jinjie Ruan <ruanjinjie@huawei.com>
wrote:
>Replace smp_wmb()/smp_rmb() with smp_store_release()/smp_load_acquire()
>when publishing and consuming `nr_extents`. This expresses the
>publish/subscribe pattern more clearly and allows architectures with
>native acquire/release instructions (e.g. arm64's STLR/LDAR) to avoid
>the cost of full one-way barriers (DMB ISHST/ISHLD).
>
>No functional change intended.
>
>Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>Cc: Christian Brauner <brauner@kernel.org>
>Cc: Jan Kara <jack@suse.cz>
>Cc: Seth Forshee <sforshee@kernel.org>
>Cc: Kees Cook <kees@kernel.org>
>Cc: Aleksa Sarai <cyphar@cyphar.com>
>Assisted-by: DeepSeek:DeepSeek-V3

LGTM, thanks

Reviewed-by: Bradley Morgan <brads@mainlining.org>


>Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>---
>v2:
>- Add missing load replace in copy_mnt_idmap()
>---
> fs/mnt_idmapping.c      |  5 ++---
> kernel/user_namespace.c | 24 +++++++++++++-----------
> 2 files changed, 15 insertions(+), 14 deletions(-)
>
>diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
>index cb61fbdb52e9..612b266ab3da 100644
>--- a/fs/mnt_idmapping.c
>+++ b/fs/mnt_idmapping.c
>@@ -219,10 +219,9 @@ EXPORT_SYMBOL_GPL(vfsgid_in_group_p);
> static int copy_mnt_idmap(struct uid_gid_map *map_from,
> 			  struct uid_gid_map *map_to)
> {
>+	/* Pairs with smp_store_release() in map_write(). */
>+	u32 nr_extents = smp_load_acquire(&map_from->nr_extents);
> 	struct uid_gid_extent *forward, *reverse;
>-	u32 nr_extents = READ_ONCE(map_from->nr_extents);
>-	/* Pairs with smp_wmb() when writing the idmapping. */
>-	smp_rmb();
> 
> 	/*
> 	 * Don't blindly copy @map_to into @map_from if nr_extents is
>diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
>index 0bed462e9b2a..576b667a8813 100644
>--- a/kernel/user_namespace.c
>+++ b/kernel/user_namespace.c
>@@ -317,9 +317,9 @@ map_id_range_down_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 co
> 
> static u32 map_id_range_down(struct uid_gid_map *map, u32 id, u32 count)
> {
>+	/* Pairs with smp_store_release() in map_write(). */
>+	unsigned int extents = smp_load_acquire(&map->nr_extents);
> 	struct uid_gid_extent *extent;
>-	unsigned extents = map->nr_extents;
>-	smp_rmb();
> 
> 	if (extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
> 		extent = map_id_range_down_base(extents, map, id, count);
>@@ -383,9 +383,9 @@ map_id_range_up_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 count
> 
> u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count)
> {
>+	/* Pairs with smp_store_release() in map_write(). */
>+	unsigned int extents = smp_load_acquire(&map->nr_extents);
> 	struct uid_gid_extent *extent;
>-	unsigned extents = map->nr_extents;
>-	smp_rmb();
> 
> 	if (extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
> 		extent = map_id_range_up_base(extents, map, id, count);
>@@ -676,9 +676,9 @@ static int projid_m_show(struct seq_file *seq, void *v)
> static void *m_start(struct seq_file *seq, loff_t *ppos,
> 		     struct uid_gid_map *map)
> {
>+	/* Pairs with smp_store_release() in map_write(). */
>+	unsigned int extents = smp_load_acquire(&map->nr_extents);
> 	loff_t pos = *ppos;
>-	unsigned extents = map->nr_extents;
>-	smp_rmb();
> 
> 	if (pos >= extents)
> 		return NULL;
>@@ -967,9 +967,11 @@ static ssize_t map_write(struct file *file, const char __user *buf,
> 	 * desired behavior is to see the values of the extents that
> 	 * were written before the count of the extents.
> 	 *
>-	 * To achieve this smp_wmb() is used on guarantee the write
>-	 * order and smp_rmb() is guaranteed that we don't have crazy
>-	 * architectures returning stale data.
>+	 * The nr_extents field is the publish point for the extent
>+	 * data.  Writers use smp_store_release() to ensure all extent
>+	 * data is visible before nr_extents is updated.  Readers use
>+	 * smp_load_acquire() to ensure they see a consistent view of
>+	 * the extent data when reading nr_extents.
> 	 */
> 	mutex_lock(&userns_state_mutex);
> 
>@@ -1098,8 +1100,8 @@ static ssize_t map_write(struct file *file, const char __user *buf,
> 		map->forward = new_map.forward;
> 		map->reverse = new_map.reverse;
> 	}
>-	smp_wmb();
>-	map->nr_extents = new_map.nr_extents;
>+	/* Pairs with smp_load_acquire() in map_id_range_{up,down}() and m_start(). */
>+	smp_store_release(&map->nr_extents, new_map.nr_extents);
> 
> 	*ppos = count;
> 	ret = count;
>

--- Thanks!
https://lore.kernel.org/all/EE579805-42F2-4C58-B752-F28779EEB717@grrlz.net/
