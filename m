From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 72181] New: ext4_mb_generate_buddy:free block calculation seems
 to overflow
Date: Sun, 16 Mar 2014 04:17:02 +0000
Message-ID: <bug-72181-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46552 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaCPERG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Mar 2014 00:17:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2A697202AE
	for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2014 04:17:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0AD4120268
	for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2014 04:17:03 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=72181

            Bug ID: 72181
           Summary: ext4_mb_generate_buddy:free block calculation seems to
                    overflow
           Product: File System
           Version: 2.5
    Kernel Version: 3.2
          Hardware: IA-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: zweiustc@gmail.com
        Regression: No

>From the log, I notice three messages like below:
kernel: EXT4-fs error (device sdc1): ext4_mb_generate_buddy:727: group
313828953 clusters in bitmap, 28952 in gd
kernel: EXT4-fs error (device sdc1): ext4_mb_generate_buddy:727: group
313722764 clusters in bitmap, 22762 in gd
kernel: EXT4-fs error (device sdc1): ext4_mb_generate_buddy:727: group
321819941 clusters in bitmap, 19940 in gd

I have used the patch with the commit number of
b0dd6b70f0fda17ae9762fbb72d98e40a4f66556 (ext4: fix the free blocks calculation
for ext3 file systems w/ uninit_bg) 

However, I think this is another problem. Because the free block calculated
form bitmap is much larger than 32768 while clusters per group is 32768(I added
some code in e2fsprogs and have confirmed the cluster size).

Analyze the code, it seems impossible and confused me. I think the freeblock
it's to no way to be larger than max(32768). Maybe the function
(mb_find_next_bit && mb_find_next_zero_bit) return a int type value  while
"free " is  unsigned may cause such a problem? I can't confirm.

attachment:
........................................................................
static noinline_for_stack
void ext4_mb_generate_buddy(struct super_block *sb,
                void *buddy, void *bitmap, ext4_group_t group)
{
    struct ext4_group_info *grp = ext4_get_group_info(sb, group);
    ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
    ext4_grpblk_t i = 0;
    ext4_grpblk_t first;
    ext4_grpblk_t len;
    unsigned free = 0;
    unsigned fragments = 0;
    unsigned long long period = get_cycles();

    /* initialize buddy from bitmap which is aggregation
     * of on-disk bitmap and preallocations */
    i = mb_find_next_zero_bit(bitmap, max, 0);
    grp->bb_first_free = i;
    while (i < max) {
        fragments++;
        first = i;
        i = mb_find_next_bit(bitmap, max, i);
        len = i - first;
        free += len;
        if (len > 1)
            ext4_mb_mark_free_simple(sb, buddy, first, len, grp);
        else
            grp->bb_counters[0]++;
        if (i < max)
            i = mb_find_next_zero_bit(bitmap, max, i);
    }
    grp->bb_fragments = fragments;

    if (free != grp->bb_free) {
        ext4_grp_locked_error(sb, group, 0, 0,
                      "%u clusters in bitmap, %u in gd",
                      free, grp->bb_free);
        /*
         * If we intent to continue, we consider group descritor
         * corrupt and update bb_free using bitmap value
         */
        grp->bb_free = free;
    }
.........................................................
static inline int mb_find_next_bit(void *addr, int max, int start)
{
    int fix = 0, ret, tmpmax;
    addr = mb_correct_addr_and_bit(&fix, addr);
    tmpmax = max + fix;
    start += fix;

    ret = ext4_find_next_bit(addr, tmpmax, start) - fix;
    if (ret > max)
        return max;
    return ret;
}
............................................................
static inline int mb_find_next_zero_bit(void *addr, int max, int start)
{
    int fix = 0, ret, tmpmax;
    addr = mb_correct_addr_and_bit(&fix, addr);
    tmpmax = max + fix;
    start += fix;

    ret = ext4_find_next_zero_bit(addr, tmpmax, start) - fix;
    if (ret > max)
        return max;
    return ret;
}
..............................................
#define ext4_find_next_zero_bit        ext2_find_next_zero_bit
#define ext4_find_next_bit        ext2_find_next_bit

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
