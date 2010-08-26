From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 3/3] Add inode table initialization code into Ext4
Date: Thu, 26 Aug 2010 14:14:41 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1008261342280.4071@dhcp-lab-213.englab.brq.redhat.com>
References: <1282326704-14838-1-git-send-email-lczerner@redhat.com> <1282326704-14838-4-git-send-email-lczerner@redhat.com> <AANLkTimRZ5Cbi7k+=-fQzc8ywpb6u-s19f7UdFdpMJFt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu, adilger@dilger.ca
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0HZMOt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Aug 2010 08:14:49 -0400
In-Reply-To: <AANLkTimRZ5Cbi7k+=-fQzc8ywpb6u-s19f7UdFdpMJFt@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 26 Aug 2010, Peng Tao wrote:

> Hi, all,
> 
> On Sat, Aug 21, 2010 at 1:51 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> > When lazy_itable_init extended option is passed to mke2fs, it
> > considerably speed up filesystem creation because inode tables are left
> > uninitialized, thus contains some old data. When this fs is mounted
> > filesystem code should initialize (zero out) uninitialized inode table.
> > So far this code was missing for ext4 and this patch adds this feature.
> >
> > When file system is mounted with "inititable" mount option, new thread
> > (called itableinitd) is created. This thread walks through allocation
> > groups searching for the group with not yet initialized inode table.
> > When such a group is found it write zeroes through whole inode table and
> > put itself into sleep for defined number of seconds to not disturb other
> > ongoing I/O. This is repeated until it walks through every allocation group
> > then the iitableinitd thread is stopped.
> This will slow down e2fsck speed that is gained from uninitialized
> italbe. Am I missing something? What about having another block group
> flag to tell itable that is just zeroed but not used, from itable that
> is already in use?
> 

Hi,

this is probably my bad. I should have used term "zeroed inode table" instead
of "initialized inode table". You see, there are two flags.

* EXT4_BG_INODE_UNINIT tells us that inode BITMAP was not used yet, thus
  no inode was allocated from that group just yet, so kernel need not to
  read this bitmap from the disk and rather construct fresh (zeroed)
  inode bitmap in memory (see ext4_init_inode_bitmap).

* EXT4_BG_INODE_ZEROED tells us whether or not inode TABLE was
  zeroed out. This is the flag which is set by the mkfs when
  lazy_itable_init extended option is set. This flag was not used
  for anything useful in kernel, nor e2fsck until now.

Se when the thread is done zeroing the inode table it sets the
EXT4_BG_INODE_ZEROED flag, but leaves EXT4_BG_INODE_UNINIT as is, so
e2fsck should not be any slower.

I hope it helped.

Regards.
-Lukas
