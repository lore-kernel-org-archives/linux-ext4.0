From: Bernd Schubert <bs@q-leap.de>
Subject: possible endless loop in ext4_mb_discard_group_preallocations()
Date: Fri, 6 Feb 2009 02:25:21 +0100
Message-ID: <200902060225.23162.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: bs_lists@aakef.fastmail.fm, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:33297 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZBFBZ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 20:25:28 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

actually I run into an endless loop in Lustres ldiskfs, but the code is very 
similar, so it also might be present in ext4. For those who are interested to 
read lustre bug reports, please see here: 
https://bugzilla.lustre.org/show_bug.cgi?id=16984

Unfortunately I have never been able to reproduce this directly on ldiskfs or 
ext4, so far the reproducer ('stress') only works on a real lustre 
filesystem.

In ext4_mb_discard_group_preallocations() there is a repeat loop

repeat:
        ext4_lock_group(sb, group);
        list_for_each_entry_safe(pa, tmp,
                                &grp->bb_prealloc_list, pa_group_list) {
                spin_lock(&pa->pa_lock);
                if (atomic_read(&pa->pa_count)) {
                        spin_unlock(&pa->pa_lock);
                        busy = 1;
                        continue;
                }
		...
	}

        /* if we still need more blocks and some PAs were used, try again */
        if (free < needed && busy) {
                busy = 0;
                ext4_unlock_group(sb, group);
                /*
                 * Yield the CPU here so that we don't get soft lockup
                 * in non preempt case.
                 */
                yield();
                goto repeat;
        }

Aren't repeat-loop somehow the style of about 30 years ago? Anyway, somehow 
the i/o pattern of Lustre manages, that it never goes out of this loop.
Unfortunately, after several thousand repeats it then locks up entirely at one 
of the spin_locks, which is nearly impossible to debug with Lustre, since it 
it doesn't allow to run lockdep.

The calling chain is (reverse order as in traces)

ext4_mb_discard_group_preallocations
ext4_mb_discard_preallocations()
ext4_mb_new_blocks()

Now in ext4_mb_new_blocks() is another repeat-loop, which will run, if 
ext4_mb_discard_group_preallocations() could free a sufficient number of 
blocks. So I simply removed the loop in 
ext4_mb_discard_group_preallocations() and all our problems where gone. This 
now leaves two questions:

1) Is it safe to to remove this second repeat-loop. As far as I can see, it 
seems so.

2) Wouldn't it make sense to run ext4_mb_discard_group_preallocations() in an 
extra thread, which would free unused preallocations, lets say after 60s? In 
our Lustre case it seems to me, that at about 60% disk usage, the other 40% 
had been take by preallocations. At least at about 60% the filesystem started 
to run ext4_mb_discard_group_preallocations().


Thanks,
Bernd


PS: I think by removing the 2nd loop in ext4_mb_discard_group_preallocations() 
the spin_lock problem is not solved, just the probability is reduced. But 
untill all the lockdep problems in Lustre are solved, I don't see how to 
debug this (at least not without a huge number of printks).


-- 
Bernd Schubert
Q-Leap Networks GmbH
