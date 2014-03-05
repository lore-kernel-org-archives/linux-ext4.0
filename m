From: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Subject: Extremely slow remounts with concurrent I/O
Date: Wed, 5 Mar 2014 15:13:43 +0100
Message-ID: <20140305141343.GA26225@xanadu.blop.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xanadu.blop.info ([178.79.145.134]:43184 "EHLO xanadu.blop.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbaCEOby (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Mar 2014 09:31:54 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

TL;DR: we experience long temporary hangs when doing multiple mount -o
remount at the same time as other I/O on an ext4 filesystem.

Hi,

When starting hundreds of LXC containers simultaneously on a system, the
boot of some containers was hanging. We tracked this down to an
initscript's use of mount -o remount, which was hanging in D state.

We reproduced the problem outside of LXC, with the script available at
[0]. That script initiates 1000 mount -o remount, and performs some
writes using a big cp to the same filesystem during the remounts.

All tests are performed on a Debian jessie system, with Linux 3.12.

Note that when running the script several times in a row, the same data is
copied over and over again, probably resulting in almost no I/O thanks to
caches. That's on purpose (see below).

When things work fine, the script above takes about 100s on our test
system (with quite a lot of variation). When things go wrong, it takes up
to 600s.

When things go wrong, we see the initial I/O caused by cp, which quickly
finishes.

After that, many (often close to 1000) mount processes are hung in D state
for a *long* time. During that time, we see still some I/O on the block
device (using dstat). At [1], you will find a btrace dump of what it
happening.

At some point, some mount processes start finishing, and then slowly all
mount process terminate.

Just to give an idea of timings:
from t0 to t0+25s: cp running
from t0+25s to t0+267s: all mount processes are hung
from t0+269s to t0+408s: mount processes terminate

After doing:
echo 100 > /proc/sys/kernel/hung_task_warnings
echo 30 > /proc/sys/kernel/hung_task_timeout_secs
We get:
[ 5879.392070] INFO: task mount:8953 blocked for more than 30 seconds.
[ 5879.429616]       Tainted: G          I  3.12-1-amd64 #1
[ 5879.461434] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5879.508354] mount           D ffff88007f104380     0  8953   7954 0x00000000
[ 5879.550760]  ffff88007f104040 0000000000000086 00000000000142c0 ffff880409281fd8
[ 5879.595415]  00000000000142c0 ffff880409281fd8 ffff880409281df8 ffff880409281d90
[ 5879.640054]  ffff880409281df0 ffff88007f104040 0000000000000000 0000000000000020
[ 5879.684652] Call Trace:
[ 5879.699328]  [<ffffffff8148d969>] ? schedule_timeout+0x1f9/0x2c0
[ 5879.735318]  [<ffffffff81087a55>] ? check_preempt_curr+0x75/0x90
[ 5879.771305]  [<ffffffff81087a7f>] ? ttwu_do_wakeup+0xf/0xd0
[ 5879.804683]  [<ffffffff810898ba>] ? try_to_wake_up+0xca/0x260
[ 5879.839112]  [<ffffffff8148fc50>] ? wait_for_completion+0xa0/0x110
[ 5879.876140]  [<ffffffff81089a90>] ? wake_up_state+0x10/0x10
[ 5879.909517]  [<ffffffff81198ebc>] ? sync_inodes_sb+0x9c/0x1a0
[ 5879.943942]  [<ffffffff8119ee33>] ? sync_filesystem+0x53/0xa0
[ 5879.978385]  [<ffffffff81176bba>] ? do_remount_sb+0x4a/0x1a0
[ 5880.012319]  [<ffffffff81191d98>] ? do_mount+0x688/0xa70
[ 5880.044158]  [<ffffffff8112c268>] ? memdup_user+0x38/0x70
[ 5880.076499]  [<ffffffff811921fc>] ? SyS_mount+0x7c/0xc0
[ 5880.107791]  [<ffffffff81498fb9>] ? system_call_fastpath+0x16/0x1b
[ 5880.697315] INFO: task mount:8957 blocked for more than 30 seconds.
[ 5880.734859]       Tainted: G          I  3.12-1-amd64 #1
[ 5880.766688] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5880.813608] mount           D ffff8804062783c0     0  8957   7956 0x00000000
[ 5880.856012]  ffff880406278080 0000000000000086 00000000000142c0 ffff88040263dfd8
[ 5880.900676]  00000000000142c0 ffff88040263dfd8 ffff880406278080 ffff88040263de68
[ 5880.945281]  ffff88042d30f068 ffff88042d30f070 ffffffff00000000 ffff88042d30f078
[ 5880.989897] Call Trace:
[ 5881.004577]  [<ffffffff81490cb5>] ? rwsem_down_write_failed+0x105/0x1d0
[ 5881.044214]  [<ffffffff81271a73>] ? call_rwsem_down_write_failed+0x13/0x20
[ 5881.085403]  [<ffffffff8148ed44>] ? down_write+0x24/0x26
[ 5881.117215]  [<ffffffff811919ed>] ? do_mount+0x2dd/0xa70
[ 5881.149042]  [<ffffffff8112c268>] ? memdup_user+0x38/0x70
[ 5881.181387]  [<ffffffff811921fc>] ? SyS_mount+0x7c/0xc0
[ 5881.212684]  [<ffffffff81498fb9>] ? system_call_fastpath+0x16/0x1b

Some other things we tried:
1) we tried to 'sync' after removing the files, and dropping the caches
(as shown in the commented lines in [0]). That makes the problem disappear
(or at least makes it less frequent). The overall script execution is
actually faster with the post-rm sync and dropping caches than without
them!

2) We tried switching to the noop scheduler (instead of cfq). The problem
could still be reproduced. A btrace dump with noop is available at [2].

3) We tried with ext3 instead of ext4. The problem could never be
reproduced.

4) We tried on different machines, and we could reproduce the problem.
However, on a machine with SSD drives, we were not able to reproduce the
problem.

Any ideas?

[0] http://blop.info/p/20140305-ext4-mount-remount.rb
[1] http://blop.info/p/20140305-ext4-mount-btrace.log
[2] http://blop.info/p/20140305-ext4-mount-btrace-noop.log.gz
-- 
Lucas Nussbaum and Emmanuel Jeanvoine
