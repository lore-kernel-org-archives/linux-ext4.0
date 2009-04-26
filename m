From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] ext4: ext4_mark_recovery_complete() doesn't need
	to use lock_super
Date: Sun, 26 Apr 2009 03:07:14 -0400
Message-ID: <20090426070713.GA17022@infradead.org>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <1240717765-16572-3-git-send-email-tytso@mit.edu> <1240717765-16572-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754433AbZDZHHb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1240717765-16572-4-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Apr 25, 2009 at 11:49:23PM -0400, Theodore Ts'o wrote:
> The function ext4_mark_recovery_complete() is called from two call
> paths: either (a) while mounting the filesystem, in which case there's
> no danger of any other CPU calling write_super() until the mount is
> completed, and (b) while remounting the filesystem read-write, in
> which case the fs core has already locked the superblock, and in any
> case write_super() wouldn't be called until the filesystem is
> successfully changed from being mounted read-only to read-write.

Currently ext4_remount releases/reqacquires lock_super around
ext4_mark_recovery_complete, and unfortunately currently ->write_super
can be called on a r/o filesystem (that's why we have the MS_RDONLY
checks in all instance, I plan to clean that mess up).

So for now I would keep that instance of lock_super, it'll also serve as
documentation for the locking requirements once we pushed down
lock_super to the filesystem in ->write_super and ->remount_fs so that
it can eventually be replaced with an ext4-local lock.
