From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: ext4 ignoring rootfs default mount options
Date: Wed, 7 Mar 2018 14:13:24 -0500
Message-ID: <20180307191324.qtloesy4zdlkfnwv@csclub.uwaterloo.ca>
References: <20180306190315.puocf5bu3bfz6yct@csclub.uwaterloo.ca>
 <20180307040608.GA2462@thunk.org>
 <20180307151427.i6vbeq6kqo55cdgs@csclub.uwaterloo.ca>
 <20180307160856.GD7507@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180307160856.GD7507@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 07, 2018 at 11:08:56AM -0500, Theodore Y. Ts'o wrote:
> This is where it's critcal to understand that the "tune2fs -o" changes
> the *default* mount options.  The key in the comment is the anything
> different from the *filesystem* defaults (that is, the defaults of the
> particular ext4 file system, as opposed to the global defaults).  The
> idea is that /proc/mounts, and /etc/mtab shows the options string that
> if used in /etc/fstab, or in the mount command line, will replicate
> the current mount option state.  Furthermore, that /proc/mounts is the
> minimal set of mount option strings.

One more question about this.

Trying to use tune2fs -E mount_opts to set some default options, and
can't figure out how to enter two options at once.

Doing:

tune2fs -E mount_opts=nodelalloc,nouser_xattr /dev/sda3

gives the error:

tune2fs 1.43.4 (31-Jan-2017)

Bad options specified.

Extended options are separated by commas, and may take an argument which
        is set off by an equals ('=') sign.

Valid extended options are:
        clear_mmp
        hash_alg=<hash algorithm>
        mount_opts=<extended default mount options>
        stride=<RAID per-disk chunk size in blocks>
        stripe_width=<RAID stride*data disks in blocks>
        test_fs
        ^test_fs

Apparently it gets confused by the , in the argument to mount_opts.

Unfortunately , happens to be the separator required by ext4 for that
field.  So how does one use it?

Sure in this case I can set one with -o and the other with -E, but in
general there seems to be a small problem here, probably only in user
space though.  Seems tune2fs needs some change in how it deals with
extended options that contain commas.

-- 
Len Sorensen
