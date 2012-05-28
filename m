From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] vfs: avoid hang caused by attempting to rmdir an
 invalid file system
Date: Mon, 28 May 2012 17:05:11 -0400
Message-ID: <20120528210511.GA5610@thunk.org>
References: <1338226422-8845-1-git-send-email-tytso@mit.edu>
 <4790434C-0DF2-4186-BE4C-CE97633F107C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, sami.liedes@iki.fi
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4790434C-0DF2-4186-BE4C-CE97633F107C@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 28, 2012 at 02:29:05PM -0600, Andreas Dilger wrote:
> This patch is good from the POV of covering all filesystems, and
> avoiding the deadlock at the dcache level.  It would be possible to
> detect this problem in the filesystem itself during lookup, before
> the bad link got into the dcache itself.  Something like:

I like that as a solution for detecting the problem in ext4.  As you
say, it's still an issue for other file systems, and so the patch I
proposed is still probably a good idea for the VFS.  But this way ext4
(and ext3 when Jan backports it) will be able to detect the problem
and mark the file system as being corrupted.

Andreas, are you ok with the Signed-off-by?  I gave you credit since
the patch is yours...  (and do you want me to use the dilger.ca or the
whamcloud.com domain)?

Regards,

						- Ted

commit bfd0ca03af12fa1dc439b57f65828dde2e7530e2
Author: Andreas Dilger <adilger@dilger.ca>
Date:   Mon May 28 17:02:25 2012 -0400

    ext4: disallow hard-linked directory in ext4_lookup
    
    A hard-linked directory to its parent can cause the VFS to deadlock,
    and is a sign of a corrupted file system.  So detect this case in
    ext4_lookup(), before the rmdir() lockup scenario can take place.
    
    Signed-off-by: Andreas Dilger <adilger@dilger.ca>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a9fd5f4..5f4a030 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1330,6 +1330,12 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 			EXT4_ERROR_INODE(dir, "bad inode number: %u", ino);
 			return ERR_PTR(-EIO);
 		}
+		if (ino == dir->i_ino) {
+			EXT4_ERROR_INODE(dir, "'%.*s' linked to parent dir",
+					 dentry->d_name.len,
+					 dentry->d_name.name);
+			return ERR_PTR(-EIO);
+		}
 		inode = ext4_iget(dir->i_sb, ino);
 		if (inode == ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,
