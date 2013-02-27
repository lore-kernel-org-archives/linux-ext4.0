From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 13:47:27 +0100
Message-ID: <20130227124727.GA225@x4>
References: <nsxr4k2kdwv.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nsxr4k2kdwv.fsf@closure.thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013.02.26 at 15:39 -0500, Theodore Ts'o wrote:
> 
> The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:
> 
>   Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

Just booted todays Linux tree and got the following errors:

...
Feb 27 13:33:31 x4 kernel: EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
...
Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: inode #70647809: block 14164000: comm cupsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2569822761, rec_len=3837, name_len=1
Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_find_dest_de:1657: inode #70911401: block 15213579: comm pdnsd: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=2000846358, rec_len=36782, name_len=120

/dev/sda       ext4      1.4T  655G  651G  51% /var
/dev/sda on /var type ext4 (rw,noatime,data=ordered)

Running "fsck.ext4 -f /dev/sda" shows no problems.

-- 
Markus
