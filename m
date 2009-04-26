From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4: ext4_mark_recovery_complete() doesn't need
	to use lock_super
Date: Sun, 26 Apr 2009 07:46:08 -0400
Message-ID: <20090426114608.GC10248@mit.edu>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <1240717765-16572-3-git-send-email-tytso@mit.edu> <1240717765-16572-4-git-send-email-tytso@mit.edu> <20090426070713.GA17022@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753795AbZDZLq2@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090426070713.GA17022@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 26, 2009 at 03:07:14AM -0400, Christoph Hellwig wrote:
> On Sat, Apr 25, 2009 at 11:49:23PM -0400, Theodore Ts'o wrote:
> > The function ext4_mark_recovery_complete() is called from two call
> > paths: either (a) while mounting the filesystem, in which case there's
> > no danger of any other CPU calling write_super() until the mount is
> > completed, and (b) while remounting the filesystem read-write, in
> > which case the fs core has already locked the superblock, and in any
> > case write_super() wouldn't be called until the filesystem is
> > successfully changed from being mounted read-only to read-write.
> 
> Currently ext4_remount releases/reqacquires lock_super around
> ext4_mark_recovery_complete, and unfortunately currently ->write_super
> can be called on a r/o filesystem (that's why we have the MS_RDONLY
> checks in all instance, I plan to clean that mess up).

That's true, but the patch also takes out the release/reacquire in in
ext4_remount (which was particularly ugly, belch).  So even if
write_super gets called on an r/o filesystem (why?!?), we should be
safe because remount will hold lock_super() throughout the entire
remount operation.

We could delay this cleanup until you clean the mess with write_super,
but I don't think it would be harmful in removing the
lock_super()/unlock_super() pair in ext4_mark_recovery_complete(), and
the unlock_super()/lock_super() pair in ext4_remount before then.  Am
I missing something?

						- Ted
