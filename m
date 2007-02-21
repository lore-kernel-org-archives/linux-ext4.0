From: Kalpak Shah <kalpak-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] Correction to check_filetype()
Date: Wed, 21 Feb 2007 20:56:18 +0530
Message-ID: <1172071578.5928.8.camel@garfield>
References: <1172049359.4727.15.camel@garfield> <45DC5BFF.4000302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Lustre-discuss <Lustre-discuss-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>,
	linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tytso <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <adilger-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
To: Peter Staubach <staubach-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <lustre-discuss-bounces-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
In-Reply-To: <45DC5BFF.4000302-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://mail.clusterfs.com/mailman/listinfo/lustre-discuss>,
	<mailto:lustre-discuss-request-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.clusterfs.com/pipermail/lustre-discuss>
List-Post: <mailto:lustre-discuss-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
List-Help: <mailto:lustre-discuss-request-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.clusterfs.com/mailman/listinfo/lustre-discuss>,
	<mailto:lustre-discuss-request-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org?subject=subscribe>
Sender: lustre-discuss-bounces-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org
Errors-To: lustre-discuss-bounces-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Hi Peter,

Thanks for pointing out the typo. In the kernel, struct ext3_dir_entry_2 has a 8-bit name_len field followed by 8-bit field for filetype. Whereas in e2fsck, struct ext2_dir_entry has a 16-bit name_len field, the upper 8 bits of which store the filetype. Hence e2fsck masks the upper 8 bits while using name_len.

Here is the patch with the change.


Signed-off-by: Andreas Dilger <adilger-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
Signed-off-by: Kalpak Shah <kalpak-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>


Index: e2fsprogs-1.39/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass2.c
+++ e2fsprogs-1.39/e2fsck/pass2.c
@@ -495,7 +495,9 @@ static _INLINE_ int check_filetype(e2fsc
                return 1;
        }

-       if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, dirent->inode)) {
+       if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, dirent->inode) ||
+           ((dirent->name_len & 0xFF) <= 2 && dirent->name[0] == '.' &&
+            (dirent->name[1] == '.' || dirent->name[1] == '\0'))) {
                should_be = EXT2_FT_DIR;
        } else if (ext2fs_test_inode_bitmap(ctx->inode_reg_map,
                                            dirent->inode)) {

Thanks,
Kalpak Shah. <kalpak-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>


On Wed, 2007-02-21 at 09:49 -0500, Peter Staubach wrote:
> Kalpak Shah wrote:
> > Hi,
> >
> > If the mode of a directory gets corrupted, check_filetype() makes wrong decisions for all its sub-directories. For example, using debugfs we can corrupt the mode of a directory to 0140755 (i.e. a socket). e2fsck will set the filetype of all its subdirectories as 6 (filetype for socket). All the subdirectories would be moved to lost+found, and in second run of e2fsck their filetype would be set back to 2.
> >
> > By the time we come to check_filetype(), we have already verified the "." and ".." entries, so we special case these dirents in check_filetype().
> >
> > Please consider for review.
> >
> > Signed-off-by: Andreas Dilger <adilger-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
> > Signed-off-by: Kalpak Shah <kalpak-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>
> >
> >
> > Index: e2fsprogs-1.39/e2fsck/pass2.c
> > ===================================================================
> > --- e2fsprogs-1.39.orig/e2fsck/pass2.c
> > +++ e2fsprogs-1.39/e2fsck/pass2.c
> > @@ -495,7 +495,9 @@ static _INLINE_ int check_filetype(e2fsc
> >                 return 1;
> >         }
> >
> > -       if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, dirent->inode)) {
> > +       if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, dirent->inode) ||
> > +           ((dirent->name_len && 0xFF) <= 2 && dirent->name[0] == '.' &&
> >   
> 
> What is the "&& 0xFF" part for?  At the very least, it should probably
> be "& 0xFF".  It doesn't seem like this mask should be needed at all
> though, I think.
> 
>     Thanx...
> 
>        ps
> 
> > +            (dirent->name[1] == '.' || dirent->name[1] == '\0'))) {
> >                 should_be = EXT2_FT_DIR;
> >         } else if (ext2fs_test_inode_bitmap(ctx->inode_reg_map,
> >                                             dirent->inode)) {
> >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >   
