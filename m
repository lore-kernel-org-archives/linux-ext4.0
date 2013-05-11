From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Nasty memory corrution v3.9-12555-g2dbd3ca
Date: Sat, 11 May 2013 12:13:20 +0400
Message-ID: <87y5bm53z3.fsf@openvz.org>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17> <20130510192747.GA11707@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Theodore Ts'o <tytso@mit.edu>, EUNBONG SONG <eunb.song@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130510192747.GA11707@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 10 May 2013 15:27:47 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> Hmm, since you seem to be able to reproduce the problem reliably, any
> chance you can try bisecting the problem?  I've looked at the commits
> that touch fs/jbd2 and nothing is jumping out at me.
> 
> Also, how many CPU's do you have your system, and what kind of storage
> device were you using when you were running iozone (5400rpm HDD,
> 7200RPM HDD, RAID array, SSD, etc.)?
XFS TOO....
It it definitely just an ext3/4 related issue.
I've run xfstests on xfs and almost immediately have got slub corruption
I use following HEAD: 2dbd3cac87250a0d44e07acc86c4224a08522709

2013-05-11 11:59:30 Slab corruption (Not tainted): xfs_efi_item
start=ffff8802335063f0, len=400^M
2013-05-11 11:59:30 Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.^M
2013-05-11 11:59:30 Last user:
[<ffffffffa03ba36f>](xfs_efi_item_free+0x3f/0x50 [xfs])^M
2013-05-11 11:59:30 070: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
jkkkkkkkkkkkkkkk^M
2013-05-11 11:59:30 Single bit error detected. Probably bad RAM.^M
2013-05-11 11:59:30 Run memtest86+ or a similar memory test tool.^M
2013-05-11 11:59:30 Prev obj: start=ffff880233506248, len=400^M
2013-05-11 11:59:30 Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.^M
2013-05-11 11:59:30 Last user:
[<ffffffffa034d7bb>](kmem_zone_alloc+0xbb/0x190 [xfs])^M
2013-05-11 11:59:30 000: 48 62 50 33 02 88 ff ff 48 62 50 33 02 88 ff ff
HbP3....HbP3....^M
2013-05-11 11:59:30 010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................^M
2013-05-11 11:59:30 Next obj: start=ffff880233506598, len=400^M
2013-05-11 11:59:30 Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.^M
> 
> Thanks,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
