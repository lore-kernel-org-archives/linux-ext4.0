From: Shriramana Sharma <jamadagni@gmail.com>
Subject: Ext4 improvements
Date: Sun, 07 Jan 2007 16:13:21 +0530
Message-ID: <45A0CEC9.5060306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57441 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbXAILII (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jan 2007 06:08:08 -0500
Received: from out1.internal (unknown [10.202.2.149])
	by out1.messagingengine.com (Postfix) with ESMTP id E5E367056C
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jan 2007 05:31:15 -0500 (EST)
Received: from [127.0.0.1] (unknown [61.17.70.153])
	by mail.messagingengine.com (Postfix) with ESMTP id 263C92CA91
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jan 2007 05:31:14 -0500 (EST)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Please be patient with my ignorance if what I am asking is meaningless
in any way. I am not too technically knowledgeable about filesystem
internals but I am willing to learn. (I thought of posting to linux-ext4
but did not want to intrude within the technical threads with my layman
thread.)

 From Wikipedia > ReiserFS article > Design section:

[quote]ext2 and other Berkeley FFS-like filesystems simply use a fixed
formula for computing inode locations, hence limiting the number of
files they may contain. Most such filesystems also store directories as
simple lists of entries, which makes directory lookups and updates
linear time operations and degrades performance on very large
directories. The single B+ tree design in ReiserFS avoids both of these
problems due to better scalability properties.[/quote]

So will ext4 avoid both of these problems just like ReiserFS? Does it
use a B+ tree? Or this "dancing B* tree" that Reiser4 is supposed to have?

Also: I found that a newly created ext3 partition uses 128 MB whereas a
new reiser3 partition uses only 32 MB. I assume that the 128 MB is the
space taken for the pre-allocated inodes or such. And I now come to know
that others have this problem much more serious on bigger filesystems -
[see comment 2 at
http://linux.wordpress.com/2006/09/27/suse-102-ditching-reiserfs-as-it-default-fs/]. 


If ext4 uses a B+ (or B*?) tree like ReiserFS then this space can be
reduced, right?

Thanks.

Shriramana Sharma.

P.S: Are there any recommended tutorials for learning filesystem basics?

P.P.S: I just put this post here because I want to convert from reiserfs
of uncertain future to ext4, which is time-tested.
