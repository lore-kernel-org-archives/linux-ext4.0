From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] Add basic BIGALLOC support for cluster-based allocation
Date: Mon, 28 Feb 2011 11:18:28 +0200
Message-ID: <AANLkTinx13sLiOpV=VG1T5JZd4G81fYFLXQRKfXnqsJB@mail.gmail.com>
References: <1298688625-19820-1-git-send-email-tytso@mit.edu>
	<AANLkTi=b8eKuiOPxUiJYaDCzu1nJ40SxNqszxONC3CZ8@mail.gmail.com>
	<20110227215947.GI2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34449 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1B1JS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Feb 2011 04:18:29 -0500
Received: by qyk7 with SMTP id 7so2080502qyk.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 01:18:28 -0800 (PST)
In-Reply-To: <20110227215947.GI2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 27, 2011 at 11:59 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sat, Feb 26, 2011 at 09:20:55AM +0200, Amir Goldstein wrote:
>> Just to be clear, my alternative suggestion to on-disk format change=
 was:
>>
>> =A0 =A0 =A0 =A0 __u32 =A0 s_log_block_size; =A0 =A0 =A0 /* Block siz=
e */
>> - =A0 =A0 =A0 __s32 =A0 s_log_frag_size; =A0 =A0 =A0 =A0/* Fragment =
size */
>> + =A0 =A0 =A0 __s32 =A0 s_log_cluster_size; =A0 =A0 /* Allocation cl=
uster size */
>> - =A0 =A0 =A0 __u32 =A0 s_blocks_per_group; =A0 =A0 /* # Blocks per =
group */
>> + =A0 =A0 =A0 __u32 =A0 s_clusters_per_group; =A0 /* # Clusters per =
group */
>> - =A0 =A0 =A0 __u32 =A0 s_frags_per_group; =A0 =A0 =A0/* # Fragments=
 per group */
>> + =A0 =A0 =A0 __u32 =A0 s_blocks_per_group; =A0 /* # Blocks per grou=
p */
>> =A0 =A0 =A0 =A0 __u32 =A0 s_inodes_per_group; =A0 =A0 /* # Inodes pe=
r group */
>>
>> This way, old kernels see a sane value in what used to be
>> s_blocks_per_group (32K) and new kernels (even without the BIGALLOC
>> feature) make sure to write correct values in both new
>> s_blocks_per_group and s_clusters_per_group (old s_blocks_per_group)
>
> Unfortunately, that's likely to confuse old kernels even more, since
> s_blocks_per_group is used to calculate the number of block groups,
> i.e. s_blocks_count / s_blocks_per_group. =A0In BIGALLOC mode, the
> number of block groups go down, and so if we change s_blocks_per_grou=
p
> to s_clusters_per_group, it's likely to cause much mischief, for
> example in ext4_check_descriptors().
>

I see..., I guess if we bite the bullet and "waste" an alloc cluster fo=
r every
block bitmap and every inode bitmap, than we could also "waste" some di=
sk
space on dummy group descriptors to leave old kernels in blissful ignor=
ance
(mischief rules!).

Another comment about the design:

It only states that ext4_map_blocks() and downstream functions need to =
be
aware of the new allocation rules, but I suspect that ext4_truncate() a=
nd
downstream functions will also need to take the new rules into account
(i.e. don't 'free' a cluster until all blocks have been freed).
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
