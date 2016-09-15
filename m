From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6 linux-next] ext4: fix memory leak in
 ext4_insert_range()
Date: Thu, 15 Sep 2016 11:40:29 -0400
Message-ID: <20160915154029.z3qtbfjjocu37paa@thunk.org>
References: <1472069000-18897-1-git-send-email-fabf@skynet.be>
 <1472069000-18897-7-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472069000-18897-7-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 24, 2016 at 10:03:20PM +0200, Fabian Frederick wrote:
> Running xfstests generic/013 with kmemleak gives the following:
> 
> unreferenced object 0xffff8801d3d27de0 (size 96):
>   comm "fsstress", pid 4941, jiffies 4294860168 (age 53.485s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff818eaaf3>] kmemleak_alloc+0x23/0x40
>     [<ffffffff81179805>] __kmalloc+0xf5/0x1d0
>     [<ffffffff8122ef5c>] ext4_find_extent+0x1ec/0x2f0
>     [<ffffffff8123530c>] ext4_insert_range+0x34c/0x4a0
>     [<ffffffff81235942>] ext4_fallocate+0x4e2/0x8b0
>     [<ffffffff81181334>] vfs_fallocate+0x134/0x210
>     [<ffffffff8118203f>] SyS_fallocate+0x3f/0x60
>     [<ffffffff818efa9b>] entry_SYSCALL_64_fastpath+0x13/0x8f
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Problem seems mitigated by dropping refs and freeing path
> when there's no path[depth].p_ext
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks.

					- Ted
