From: Nick Piggin <npiggin@suse.de>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has
 been remounted readonly
Date: Tue, 2 Mar 2010 21:29:01 +1100
Message-ID: <20100302102901.GE8653@laptop>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
 <9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
 <baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
 <20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
 <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Camille Moncelier <pix@devlife.org>, linux-fsdevel@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 23, 2010 at 12:05:52AM +0100, Jan Kara wrote:
> > > On Thu, Feb 18, 2010 at 10:41 PM, Andreas Dilger <adilger@sun.com> wrote:
> > > 
> > > > Are you sure this isn't because e2fsck has been run at boot time and changed
> > > > e.g. the "last checked" timestamp in the superblock?
> > > >
> > > No, I replaced /sbin/init by something which compute the sha1sum of
> > > the root partition, display it then call /sbin/init and I can see that
> > > the hash has changed after mount -o remount,ro.
> > > 
> > > As little as I understand, I managed to make a diff between two
> > > hexdump of small images where changes happened after I created a file
> > > and remounted the fs ro and it seems that, the driver didn't wrote
> > > changes to the disk until unmount  ( The hexdump clearly shows that
> > > /lost+found and /test file has been written after the umount )
> > > 
> > > workaround: Is there some knob in /proc or /sys which can trigger all
> > > pending changes to disk ? ( Like /proc/sys/vm/drop_caches but for
> > > filesystems ? )
> >   I've looked at your script. The problem is that "echo s >/proc/sysrq_trigger"
> > isn't really a data integrity operation. In particular it does not wait on
> > IO to finish (with the new writeback code it does not even wait for IO to be
> > submitted) so you sometimes take the image checksum before the sync actually
> > happens. If you used sync(1) instead, everything should work as expected...
>   Hmm, and apparently there is some subtlety in the loopback device code
> because even when I use sync(1), the first and second images sometimes differ
> (although it's much rarer). But I see a commit block of the transaction already
> in the first image (the commit block is written last) but the contents of the
> transaction is present only in the second image.

Then I would guess that it might be running into the problem solved by
this commit in Al's tree (don't think it hit mainline yet).

Hmm, now that I look at the patch again, I can't remember whether I
checked that a umount also does the correct bdev invalidation. Better
check that.

commit 17b0184495b52858fcc514aa0769801ac055b086
Author: Nick Piggin <npiggin@suse.de>
Date:   Mon Dec 21 16:28:53 2009 -0800

    fs: improve remount,ro vs buffercache coherency
    
    Invalidate sb->s_bdev on remount,ro.
    
    Fixes a problem reported by Jorge Boncompte who is seeing corruption
    trying to snapshot a minix filesystem image.  Some filesystems modify
    their metadata via a path other than the bdev buffer cache (eg.  they may
    use a private linear mapping for their metadata, or implement directories
    in pagecache, etc).  Also, file data modifications usually go to the bdev
    via their own mappings.
    
    These updates are not coherent with buffercache IO (eg.  via /dev/bdev)
    and never have been.  However there could be a reasonable expectation that
    after a mount -oremount,ro operation then the buffercache should
    subsequently be coherent with previous filesystem modifications.
    
    So invalidate the bdev mappings on a remount,ro operation to provide a
    coherency point.
    
    The problem was exposed when we switched the old rd to brd because old rd
    didn't really function like a normal block device and updates to rd via
    mappings other than the buffercache would still end up going into its
    buffercache.  But the same problem has always affected other "normal"
    block devices, including loop.
    
    [akpm@linux-foundation.org: repair comment layout]
    Reported-by: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
    Tested-by: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/super.c b/fs/super.c
index aff046b..903896e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -568,7 +568,7 @@ out:
 int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 {
 	int retval;
-	int remount_rw;
+	int remount_rw, remount_ro;
 
 	if (sb->s_frozen != SB_UNFROZEN)
 		return -EBUSY;
@@ -583,9 +583,12 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	shrink_dcache_sb(sb);
 	sync_filesystem(sb);
 
+	remount_ro = (flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY);
+	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
+
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
-	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
+	if (remount_ro) {
 		if (force)
 			mark_files_ro(sb);
 		else if (!fs_may_remount_ro(sb))
@@ -594,7 +597,6 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 		if (retval < 0 && retval != -ENOSYS)
 			return -EBUSY;
 	}
-	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
@@ -604,6 +606,16 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	if (remount_rw)
 		vfs_dq_quota_on_remount(sb);
+	/*
+	 * Some filesystems modify their metadata via some other path than the
+	 * bdev buffer cache (eg. use a private mapping, or directories in
+	 * pagecache, etc). Also file data modifications go via their own
+	 * mappings. So If we try to mount readonly then copy the filesystem
+	 * from bdev, we could get stale data, so invalidate it to give a best
+	 * effort at coherency.
+	 */
+	if (remount_ro && sb->s_bdev)
+		invalidate_bdev(sb->s_bdev);
 	return 0;
 }
 


