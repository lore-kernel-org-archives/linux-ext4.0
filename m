From: Andreas Dilger <adilger@sun.com>
Subject: Re: Maximum filename length
Date: Sat, 22 Nov 2008 17:36:18 -0600
Message-ID: <20081122233618.GR3186@webber.adilger.int>
References: <87a8dc10811210451p3ec1e3dar371a3ebffcedcdc@mail.gmail.com>
 <20081121223248.GA22671@mit.edu>
 <87a8dc10811221048t27b0c6dx253bed61418389e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Alexey Salmin <alexey.salmin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59903 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYKVXgW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Nov 2008 18:36:22 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAMNaLth018227
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 15:36:21 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAR00E01DDU6000@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 22 Nov 2008 15:36:21 -0800 (PST)
In-reply-to: <87a8dc10811221048t27b0c6dx253bed61418389e8@mail.gmail.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 23, 2008  00:48 +0600, Alexey Salmin wrote:
> Sure, I understand the problems you've mentioned. But every big act
> has the beginning. Adding the extension to the ext4 is only the first
> step. Of course it'll cause crashes and other problems in many places
> from kernel to userspace code. But these problems will disturb only
> people who will really use this extension (like me). Anyway most of these
> bugs will be fixed some day, may be in two or three years. No one is
> talking that it's a fast process but it will reach it's end and that's good
> I think.

If you are motivated to work on this, there are a number of possible ways
that this could be done.  The simplest would be to create a new directory
entry (replacing ext4_dir_entry_2) that has a longer name_len field, and
ideally it would also have space for a 48-bit inode number (ext4 will
NEVER need more than 280 trillion inodes I think).  

I don't know that it is practical to require this format for the entire
directory, because it would mean in some rare cases rewriting 1M entries
(or whatever) in a large directory to the new format.  It would be better
to allow either just the leaf block to hold the new record format (with a
marker at the start of the block), or individual records having the new
format, possibly marked by a bit in the "file_type" field.

It's kind of ugly, but it needs to be possible to detect if the entry is
the old format or the new one.

#define EXT4_DIRENT3_FL		0x00400000  /* directory has any dir_entry_3 */


#define EXT4_FT_ENTRY_3 0x80			/* file_type for dir_entry_3 */
#define EXT4_FT_MASK    0x0f			/* EXT4_FT_* mask */
#define EXT4_INODE_MASK 0x00ffffffffffffff	/* 48-bit inode number mask */
#define EXT4_NAME_LEN3  1012

struct ext4_dir_entry_3 {
	__le64 inode;		/* High byte holds file_type */
	__le16 rec_len;
	__le16 name_len;
	char   name[EXT4_NAME_LEN3];
};

static inline __u8 ext4_get_de_file_type(struct ext4_dir_entry_2 *dirent)
{
	return (dirent->file_type & EXT4_FT_MASK);
}

static inline int ext4_get_de_name_len(struct ext4_dir_entry_2 *dirent)
{
	if (dirent->file_type & EXT4_FT_ENTRY_3) {
		struct ext4_dir_entry_3 *dirent3 = dirent;

		return le16_to_cpu(dirent3->name_len);
	}

	return dirent->name_len;
}

static inline int ext4_get_de_rec_len(struct ext4_dir_entry_2 *dirent)
{
	if (dirent->file_type & EXT4_FT_ENTRY_3) {
		struct ext4_dir_entry_3 *dirent3 = dirent;

		return le16_to_cpu(dirent3->rec_len);
	}

	return le16_to_cpu(dirent->rec_len);
}

static inline __u64 ext4_get_de_inode(struct ext4_dir_entry_2 *dirent)
{
	if (dirent->file_type & EXT4_FT_ENTRY_3) {
		struct ext4_dir_entry_3 *dirent3 = dirent;

		return le64_to_cpu(dirent3->inode) & EXT4_INODE_MASK;
	}

	return le32_to_cpu(dirent->inode);
}

static inline __u64 ext4_get_de_name(struct ext4_dir_entry_2 *dirent)
{
	if (dirent->file_type & EXT4_FT_ENTRY_3) {
		struct ext4_dir_entry_3 *dirent3 = dirent;

		return dirent3->name;
	}

	return dirent->name);
}


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

