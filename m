From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/3] Lazy itable initialization for Ext4
Date: Fri, 20 Aug 2010 19:51:41 +0200
Message-ID: <1282326704-14838-1-git-send-email-lczerner@redhat.com>
Cc: rwheeler@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu, adilger@dilger.ca, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab0HTRwF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Aug 2010 13:52:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, all

I am presenting you initial version of my lazy inode table initialization
code for Ext4. The patch set consist of three patches. The first one adds
helper function for blkdev_issue_zeroout called sb_issue_zeroout as I am
using it to zero out inode table. Second patch adds new pair of mount
options (inititable/noinititable), so you can enable or disable this
feature. In default it is off (noinititable), so in order to try the new
code you should moutn the fs like this:

  mount -o noinititable /dev/sda /mnt/

And finally the third patch adds the inode table initialization code
itself. Thread initialization was heavily inspired by nilfs2 segctord.


DESCRIPTION:

When file system is mounted with "inititable" mount option, new thread
(called itableinitd) is created. This thread walks through allocation
groups searching for the group with not yet initialized inode table.
When such a group is found it write zeroes through whole inode table and
put itself into sleep for defined number of seconds to not disturb other
ongoing I/O. This is repeated until it walks through every allocation group
then the itableinitd thread is stopped.

When regular inode allocation are going too fast, there is a chance that
it hits the group with uninitialized inode table sooner than the
itableinitd thread. In that case it just initializes the itable for
itself the same way that itableinitd thread would do eventually. To
prevent race conditions, each group is protected by the mutex.



For now, there is no way to control itableinitd thread. It would probably be
nice to have more control over how often it is woken up maybe through
sysfs interface, or we can add some more logic into it in order to be more
I/O sensitive and not put too much stress on already stressed system.
However, this may be counterproductive, because we want inode table to be
initialized before regular inode allocator hits it.

Personally I think, we should create some kind of sysfs interface
(/sys/fs/ext4/<device>/itable_init_interval ?) so the user space can watch
the system and control itableinitd wake-up interval for itself.

This is the first version of patch set and it received very limited testing
so far. In order to try this patch you should do the following (aside
compiling kernel with this patch)

 1. Make Ext4 fs with lazy_itable_init extended option.
	mke2fs -T ext4 -E lazy_itable_init=1 <device>

 2. Mount this file system with inititable mount option
	mount -o inititable <device> <dir>



Any comments are more than welcomed.

Thanks!
-Lukas

---
[PATCH 1/3] Add helper function for blkdev_issue_zeroout
[PATCH 2/3] Add inititable/noinititable mount options for ext4
[PATCH 3/3] Add inode table initialization code into Ext4

 fs/ext4/ext4.h         |   66 ++++++++++++
 fs/ext4/ialloc.c       |   75 +++++++++++++
 fs/ext4/super.c        |  274 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    8 ++
 4 files changed, 423 insertions(+), 0 deletions(-)
