From: marcus.husar@rose.uni-heidelberg.de
Subject: Re: [PATCH 1/4][2.6.32-stable] ext4: Prepare for backporting first
	quota patch
Date: Sat, 06 Feb 2010 20:00:21 +0100
Message-ID: <20100206200021.temprma80wk8sco4@wwwmail.urz.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.uni-heidelberg.de ([129.206.210.211]:60422 "EHLO
	relay2.uni-heidelberg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab0BFTAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Feb 2010 14:00:24 -0500
Received: from ix.urz.uni-heidelberg.de (cyrus-portal.urz.uni-heidelberg.de [129.206.100.176])
	by relay2.uni-heidelberg.de (8.13.8/8.13.8) with ESMTP id o16J0P7W009382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 20:00:25 +0100
Received: from wwwmail.urz.uni-heidelberg.de (wwwmail.urz.uni-heidelberg.de [129.206.100.145])
	by ix.urz.uni-heidelberg.de (8.13.8/8.13.8) with ESMTP id o16J0Mme020225
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 20:00:22 +0100
Received: from wwwmail.urz.uni-heidelberg.de (localhost.localdomain [127.0.0.1])
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1) with ESMTP id o16J0Mcm009230
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 20:00:22 +0100
Received: (from apache@localhost)
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1/Submit) id o16J0LCM009228
	for linux-ext4@vger.kernel.org; Sat, 6 Feb 2010 20:00:21 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi again,

before I sent my patches out I have done a lot of testing. Everything  
seemed to work fine. But an aideupdate started by a cron-job revealed  
that the patches even introduce two new bugs. At least I have never  
hit these bugs before. There were no identical traces in the logfiles  
of the last year.

Perhaps they are also to be found in 2.6.33-rc. I'll do more testing  
and try it another time again.

Sincerely yours,
Marcus

First trace:
Feb  6 19:02:11 pauling kernel: [17124.290892] ------------[ cut here  
]------------
Feb  6 19:02:11 pauling kernel: [17124.290901] WARNING: at  
fs/quota/dquot.c:964
dquot_claim_space+0x98/0x131()
Feb  6 19:02:11 pauling kernel: [17124.290904] Hardware name: GA-MA790FX-DQ6
Feb  6 19:02:11 pauling kernel: [17124.290908] Pid: 10823, comm: mv  
Tainted: G        W
2.6.32.7-2-amd64 #1
Feb  6 19:02:11 pauling kernel: [17124.290911] Call Trace:
Feb  6 19:02:11 pauling kernel: [17124.290918]  [<ffffffff81485258>] ?
__down_read+0x15/0x9d
Feb  6 19:02:11 pauling kernel: [17124.290922]  [<ffffffff810f6c74>] ?
dquot_claim_space+0x98/0x131
Feb  6 19:02:11 pauling kernel: [17124.290927]  [<ffffffff81058f04>] ?
warn_slowpath_common+0x72/0x9e
Feb  6 19:02:11 pauling kernel: [17124.290931]  [<ffffffff810f6c74>] ?
dquot_claim_space+0x98/0x131
Feb  6 19:02:11 pauling kernel: [17124.290935]  [<ffffffff81148b48>] ?
ext4_mb_mark_diskspace_used+0x37e/0x433
Feb  6 19:02:11 pauling kernel: [17124.290939]  [<ffffffff8114b51d>] ?
ext4_mb_new_blocks+0x1d1/0x3aa
Feb  6 19:02:11 pauling kernel: [17124.290944]  [<ffffffff81144da3>] ?
ext4_ext_get_blocks+0x141d/0x1702
Feb  6 19:02:11 pauling kernel: [17124.290948]  [<ffffffff81142797>] ?
ext4_ext_find_extent+0x4b/0x285
Feb  6 19:02:11 pauling kernel: [17124.290952]  [<ffffffff811321b4>] ?
ext4_get_blocks+0x15a/0x23d
Feb  6 19:02:11 pauling kernel: [17124.290956]  [<ffffffff81132644>] ?
mpage_da_map_blocks+0xa4/0x5a1
Feb  6 19:02:11 pauling kernel: [17124.290960]  [<ffffffff8109971a>] ?
pagevec_lookup_tag+0x1a/0x21
Feb  6 19:02:11 pauling kernel: [17124.290963]  [<ffffffff810983bc>] ?
write_cache_pages+0x162/0x322
Feb  6 19:02:11 pauling kernel: [17124.290967]  [<ffffffff8113320c>] ?
__mpage_da_writepage+0x0/0x146
Feb  6 19:02:11 pauling kernel: [17124.290971]  [<ffffffff81132fd4>] ?
ext4_da_writepages+0x493/0x62a
Feb  6 19:02:11 pauling kernel: [17124.290980]  [<ffffffff81069f7f>] ?
bit_waitqueue+0x10/0xa0
Feb  6 19:02:11 pauling kernel: [17124.290985]  [<ffffffff810929b1>] ?
__filemap_fdatawrite_range+0x4b/0x54
Feb  6 19:02:11 pauling kernel: [17124.290989]  [<ffffffff81139007>] ?
ext4_rename+0x758/0x790
Feb  6 19:02:11 pauling kernel: [17124.290994]  [<ffffffff810c9adc>] ?
vfs_rename+0x2a4/0x4b3
Feb  6 19:02:11 pauling kernel: [17124.290998]  [<ffffffff810c887b>] ?
__lookup_hash+0x4e/0x11f
Feb  6 19:02:11 pauling kernel: [17124.291002]  [<ffffffff810cb766>] ?
sys_renameat+0x16d/0x1e9
Feb  6 19:02:11 pauling kernel: [17124.291005]  [<ffffffff810a616c>] ?
handle_mm_fault+0x368/0x72e
Feb  6 19:02:11 pauling kernel: [17124.291010]  [<ffffffff810435cd>] ?
do_page_fault+0x1e5/0x1fa
Feb  6 19:02:11 pauling kernel: [17124.291014]  [<ffffffff81088feb>] ?
audit_syscall_entry+0x15b/0x186
Feb  6 19:02:11 pauling kernel: [17124.291019]  [<ffffffff811fab3e>] ?  
__up_read+0x13/0x8d
Feb  6 19:02:11 pauling kernel: [17124.291022]  [<ffffffff8102986b>] ?
system_call_fastpath+0x16/0x1b
Feb  6 19:02:11 pauling kernel: [17124.291025] ---[ end trace  
64137460f91d3829 ]---


Second trace:
Feb  6 19:02:33 pauling kernel: [17146.000977] ------------[ cut here  
]------------
Feb  6 19:02:33 pauling kernel: [17146.000984] WARNING: at  
fs/quota/dquot.c:964
dquot_claim_space+0xc1/0x131()
Feb  6 19:02:33 pauling kernel: [17146.000991] Hardware name: GA-MA790FX-DQ6
Feb  6 19:02:33 pauling kernel: [17146.000996] Pid: 10238, comm:  
flush-251:1 Tainted: G
      W  2.6.32.7-2-amd64 #1
Feb  6 19:02:33 pauling kernel: [17146.001002] Call Trace:
Feb  6 19:02:33 pauling kernel: [17146.001008]  [<ffffffff81485258>] ?
__down_read+0x15/0x9d
Feb  6 19:02:33 pauling kernel: [17146.001019]  [<ffffffff810f6c9d>] ?
dquot_claim_space+0xc1/0x131
Feb  6 19:02:33 pauling kernel: [17146.001031]  [<ffffffff81058f04>] ?
warn_slowpath_common+0x72/0x9e
Feb  6 19:02:33 pauling kernel: [17146.001042]  [<ffffffff810f6c9d>] ?
dquot_claim_space+0xc1/0x131
Feb  6 19:02:33 pauling kernel: [17146.001049]  [<ffffffff81131efe>] ?
ext4_da_update_reserve_space+0x167/0x2c3
Feb  6 19:02:33 pauling kernel: [17146.001058]  [<ffffffff81144ef6>] ?
ext4_ext_get_blocks+0x1570/0x1702
Feb  6 19:02:33 pauling kernel: [17146.001067]  [<ffffffff81336a70>] ?
get_active_stripe+0x44d/0x542
Feb  6 19:02:33 pauling kernel: [17146.001078]  [<ffffffff81333dd8>] ?
release_stripe+0x30/0x44
Feb  6 19:02:33 pauling kernel: [17146.001088]  [<ffffffff811321b4>] ?
ext4_get_blocks+0x15a/0x23d
Feb  6 19:02:33 pauling kernel: [17146.001097]  [<ffffffff8134a40d>] ?
__split_and_process_bio+0x55a/0x569
Feb  6 19:02:33 pauling kernel: [17146.001104]  [<ffffffff81132644>] ?
mpage_da_map_blocks+0xa4/0x5a1
Feb  6 19:02:33 pauling kernel: [17146.001111]  [<ffffffff8109971a>] ?
pagevec_lookup_tag+0x1a/0x21
Feb  6 19:02:33 pauling kernel: [17146.001118]  [<ffffffff810983bc>] ?
write_cache_pages+0x162/0x322
Feb  6 19:02:33 pauling kernel: [17146.001127]  [<ffffffff8113320c>] ?
__mpage_da_writepage+0x0/0x146
Feb  6 19:02:33 pauling kernel: [17146.001136]  [<ffffffff81132fd4>] ?
ext4_da_writepages+0x493/0x62a
Feb  6 19:02:33 pauling kernel: [17146.001148]  [<ffffffff8104ae76>] ?
scale_rt_power+0x1f/0x64
Feb  6 19:02:33 pauling kernel: [17146.001155]  [<ffffffff810da654>] ?
writeback_single_inode+0xe6/0x2d9
Feb  6 19:02:33 pauling kernel: [17146.001166]  [<ffffffff810db2c5>] ?
writeback_inodes_wb+0x421/0x4fa
Feb  6 19:02:33 pauling kernel: [17146.001173]  [<ffffffff810db4ca>] ?
wb_writeback+0x12c/0x1aa
Feb  6 19:02:33 pauling kernel: [17146.001182]  [<ffffffff810db72e>] ?
wb_do_writeback+0x145/0x15b
Feb  6 19:02:33 pauling kernel: [17146.001190]  [<ffffffff810db76e>] ?
bdi_writeback_task+0x2a/0x85
Feb  6 19:02:33 pauling kernel: [17146.001197]  [<ffffffff810a2c0a>] ?
bdi_start_fn+0x0/0xca
Feb  6 19:02:33 pauling kernel: [17146.001203]  [<ffffffff810a2c7a>] ?
bdi_start_fn+0x70/0xca
Feb  6 19:02:33 pauling kernel: [17146.001209]  [<ffffffff810a2c0a>] ?
bdi_start_fn+0x0/0xca
Feb  6 19:02:33 pauling kernel: [17146.001216]  [<ffffffff81069ddb>] ?  
kthread+0x79/0x81
Feb  6 19:02:33 pauling kernel: [17146.001225]  [<ffffffff8102a7fa>] ?  
child_rip+0xa/0x20
Feb  6 19:02:33 pauling kernel: [17146.001232]  [<ffffffff81069d62>] ?  
kthread+0x0/0x81
Feb  6 19:02:33 pauling kernel: [17146.001243]  [<ffffffff8102a7f0>] ?  
child_rip+0x0/0x20
Feb  6 19:02:33 pauling kernel: [17146.001247] ---[ end trace  
64137460f91d389c ]---
Feb  6 19:02:33 pauling kernel: [17146.105248] ------------[ cut here  
]------------
