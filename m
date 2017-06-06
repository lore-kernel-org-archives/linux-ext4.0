From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [BUG] Unable to handle kernel paging request for unaligned
 access at address 0xc0000001c52c53df
Date: Tue, 6 Jun 2017 17:04:43 -0400
Message-ID: <20170606210443.zoqc7lajpstlridt@thunk.org>
References: <CAEemH2fq0ciRxhpi2m7Rv1HTyzB1z=jFkEUOvan5jtSkw-tDSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ebiggers@google.com, jack@suse.cz, linux-kernel@vger.kernel.org,
        ltp@lists.linux.it, linux-ext4@vger.kernel.org,
        Chunyu Hu <chuhu@redhat.com>
To: Li Wang <liwang@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEemH2fq0ciRxhpi2m7Rv1HTyzB1z=jFkEUOvan5jtSkw-tDSw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 06, 2017 at 06:00:34PM +0800, Li Wang wrote:
> Hi,
> 
> ltp/access04 always panic the latest mainstream kernel-4.12-rc4 on
> ppc64le. From the calltrace
> I guess the reason is probably that the tests mount ext2 file system
> using ext4 driver.
> 
> A simple way to reproduce:
> 
> # dd of=wangli if=/dev/zero count=1024 bs=1024
> # mkfs -t ext2 wangli
> # mount -t ext4 wangli /mnt/

So I'm guessing from the stack trace that the crash is happening while
creating a workqueue:

> [  318.558229] Call Trace:
> [  318.558231] [c0000003ac1376a0] [c000000009d06034] 0xc000000009d06034 (unreliable)
> [  318.558236] [c0000003ac1376d0] [c00000000011c5d4] try_to_wake_up+0x1f4/0x5b0
> [  318.558241] [c0000003ac137750] [c000000000102828] create_worker+0x148/0x250
> [  318.558245] [c0000003ac1377f0] [c0000000001059dc] alloc_unbound_pwq+0x3bc/0x4c0
> [  318.558249] [c0000003ac137850] [c00000000010601c] apply_wqattrs_prepare+0x2ac/0x320
> [  318.558253] [c0000003ac1378c0] [c0000000001060cc] apply_workqueue_attrs_locked+0x3c/0xa0
> [  318.558257] [c0000003ac1378f0] [c00000000010662c] apply_workqueue_attrs+0x4c/0x80
> [  318.558261] [c0000003ac137930] [c0000000001081cc] __alloc_workqueue_key+0x16c/0x4e0
> [  318.558280] [c0000003ac1379f0] [d000000008455ca0] ext4_fill_super+0x1c70/0x3390 [ext4]
  ...

And the ext4 code in question is just doing this:

	EXT4_SB(sb)->rsv_conversion_wq =
		alloc_workqueue("ext4-rsv-conversion", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);

This looks pretty boring and I don't see anything which is specific
about ext4 or the file system that would cause the crash.

Can you bisect this by any chance?  When was the last kernel version
where this worked?  When did it first fail?

Thanks,

					- Ted
