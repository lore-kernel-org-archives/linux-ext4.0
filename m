From: "Nelson, John R" <John_Nelson@student.uml.edu>
Subject: Inode and Block Allocation Policy
Date: Mon, 25 Jun 2012 17:56:17 +0000
Message-ID: <0408C81F72528E40A0D3235A1F67FFC804A36B@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:11877 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262Ab2FYR4W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 13:56:22 -0400
Received: from mail183-tx2 (localhost [127.0.0.1])	by
 mail183-tx2-R.bigfish.com (Postfix) with ESMTP id 19268380070	for
 <linux-ext4@vger.kernel.org>; Mon, 25 Jun 2012 17:54:43 +0000 (UTC)
Received: from TX2EHSMHS001.bigfish.com (unknown [10.9.14.245])	by
 mail183-tx2.bigfish.com (Postfix) with ESMTP id 00735E0177	for
 <linux-ext4@vger.kernel.org>; Mon, 25 Jun 2012 17:54:42 +0000 (UTC)
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

i have a quick question about the block allocation in EXT4. I know that EXT4 trys to allocate the files blocks in the files inodes Block Group. But what does EXT4 do when say you have a 100GB Virtualbox image? Does the block allocator just keep allocating blocks in the groups next to the group the files inode is in? Now say that the block group has no blocks but tons of free inodes, does the ext4 allocator use another block group to allocate the inode in or does it use the same block group the directorys inode is in despite no free blocks?
