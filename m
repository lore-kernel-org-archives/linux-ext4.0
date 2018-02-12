From: Jiri Slaby <jslaby@suse.cz>
Subject: ext4 iomap SEEK broken [was: [GIT PULL] ext4 updates for 4.15]
Date: Mon, 12 Feb 2018 11:02:29 +0100
Message-ID: <7ae851b1-92a8-779a-a066-1c7e34867465@suse.cz>
References: <20171113031502.f6mctmlmgk5psh77@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:46330 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932505AbeBLKCc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Feb 2018 05:02:32 -0500
In-Reply-To: <20171113031502.f6mctmlmgk5psh77@thunk.org>
Content-Language: en-GB
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 11/13/2017, 04:15 AM, Theodore Ts'o wrote:
> The following changes since commit 9e66317d3c92ddaab330c125dfe9d06eee268aff:
> 
>   Linux 4.14-rc3 (2017-10-01 14:54:54 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus
...
> Christoph Hellwig (1):
>       ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA

So I bisected a 32bit hole problem in 4.15 down to this one.

tar selftests never finish during build on the 32bit kernel. The stack
trace is something like this:
tar             R  running task        0 24780  24590 0x00000000
Call Trace:
 ? ext4_map_blocks+0x2fa/0x5f0
 ? ext4_map_blocks+0x348/0x5f0
 ? ext4_iomap_begin+0x39b/0x4d0
 ? ext4_evict_inode+0x5c0/0x5c0
 ? iomap_apply+0x61/0x160
 ? iomap_to_fiemap+0xd0/0xd0
 ? iomap_seek_data+0xac/0x110
 ? iomap_seek_hole_actor+0x80/0x80
 ? ext4_llseek+0x13a/0x140
 ? ext4_file_mmap+0x90/0x90
 ? SyS_llseek+0x7b/0xc0
 ? do_int80_syscall_32+0x51/0x100
 ? entry_INT80_32+0x36/0x36


The tar test does this:
AT_TAR_CHECK([
AT_DATA([mapfile],
[0 =2560
m4_for([i], 1, 999, 1, [10M =2560
])])
genfile --sparse --file BIGFILE --block-size 4K - < mapfile || AT_SKIP_TEST
tar -f - -c --sparse --posix BIGFILE | tar tvf - | awk '{ print $3, $(NF) }'
],

I.e. it generates a file with 1000 blocks of 2560*4K bytes. The blocks
are 10M from each other, that is 999 10M holes. Tar then tries to
read&seek in the file, but the seek above never finishes (or maybe
finishes after a long time).

Given this happens only on 32bit kernel, I assume some 32bit overflow.
But I am unable to see it (yet).

thanks,
-- 
js
suse labs
