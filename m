From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Inode and Block Allocation Policy
Date: Mon, 25 Jun 2012 22:54:31 -0600
Message-ID: <B949434F-99F6-479F-BC76-E4E353E457FE@dilger.ca>
References: <0408C81F72528E40A0D3235A1F67FFC804A36B@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:33275 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2FZEyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2012 00:54:32 -0400
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC804A36B@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-06-25, at 11:56 AM, Nelson, John R wrote:
> i have a quick question about the block allocation in EXT4. I know that EXT4 trys to allocate the files blocks in the files inodes Block Group. But what does EXT4 do when say you have a 100GB Virtualbox image? Does the block allocator just keep allocating blocks in the groups next to the group the files inode is in?

Yes.

> Now say that the block group has no blocks but tons of free inodes, does the ext4 allocator use another block group to allocate the inode in or does it use the same block group the directorys inode is in despite no free blocks?

It checks the free blocks in addition to the free inodes.

Cheers, Andreas





