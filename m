From: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 19/19] fs: handle inode->i_version more efficiently
Date: Sun, 7 Jan 2018 13:44:52 +0100
Message-ID: <CAJKOXPd8ojTjiGF3nKQKWtVrEsjWfjvg6rLL+RGnbu_SZMDu7g@mail.gmail.com>
References: <20171222120556.7435-1-jlayton@kernel.org> <20171222120556.7435-20-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, jack-l3A5Bk7waGM@public.gmane.org,
        linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, jbacik-b10kYP2dOMg@public.gmane.org,
        dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvxYJuaWVya2lld2ljeg==?=
        <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222120556.7435-20-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 22, 2017 at 1:05 PM, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Since i_version is mostly treated as an opaque value, we can exploit that
> fact to avoid incrementing it when no one is watching. With that change,
> we can avoid incrementing the counter on writes, unless someone has
> queried for it since it was last incremented. If the a/c/mtime don't
> change, and the i_version hasn't changed, then there's no need to dirty
> the inode metadata on a write.
>
> Convert the i_version counter to an atomic64_t, and use the lowest order
> bit to hold a flag that will tell whether anyone has queried the value
> since it was last incremented.
>
> When we go to maybe increment it, we fetch the value and check the flag
> bit.  If it's clear then we don't need to do anything if the update
> isn't being forced.
>
> If we do need to update, then we increment the counter by 2, and clear
> the flag bit, and then use a CAS op to swap it into place. If that
> works, we return true. If it doesn't then do it again with the value
> that we fetch from the CAS operation.
>
> On the query side, if the flag is already set, then we just shift the
> value down by 1 bit and return it. Otherwise, we set the flag in our
> on-stack value and again use cmpxchg to swap it into place if it hasn't
> changed. If it has, then we use the value from the cmpxchg as the new
> "old" value and try again.
>
> This method allows us to avoid incrementing the counter on writes (and
> dirtying the metadata) under typical workloads. We only need to increment
> if it has been queried since it was last changed.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/fs.h       |   2 +-
>  include/linux/iversion.h | 208 ++++++++++++++++++++++++++++++++++-------------
>  2 files changed, 154 insertions(+), 56 deletions(-)
>

Hi,

On recent linux-next my ARM/Exynos boards fail to boot over nfsroot.
This commit popped up through bisect (log at the end). Systemd
timeouts on some device-specific services, including mounting ext4
/home:

[ *** ] (1 of 4) A start job is running for…ress polling (1min 41s / no limit)
[ TIME ] Timed out waiting for device dev-ttySAC2.device.
Jan 07 13:29:38 [DEPEND] Dependency failed for Serial Getty on ttySAC2.
Jan 07 13:29:38 [ TIME ] Timed out waiting for device
dev-disk-by\x2dlabel-home.device.
Jan 07 13:29:38 [DEPEND] Dependency failed for /home.
Jan 07 13:29:38 [DEPEND] Dependency failed for Local File Systems.
Jan 07 13:29:38 [DEPEND] Dependency failed for File System Check on
/dev/disk/by-label/home.
Jan 07 13:30:02 [ *** ] (1 of 2) A start job is running for…ress
polling (1min 53s / no limit)

Kernel command line:
console=tty1 console=ttySAC2,115200n8
ip=192.168.1.11:192.168.1.10:192.168.1.1:255.255.255.0::eth0:none
nfsrootdebug root=/dev/nfs
nfsroot=192.168.1.10:/srv/nfs/odroidxu3,vers=4,nolock rootwait rw
smsc95xx.macaddr=00:1e:06:61:7a:93 no_console_suspend

/home is /dev/mmcblk1p2:
kozik@odroidxu3:~$ tune2fs -l /dev/mmcblk1p2
tune2fs 1.43.7 (16-Oct-2017)
Filesystem volume name:   home
Last mounted on:          /home
Filesystem UUID:          3f9dbeba-2738-45d3-807e-c1b2e21128ed
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              1430800
Block count:              5717760
Reserved block count:     285888
Free blocks:              5467576
Free inodes:              1428301
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1022
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8176
Inode blocks per group:   511
Flex block group size:    16
Filesystem created:       Thu May 21 12:17:05 2015
Last mount time:          Thu Dec 21 13:31:26 2017
Last write time:          Thu Dec 21 13:31:26 2017
Mount count:              1
Maximum mount count:      -1
Last checked:             Thu Dec 21 13:31:25 2017
Check interval:           0 (<none>)
Lifetime writes:          126 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:           256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      42e17e23-86b2-4356-ad63-78aa51651d03
Journal backup:           inode blocks


Full dmesg log:
http://www.krzk.eu/#/builders/1/builds/1258/steps/10/logs/serial0

The regular boot from rootfs on SD card also fails - but without any
serial console logs (just "Starting kernel...") so the real cause is
unknown.

Any hints?

Best regards,
Krzysztof


bisect log:
# bad: [73005e1a35fd67c644b0645c9e4c1efabd0fe62c] Add linux-next
specific files for 20180103
# good: [30a7acd573899fd8b8ac39236eff6468b195ac7d] Linux 4.15-rc6
git bisect start 'next/master' 'next/stable'
# bad: [c1d290f9ce8daa2b0a79d2fe48c1b7c3c5370f5a] Merge
remote-tracking branch 'crypto/master'
git bisect bad c1d290f9ce8daa2b0a79d2fe48c1b7c3c5370f5a
# bad: [55695d94f0915121d106cd2d1ab94983a32f3e9a] Merge
remote-tracking branch 'hid/for-next'
git bisect bad 55695d94f0915121d106cd2d1ab94983a32f3e9a
# good: [cffae1eead0dd91be1a3069a8348127bb00158f3] Merge
remote-tracking branch 'realtek/for-next'
git bisect good cffae1eead0dd91be1a3069a8348127bb00158f3
# good: [5f889f1176dc99636c6bf8af7c286decc888c007] Merge
remote-tracking branch 'btrfs/next'
git bisect good 5f889f1176dc99636c6bf8af7c286decc888c007
# good: [984c35877f36bee305e43a1c58176169854d85cf] Merge
remote-tracking branch 'xfs/for-next'
git bisect good 984c35877f36bee305e43a1c58176169854d85cf
# bad: [f9fec502daea2a869232b6dff33ba3de79dd0d61] Merge
remote-tracking branch 'printk/for-next'
git bisect bad f9fec502daea2a869232b6dff33ba3de79dd0d61
# good: [c71d227fc4133f949dae620ed5e3a250b43f2415] make kernel-side
POLL... arch-independent
git bisect good c71d227fc4133f949dae620ed5e3a250b43f2415
# good: [416d20e8c31107f5dfd45d1d80d1e6c8e4871180] Merge branches
'work.get_user_pages_fast', 'work.wmci', 'work.sock_recvmsg',
'misc.netdrv', 'misc.poll', 'work.mqueue', 'work.whack-a-mole' and
'work.misc' into for-next
git bisect good 416d20e8c31107f5dfd45d1d80d1e6c8e4871180
# good: [325a1de4a691512a48c1426b943a7b0b9f8d6744] xfs: convert to new
i_version API
git bisect good 325a1de4a691512a48c1426b943a7b0b9f8d6744
# good: [a94fe10fb114c169e7ddaecd8251521886409121] checkpatch: add
pF/pf deprecation warning
git bisect good a94fe10fb114c169e7ddaecd8251521886409121
# good: [6b3911dffd1184fdcd63299a5fee59ac000f2067] btrfs: only dirty
the inode in btrfs_update_time if something was changed
git bisect good 6b3911dffd1184fdcd63299a5fee59ac000f2067
# bad: [448f8c749a7a0ae03505823910ec45a112678048] Merge
remote-tracking branch 'iversion/iversion-next'
git bisect bad 448f8c749a7a0ae03505823910ec45a112678048
# bad: [8618bff776758ebff5b55211e7b5a60a0fc119a5] fs: handle
inode->i_version more efficiently
git bisect bad 8618bff776758ebff5b55211e7b5a60a0fc119a5
# first bad commit: [8618bff776758ebff5b55211e7b5a60a0fc119a5] fs:
handle inode->i_version more efficiently
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
