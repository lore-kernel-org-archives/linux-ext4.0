From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Wed, 18 May 2011 13:29:23 -0700
Message-ID: <BANLkTinGw51VCPi4a0eZsPxjQ7vpF7oLiw@mail.gmail.com>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com>
	<4DD33AA9.9060104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:49954 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1ERU31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 16:29:27 -0400
Received: from kpbe16.cbf.corp.google.com (kpbe16.cbf.corp.google.com [172.25.105.80])
	by smtp-out.google.com with ESMTP id p4IKTPg1005426
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:29:25 -0700
Received: from gyf2 (gyf2.prod.google.com [10.243.50.66])
	by kpbe16.cbf.corp.google.com with ESMTP id p4IKSk1W001492
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:29:24 -0700
Received: by gyf2 with SMTP id 2so1010931gyf.39
        for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:29:23 -0700 (PDT)
In-Reply-To: <4DD33AA9.9060104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 8:19 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
>
> On 5/17/11 5:59 PM, Jiaying Zhang wrote:
> > There is a bug in commit c8d46e41 "ext4: Add flag to files with blo=
cks
> > intentionally past EOF" that if we fallocate a file with FALLOC_FL_=
KEEP_SIZE
> > flag and then ftruncate the file to a size larger than the file's i=
_size,
> > any allocated but unwritten blocks will be freed but the file size =
is set
> > to the size that ftruncate specifies.
> >
> > Here is a simple test to reproduce the problem:
> > =A0 1. fallocate a 12k size file with KEEP_SIZE flag
> > =A0 2. write the first 4k
> > =A0 3. ftruncate the file to 8k
> > Then 'ls -l' shows that the i_size of the file becomes 8k but debug=
fs
> > shows the file has only the first written block left.
>
> To be honest I'm not 100% certain what the fiesystem -should- do in t=
his case.
>
> If I go through that same sequence on xfs, I get 4k written / 8k unwr=
itten:
>
> # xfs_bmap -vp testfile
> testfile:
> =A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0 =A0 =A0 =A0AG =
AG-OFFSET =A0 =A0 =A0 =A0 =A0 =A0 =A0TOTAL FLAGS
> =A0 0: [0..7]: =A0 =A0 =A0 =A0 =A02648750760..2648750767 =A03 (356066=
400..356066407) =A0 =A0 8 00000
> =A0 1: [8..23]: =A0 =A0 =A0 =A0 2648750768..2648750783 =A03 (35606640=
8..356066423) =A0 =A016 10000
>
> size 8k:
> # ls -l testfile
> -rw-r--r-- 1 root root 8192 May 17 22:33 testfile
>
> and diskspace used 12k:
> # du -hc testfile
> 12K =A0 =A0 testfile
> 12K =A0 =A0 total
>
> I think this is a different result from ext4, either with or without =
your patch.
>
> On ext4 I get size 8k, but only the first 4k mapped, as you say.
I agree that truncating to a size larger than i_size is un-specified by
POSIX. However, I think the problem with the current behavior is that
we have an inconsistency between file's i_size and its extent tree.
Now we have 8k i_size but the file has only 4k space allocated. That
can confuse applications.

Jiaying
>
> I don't recall when truncate is supposed to free fallocated blocks, a=
nd from what point?
>
> -Eric
>
> > Below is the proposed patch to fix the bug:
> >
> > ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()=
=2E
> >
> > Change ext4_setattr() to use vmtruncate(inode, attr->ia_size) inste=
ad
> > of ext4_truncate(inode) when it needs to truncate an inode so that
> > if the inode has EXT4_EOFBLOCKS_FL flag set and we are trying to tr=
uncate
> > to a size larger than the inode's i_size, we will only truncate the=
 blocks
> > beyond the specified truncate size instead of all of blocks beyond =
i_size.
> >
> > Signed-off-by: Jiaying Zhang <jiayingz@google.com>
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 3424e82..3bfad57 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -5347,8 +5347,11 @@ int ext4_setattr(struct dentry *dentry, stru=
ct iattr *attr)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* ext4_truncate will clear the flag */
> > - =A0 =A0 =A0 =A0 =A0 =A0 if ((ext4_test_inode_flag(inode, EXT4_INO=
DE_EOFBLOCKS)))
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);
> > + =A0 =A0 =A0 =A0 =A0 =A0 if ((ext4_test_inode_flag(inode, EXT4_INO=
DE_EOFBLOCKS))) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D vmtruncate(inode, =
attr->ia_size);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_=
out;
> > + =A0 =A0 =A0 =A0 =A0 =A0 }
> > =A0 =A0 =A0 }
> >
> > =A0 =A0 =A0 if ((attr->ia_valid & ATTR_SIZE) &&
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
