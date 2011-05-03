From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 34302] New: Errors from kjournald
Date: Tue, 3 May 2011 13:30:46 GMT
Message-ID: <bug-34302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:33616 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1ECNaq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 09:30:46 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p43DUkD2004751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 13:30:46 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=34302

           Summary: Errors from kjournald
           Product: File System
           Version: 2.5
    Kernel Version: linux-2.6-2.6.32/debian
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: tmoore@spatial.ca
        Regression: No


I am occasionally finding errors in syslog.  Is this something that I should be
worrying about?  Does this indicate a hardware problem, or is this a kernel
problem?  

I am running on the latest amd64 kernel from debian squeeze.

Here are the messages:

ay  3 01:02:25 fawkes kernel: [307200.700513] kjournald     D 0000000000000000 
   0  6416      2 0x00000000
May  3 01:02:25 fawkes kernel: [307200.700524]  ffff88021f083880
0000000000000046 0000000000000000 ffffffff8117628c
May  3 01:02:25 fawkes kernel: [307200.700534]  ffff88021cec1e30
ffff88021c6811a0 000000000000f9e0 ffff8801fc6d7fd8
May  3 01:02:25 fawkes kernel: [307200.700542]  0000000000015780
0000000000015780 ffff8801fa1eb170 ffff8801fa1eb468
May  3 01:02:25 fawkes kernel: [307200.700551] Call Trace:
May  3 01:02:25 fawkes kernel: [307200.700566]  [<ffffffff8117628c>] ?
elv_merged_request+0x30/0x39
May  3 01:02:25 fawkes kernel: [307200.700577]  [<ffffffff8106c403>] ?
ktime_get_ts+0x68/0xb2
May  3 01:02:25 fawkes kernel: [307200.700586]  [<ffffffff81099caa>] ?
delayacct_end+0x74/0x7f
May  3 01:02:25 fawkes kernel: [307200.700595]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:02:25 fawkes kernel: [307200.700603]  [<ffffffff812faf1a>] ?
io_schedule+0x73/0xb7
May  3 01:02:25 fawkes kernel: [307200.700611]  [<ffffffff8110e0ed>] ?
sync_buffer+0x3b/0x40
May  3 01:02:25 fawkes kernel: [307200.700618]  [<ffffffff812fb427>] ?
__wait_on_bit+0x41/0x70
May  3 01:02:25 fawkes kernel: [307200.700625]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:02:25 fawkes kernel: [307200.700633]  [<ffffffff812fb4c1>] ?
out_of_line_wait_on_bit+0x6b/0x77
May  3 01:02:25 fawkes kernel: [307200.700641]  [<ffffffff81064ec4>] ?
wake_bit_function+0x0/0x23
May  3 01:02:25 fawkes kernel: [307200.700660]  [<ffffffffa03b81d1>] ?
journal_commit_transaction+0x508/0xe2b [jbd]
May  3 01:02:25 fawkes kernel: [307200.700671]  [<ffffffff8105a834>] ?
lock_timer_base+0x26/0x4b
May  3 01:02:25 fawkes kernel: [307200.700683]  [<ffffffffa03bb423>] ?
kjournald+0xdf/0x226 [jbd]
May  3 01:02:25 fawkes kernel: [307200.700691]  [<ffffffff81064e96>] ?
autoremove_wake_function+0x0/0x2e
May  3 01:02:25 fawkes kernel: [307200.700703]  [<ffffffffa03bb344>] ?
kjournald+0x0/0x226 [jbd]
May  3 01:02:25 fawkes kernel: [307200.700709]  [<ffffffff81064bc9>] ?
kthread+0x79/0x81
May  3 01:02:25 fawkes kernel: [307200.700718]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
May  3 01:02:25 fawkes kernel: [307200.700724]  [<ffffffff81064b50>] ?
kthread+0x0/0x81
May  3 01:02:25 fawkes kernel: [307200.700731]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
May  3 01:04:25 fawkes kernel: [307320.700160] kjournald     D 0000000000000000
    0  6416      2 0x00000000
May  3 01:04:25 fawkes kernel: [307320.700172]  ffff88021f083880
0000000000000046 0000000000000000 ffffffff8117628c
May  3 01:04:25 fawkes kernel: [307320.700181]  ffff88021cec1e30
ffff88021c6811a0 000000000000f9e0 ffff8801fc6d7fd8
May  3 01:04:25 fawkes kernel: [307320.700190]  0000000000015780
0000000000015780 ffff8801fa1eb170 ffff8801fa1eb468
May  3 01:04:25 fawkes kernel: [307320.700198] Call Trace:
May  3 01:04:25 fawkes kernel: [307320.700214]  [<ffffffff8117628c>] ?
elv_merged_request+0x30/0x39
May  3 01:04:25 fawkes kernel: [307320.700225]  [<ffffffff8106c403>] ?
ktime_get_ts+0x68/0xb2
May  3 01:04:25 fawkes kernel: [307320.700234]  [<ffffffff81099caa>] ?
delayacct_end+0x74/0x7f
May  3 01:04:25 fawkes kernel: [307320.700243]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:04:25 fawkes kernel: [307320.700252]  [<ffffffff812faf1a>] ?
io_schedule+0x73/0xb7
May  3 01:04:25 fawkes kernel: [307320.700259]  [<ffffffff8110e0ed>] ?
sync_buffer+0x3b/0x40
May  3 01:04:25 fawkes kernel: [307320.700266]  [<ffffffff812fb427>] ?
__wait_on_bit+0x41/0x70
May  3 01:04:25 fawkes kernel: [307320.700273]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:04:25 fawkes kernel: [307320.700281]  [<ffffffff812fb4c1>] ?
out_of_line_wait_on_bit+0x6b/0x77
May  3 01:04:25 fawkes kernel: [307320.700289]  [<ffffffff81064ec4>] ?
wake_bit_function+0x0/0x23
May  3 01:04:25 fawkes kernel: [307320.700308]  [<ffffffffa03b81d1>] ?
journal_commit_transaction+0x508/0xe2b [jbd]
May  3 01:04:25 fawkes kernel: [307320.700319]  [<ffffffff8105a834>] ?
lock_timer_base+0x26/0x4b
May  3 01:04:25 fawkes kernel: [307320.700331]  [<ffffffffa03bb423>] ?
kjournald+0xdf/0x226 [jbd]
May  3 01:04:25 fawkes kernel: [307320.700362]  [<ffffffff81064e96>] ?
autoremove_wake_function+0x0/0x2e
May  3 01:04:25 fawkes kernel: [307320.700376]  [<ffffffffa03bb344>] ?
kjournald+0x0/0x226 [jbd]
May  3 01:04:25 fawkes kernel: [307320.700387]  [<ffffffff81064bc9>] ?
kthread+0x79/0x81
May  3 01:04:25 fawkes kernel: [307320.700401]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
May  3 01:04:25 fawkes kernel: [307320.700411]  [<ffffffff81064b50>] ?
kthread+0x0/0x81
May  3 01:04:25 fawkes kernel: [307320.700422]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
May  3 01:04:25 fawkes kernel: [307320.700452] flush-8:48    D 0000000000000000
    0 12133      2 0x00000000
May  3 01:04:25 fawkes kernel: [307320.700468]  ffff88021f0854c0
0000000000000046 0000000000000000 ffffffff8117628c
May  3 01:04:25 fawkes kernel: [307320.700487]  ffff88013e7e4150
ffff88021c6811a0 000000000000f9e0 ffff88009831dfd8
May  3 01:04:25 fawkes kernel: [307320.700507]  0000000000015780
0000000000015780 ffff8801fe0ea350 ffff8801fe0ea648
May  3 01:04:25 fawkes kernel: [307320.700526] Call Trace:
May  3 01:04:25 fawkes kernel: [307320.700537]  [<ffffffff8117628c>] ?
elv_merged_request+0x30/0x39
May  3 01:04:25 fawkes kernel: [307320.700551]  [<ffffffff81191aa3>] ?
radix_tree_tag_clear+0x93/0xf1
May  3 01:04:25 fawkes kernel: [307320.700563]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:04:25 fawkes kernel: [307320.700575]  [<ffffffff812faf1a>] ?
io_schedule+0x73/0xb7
May  3 01:04:25 fawkes kernel: [307320.700587]  [<ffffffff8110e0ed>] ?
sync_buffer+0x3b/0x40
May  3 01:04:25 fawkes kernel: [307320.700598]  [<ffffffff812fb32a>] ?
__wait_on_bit_lock+0x3f/0x84
May  3 01:04:25 fawkes kernel: [307320.700611]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:04:25 fawkes kernel: [307320.700622]  [<ffffffff812fb3da>] ?
out_of_line_wait_on_bit_lock+0x6b/0x77
May  3 01:04:25 fawkes kernel: [307320.700634]  [<ffffffff81064ec4>] ?
wake_bit_function+0x0/0x23
May  3 01:04:25 fawkes kernel: [307320.700647]  [<ffffffff8110f47f>] ?
__block_write_full_page+0x159/0x2ac
May  3 01:04:25 fawkes kernel: [307320.700660]  [<ffffffff8110e27c>] ?
end_buffer_async_write+0x0/0x13b
May  3 01:04:25 fawkes kernel: [307320.700673]  [<ffffffff810ba5da>] ?
__writepage+0xa/0x25
May  3 01:04:25 fawkes kernel: [307320.700685]  [<ffffffff810bac61>] ?
write_cache_pages+0x20b/0x327
May  3 01:04:25 fawkes kernel: [307320.700697]  [<ffffffff810ba5d0>] ?
__writepage+0x0/0x25
May  3 01:04:25 fawkes kernel: [307320.700712]  [<ffffffff81107e36>] ?
writeback_single_inode+0xe7/0x2da
May  3 01:04:25 fawkes kernel: [307320.700725]  [<ffffffff81108b3c>] ?
writeback_inodes_wb+0x424/0x4ff
May  3 01:04:25 fawkes kernel: [307320.700739]  [<ffffffff81108d43>] ?
wb_writeback+0x12c/0x1ab
May  3 01:04:25 fawkes kernel: [307320.700752]  [<ffffffff8105a8bc>] ?
try_to_del_timer_sync+0x63/0x6c
May  3 01:04:25 fawkes kernel: [307320.700765]  [<ffffffff81108fb9>] ?
wb_do_writeback+0x14f/0x165
May  3 01:04:25 fawkes kernel: [307320.700779]  [<ffffffff81109000>] ?
bdi_writeback_task+0x31/0xaa
May  3 01:04:25 fawkes kernel: [307320.700792]  [<ffffffff810c8f2a>] ?
bdi_start_fn+0x0/0xd2
May  3 01:04:25 fawkes kernel: [307320.700804]  [<ffffffff810c8f9a>] ?
bdi_start_fn+0x70/0xd2
May  3 01:04:25 fawkes kernel: [307320.700816]  [<ffffffff810c8f2a>] ?
bdi_start_fn+0x0/0xd2
May  3 01:04:25 fawkes kernel: [307320.700827]  [<ffffffff81064bc9>] ?
kthread+0x79/0x81
May  3 01:04:25 fawkes kernel: [307320.700838]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
May  3 01:04:25 fawkes kernel: [307320.700849]  [<ffffffff81064b50>] ?
kthread+0x0/0x81
May  3 01:04:25 fawkes kernel: [307320.700859]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
May  3 01:08:25 fawkes kernel: [307560.700160] kjournald     D 0000000000000000
    0  6416      2 0x00000000
May  3 01:08:25 fawkes kernel: [307560.700172]  ffff88021f083880
0000000000000046 0000000000000000 ffffffff8117628c
May  3 01:08:25 fawkes kernel: [307560.700182]  ffff88021cf42a80
ffff88021c6811a0 000000000000f9e0 ffff8801fc6d7fd8
May  3 01:08:25 fawkes kernel: [307560.700190]  0000000000015780
0000000000015780 ffff8801fa1eb170 ffff8801fa1eb468
May  3 01:08:25 fawkes kernel: [307560.700199] Call Trace:
May  3 01:08:25 fawkes kernel: [307560.700214]  [<ffffffff8117628c>] ?
elv_merged_request+0x30/0x39
May  3 01:08:25 fawkes kernel: [307560.700226]  [<ffffffff8117e51f>] ?
generic_make_request+0x299/0x2f9
May  3 01:08:25 fawkes kernel: [307560.700237]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:08:25 fawkes kernel: [307560.700245]  [<ffffffff812faf1a>] ?
io_schedule+0x73/0xb7
May  3 01:08:25 fawkes kernel: [307560.700253]  [<ffffffff8110e0ed>] ?
sync_buffer+0x3b/0x40
May  3 01:08:25 fawkes kernel: [307560.700260]  [<ffffffff812fb427>] ?
__wait_on_bit+0x41/0x70
May  3 01:08:25 fawkes kernel: [307560.700267]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:08:25 fawkes kernel: [307560.700274]  [<ffffffff812fb4c1>] ?
out_of_line_wait_on_bit+0x6b/0x77
May  3 01:08:25 fawkes kernel: [307560.700283]  [<ffffffff81064ec4>] ?
wake_bit_function+0x0/0x23
May  3 01:08:25 fawkes kernel: [307560.700303]  [<ffffffffa03b85de>] ?
journal_commit_transaction+0x915/0xe2b [jbd]
May  3 01:08:25 fawkes kernel: [307560.700317]  [<ffffffffa03bb423>] ?
kjournald+0xdf/0x226 [jbd]
May  3 01:08:25 fawkes kernel: [307560.700324]  [<ffffffff81064e96>] ?
autoremove_wake_function+0x0/0x2e
May  3 01:08:25 fawkes kernel: [307560.700336]  [<ffffffffa03bb344>] ?
kjournald+0x0/0x226 [jbd]
May  3 01:08:25 fawkes kernel: [307560.700366]  [<ffffffff81064bc9>] ?
kthread+0x79/0x81
May  3 01:08:25 fawkes kernel: [307560.700375]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
May  3 01:08:25 fawkes kernel: [307560.700387]  [<ffffffff81064b50>] ?
kthread+0x0/0x81
May  3 01:08:25 fawkes kernel: [307560.700399]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
May  3 01:10:25 fawkes kernel: [307680.700161] kjournald     D 0000000000000000
    0  6416      2 0x00000000
May  3 01:10:25 fawkes kernel: [307680.700172]  ffff88021f083880
0000000000000046 0000000000000000 ffffffff8117628c
May  3 01:10:25 fawkes kernel: [307680.700182]  ffff88021cf42a80
ffff88021c6811a0 000000000000f9e0 ffff8801fc6d7fd8
May  3 01:10:25 fawkes kernel: [307680.700191]  0000000000015780
0000000000015780 ffff8801fa1eb170 ffff8801fa1eb468
May  3 01:10:25 fawkes kernel: [307680.700199] Call Trace:
May  3 01:10:25 fawkes kernel: [307680.700215]  [<ffffffff8117628c>] ?
elv_merged_request+0x30/0x39
May  3 01:10:25 fawkes kernel: [307680.700227]  [<ffffffff8117e51f>] ?
generic_make_request+0x299/0x2f9
May  3 01:10:25 fawkes kernel: [307680.700238]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:10:25 fawkes kernel: [307680.700246]  [<ffffffff812faf1a>] ?
io_schedule+0x73/0xb7
May  3 01:10:25 fawkes kernel: [307680.700254]  [<ffffffff8110e0ed>] ?
sync_buffer+0x3b/0x40
May  3 01:10:25 fawkes kernel: [307680.700261]  [<ffffffff812fb427>] ?
__wait_on_bit+0x41/0x70
May  3 01:10:25 fawkes kernel: [307680.700268]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:10:25 fawkes kernel: [307680.700275]  [<ffffffff812fb4c1>] ?
out_of_line_wait_on_bit+0x6b/0x77
May  3 01:10:25 fawkes kernel: [307680.700284]  [<ffffffff81064ec4>] ?
wake_bit_function+0x0/0x23
May  3 01:10:25 fawkes kernel: [307680.700303]  [<ffffffffa03b85de>] ?
journal_commit_transaction+0x915/0xe2b [jbd]
May  3 01:10:25 fawkes kernel: [307680.700317]  [<ffffffffa03bb423>] ?
kjournald+0xdf/0x226 [jbd]
May  3 01:10:25 fawkes kernel: [307680.700325]  [<ffffffff81064e96>] ?
autoremove_wake_function+0x0/0x2e
May  3 01:10:25 fawkes kernel: [307680.700337]  [<ffffffffa03bb344>] ?
kjournald+0x0/0x226 [jbd]
May  3 01:10:25 fawkes kernel: [307680.700366]  [<ffffffff81064bc9>] ?
kthread+0x79/0x81
May  3 01:10:25 fawkes kernel: [307680.700376]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
May  3 01:10:25 fawkes kernel: [307680.700388]  [<ffffffff81064b50>] ?
kthread+0x0/0x81
May  3 01:10:25 fawkes kernel: [307680.700399]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
May  3 01:12:25 fawkes kernel: [307800.700160] kjournald     D 0000000000000000
    0  6416      2 0x00000000
May  3 01:12:25 fawkes kernel: [307800.700171]  ffff88021f083880
0000000000000046 0000000000000000 ffffffff8117628c
May  3 01:12:25 fawkes kernel: [307800.700180]  ffff88021cf42a80
ffff88021c6811a0 000000000000f9e0 ffff8801fc6d7fd8
May  3 01:12:25 fawkes kernel: [307800.700189]  0000000000015780
0000000000015780 ffff8801fa1eb170 ffff8801fa1eb468
May  3 01:12:25 fawkes kernel: [307800.700197] Call Trace:
May  3 01:12:25 fawkes kernel: [307800.700213]  [<ffffffff8117628c>] ?
elv_merged_request+0x30/0x39
May  3 01:12:25 fawkes kernel: [307800.700225]  [<ffffffff8117e51f>] ?
generic_make_request+0x299/0x2f9
May  3 01:12:25 fawkes kernel: [307800.700235]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:12:25 fawkes kernel: [307800.700244]  [<ffffffff812faf1a>] ?
io_schedule+0x73/0xb7
May  3 01:12:25 fawkes kernel: [307800.700251]  [<ffffffff8110e0ed>] ?
sync_buffer+0x3b/0x40
May  3 01:12:25 fawkes kernel: [307800.700258]  [<ffffffff812fb427>] ?
__wait_on_bit+0x41/0x70
May  3 01:12:25 fawkes kernel: [307800.700266]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:12:25 fawkes kernel: [307800.700273]  [<ffffffff812fb4c1>] ?
out_of_line_wait_on_bit+0x6b/0x77
May  3 01:12:25 fawkes kernel: [307800.700282]  [<ffffffff81064ec4>] ?
wake_bit_function+0x0/0x23
May  3 01:12:25 fawkes kernel: [307800.700301]  [<ffffffffa03b85de>] ?
journal_commit_transaction+0x915/0xe2b [jbd]
May  3 01:12:25 fawkes kernel: [307800.700315]  [<ffffffffa03bb423>] ?
kjournald+0xdf/0x226 [jbd]
May  3 01:12:25 fawkes kernel: [307800.700323]  [<ffffffff81064e96>] ?
autoremove_wake_function+0x0/0x2e
May  3 01:12:25 fawkes kernel: [307800.700334]  [<ffffffffa03bb344>] ?
kjournald+0x0/0x226 [jbd]
May  3 01:12:25 fawkes kernel: [307800.700364]  [<ffffffff81064bc9>] ?
kthread+0x79/0x81
May  3 01:12:25 fawkes kernel: [307800.700374]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
May  3 01:12:25 fawkes kernel: [307800.700386]  [<ffffffff81064b50>] ?
kthread+0x0/0x81
May  3 01:12:25 fawkes kernel: [307800.700396]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
May  3 01:16:25 fawkes kernel: [308040.700182] flush-8:48    D ffff88009831d920
    0 12133      2 0x00000000
May  3 01:16:25 fawkes kernel: [308040.700194]  ffff88021f16cdb0
0000000000000046 0000000000000282 ffffffff8118aecf
May  3 01:16:25 fawkes kernel: [308040.700204]  ffff8801fe0ea350
000000100888fba8 000000000000f9e0 ffff88009831dfd8
May  3 01:16:25 fawkes kernel: [308040.700212]  0000000000015780
0000000000015780 ffff8801fe0ea350 ffff8801fe0ea648
May  3 01:16:25 fawkes kernel: [308040.700221] Call Trace:
May  3 01:16:25 fawkes kernel: [308040.700237]  [<ffffffff8118aecf>] ?
cfq_set_request+0x2af/0x319
May  3 01:16:25 fawkes kernel: [308040.700248]  [<ffffffff8118a8d5>] ?
cfq_may_queue+0x59/0xd7
May  3 01:16:25 fawkes kernel: [308040.700258]  [<ffffffff8101657d>] ?
read_tsc+0xa/0x20
May  3 01:16:25 fawkes kernel: [308040.700267]  [<ffffffff8117f687>] ?
get_request+0x7e/0x2ba
May  3 01:16:25 fawkes kernel: [308040.700275]  [<ffffffff812faf1a>] ?
io_schedule+0x73/0xb7
May  3 01:16:25 fawkes kernel: [308040.700283]  [<ffffffff8117f9b3>] ?
get_request_wait+0xf0/0x188
May  3 01:16:25 fawkes kernel: [308040.700292]  [<ffffffff81064e96>] ?
autoremove_wake_function+0x0/0x2e
May  3 01:16:25 fawkes kernel: [308040.700300]  [<ffffffff8117fd42>] ?
__make_request+0x2f7/0x428
May  3 01:16:25 fawkes kernel: [308040.700308]  [<ffffffff8117e51f>] ?
generic_make_request+0x299/0x2f9
May  3 01:16:25 fawkes kernel: [308040.700317]  [<ffffffff8117e655>] ?
submit_bio+0xd6/0xf2
May  3 01:16:25 fawkes kernel: [308040.700325]  [<ffffffff8110cf81>] ?
submit_bh+0x103/0x123
May  3 01:16:25 fawkes kernel: [308040.700334]  [<ffffffff8110f4fc>] ?
__block_write_full_page+0x1d6/0x2ac
May  3 01:16:25 fawkes kernel: [308040.700365]  [<ffffffff8110e27c>] ?
end_buffer_async_write+0x0/0x13b
May  3 01:16:25 fawkes kernel: [308040.700376]  [<ffffffff8111156c>] ?
blkdev_get_block+0x0/0x57
May  3 01:16:25 fawkes kernel: [308040.700389]  [<ffffffff810ba5da>] ?
__writepage+0xa/0x25
May  3 01:16:25 fawkes kernel: [308040.700401]  [<ffffffff810bac61>] ?
write_cache_pages+0x20b/0x327
May  3 01:16:25 fawkes kernel: [308040.700413]  [<ffffffff810ba5d0>] ?
__writepage+0x0/0x25
May  3 01:16:25 fawkes kernel: [308040.700428]  [<ffffffff81107e36>] ?
writeback_single_inode+0xe7/0x2da
May  3 01:16:25 fawkes kernel: [308040.700441]  [<ffffffff81108b3c>] ?
writeback_inodes_wb+0x424/0x4ff
May  3 01:16:25 fawkes kernel: [308040.700455]  [<ffffffff81108d43>] ?
wb_writeback+0x12c/0x1ab
May  3 01:16:25 fawkes kernel: [308040.700468]  [<ffffffff8105a8bc>] ?
try_to_del_timer_sync+0x63/0x6c
May  3 01:16:25 fawkes kernel: [308040.700481]  [<ffffffff81108fb9>] ?
wb_do_writeback+0x14f/0x165
May  3 01:16:25 fawkes kernel: [308040.700495]  [<ffffffff81109000>] ?
bdi_writeback_task+0x31/0xaa
May  3 01:16:25 fawkes kernel: [308040.700509]  [<ffffffff810c8f2a>] ?
bdi_start_fn+0x0/0xd2
May  3 01:16:25 fawkes kernel: [308040.700521]  [<ffffffff810c8f9a>] ?
bdi_start_fn+0x70/0xd2
May  3 01:16:25 fawkes kernel: [308040.700533]  [<ffffffff810c8f2a>] ?
bdi_start_fn+0x0/0xd2
May  3 01:16:25 fawkes kernel: [308040.700544]  [<ffffffff81064bc9>] ?
kthread+0x79/0x81
May  3 01:16:25 fawkes kernel: [308040.700556]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
May  3 01:16:25 fawkes kernel: [308040.700567]  [<ffffffff81064b50>] ?
kthread+0x0/0x81
May  3 01:16:25 fawkes kernel: [308040.700577]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
May  3 01:18:25 fawkes kernel: [308160.700177] kjournald     D 0000000000000000
    0  6416      2 0x00000000
May  3 01:18:25 fawkes kernel: [308160.700188]  ffff88021f083880
0000000000000046 0000000000000000 ffffffff8117628c
May  3 01:18:25 fawkes kernel: [308160.700198]  ffff88021cf42e70
ffff88021c6811a0 000000000000f9e0 ffff8801fc6d7fd8
May  3 01:18:25 fawkes kernel: [308160.700207]  0000000000015780
0000000000015780 ffff8801fa1eb170 ffff8801fa1eb468
May  3 01:18:25 fawkes kernel: [308160.700215] Call Trace:
May  3 01:18:25 fawkes kernel: [308160.700231]  [<ffffffff8117628c>] ?
elv_merged_request+0x30/0x39
May  3 01:18:25 fawkes kernel: [308160.700243]  [<ffffffff8117e51f>] ?
generic_make_request+0x299/0x2f9
May  3 01:18:25 fawkes kernel: [308160.700253]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:18:25 fawkes kernel: [308160.700261]  [<ffffffff812faf1a>] ?
io_schedule+0x73/0xb7
May  3 01:18:25 fawkes kernel: [308160.700269]  [<ffffffff8110e0ed>] ?
sync_buffer+0x3b/0x40
May  3 01:18:25 fawkes kernel: [308160.700276]  [<ffffffff812fb427>] ?
__wait_on_bit+0x41/0x70
May  3 01:18:25 fawkes kernel: [308160.700283]  [<ffffffff8110e0b2>] ?
sync_buffer+0x0/0x40
May  3 01:18:25 fawkes kernel: [308160.700291]  [<ffffffff812fb4c1>] ?
out_of_line_wait_on_bit+0x6b/0x77
May  3 01:18:25 fawkes kernel: [308160.700299]  [<ffffffff81064ec4>] ?
wake_bit_function+0x0/0x23
May  3 01:18:25 fawkes kernel: [308160.700319]  [<ffffffffa03b85de>] ?
journal_commit_transaction+0x915/0xe2b [jbd]
May  3 01:18:25 fawkes kernel: [308160.700333]  [<ffffffffa03bb423>] ?
kjournald+0xdf/0x226 [jbd]
May  3 01:18:25 fawkes kernel: [308160.700363]  [<ffffffff81064e96>] ?
autoremove_wake_function+0x0/0x2e
May  3 01:18:25 fawkes kernel: [308160.700378]  [<ffffffffa03bb344>] ?
kjournald+0x0/0x226 [jbd]
May  3 01:18:25 fawkes kernel: [308160.700390]  [<ffffffff81064bc9>] ?
kthread+0x79/0x81
May  3 01:18:25 fawkes kernel: [308160.700403]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
May  3 01:18:25 fawkes kernel: [308160.700414]  [<ffffffff81064b50>] ?
kthread+0x0/0x81
May  3 01:18:25 fawkes kernel: [308160.700425]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
May  3 01:18:25 fawkes kernel: [308160.700454] flush-8:48    D ffff88009831d920
    0 12133      2 0x00000000
May  3 01:18:25 fawkes kernel: [308160.700470]  ffff88021f16cdb0
0000000000000046 0000000000000282 ffffffff8118aecf
May  3 01:18:25 fawkes kernel: [308160.700490]  ffff8801fe0ea350
000000100888fba8 000000000000f9e0 ffff88009831dfd8
May  3 01:18:25 fawkes kernel: [308160.700510]  0000000000015780
0000000000015780 ffff8801fe0ea350 ffff8801fe0ea648
May  3 01:18:25 fawkes kernel: [308160.700530] Call Trace:
May  3 01:18:25 fawkes kernel: [308160.700542]  [<ffffffff8118aecf>] ?
cfq_set_request+0x2af/0x319
May  3 01:18:25 fawkes kernel: [308160.700555]  [<ffffffff8118a8d5>] ?
cfq_may_queue+0x59/0xd7
May  3 01:18:25 fawkes kernel: [308160.700569]  [<ffffffff8101657d>] ?
read_tsc+0xa/0x20
May  3 01:18:25 fawkes kernel: [308160.700580]  [<ffffffff8117f687>] ?
get_request+0x7e/0x2ba
May  3 01:18:25 fawkes kernel: [308160.700593]  [<ffffffff812faf1a>] ?
io_schedule+0x73/0xb7
May  3 01:18:25 fawkes kernel: [308160.700605]  [<ffffffff8117f9b3>] ?
get_request_wait+0xf0/0x188
May  3 01:18:25 fawkes kernel: [308160.700616]  [<ffffffff81064e96>] ?
autoremove_wake_function+0x0/0x2e
May  3 01:18:25 fawkes kernel: [308160.700628]  [<ffffffff8117fd42>] ?
__make_request+0x2f7/0x428
May  3 01:18:25 fawkes kernel: [308160.700640]  [<ffffffff8117e51f>] ?
generic_make_request+0x299/0x2f9
May  3 01:18:25 fawkes kernel: [308160.700653]  [<ffffffff8117e655>] ?
submit_bio+0xd6/0xf2
May  3 01:18:25 fawkes kernel: [308160.700665]  [<ffffffff8110cf81>] ?
submit_bh+0x103/0x123
May  3 01:18:25 fawkes kernel: [308160.700677]  [<ffffffff8110f4fc>] ?
__block_write_full_page+0x1d6/0x2ac
May  3 01:18:25 fawkes kernel: [308160.700689]  [<ffffffff8110e27c>] ?
end_buffer_async_write+0x0/0x13b
May  3 01:18:25 fawkes kernel: [308160.700702]  [<ffffffff8111156c>] ?
blkdev_get_block+0x0/0x57
May  3 01:18:25 fawkes kernel: [308160.700715]  [<ffffffff810ba5da>] ?
__writepage+0xa/0x25
May  3 01:18:25 fawkes kernel: [308160.700727]  [<ffffffff810bac61>] ?
write_cache_pages+0x20b/0x327
May  3 01:18:25 fawkes kernel: [308160.700739]  [<ffffffff810ba5d0>] ?
__writepage+0x0/0x25
May  3 01:18:25 fawkes kernel: [308160.700753]  [<ffffffff81107e36>] ?
writeback_single_inode+0xe7/0x2da
May  3 01:18:25 fawkes kernel: [308160.700766]  [<ffffffff81108b3c>] ?
writeback_inodes_wb+0x424/0x4ff
May  3 01:18:25 fawkes kernel: [308160.700780]  [<ffffffff81108d43>] ?
wb_writeback+0x12c/0x1ab
May  3 01:18:25 fawkes kernel: [308160.700793]  [<ffffffff8105a8bc>] ?
try_to_del_timer_sync+0x63/0x6c
May  3 01:18:25 fawkes kernel: [308160.700807]  [<ffffffff81108fb9>] ?
wb_do_writeback+0x14f/0x165
May  3 01:18:25 fawkes kernel: [308160.700820]  [<ffffffff81109000>] ?
bdi_writeback_task+0x31/0xaa
May  3 01:18:25 fawkes kernel: [308160.700833]  [<ffffffff810c8f2a>] ?
bdi_start_fn+0x0/0xd2
May  3 01:18:25 fawkes kernel: [308160.700845]  [<ffffffff810c8f9a>] ?
bdi_start_fn+0x70/0xd2
May  3 01:18:25 fawkes kernel: [308160.700857]  [<ffffffff810c8f2a>] ?
bdi_start_fn+0x0/0xd2
May  3 01:18:25 fawkes kernel: [308160.700868]  [<ffffffff81064bc9>] ?
kthread+0x79/0x81
May  3 01:18:25 fawkes kernel: [308160.700880]  [<ffffffff81011baa>] ?
child_rip+0xa/0x20
May  3 01:18:25 fawkes kernel: [308160.700891]  [<ffffffff81064b50>] ?
kthread+0x0/0x81
May  3 01:18:25 fawkes kernel: [308160.700902]  [<ffffffff81011ba0>] ?
child_rip+0x0/0x20
May  3 01:40:09 fawkes kernel: [309464.781131] ata8: hard resetting link
May  3 01:40:10 fawkes kernel: [309465.112103] ata8: SATA link up 6.0 Gbps
(SStatus 133 SControl 300)
May  3 01:40:10 fawkes kernel: [309465.119531] ata8.00: configured for UDMA/133
May  3 01:40:10 fawkes kernel: [309465.119543] ata8.00: device reported invalid
CHS sector 0
May  3 01:40:10 fawkes kernel: [309465.119559] ata8: EH complete

Here is a description of the stock debian squeeze kernel:

Modules linked in: tun powernow_k8 cpufreq_userspace cpufreq_conservative
cpufreq_stats cpufreq_powersave binfmt_misc fuse ipt_REDIRECT xt_limit
xt_tcpudp ipt_LOG xt_state iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables ext3 jbd ext2
loop snd_hda_codec_atihdmi usbhid hid snd_hda_codec_realtek snd_hda_intel
snd_hda_codec radeon snd_hwdep ttm snd_seq snd_pcm sr_mod drm_kms_helper
snd_seq_device snd_timer drm i2c_algo_bit ata_generic cdrom i2c_piix4 snd sg
pata_jmicron firewire_ohci soundcore i2c_core shpchp ohci_hcd edac_core
firewire_core crc_itu_t snd_page_alloc r8169 mii processor pci_hotplug ehci_hcd
asus_atk0110 edac_mce_amd xhci pcspkr evdev usbcore e1000e nls_base button ext4
mbcache jbd2 crc16 dm_mod raid10 raid456 async_raid6_recov async_pq raid6_pq
async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod sd_mod
crc_t10dif ahci thermal thermal_sys libata scsi_mod

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
