From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 66/73] ext2: Split ext2_add_entry() from ext2_add_link() [ver #2]
Date: Mon, 27 Feb 2012 13:45:50 -0700
Message-ID: <8F6CA4DC-A52C-4210-B0AD-FF4CBD5BB1EE@dilger.ca>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk> <20120221180546.25235.50961.stgit@warthog.procyon.org.uk> <20120227000428.GA8044@thunk.org> <B5DCCBD9-F032-44E1-8368-146137487B83@dilger.ca> <20120227190916.GH1651@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: David Howells <dhowells@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"valerie.aurora@gmail.com" <valerie.aurora@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	"linux-ext4@kernel.org" <linux-ext4@kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120227190916.GH1651@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2012-02-27, at 12:09 PM, Ted Ts'o wrote:
> On Sun, Feb 26, 2012 at 08:30:34PM -0700, Andreas Dilger wrote:
>>> I'd suggest folding this in with the following patch (67/73).  It's
>>> not clear from this patch why renaming ext2_add_link to
>>> ext2_add_entry() makes sense and then adding a new ext2_add_link()
>>> which calls ext_add_entry().   It doesn't seem to clarify much....
>> 
>> Also, why is this being done in ext2, when it should only be done in ext4?
> 
> I believe Val used ext2 as a proof-of-concept, because the codebase
> was stable (and Union Mounts has been in the oven a loooong time, so
> that was probably a good choice).  I agree that if union mounts is
> finally going to make it upstream, this would be a good time to
> support implemented for ext4, and to get the support into e2fsprogs.
> 
> BTW, one thing that I think would be a good thing to do while we're
> making this change is to mask off the low 4 bits when looking at the
> filetype field so eventually we can use the high 4 bits for some
> future extension.

Umm, we already DO use the high 4 bits for a future extension in the
EXT4_FEATURE_INCOMPAT_DIRDATA feature.  The bare minimum for this is
extracted from a larger patch that allows storing extra data in the
dirent.  We use it to store a filesystem-wide 128-bit identifier into
the dirent, and it could also be used to store the high 32 bits of the
inode number in a compatible way.

I haven't pushed this upstream as I don't think anyone else is interested
in this yet, but masking off the file type is definitely simple and could
be accepted upstream.

Index: linux-stage/fs/ext4/ext4.h
===================================================================
--- linux-stage.orig/fs/ext4/ext4.h
+++ linux-stage/fs/ext4/ext4.h
@@ -1262,6 +1265,24 @@ struct ext4_dir_entry_2 {
 #define EXT4_FT_SYMLINK		7

 #define EXT4_FT_MAX		8
+#define EXT4_FT_MASK		0xf
+
+#if EXT4_FT_MAX > EXT4_FT_MASK
+#error "conflicting EXT4_FT_MAX and EXT4_FT_MASK"
+#endif
+
+/*
+ * d_type has 4 unused bits, so it can hold four types data. these different
+ * type of data (e.g. lustre file ID, high 32 bits of 64-bit inode number)
+ * can be stored, in flag order, after file-name in ext4 dirent.
+*/
+/*
+ * This flag is added to d_type if ext4 dirent has extra data after filename.
+ * This data length is variable and length is stored in first byte of data.
+ * Data starts after filename NUL byte. This is used by Lustre FS.
+  */
+#define EXT4_DIRENT_LUFID		0x10

 /*
  * EXT4_DIR_PAD defines the directory entries boundaries
Index: linux-stage/fs/ext4/dir.c
===================================================================
--- linux-stage.orig/fs/ext4/dir.c
+++ linux-stage/fs/ext4/dir.c
@@ -53,11 +53,14 @@ const struct file_operations ext4_dir_op
 
 static unsigned char get_dtype(struct super_block *sb, int filetype)
 {
+	int fl_index = filetype & EXT4_FT_MASK;
+
 	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FILETYPE) ||
-	    (filetype >= EXT4_FT_MAX))
+	    (fl_index >= EXT4_FT_MAX))
 		return DT_UNKNOWN;

-	return (ext4_filetype_table[filetype]);
+	return ext4_filetype_table[fl_index]);
+
 }




Cheers, Andreas
