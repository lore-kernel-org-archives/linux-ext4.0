From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] A request to reserve a "tree id" field on ext[34] inodes
Date: Tue, 17 Nov 2009 09:06:03 -0800
Message-ID: <0D1BE31B-34F9-40A1-8C7F-6A9FFF18DA8E@sun.com>
References: <4B02AD8B.2030202@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Dmitri Monakhov <dmonakhov@openvz.org>
To: Pavel Emelyanov <xemul@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57552 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbZKQRGF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 12:06:05 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nAHH68l0025462
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 09:06:09 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KT900700JASM700@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 17 Nov 2009 09:06:08 -0800 (PST)
In-reply-to: <4B02AD8B.2030202@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-17, at 06:04, Pavel Emelyanov wrote:
> We have a proposal to implement a 2-level disk quota on ext3 and ext4.
>
> In two words - the aim is to have directories on ext3/4 partitions
> which are limited by its disk usage and the number of inodes. Further
> the plan is to allow configuring uid and gid quotas within them.
>
> The main usage of this is containers. When two or more of them are
> located on one disk their roots will be marked with a unique tree id
> and thus the disk consumption of each container will be limited. While
> achieving this goal having an id of what tree an inode belongs to is
> a key requirement.

How do you handle files with multiple links, if they are located in  
different trees?  The inode would need to have multiple tree ids.

You can instead just store this data in an xattr (which will normally
be stored in the inode, so no performance impact), and then you are
free to store multiple values per inode.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

