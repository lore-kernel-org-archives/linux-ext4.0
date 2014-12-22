From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 32/31] libext2fs: initialize i_extra_isize when writing
 EAs
Date: Mon, 22 Dec 2014 14:32:45 -0800
Message-ID: <20141222223245.GA23837@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
 <20141222185351.GG5368@birch.djwong.org>
 <5A383D23-2884-4784-AB9F-9C6FD99A0678@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47448 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaLVWcz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Dec 2014 17:32:55 -0500
Content-Disposition: inline
In-Reply-To: <5A383D23-2884-4784-AB9F-9C6FD99A0678@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 22, 2014 at 03:22:30PM -0700, Andreas Dilger wrote:
> On Dec 22, 2014, at 11:53 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > If i_extra_isize is zero when we try to write extended attributes,
> > we'll end up writing the EA magic into the i_extra_isize field, which
> > causes a subsequent crash on big endian systems (when we try to write
> > 0xEA02 bytes past the inode!).  Therefore when the field is zero, set
> > i_extra_isize to the desired extra_isize size, zero those bytes, and
> > write the EAs after the end of the extended inode.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > lib/ext2fs/ext_attr.c                    |   11 +++++++++++
> > tests/f_write_ea_no_extra_isize/expect.1 |   12 ++++++++++++
> > tests/f_write_ea_no_extra_isize/expect.2 |    7 +++++++
> > tests/f_write_ea_no_extra_isize/image.gz |  Bin
> > tests/f_write_ea_no_extra_isize/name     |    1 +
> > 5 files changed, 31 insertions(+)
> > create mode 100644 tests/f_write_ea_no_extra_isize/expect.1
> > create mode 100644 tests/f_write_ea_no_extra_isize/expect.2
> > create mode 100644 tests/f_write_ea_no_extra_isize/image.gz
> > create mode 100644 tests/f_write_ea_no_extra_isize/name
> > 
> > diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
> > index 70bc3f9..551c1f2 100644
> > --- a/lib/ext2fs/ext_attr.c
> > +++ b/lib/ext2fs/ext_attr.c
> > @@ -519,6 +519,17 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
> > 	if (err)
> > 		goto out;
> > 
> > +	/* If extra_isize isn't set, we need to set it now */
> > +	if (inode->i_extra_isize == 0) {
> > +		char *p = (char *)inode;
> > +		size_t extra = handle->fs->super->s_want_extra_isize;
> > +
> > +		if (extra == 0)
> > +			extra = sizeof(inode->i_extra_isize);
> 
> I don't think this is quite correct.  At a minimum, i_extra_isize should
> include the padding bytes (now i_checksum_hi) following it so that the
> xattr magic and other fields will be properly 32-bit aligned.  That said,
> if we are going to use the large inode it probably makes sense to leave
> space for the i_*time_extra fields.

s_want_extra_isize should be set to a sensible value -- mke2fs has
been setting it to 28 (i.e. big enough for i_version_hi) since 2008.
The if (extra == 0) fallback handles the case when the superblock
field is also zero.

Though, hmm, there is a bug; we ought to skip all this if
EXT2_INODE_SIZE == EXT2_GOOD_OLD_INODE SIZE.

--D

> 
> Cheers, Andreas
> 
> > +		memset(p + EXT2_GOOD_OLD_INODE_SIZE, 0, extra);
> > +		inode->i_extra_isize = extra;
> > +	}
> > +
> > 	move_inline_data_to_front(handle);
> > 
> > 	x = handle->attrs;
> > diff --git a/tests/f_write_ea_no_extra_isize/expect.1 b/tests/f_write_ea_no_extra_isize/expect.1
> > new file mode 100644
> > index 0000000..b7e7438
> > --- /dev/null
> > +++ b/tests/f_write_ea_no_extra_isize/expect.1
> > @@ -0,0 +1,12 @@
> > +Pass 1: Checking inodes, blocks, and sizes
> > +Pass 2: Checking directory structure
> > +Directory inode 12, block #0, offset 4: directory corrupted
> > +Salvage? yes
> > +
> > +Pass 3: Checking directory connectivity
> > +Pass 4: Checking reference counts
> > +Pass 5: Checking group summary information
> > +
> > +test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> > +test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
> > +Exit status is 1
> > diff --git a/tests/f_write_ea_no_extra_isize/expect.2 b/tests/f_write_ea_no_extra_isize/expect.2
> > new file mode 100644
> > index 0000000..3b6073e
> > --- /dev/null
> > +++ b/tests/f_write_ea_no_extra_isize/expect.2
> > @@ -0,0 +1,7 @@
> > +Pass 1: Checking inodes, blocks, and sizes
> > +Pass 2: Checking directory structure
> > +Pass 3: Checking directory connectivity
> > +Pass 4: Checking reference counts
> > +Pass 5: Checking group summary information
> > +test_filesys: 12/128 files (0.0% non-contiguous), 17/512 blocks
> > +Exit status is 0
> > diff --git a/tests/f_write_ea_no_extra_isize/image.gz b/tests/f_write_ea_no_extra_isize/image.gz
> > new file mode 100644
> > index 0000000000000000000000000000000000000000..928daff1f344824d357e816883a98b2cdfdaffb3
> > GIT binary patch
> > literal 2516
> > zcmb2|=3qFkI6Z`k`Ry&+Y!OEZh6m-}^`s^_@O3Vjpj4;eVQ?ceQSj)oL#Gnz1=cLm
> > zv~lFfFtI=2=98SCs6XwXQ}-6Ju%@X>9fI9126HxlZ#2Be**0UwlghsG_L*~cr<Q$x
> > zcJJ<Oj)e8Ibj2!<JPfHhr<Aq!+aA$gzRhQoDpTqfm88@ubyxlMdNpU)@t~~i`mk$S
> > zzoVyaURhCSpQJX`e|`A<yOq_6FK*5jUa#jL8+)&B<F~W5)<2(II(+ff@7nX~@@wXt
> > zO0r@5^laDG$2W8iznog0p}+h^;VVXl4ZK}{zBqI(?)|f0Y^ht>t&nbG@wbW$3=B7Z
> > zzWX-qadqb7_v@K~-2ZzY{r}&1;?u?qJ8lDkN;|V_HErb@zdo&eIeY8H?91Epe8gTW
> > z#qp>8%-!w_RG#4e@_o_Y_#Xxt|AD*%>jF1&gXpjJK#~;jC;IEb(o&#~gzJUuETrf}
> > zRok%tV=6ElWvesq%s;o>RW(Vqw|cASS<|O4a;NN_xHR?tb)Bt$LbgmbOZ<IUQ%o$p
> > zUwq@2A5YK3-Tr^z+swV;J`Rs%pZ#BB`ad`3|E{WQssEz?TR&NG;97*nr}>xXe%f!t
> > zxAoKf7Zd(Zk&?Xh?1}x|{r`U+Uwh*Jxur#4xBt=4FJGCGo%NMBXYuokNl*KaC%k*G
> > zu}tK){;6+2PXDfdYaO{ZbnaGE_m1*LLtr!nMnhmU1V%$(Gz6#@0(bv1g#8Yk!N8!v
> > F003fX5hwrv
> > 
> > literal 0
> > HcmV?d00001
> > 
> > diff --git a/tests/f_write_ea_no_extra_isize/name b/tests/f_write_ea_no_extra_isize/name
> > new file mode 100644
> > index 0000000..200e365
> > --- /dev/null
> > +++ b/tests/f_write_ea_no_extra_isize/name
> > @@ -0,0 +1 @@
> > +write EA when i_extra_size is zero
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
