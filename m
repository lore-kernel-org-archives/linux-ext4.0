From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Tue, 23 Oct 2012 20:13:22 -0500
Message-ID: <508740B2.2030401@redhat.com>
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Bryan Schumaker <bjschuma-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	Peng Tao <bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nix <nix-dKoSMcxRz+Te9xe1eoZjHA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87pq48nbyz.fsf_-_-AdTWujXS48Mg67Zj9sPl2A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 10/23/12 3:57 PM, Nix wrote:

<snip>

> (I'd provide more sample errors, but this bug has been eating
> newly-written logs in /var all day, so not much has survived.)
> 
> I rebooted into 3.6.1 rescue mode and fscked everything: lots of
> orphans, block group corruption and cross-linked files. The problems did
> not recur upon booting from 3.6.1 into 3.6.1 again. It is quite clear
> that metadata changes made in 3.6.3 are not making it to disk reliably,
> thus leading to corrupted filesystems marked clean on reboot into other
> kernels: pretty much every file appended to in 3.6.3 loses some or all
> of its appended data, and newly allocated blocks often end up
> cross-linked between multiple files.
> 
> The curious thing is this doesn't affect every filesystem: for a while
> it affected only /var, and now it's affecting only /var and /home. The
> massive writes to the ext4 filesystem mounted on /usr/src seem to have
> gone off without incident: fsck reports no problems.
> 
> 
> The only unusual thing about the filesystems on this machine are that
> they have hardware RAID-5 (using the Areca driver), so I'm mounting with
> 'nobarrier': 

I should have read more.  :(  More questions follow:

* Does the Areca have a battery backed write cache?
* Are you crashing or rebooting cleanly?
* Do you see log recovery messages in the logs for this filesystem?

> the full set of options for all my ext4 filesystems are:
> 
> rw,nosuid,nodev,relatime,journal_checksum,journal_async_commit,nobarrier,quota,
> usrquota,grpquota,commit=30,stripe=16,data=ordered,usrquota,grpquota

ok journal_async_commit is off the reservation a bit; that's really not
tested, and Jan had serious reservations about its safety.

* Can you reproduce this w/o journal_async_commit?

-Eric

> If there's anything I can do to help, I'm happy to do it, once I've
> restored my home directory from backup :(
> 
> 
> tune2fs output for one of the afflicted filesystems (after fscking):
> 
> tune2fs 1.42.2 (9-Apr-2012)
> Filesystem volume name:   home
> Last mounted on:          /home
> Filesystem UUID:          95bd22c2-253c-456f-8e36-b6cfb9ecd4ef
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              3276800
> Block count:              13107200
> Reserved block count:     655360
> Free blocks:              5134852
> Free inodes:              3174777
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      20
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8192
> Inode blocks per group:   512
> RAID stripe width:        16
> Flex block group size:    64
> Filesystem created:       Tue May 26 21:29:41 2009
> Last mount time:          Tue Oct 23 21:32:07 2012
> Last write time:          Tue Oct 23 21:32:07 2012
> Mount count:              2
> Maximum mount count:      20
> Last checked:             Tue Oct 23 21:22:16 2012
> Check interval:           15552000 (6 months)
> Next check after:         Sun Apr 21 21:22:16 2013
> Lifetime writes:          1092 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> First orphan inode:       1572907
> Default directory hash:   half_md4
> Directory Hash Seed:      a201983d-d8a3-460b-93ca-eb7804b62c23
> Journal backup:           inode blocks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
