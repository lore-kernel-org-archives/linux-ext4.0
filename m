From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: How to add new fields into inode?
Date: Fri, 27 Feb 2015 00:52:43 -0700
Message-ID: <38ED78B4-149F-4C6F-A2EC-634C71ED9ADF@dilger.ca>
References: <54EDABB5.5020806@yandex-team.ru>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Li Xi <pkuelelixi@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38276 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbbB0Hwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Feb 2015 02:52:45 -0500
Received: by padbj1 with SMTP id bj1so20779986pad.5
        for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2015 23:52:45 -0800 (PST)
In-Reply-To: <54EDABB5.5020806@yandex-team.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 25, 2015, at 4:02 AM, Konstantin Khlebnikov <khlebnikov@yandex-team.ru> wrote:
> 
> Currently I'm working on (yet another attempt of) project id and quota
> for ext4. Obviously I want to add new u32 field into inode for holding
> it's project id.
> 
> As I see policy for that isn't well defined:
> 
> Kernel tries to allocate extra space according to sizeof(struct
> ext4_inode). If EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE is set then it takes
> maximum of sizeof, s_want_extra_isize and s_min_extra_isize.
> 
> Libext2fs always allocates space for it's own structure and in some
> cases checks s_want_extra_isize but without checking related feature.

That is likely a bug in libext2fs.  This feature was written because
some people were concerned about requiring extra inode features on a
filesystem that was upgraded from an older kernel where the reserved
fields were fewer.  In many cases, it is not critical if some field
at the end of the inode is present or not, but in other cases (maybe
project quota?) it is important that there is always space for saving
this data.

We have a patch for e2fsck which allows expanding the i_extra_size on
all in-use inodes in the filesystem to ensure that it meets at least
s_min_extra_isize.  New inodes will always reserve the needed space.

http://git.hpdd.intel.com/tools/e2fsprogs.git/commitdiff/6a7efec02c4d01b6bd951fef7d1c8c78f0426aa4
http://git.hpdd.intel.com/tools/e2fsprogs.git/commitdiff/89555784b583ff1dd48e31ff276a4ad0421172b0

If there isn't enough space in the inode for the extra bytes, then
e2fsck will prompt the user to delete an xattr from the inode, or
abort e2fsck (in a safe manner, nothing will be one in preen mode).

> Thus in some cases default extra size of inodes doesn't depend on
> present features and changes if we add new fields into structure.
> For example expected output of some unit tests depends on that value.
> 
> Question is: it's ok to waste some bytes for unused fields at the of
> inode or default extra size should depend on actually enabled features?

I think it is preferable that the i_extra_size not be larger than what
is actually used.  If some feature like project quota is enabled on an
existing filesystem, then e2fsck could be run to expand the inode size
to the needed size,  It would also be possible for the kernel to grow
i_extra_size to cover the new field, or return an error to userspace
at the time the new project quota is being set on the file (either
explicitly or by rename into a project quota-enabled directory).

Cheers, Andreas





