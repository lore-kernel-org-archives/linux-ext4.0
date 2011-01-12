From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: Oops while going into hibernate
Date: Wed, 12 Jan 2011 19:49:32 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org> <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6> <20110112172646.GB13496@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:40880 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab1ALStf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jan 2011 13:49:35 -0500
In-Reply-To: <20110112172646.GB13496@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
On Wed, 12 Jan 2011, Ted Ts'o wrote:
> Since I don't have a machine set up to test hibernation easily at
> hand, I'd really appreciate it if you could try this patch to
> determine which inode had the NULL jinode --- and then once you get
> the device and inode number, to use debugfs's "ncheck" command to map
> the inode number to a pathname.
> 
> If you could do that, it would be a huge help.

I did about 5 re-tests with different loads, the result was always:

[  249.238697] EXT4-fs (dasda1): inode #1106 has NULL jinode
[  249.238732] ------------[ cut here ]------------
[  249.238738] kernel BUG at fs/ext4/ext4_jbd2.h:260!
[  249.238747] illegal operation: 0001 [#1] PREEMPT SMP 
[  249.238760] Modules linked in: binfmt_misc dm_multipath scsi_dh vmur [last unloaded: scsi_wait_scan]
[  249.238786] CPU: 2 Not tainted 2.6.37-05668-g4162cf6-dirty #20
[  249.238794] Process flush-94:0 (pid: 1244, task: 000000003f110040, ksp: 000000003dca3c70)
[  249.238803] Krnl PSW : 0704000180000000 00000000001d1130 (mpage_da_map_and_submit+0x464/0x468)
[  249.238824]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[  249.238835] Krnl GPRS: 000000000000c65f 0000000000000000 0000000000000043 0000000000000000
[  249.238848]            00000000004735c0 0000000000000000 000000003ee45478 0000000000000001
[  249.238863]            0000000035544aa8 000000003dca3a88 0000000000000004 000000003d29d680
[  249.238868]            000000003dca3b80 000000000049ef98 00000000001d112c 000000003dca39d8
[  249.238886] Krnl Code: 00000000001d1120: c040001e01c2        larl    %r4,5914a4
[  249.238893]            00000000001d1126: c0e5000092ed        brasl   %r14,1e3700
[  249.238899]            00000000001d112c: a7f40001            brc     15,1d112e
[  249.238906]           >00000000001d1130: a7f40000            brc     15,1d1130
[  249.238913]            00000000001d1134: e3e0f0080024        stg     %r14,8(%r15)
[  249.238920]            00000000001d113a: c0f400000006        brcl    15,1d1146
[  249.238942]            00000000001d1140: b9040000            lgr     %r0,%r0
[  249.238963]            00000000001d1144: 0de1                basr    %r14,%r1
[  249.238989] Call Trace:
[  249.238998] ([<00000000001d112c>] mpage_da_map_and_submit+0x460/0x468)
[  249.239012]  [<00000000001d19f2>] ext4_da_writepages+0x32e/0x744
[  249.239028]  [<000000000016fe64>] writeback_single_inode+0xd4/0x25c
[  249.239044]  [<0000000000170514>] writeback_sb_inodes+0xd0/0x160
[  249.239050]  [<0000000000171278>] writeback_inodes_wb+0x90/0x16c
[  249.239055]  [<00000000001715fa>] wb_writeback+0x2a6/0x480
[  249.239060]  [<00000000001718b6>] wb_do_writeback+0xe2/0x294
[  249.239066]  [<0000000000171b14>] bdi_writeback_thread+0xac/0x2fc
[  249.239072]  [<000000000007d192>] kthread+0xbe/0xc8
[  249.239087]  [<0000000000479182>] kernel_thread_starter+0x6/0xc
[  249.239101]  [<000000000047917c>] kernel_thread_starter+0x0/0xc
[  249.239112] INFO: lockdep is turned off.
[  249.239119] Last Breaking-Event-Address:
[  249.239126]  [<00000000001d112c>] mpage_da_map_and_submit+0x460/0x468


# debugfs /dev/dasda1
debugfs 1.41.10 (10-Feb-2009)
debugfs:  ncheck 1106
Inode   Pathname
1106    /usr/bin/killall
debugfs:  q

there are also a few messages like:
EXT4-fs error (device dasda1): ext4_lookup:1043: inode #130849: comm find: deleted inode referenced: 129148
I guess they appeared after one of the crashes during bisecting (can't 
run fsck right now, since its my /)

Regards,
Sebastian

> 
> Thanks, regards,
> 
> 						- Ted
> 
> P.S.  Also, if you could try suspending once or twice, with different
> programs running, to see if the inode number and pathname are constant
> or vary, that would also be helpful.
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index d8b992e..7d6d7d7 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -252,8 +252,15 @@ static inline int ext4_journal_force_commit(journal_t *journal)
> 
>  static inline int ext4_jbd2_file_inode(handle_t *handle, struct inode *inode)
>  {
> -	if (ext4_handle_valid(handle))
> +	if (ext4_handle_valid(handle)) {
> +		if (unlikely(EXT4_I(inode)->jinode == NULL)) {
> +			/* Should never happen */
> +			ext4_msg(inode->i_sb, KERN_CRIT, 
> +				 "inode #%lu has NULL jinode", inode->i_ino);
> +			BUG();
> +		}
>  		return jbd2_journal_file_inode(handle, EXT4_I(inode)->jinode);
> +	}
>  	return 0;
>  }
> 
> 
