From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: Re: ext2fs_block_iterate (e2, EXT2_RESIZE_INO, ...) => EXT2_ET_FILE_TOO_BIG?
Date: Wed, 31 Aug 2011 22:59:22 +0700
Message-ID: <86y5y9bmhx.fsf@gray.siamics.net>
References: <867h5tdf9o.fsf@gray.siamics.net>
	<20110831152207.GB32582@thunk.org>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41341 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab1HaP7m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 11:59:42 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QynCX-0000TD-52
	for linux-ext4@vger.kernel.org; Wed, 31 Aug 2011 17:59:41 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 17:59:41 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 17:59:41 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Ted Ts'o <tytso@mit.edu> writes:

[=E2=80=A6]

 > Yeah, the resize inode is a special case.  It is specially
 > constructed to reserve space for new block group descriptor blocks
 > when doing an online resize.  I would suggest for your purposes that
 > you _not_ support the online-resizable file system feature, as it's
 > unneeded complexity (from what I understand of what you're going to
 > be doing with the file system).

	I don't seem to understand why such a support would require a
	specific handling of the resizable filesystems (other than that
	EXT2_RESIZE_INO is to be ignored by e2dis.)

	As I currently have no means of Ext2+ FS non-payload parts
	extraction, I'm going to rely on e2image(8).  Like:

# tar -C / -jcf image.files.tar.bz2 mnt/=20

$ /sbin/e2image -r image.ext2 image.e2image=20
$ e2dis image.index < image.ext2=20

	Then, the image could be restored with:

$ tar -jxf image.files.tar.bz2=20
$ find mnt/ -type f -print0 \
      | (cat < image.e2image && imrt image.index) \
      > image.ext2=20

	(Note that imrt is going to lseek(2) its stdout.)

	That way, I assume that the resize inode is going to be
	preserved thanks to e2image.

	The point of the procedure above is that instead of passing a
	complete .tar.bz2 archive with all the files, only the new files
	may be passed, should it be necessary to produce a new version
	of the image (like passing a diff instead of the whole source.)
	Moreover, for system images, most of the files would likely to
	be available from the regular OS packages' repositories.

 > P.S. The code to create the reserved inode can be found in
 > lib/ext2fs/res_gdt.c, in ext2fs_create_resize_inode().

	ACK.  Thanks.

--=20
=46SF associate member #7257	Coming soon: Software Freedom Day
http://mail.sf-day.org/lists/listinfo/ planning-ru (ru), sfd-discuss (e=
n)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
