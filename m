From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH 7/9]ext4: Add the EXT4_IOC_FIEMAP_INO ioctl
Date: Mon, 27 Oct 2008 13:55:24 -0600
Message-ID: <20081027195524.GN3184@webber.adilger.int>
References: <49019EF6.4000706@rs.jp.nec.com>
 <20081026084048.GF3184@webber.adilger.int> <49059633.8080600@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>, hch@infradead.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33985 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYJ0Tzw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 15:55:52 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m9RJtpEb003795
	for <linux-ext4@vger.kernel.org>; Mon, 27 Oct 2008 12:55:51 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K9E00001UF7YD00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 27 Oct 2008 12:55:51 -0700 (PDT)
In-reply-to: <49059633.8080600@rs.jp.nec.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 27, 2008  19:21 +0900, Akira Fujita wrote:
> Andreas Dilger wrote:
>> On Oct 24, 2008  19:09 +0900, Akira Fujita wrote:
>>> The EXT4_IOC_FIEMAP_INO is used to get extents information of
>>> inode which set to ioctl.
>>> The defragger uses this ioctl to check the fragment condition
>>> and to get extents information in the specified block group.
>>
>> Instead of having a separate IOC number for each such ioctl, instead
>> we implemented EXT4_IOC_WRAPPER, which is an root-specific ioctl that
>> passes in an inode number and a second IOC number so that arbitrary file
>> ioctls can be run on any inode by root.
>
> The EXT4_IOC_WRAPPER ioctl seems to be usuful for many situations.
> But the EXT4_IOC_FIEMAP_INO ioctl is used not only root user but also
> non-root user to call fiemap,
> so we cannot use the current EXT4_IOC_WRAPPER ioctl for defrag.

Why does a regular user need to do the ioctl on a file that it may not
have read permission to access?  I can see this is useful for root
doing a defrag of the whole filesystem instead of opening and closing
all of the files, but for regular users we need to validate via the
full path to ensure they can even access the file before defragmenting it.

>> This was mentioned last time these patches were posted, but there was
>> no reply from you.  Christoph suggested a more generic VFS open-by-inum,
>> which isn't impossible to do but would cause a lot of controversy I
>> think, while the EXT4_IOC_WRAPPER is at least contained within ext4,
>> but is more generically useful than EXT4_IOC_FIEMAP_INO.
>
> Do you plan to add EXT4_IOC_WRAPPER into the ext4 patch queue?

If there is interest, yes.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

