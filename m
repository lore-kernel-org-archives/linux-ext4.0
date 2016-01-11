From: Richard Weinberger <richard@nod.at>
Subject: Consolidated file encryption interface/semantics?
Date: Mon, 11 Jan 2016 23:56:25 +0100
Message-ID: <56943319.9080802@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:11949 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933565AbcAKW43 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2016 17:56:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

I consider adding file encryption to UBIFS.
While looking into ext4 and f2fs I realized that both
use the same data structures/concepts.

f2fs copy&pasted a lot from ext4.
Before I do the next copy&paste, I'd to ask whether it would make sense
to more parts of the ioctl() interface out to VFS?

Let's checkout the user visible interface:

ext4 offers:
EXT4_IOC_SET_ENCRYPTION_POLICY
EXT4_IOC_GET_ENCRYPTION_PWSALT
EXT4_IOC_GET_ENCRYPTION_POLICY

with:
#define EXT4_KEY_DESCRIPTOR_SIZE 8

/* Policy provided via an ioctl on the topmost directory */
struct ext4_encryption_policy {
        char version;
        char contents_encryption_mode;
        char filenames_encryption_mode;
        char flags;
        char master_key_descriptor[EXT4_KEY_DESCRIPTOR_SIZE];
} __attribute__((__packed__));


f2fs:
F2FS_IOC_SET_ENCRYPTION_POLICY
F2FS_IOC_GET_ENCRYPTION_POLICY
F2FS_IOC_GET_ENCRYPTION_PWSALT

#define F2FS_KEY_DESCRIPTOR_SIZE        8

/* Policy provided via an ioctl on the topmost directory */
struct f2fs_encryption_policy {
        char version;
        char contents_encryption_mode;
        char filenames_encryption_mode;
        char flags;
        char master_key_descriptor[F2FS_KEY_DESCRIPTOR_SIZE];
} __attribute__((__packed__));

So, the data structures are identical and AFAIK also the supported cipher modes are.
But as both use their own ioctls having a single tool to control file encryption
can be error prone in future.
Interestingly the current ioctls for ext4 and f2fs resolve to the same integers,
is this on purpose? :)

Wouldn't it be worthwhile having exactly the same ioctls such that util-linux could offer
a decent file encryption tool which can be used by all file systems with file encryption
support?

Another thing are semantics, ext4 implemented a policy which controls
under which conditions encrypted files are allowed to be unlinked, moved, etc...
f2fs adopted these from ext4. But can't we do that in VFS or at least
agree one a policy and document it? :-)

Thanks,
//richard
