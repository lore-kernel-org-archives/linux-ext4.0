From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 7/9]ext4: Add the EXT4_IOC_FIEMAP_INO ioctl
Date: Mon, 27 Oct 2008 19:21:39 +0900
Message-ID: <49059633.8080600@rs.jp.nec.com>
References: <49019EF6.4000706@rs.jp.nec.com> <20081026084048.GF3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>, hch@infradead.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37557 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYJ0KV5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 06:21:57 -0400
In-Reply-To: <20081026084048.GF3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Andreas Dilger wrote:
> On Oct 24, 2008  19:09 +0900, Akira Fujita wrote:
>> The EXT4_IOC_FIEMAP_INO is used to get extents information of
>> inode which set to ioctl.
>> The defragger uses this ioctl to check the fragment condition
>> and to get extents information in the specified block group.
> 
> Instead of having a separate IOC number for each such ioctl, instead
> we implemented EXT4_IOC_WRAPPER, which is an root-specific ioctl that
> passes in an inode number and a second IOC number so that arbitrary file
> ioctls can be run on any inode by root.

The EXT4_IOC_WRAPPER ioctl seems to be usuful for many situations.
But the EXT4_IOC_FIEMAP_INO ioctl is used not only root user but also
non-root user to call fiemap,
so we cannot use the current EXT4_IOC_WRAPPER ioctl for defrag.

> This was mentioned last time these patches were posted, but there was
> no reply from you.  Christoph suggested a more generic VFS open-by-inum,
> which isn't impossible to do but would cause a lot of controversy I
> think, while the EXT4_IOC_WRAPPER is at least contained within ext4,
> but is more generically useful than EXT4_IOC_FIEMAP_INO.
> 

Do you plan to add EXT4_IOC_WRAPPER into the ext4 patch queue?


Regards,
Akira Fujita
