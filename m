From: Andreas Dilger <adilger@sun.com>
Subject: [RFC] new INCOMPAT flag for extended directory data
Date: Tue, 05 May 2009 14:25:24 -0600
Message-ID: <20090505202524.GL3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Tom Wang <Tom.Wang@sun.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35402 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZEEUZo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 May 2009 16:25:44 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n45KPh6X019469
	for <linux-ext4@vger.kernel.org>; Tue, 5 May 2009 13:25:44 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KJ600700TZVD500@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 05 May 2009 13:25:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,
we're looking to store some extended data in each directory entry
for Lustre, to hold a 128-bit filesystem-unique file identifier
in the dirent.  If we ever wanted to look at 64-bit or larger
inode numbers we would need to do the same.

There are a couple of approaches to do this, either having the extra
data beyond name_len but within rec_len, or to have the extra data within
name_len, but after a NUL terminator.  Keeping the extra dirent data
within name_len is somewhat easier to implement, only the few places
that do filename comparisons/hashing need to be changed.

In order to detect the presence of this extra data in the dirent, we
would want to use the high bits in d_type (say bits 0xf0).  This part
of d_type could either be a flag for the presence of 4 different bits
of data (which limits the number of different kinds of data), or it
could be the length of the extra data (which means there is no way to
identify the type of data being stored there).  The d_type would mask
off the high bits in get_dtype() so as not to confuse filldir.

If e2fsck detected these bits set in d_type, and name_len != strlen(name)
either it would ask to set the INCOMPAT_DIRDATA feature, or failing
that it would clear the flag in d_type and set name_len == strlen(name).
I don't think there are any valid name encodings that have an embedded NUL
byte.

So, the questions:
- do you have a strong objection to this?
- do you prefer data-in-name_len or data-in-rec_len?
- can we get an EXT4_FEATURE_INCOMPAT_DIRDATA = 0x200 flag for this?
- can we reserve the high 4 bits of d_type, and use EXT4_FT_DIRDATA = 0x20
  for our 128-bit identifier?  0x20 would match both the length of the
  identifier in 4-byte words, or be a flag indicating this FID is present.
  We can keep 0x10 for the inode_hi field (which will also match the length
  of a 32-bit inode_hi field and/or the presence of inode_hi) and we can
  defer the decision on whether this is the length or the type of the extra
  data.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

