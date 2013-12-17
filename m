From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: dumpe2fs manpage updates
Date: Tue, 17 Dec 2013 15:46:04 -0700
Message-ID: <6D71DA55-9543-4965-A652-FCF91DCD9FE1@dilger.ca>
References: <CAO+X6Oiq5PLxjcGkjNi=D3qr=hB_zaCkgQfNcNjBQJaVjsNKBQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: multipart/signed; boundary="Apple-Mail=_81220D6A-9169-4E2B-9F1A-AFF80759C31D"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Uri Corin <uri.corin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43425 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3LQWqK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Dec 2013 17:46:10 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so7665913pbc.1
        for <linux-ext4@vger.kernel.org>; Tue, 17 Dec 2013 14:46:09 -0800 (PST)
In-Reply-To: <CAO+X6Oiq5PLxjcGkjNi=D3qr=hB_zaCkgQfNcNjBQJaVjsNKBQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_81220D6A-9169-4E2B-9F1A-AFF80759C31D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Dec 17, 2013, at 7:49 AM, Uri Corin <uri.corin@gmail.com> wrote:
> I've added documentation for all defined features, including legacy
> and work in progress.
> * Some pre-existing feature explanations have been expanded based on
> ext4.wiki.kernel.org.
> * Future features (dirdata, ea_inode and metadata_csum) are commented =
out

Thanks for the updates.  It is really helpful for users to have good
descriptions of these features, and man pages are often forgotten when
writing the feature itself.

Is it worthwhile to include a short list after each feature to indicate
which filesystem type (ext2, ext3, ext4) supports each feature?  Would
it be useful to indicate the kernel in which it was added?

> +.B 64bit
> +.br
> +Enables the file system to be larger than 2^32 blocks.  This feature =
may be set
> +automatically, as needed.

The 64bit feature can also be set on filesystems with < 2^32 blocks,
to prepare the filesystem for resizing beyond 2^32 blocks in the future.
I think Ted updated this description in the mke2fs man page.  (ext4)

> +.B bigalloc
> +.br
> +This feature enables clustered allocation, so that the unit of

I just updated this to be "clustered block allocation" to be more clear.

> +allocation is a power of two number of blocks.  That is, each bit in =
the
> +what had traditionally been known as the block allocation bitmap now
> +indicates whether a cluster is in use or not, where a cluster is by
> +default composed of 16 blocks.

(ext4)

> +.\" .TP
> +.\" .B dirdata
> +.\" .br
> +.\" Data in directory entry.

FYI, this is to allow 64-bit inode numbers to be stored in the
directory entry, along with Lustre 128-bit File IDentifiers (FID).
(Lustre ldiskfs only)

> +.\" .br
> +.\" Not implemented.
> +.TP
> +.B dir_index
> +.br
> +Filesystem Uses hashed b-trees to speed up lookups in large =
directories.

(ext3, ext4)

> +.B dir_nlink
> +.br
> +Allows more than 65000 subdirectories per directory.

(ext3, ext4)

> +.TP
> +.B dir_prealloc
> +.br
> +Block pre-allocation for new directories is enabled.

(ext2?)

> +.\" .TP
> +.\" .B ea_inode
> +.\" .br
> +.\" Inodes can be used for large extended attributes.
> +.\" .br
> +.\" Not implemented.

(Lustre ldiskfs only)

> +.TP
> +.B extent
> +.br
> +Instead of using the indirect block scheme for storing the location =
of
> +data blocks in an inode, use extents instead.  This is a much more
> +efficient encoding which speeds up filesystem access, especially for
> +large files.  (Note: both
> +.B extent
> +and
> +.B extents
> +are accepted as valid names for this feature for
> +historical/backwards compatibility reasons.)

(ext4)

> +.TP
> +.B extra_isize
> +.br
> +This feature enables storage of nanosecond timestamps and creation
> +time, if the inode size is larger than 256 bytes or larger.

Could you please use the updated description I just sent for mke2fs.

> +This feature enables the storage file type information in directory
> +entries.  It is normally enabled by default for all file system =
types.

(ext4)

> +.TP
> +.B flex_bg
> +.br
> +Allow the per-block group metadata (allocation bitmaps and inode =
tables)
> +to be placed anywhere on the storage media.  In addition,
> +.B mke2fs
> +will place the per-block group metadata together starting at the =
first
> +block group of each "flex_bg group".   The size of the flex_bg group

... ?  truncated sentence.

(ext4)

> +.TP
> +.B inline_data
> +.br
> +Allows small files or directories to be stored within the in-inode
> extended attribute area.

(ext4 after 3.13?)

> +.TP
> +.B has_journal
> +.br
> +Uses a journal to ensure filesystem consistency even across unclean =
shutdowns.

(ext3, ext4)

> +.TP
> +.B huge_file
> +.br
> +Allows files larger than 2TiB in size.

(ext4)

> +.TP
> +.B imagic_inodes
> +.br
> +Legacy feature, not settable by
> +.BR mke2fs (8)
> +and
> +.BR tune2fs (8)
> +.TP
> +.B journal_dev
> +.br
> +This is a journal device
> +(see journal-options in
> +.BR tune2fs (8)
> +or
> +.BR mke2fs (8)).

(ext3, ext4)

> +.TP
> +.B large_dir
> +Supports large directory >2GiB or 3-level htree.

This is for Lustre ldiskfs only so far, so should probably be commented =
out.

> +.TP
> +.B large_file
> +.br
> +Filesystem can contain files that are greater than 2GiB.  (Modern =
kernels
> +set this feature automatically when a file > 2GiB is created.)

(ext2, ext3, ext4)

> +.TP
> +.B lazy_bg
> +.br
> +Legacy parameter for testing purposes, no longer supported by kernel.
> +.br
> +Allows an ext2/ext3 developer to create very large filesystems using
> sparse files where most of the block groups are not initialized and so
> do not require much disk space.

Not sure if it is worthwhile to document this in the man page?

> +.TP
> +.B meta_bg
> +.br
> +This feature allows file systems to be resized on-line without =
explicitly
> +needing to reserve space for growth in the size of the block group
> +descriptors.  This scheme is also used to resize file systems which =
are
> +larger than 2^32 blocks.  It is not recommended that this feature be =
set
> +when a file system is created, since this alternate method of storing
> +the block group descriptor will slow down the time needed to mount =
the
> +file system, and newer kernels can automatically set this feature as
> +necessary when doing an online resize and no more reserved space is
> +available in the resize inode.

(ext4, some support in ext3?)

> +.\" .TP
> +.\" .B metadata_csum
> +.\" .br
> +.\" Filesystem supports metadata checksumming.  This feature enables =
a
> +.\" superset of the functionality of the
> +.\" .B uninit_bg
> +.\" feature.

Please see my recent patch for mke2fs for an updated description of
this feature.

> +.\" .br
> +.\" .B Future feature, available in e2fsprogs 1.43-WIP

More importantly, only ext4 beyond 3.xx?

> +.TP
> +.B mmp
> +.br
> +Multiple mount protection (MMP) helps to protect the filesystem from
> being multiply mounted and is useful in shared storage environments.
> +.TP
> +.B needs_recovery
> +.br
> +This flag is set by the kernel to indicate either a mounted =
filesystem with
> +.B has_journal
> +is write enabled or, an unmounted filesystem is in an unclean state.
> +@QUOTA_MAN_COMMENT@.TP
> +@QUOTA_MAN_COMMENT@.B quota
> +@QUOTA_MAN_COMMENT@.br
> +@QUOTA_MAN_COMMENT@Create quota inodes (inode #3 for userquota and =
inode
> +@QUOTA_MAN_COMMENT@#4 for group quota) and set them in the =
superblock.
> +@QUOTA_MAN_COMMENT@With this feature, the quotas will be enabled
> +@QUOTA_MAN_COMMENT@automatically when the filesystem is mounted.
> +@QUOTA_MAN_COMMENT@.IP
> +@QUOTA_MAN_COMMENT@Causes the quota files (i.e., user.quota and
> +@QUOTA_MAN_COMMENT@group.quota which existed
> +@QUOTA_MAN_COMMENT@in the older quota design) to be hidden inodes.
> +@QUOTA_MAN_COMMENT@.IP
> +@QUOTA_MAN_COMMENT@.B Not defined by default,
> +@QUOTA_MAN_COMMENT@see https://ext4.wiki.kernel.org/index.php/Quota
> +.TP
> +.B replica
> +.br
> +Non-upstream feature.

I think this should be commented out like the other features not in
the upstream kernel.

> +.TP
> +.B resize_inode
> +.br
> +Reserves space so the block group descriptor table may grow in the =
future.
> +Useful for online resizing using
> +.BR resize2fs .
> +.TP
> +.B snapshot_bitmap
> +.br
> +Legacy parameter, no longer supported by kernel.

Likewise, I'm not sure if it is useful to document this one, since
it was never supported by any mainline kernel.

> +.TP
> +
> +.B sparse_super
> +.br
> +Filesystem has fewer superblock backup copies
> +(saves space on large filesystems).  This feature is normally enabled =
by
> +default for all file systems.
> +.TP
> +.B uninit_bg
> +.br
> +Not all of the block groups are initialized.
> +This feature allows the kernel to initialize bitmaps and inode tables
> +and keep a high watermark for the unused inodes in a filesystem, to =
reduce
> +.BR e2fsck (8)
> +time.  The result is that it can speed up filesystem creation time =
noticeably
> +(if lazy_itable_init is enabled).
> +.IP
> +This first e2fsck run after enabling this feature will take the
> +full time, but subsequent e2fsck runs will take only a fraction of =
the
> +original time, depending on how full the file system is.
> +It is only supported by the ext4 filesystem in recent Linux kernels.

This last hunk is not accurate - the slow e2fsck is only needed if the
feature is enabled on an existing filesystem, not if it is enabled by
e2fsck.  Also, the uninit_bg feature has been available for all ext4
versions.  Maybe you mix this up with metadata_csum?

> +.B sparse_super
> +.br
> +Limits the number of backup superblocks to save space on large =
filesystems.

"sparse_super" is already listed above.

> +.TP
> +.B uninit_bg, uninit_groups
> +.br
> +Allows the kernel to initialize bitmaps and inode tables and keep a =
high
> +watermark for the unused inodes in a filesystem, to reduce
> +.BR e2fsck (8)
> +time.
> +.br
> +The first e2fsck run after enabling this feature will take the full
> time, but subsequent e2fsck runs will take only a fraction of the
> original time, depending on how full the file system is.

"uninit_bg" is also listed twice.

> +SH BUGS
> You need to know the physical filesystem structure to understand the
> output.
> .SH AUTHOR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_81220D6A-9169-4E2B-9F1A-AFF80759C31D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUrDULHKl2rkXzB/gAQJyPxAAlDddn+jZTx98J7KHevu3IVJOyUpQcGVh
RaOMQ6K3aNGkvlXAAyVoLfLACcPOgqSLXvjRU1UqSVhNNpVvdSmbXxbIKawx8mn4
Lf60jBogve0OXs3i03UnIr3erute9MJKcaahkXtKJdCzD/pI9+3E6r10rdXV711Q
2DrO0V4u634phN5BQvyKBLl8btZBAUOEOv7bB1jORWzNz3ESZ5y49u8PTTuHHx9T
7dfmP8ZKugq1c7VWtseP0lnmqZAHb6+A4O1JmeBAzHTP/SPh4Hx7wytJtAz6GiW0
NlIcOJ8kGKDLHJhVPOCjtY/KT4CiQVbpguqtexlVSXzQfpMREK1tIFDKRThevxoT
N7YkYU46hwCtIBaLtKhwFHYSlnrzGLVQyaH57wXdIt2YAea9TZ7X7Pq91cA8N7hB
fXaZzSHXgaz7kt7dvHP62yG/JnqbxGNXH6/bYD8mGm4yqfvRd/wC6QAnuZeiabrf
3v0gL84UxopX1kL4ziy2YSjhrjpzxLXfh2kgv7J8p9DKZ7Uz5izrh09eDcOJ4Ibw
lx1nD70+nk3XtakYvxwRyYgeQpFx4dKsqH1XuF+29PcyTvFQukAZ3CG8Qfrh646+
XOWb4pLkVDMLkYSBe3WUNzvrjqAc0xTh7PwoHv2/yKo1n7TswDVqf/Bx//ZFwjSK
cdhcw9AV10c=
=SFOM
-----END PGP SIGNATURE-----

--Apple-Mail=_81220D6A-9169-4E2B-9F1A-AFF80759C31D--
