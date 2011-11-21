From: Yu Jian <yujian@whamcloud.com>
Subject: Increase xattr space by allocating contiguous xattr blocks
Date: Mon, 21 Nov 2011 20:22:26 +0800
Message-ID: <4ECA4282.5020908@whamcloud.com>
References: <4EC10664.1080501@tuxadero.com> <CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com> <20111115142246.GA7516@thunk.org> <246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@whamcloud.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Yu Jian <yujian@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52446 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1KUMWj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 07:22:39 -0500
Received: by ghbz2 with SMTP id z2so2703508ghb.19
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2011 04:22:38 -0800 (PST)
In-Reply-To: <246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted,

I'm working on the patches for large xattrs support again based on the 
previous patch made by Kalpak Shah. There are some small issues in the 
previous patch, I'd fix them and rebase the patch on the latest ext4 codes.

Per the thread of 
http://kerneltrap.org/mailarchive/linux-ext4/2009/2/9/4931244, there are 
two features need to be implemented:
1) store large xattr value (with value_size > blocksize) in an external 
xattr inode
2) increase xattr space by allocating a single chunk of up to 64kB (in 
size) contiguous xattr blocks

The first one has been implemented in the previous patch, and I'm 
working on the second one, which would handle "medium-sized" xattrs more 
efficiently.

Now, I've the same question as that in the above thread:
In xattr.{h,c}, all of the macros and functions assume the xattr space 
is contiguous with entries growing downwards and values growing upwards 
(aligned to the end of the space). Especially, the create, replace, 
remove and shift operations of xattrs are all performed inside a 
contiguous buffer. This is no problem with in-inode xattr space and 
single external xattr block which is associated with one block buffer. 
But for multiple xattr blocks, since the data of them would be read into 
different block buffers, which are not contiguous, most of the existing 
macros and functions need to be changed. Is this way acceptable?

In order to make most of the codes remain as-is, we could allocate a 
contiguous large buffer (up to 64kB in size) to handle all of the data. 
However, we have to memcpy the data from block buffers to the large 
buffer, and after the data are changed, we need memcpy the data back to 
block buffers to make the data written into the block device. Is this 
way reasonable?

Could you please give me some suggestions on how to solve this issue?

Thanks!
-- 
Best regards,
Yu Jian
