From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/32] ext4: do not set posix acls on xattr inodes
Date: Wed, 21 Jun 2017 21:23:37 -0400
Message-ID: <20170622012337.pemajnble5pvyhst@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-4-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-4-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:14PM -0700, Tahsin Erdogan wrote:
> We don't need acls on xattr inodes because they are not directly
> accessible from user mode.
> 
> Besides lockdep complains about recursive locking of xattr_sem as seen
> below.
> 
>   =============================================
>   [ INFO: possible recursive locking detected ]
>   4.11.0-rc8+ #402 Not tainted
>   ---------------------------------------------
>   python/1894 is trying to acquire lock:
>    (&ei->xattr_sem){++++..}, at: [<ffffffff804878a6>] ext4_xattr_get+0x66/0x270
> 
>   but task is already holding lock:
>    (&ei->xattr_sem){++++..}, at: [<ffffffff80489500>] ext4_xattr_set_handle+0xa0/0x5d0
> 
>   other info that might help us debug this:
>    Possible unsafe locking scenario:
> 
>          CPU0
>          ----
>     lock(&ei->xattr_sem);
>     lock(&ei->xattr_sem);
> 
>    *** DEADLOCK ***
> 
>    May be due to missing lock nesting notation
> 
>   3 locks held by python/1894:
>    #0:  (sb_writers#10){.+.+.+}, at: [<ffffffff803d829f>] mnt_want_write+0x1f/0x50
>    #1:  (&sb->s_type->i_mutex_key#15){+.+...}, at: [<ffffffff803dda27>] vfs_setxattr+0x57/0xb0
>    #2:  (&ei->xattr_sem){++++..}, at: [<ffffffff80489500>] ext4_xattr_set_handle+0xa0/0x5d0
> 
>   stack backtrace:
>   CPU: 0 PID: 1894 Comm: python Not tainted 4.11.0-rc8+ #402
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>   Call Trace:
>    dump_stack+0x67/0x99
>    __lock_acquire+0x5f3/0x1830
>    lock_acquire+0xb5/0x1d0
>    down_read+0x2f/0x60
>    ext4_xattr_get+0x66/0x270
>    ext4_get_acl+0x43/0x1e0
>    get_acl+0x72/0xf0
>    posix_acl_create+0x5e/0x170
>    ext4_init_acl+0x21/0xc0
>    __ext4_new_inode+0xffd/0x16b0
>    ext4_xattr_set_entry+0x5ea/0xb70
>    ext4_xattr_block_set+0x1b5/0x970
>    ext4_xattr_set_handle+0x351/0x5d0
>    ext4_xattr_set+0x124/0x180
>    ext4_xattr_user_set+0x34/0x40
>    __vfs_setxattr+0x66/0x80
>    __vfs_setxattr_noperm+0x69/0x1c0
>    vfs_setxattr+0xa2/0xb0
>    setxattr+0x129/0x160
>    path_setxattr+0x87/0xb0
>    SyS_setxattr+0xf/0x20
>    entry_SYSCALL_64_fastpath+0x18/0xad
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, added to the ext4 patch queue.

						- Ted
