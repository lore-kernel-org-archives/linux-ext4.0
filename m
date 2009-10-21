From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 2/4 v2] avoid perform unwritten convertion for direct
 IO over non fallocated space
Date: Wed, 21 Oct 2009 15:48:01 -0700
Message-ID: <1256165281.6404.4.camel@mingming-laptop>
References: <1255050810.4931.191.camel@mingming-laptop>
	 <6601abe90910200803n1c499ba0w825c59c2f747dce8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-H7tOkx0AGZBz8HDTqu6H"
Cc: tytso@mit.edu, ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:57737 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbZJUWsK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Oct 2009 18:48:10 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9LMgI9E030155
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:42:18 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9LMm9cn076838
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:48:09 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9LMm6Mx010014
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:48:07 -0600
In-Reply-To: <6601abe90910200803n1c499ba0w825c59c2f747dce8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-H7tOkx0AGZBz8HDTqu6H
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2009-10-20 at 08:03 -0700, Curt Wohlgemuth wrote: 
> Hi Mingming:
> 
> On Thu, Oct 8, 2009 at 6:13 PM, Mingming <cmm@us.ibm.com> wrote:
> > ext4: avoid perform unwritten convertion for direct IO over non fallocated space
> >
> > When direct IO complete, without this patch, it always check and convert
> > the range covered by the completed IO to be written. This is unnecessary
> > if the range doesn't has any preallocated area or holes. This patch add
> > a state flag to alart direct IO code to only run the convertion when
> > there is unwritten extents being covered in this IO.
> >
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/ext4/ext4.h    |    1 +
> >  fs/ext4/extents.c |   22 +++++++++++++++++-----
> >  fs/ext4/inode.c   |    4 +++-
> >  3 files changed, 21 insertions(+), 6 deletions(-)
> >
> > Index: linux-2.6.31-rc4/fs/ext4/ext4.h
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/ext4.h
> > +++ linux-2.6.31-rc4/fs/ext4/ext4.h
> > @@ -299,6 +299,7 @@ static inline __u32 ext4_mask_flags(umod
> >  #define EXT4_STATE_XATTR               0x00000004 /* has in-inode xattrs */
> >  #define EXT4_STATE_NO_EXPAND           0x00000008 /* No space for expansion */
> >  #define EXT4_STATE_DA_ALLOC_CLOSE      0x00000010 /* Alloc DA blks on close */
> > +#define EXT4_STATE_DIO_UNWRITTEN       0x00000020 /* need convert on dio done*/
> 
> You'll need to change this value, since EXT4_STATE_EXT_MIGRATE has
> already been assigned 0x20.
> 
> Thanks,
> Curt
> 
thanks, The patch was originally made on a older kernel, the following
patch is rebased on the new kernel


> >
> >  /* Used to pass group descriptor data when online resize is done */
> >  struct ext4_new_group_input {
> > Index: linux-2.6.31-rc4/fs/ext4/extents.c
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/extents.c
> > +++ linux-2.6.31-rc4/fs/ext4/extents.c
> > @@ -3029,12 +3029,18 @@ ext4_ext_handle_uninitialized_extents(ha
> >                ret = ext4_split_unwritten_extents(handle,
> >                                                inode, path, iblock,
> >                                                max_blocks, flags);
> > -               /* flag the io_end struct that we need convert when IO done */
> > +               /*
> > +                * Flag the inode(non aio case) or end_io struct (aio case)
> > +                * that this IO needs to convertion to written when IO is
> > +                * completed
> > +                */
> >                if (io)
> >                        io->flag = DIO_AIO_UNWRITTEN;
> > +               else
> > +                       EXT4_I(inode)->i_state |= EXT4_STATE_DIO_UNWRITTEN;
> >                goto out;
> >        }
> > -       /* DIO end_io complete, convert the filled extent to written */
> > +       /* async DIO end_io complete, convert the filled extent to written */
> >        if (flags == EXT4_GET_BLOCKS_DIO_CONVERT_EXT) {
> >                ret = ext4_convert_unwritten_extents_dio(handle, inode,
> >                                                        path);
> > @@ -3276,10 +3282,16 @@ int ext4_ext_get_blocks(handle_t *handle
> >                 * To avoid unecessary convertion for every aio dio rewrite
> >                 * to the mid of file, here we flag the IO that is really
> >                 * need the convertion.
> > -                *
> > +                * For non asycn direct IO case, flag the inode state
> > +                * that we need to perform convertion when IO is done.
> >                 */
> > -               if (io && flags == EXT4_GET_BLOCKS_DIO_CREATE_EXT)
> > -                       io->flag = DIO_AIO_UNWRITTEN;
> > +               if (flags == EXT4_GET_BLOCKS_DIO_CREATE_EXT) {
> > +                       if (io)
> > +                               io->flag = DIO_AIO_UNWRITTEN;
> > +                       else
> > +                               EXT4_I(inode)->i_state |=
> > +                                       EXT4_STATE_DIO_UNWRITTEN;;
> > +               }
> >        }
> >        err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
> >        if (err) {
> > Index: linux-2.6.31-rc4/fs/ext4/inode.c
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/inode.c
> > +++ linux-2.6.31-rc4/fs/ext4/inode.c
> > @@ -3693,7 +3693,8 @@ static ssize_t ext4_ext_direct_IO(int rw
> >                if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
> >                        ext4_free_io_end(iocb->private);
> >                        iocb->private = NULL;
> > -               } else if (ret > 0){
> > +               } else if (ret > 0 && EXT4_I(inode)->i_state &
> > +                               EXT4_STATE_DIO_UNWRITTEN){
> >                        int err;
> >                        /*
> >                         * for non AIO case, since the IO is already
> > @@ -3703,6 +3704,7 @@ static ssize_t ext4_ext_direct_IO(int rw
> >                                                                offset, ret);
> >                        if (err < 0)
> >                                ret = err;
> > +                       EXT4_I(inode)->i_state &= ~EXT4_STATE_DIO_UNWRITTEN;
> >                }
> >                return ret;
> >        }
> >
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
a

--=-H7tOkx0AGZBz8HDTqu6H
Content-Disposition: attachment; filename="dio-avoid-convertion-for-non-fallocate.patch"
Content-Type: text/x-patch; name="dio-avoid-convertion-for-non-fallocate.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

ext4: avoid perform convertion for direct IO over non fallocated space

When direct IO complete, without this patch, it always check and convert
the range covered by the completed IO to be written. This is unnecessary
if the range doesn't has any preallocated area or holes. This patch add
a state flag to alart direct IO code to only run the convertion when
there is unwritten extents being covered in this IO.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |   22 +++++++++++++++++-----
 fs/ext4/inode.c   |    4 +++-
 3 files changed, 21 insertions(+), 6 deletions(-)

Index: linux-2.6.32-rc4/fs/ext4/ext4.h
===================================================================
--- linux-2.6.32-rc4.orig/fs/ext4/ext4.h	2009-10-11 14:43:56.000000000 -0700
+++ linux-2.6.32-rc4/fs/ext4/ext4.h	2009-10-12 15:05:46.000000000 -0700
@@ -322,6 +322,7 @@ static inline __u32 ext4_mask_flags(umod
 #define EXT4_STATE_NO_EXPAND		0x00000008 /* No space for expansion */
 #define EXT4_STATE_DA_ALLOC_CLOSE	0x00000010 /* Alloc DA blks on close */
 #define EXT4_STATE_EXT_MIGRATE		0x00000020 /* Inode is migrating */
+#define EXT4_STATE_DIO_UNWRITTEN	0x00000040 /* need convert on dio done*/
 
 /* Used to pass group descriptor data when online resize is done */
 struct ext4_new_group_input {
Index: linux-2.6.32-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.32-rc4.orig/fs/ext4/extents.c	2009-10-12 15:03:40.000000000 -0700
+++ linux-2.6.32-rc4/fs/ext4/extents.c	2009-10-12 15:04:07.000000000 -0700
@@ -3048,12 +3048,18 @@ ext4_ext_handle_uninitialized_extents(ha
 		ret = ext4_split_unwritten_extents(handle,
 						inode, path, iblock,
 						max_blocks, flags);
-		/* flag the io_end struct that we need convert when IO done */
+		/*
+		 * Flag the inode(non aio case) or end_io struct (aio case)
+		 * that this IO needs to convertion to written when IO is
+		 * completed
+		 */
 		if (io)
 			io->flag = DIO_AIO_UNWRITTEN;
+		else
+			EXT4_I(inode)->i_state |= EXT4_STATE_DIO_UNWRITTEN;
 		goto out;
 	}
-	/* DIO end_io complete, convert the filled extent to written */
+	/* async DIO end_io complete, convert the filled extent to written */
 	if (flags == EXT4_GET_BLOCKS_DIO_CONVERT_EXT) {
 		ret = ext4_convert_unwritten_extents_dio(handle, inode,
 							path);
@@ -3295,10 +3301,16 @@ int ext4_ext_get_blocks(handle_t *handle
 		 * To avoid unecessary convertion for every aio dio rewrite
 		 * to the mid of file, here we flag the IO that is really
 		 * need the convertion.
-		 *
+		 * For non asycn direct IO case, flag the inode state
+		 * that we need to perform convertion when IO is done.
 		 */
-		if (io && flags == EXT4_GET_BLOCKS_DIO_CREATE_EXT)
-			io->flag = DIO_AIO_UNWRITTEN;
+		if (flags == EXT4_GET_BLOCKS_DIO_CREATE_EXT) {
+			if (io)
+				io->flag = DIO_AIO_UNWRITTEN;
+			else
+				EXT4_I(inode)->i_state |=
+					EXT4_STATE_DIO_UNWRITTEN;;
+		}
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
Index: linux-2.6.32-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.32-rc4.orig/fs/ext4/inode.c	2009-10-12 15:03:40.000000000 -0700
+++ linux-2.6.32-rc4/fs/ext4/inode.c	2009-10-12 15:04:07.000000000 -0700
@@ -3771,7 +3771,8 @@ static ssize_t ext4_ext_direct_IO(int rw
 		if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
 			ext4_free_io_end(iocb->private);
 			iocb->private = NULL;
-		} else if (ret > 0){
+		} else if (ret > 0 && EXT4_I(inode)->i_state &
+				EXT4_STATE_DIO_UNWRITTEN){
 			int err;
 			/*
 			 * for non AIO case, since the IO is already
@@ -3781,6 +3782,7 @@ static ssize_t ext4_ext_direct_IO(int rw
 								offset, ret);
 			if (err < 0)
 				ret = err;
+			EXT4_I(inode)->i_state &= ~EXT4_STATE_DIO_UNWRITTEN;
 		}
 		return ret;
 	}

--=-H7tOkx0AGZBz8HDTqu6H--

