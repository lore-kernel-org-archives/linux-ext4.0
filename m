From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: ext4 ignoring rootfs default mount options
Date: Wed, 7 Mar 2018 11:08:56 -0500
Message-ID: <20180307160856.GD7507@thunk.org>
References: <20180306190315.puocf5bu3bfz6yct@csclub.uwaterloo.ca>
 <20180307040608.GA2462@thunk.org>
 <20180307151427.i6vbeq6kqo55cdgs@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180307151427.i6vbeq6kqo55cdgs@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 07, 2018 at 10:14:28AM -0500, Lennart Sorensen wrote:
> 
> But delalloc is the default for ext4, so a filesystem mounted with
> nodelalloc ought to show that in /proc/mounts as far as I am concerned.
> The comment in the code says anything that is different than the global
> defaults and the filesystem defaults will be shown, but in this case it
> is not.  Maybe the comment is just wrong or unclear and this is actually
> the intended behaviour.  I don't think I like the behaviour if it is
> intended to work this way.  The /proc/fs/ext4/ option at least looks
> workable.  Strangely I found the function that implements it but couldn't
> find anything using it for some reason.  I must have just missed it
> since it obviously is there.

This is where it's critcal to understand that the "tune2fs -o" changes
the *default* mount options.  The key in the comment is the anything
different from the *filesystem* defaults (that is, the defaults of the
particular ext4 file system, as opposed to the global defaults).  The
idea is that /proc/mounts, and /etc/mtab shows the options string that
if used in /etc/fstab, or in the mount command line, will replicate
the current mount option state.  Furthermore, that /proc/mounts is the
minimal set of mount option strings.

You may not like the behavior, but it's been this way forever, and the
reasoning behind it is that the low-level file system code doesn't
really know what the actual mount option string that would be in
/etc/fstab or in the /sbin/mount command line.  That's because
/sbin/mount command actually parses the mount options, and things like
"ro" is actually translated into bitflag passed to the mount option.
So for example, it's impossible to know whether "rw" was in the
user-specified mount string, since we never see it by the time the
string gets sent to ext4_fill_super (in fact the kernel never sees
it).  So when we try to make /proc/mounts a replacement for /etc/mtab
(since some people make /etc/mtab as symlink /proc/mounts), it's
actually impossible.  Trying to make it be the minimal set of options
was at least a consitent thing.  That is, if you use "tune2fs -o
nodelalloc", it's not necessary to put nodelalloc in /etc/fstab or in
the mount command line.  And hence, it should not be in /proc/mounts.

As far as where ext4_seq_options_show() gets called, it's because we
have a fair amount of macro shortcuts in fs/ext4/sysfs.c (which is
where we put all of the pseudo file system support for ext4, which
means it includes procfs).  Search for macros PROC_FILE_SHOW_DEFN and
PROC_FILE_LIST.

						- Ted
