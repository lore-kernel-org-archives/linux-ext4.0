From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: ext4 crash in 4.4.10
Date: Mon, 4 Jul 2016 11:49:27 +0300
Message-ID: <577A2317.2070609@kyup.com>
References: <57513FAF.5030800@kyup.com> <20160603091936.GA2470@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
	SiteGround Operations <operations@siteground.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36911 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbcGDItb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jul 2016 04:49:31 -0400
Received: by mail-wm0-f47.google.com with SMTP id a66so105692211wme.0
        for <linux-ext4@vger.kernel.org>; Mon, 04 Jul 2016 01:49:30 -0700 (PDT)
In-Reply-To: <20160603091936.GA2470@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello again Jan, 

On 06/03/2016 12:19 PM, Jan Kara wrote:
> Hi,
> 
> On Fri 03-06-16 11:28:31, Nikolay Borisov wrote:
>> Recently the following crash was brought to my attention:
>>
[SNIP]
> 
> Hum, this looks most likely like a memory corruption. The value
> ffffffffd9c01f11 doesn't look like a valid pointer to any dynamically
> allocated data (it is not aligned to multiple of 4, it does not point to
> data segment ffff88..........). It is close to a pointer to kernel code
> (modules start at ffffffffa.......) so if it really points to some kernel
> code it may be interesting to find out where. I have no clue how such
> number could get to ei->i_dquot[0]. Usually what I do in such cases is
> search kernel memory whether something unusual points to that place,
> whether previous struct members didn't get corrupted as well or whether
> that value is not also somewhere else in memory. But it's a search for a
> needle in a haystack.
> 
> 								Honza

So I got this exact same crash on a different machine, 
with the exact same value. This rules out it being a random corruption: 

[2455521.848677] BUG: unable to handle kernel paging request at ffffffffd9c01fb1
[2455521.849025] IP: [<ffffffff81204b62>] dquot_free_inode+0xa2/0x230
[2455521.849315] PGD 1c0b067 PUD 1c0d067 PMD 0 
[2455521.849720] Oops: 0000 [#1] SMP 
[2455521.850062] Modules linked in: <OMITTED >
[2455521.856549]  ipv6 [last unloaded: nf_conntrack_ftp]
[2455521.856904] CPU: 8 PID: 2955 Comm: rm Tainted: G           O    4.4.10-clouder1 #73
[2455521.857286] Hardware name: Supermicro X10DRi/X10DRi, BIOS 2.0 12/28/2015
[2455521.857517] task: ffff883506658000 ti: ffff881d50198000 task.ti: ffff881d50198000
[2455521.857898] RIP: 0010:[<ffffffff81204b62>]  [<ffffffff81204b62>] dquot_free_inode+0xa2/0x230
[2455521.858353] RSP: 0018:ffff881d5019bc48  EFLAGS: 00010286
[2455521.858581] RAX: ffffffffd9c01f11 RBX: ffff881d5019bc48 RCX: 000000000000fb20
[2455521.858962] RDX: ffff881d5019bc58 RSI: ffff880996894680 RDI: ffffffff81c09540
[2455521.859343] RBP: ffff881d5019bcc8 R08: 0000000000000001 R09: ffff881d5019bc58
[2455521.859724] R10: ffff881d5019bca0 R11: 0000000100000000 R12: ffff880996894680
[2455521.860105] R13: 0000000000000000 R14: 0000000000000008 R15: ffff881d5019be68
[2455521.860486] FS:  00007f6ad2fe9700(0000) GS:ffff881fffb00000(0000) knlGS:0000000000000000
[2455521.860868] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2455521.861096] CR2: ffffffffd9c01fb1 CR3: 0000000151007000 CR4: 00000000001406e0
[2455521.861476] Stack:
[2455521.861696]  ffff881fa0388c00 ffff880996894368 0000000000000000 0000000000000000
[2455521.862335]  0000000000000000 ffffffff8123949c ffff881d5019bd28 ffffffff812351c8
[2455521.862972]  ffff881d5019bcb8 ffff883fb9a4d800 ffff881ff093a810 ffff883fb9a4d800
[2455521.863611] Call Trace:
[2455521.863838]  [<ffffffff8123949c>] ? ext4_evict_inode+0x26c/0x4c0
[2455521.864069]  [<ffffffff812351c8>] ? ext4_mark_iloc_dirty+0x518/0x770
[2455521.864304]  [<ffffffff812312e3>] ext4_free_inode+0x83/0x5a0
[2455521.864534]  [<ffffffff8123949c>] ? ext4_evict_inode+0x26c/0x4c0
[2455521.864765]  [<ffffffff8123673b>] ? ext4_mark_inode_dirty+0x7b/0x260
[2455521.864999]  [<ffffffff812396e5>] ext4_evict_inode+0x4b5/0x4c0
[2455521.865233]  [<ffffffff811ba616>] evict+0xc6/0x1c0
[2455521.865466]  [<ffffffff811ba9dc>] iput+0x1ec/0x260
[2455521.865696]  [<ffffffff811ab128>] ? vfs_unlink+0x128/0x130
[2455521.865928]  [<ffffffff811ae766>] do_unlinkat+0x186/0x2c0
[2455521.866158]  [<ffffffff811ae8e2>] SyS_unlinkat+0x22/0x40
[2455521.866390]  [<ffffffff81635c57>] entry_SYSCALL_64_fastpath+0x12/0x6a
[2455521.866620] Code: 80 41 be 08 00 00 00 65 ff 0d cf 60 e0 7e e8 f6 0d 43 00 48 8d 53 10 4c 89 e6 4c 8d 55 d8 66 c7 02 00 00 48 8b 06 48 85 c0 74 61 <48> 8b 88 a0 00 00 00 4c 8d 80 a0 00 00 00 83 e1 08 0f 84 a5 00 
[2455521.871376] RIP  [<ffffffff81204b62>] dquot_free_inode+0xa2/0x230
[2455521.871674]  RSP <ffff881d5019bc48>
[2455521.871897] CR2: ffffffffd9c01fb1

The crash again points to test_bit in info_idq_free.  I followed
your advise to search for the address and here is what I got: 

crash> search -m ffffffff00000000 d9c01f11

ffff88000181e030: d9c01927d9c01f11 
ffff880996894680: ffffffffd9c01f11 
ffff881d5019b858: ffffffffd9c01f11 
ffff881d5019b998: ffffffffd9c01f11 - <stack frame of crash_kexec>
ffff881d5019bbe8: ffffffffd9c01f11 - <stack frame of page_fault)
ffffffff8181e030: d9c01927d9c01f11

So two of the values are in the stack frames of function involved, 
in the crash so I'd say they are of no interest. What's interesting
is that ffffffff8181e030 seems to be quota_magics: 

readelf -s vmlinux-4.4.10-clouder1 | grep ffffffff8181e030
15605: ffffffff8181e030    12 OBJECT  LOCAL  DEFAULT    4 quota_magics.24849

#define V2_INITQMAGICS {\
        0xd9c01f11,     /* USRQUOTA */\
        0xd9c01927,     /* GRPQUOTA */\
        0xd9c03f14,     /* PRJQUOTA */\
}

So it seems that somehow the USRQUOTA magic values overwrites
the dquot pointer. Looking at the code I'm not entirely 
sure how this can happen though.
