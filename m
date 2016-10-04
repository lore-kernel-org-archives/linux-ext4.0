From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Regression in next with ext4 oops
Date: Tue, 4 Oct 2016 15:56:39 +0100
Message-ID: <20161004145639.GY19539@ZenIV.linux.org.uk>
References: <20161003233054.eltv3coiweht3ui4@atomide.com>
 <20161004090041.GE17515@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tony Lindgren <tony@atomide.com>,
        Eric Biggers <ebiggers@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161004090041.GE17515@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 04, 2016 at 11:00:41AM +0200, Jan Kara wrote:
> Hi!
> 
> On Mon 03-10-16 16:30:55, Tony Lindgren wrote:
> > I'm seeing a repeatable oops with Linux next while running
> > update-initramfs, see below. I tried reverting commit 59aa5a3aeead
> > ("fscrypto: make filename crypto functions return 0 on success")
> > as that's the only commit changing ext4_htree_store_dirent, but
> > that did not help.
> > 
> > Anybody else seeing something like this?
> 
> Never seen this but I suspect it is a fallout from Al's directory locking
> changes. In particular ext4_htree_fill_tree() builds rb-tree of found
> directory entries in file->private_data (and generally modifies the
> structure stored there) but after Al's changes we don't have exclusive
> access to struct file if I'm right so if two processes end up calling
> getdents() for the same 'struct file' we are doomed.

RTFS.  We sure as hell *do* have exclusive access to struct file.  See
        /* POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
        if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))
                f->f_mode |= FMODE_ATOMIC_POS;
in do_dentry_open() as well as
        if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
                if (file_count(file) > 1) {
                        v |= FDPUT_POS_UNLOCK;
                        mutex_lock(&file->f_pos_lock);
                }
        }
in __fdget_pos() and
        f = fdget_pos(fd);
        if (!f.file)
                return -EBADF;
in getdents(2).
