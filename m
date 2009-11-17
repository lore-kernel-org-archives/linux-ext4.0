From: Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] A request to reserve a "tree id" field on ext[34] inodes
Date: Tue, 17 Nov 2009 20:55:57 +0300
Message-ID: <4B02E3AD.3090904@openvz.org>
References: <4B02AD8B.2030202@openvz.org> <20091117171226.GC1923@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Dmitri Monakhov <dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:37673 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZKQR5B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Nov 2009 12:57:01 -0500
In-Reply-To: <20091117171226.GC1923@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>   Hi,
> 
>> We have a proposal to implement a 2-level disk quota on ext3 and ext4.
>>
>> In two words - the aim is to have directories on ext3/4 partitions
>> which are limited by its disk usage and the number of inodes. Further
>> the plan is to allow configuring uid and gid quotas within them.
>   If I understand it right, this is something like XFS's project quota,
> right? 

Not exactly. XFS tree quota actually replaces gid one. My proposal is
to add the 3rd id.

> Note that such thing has implications such as you have to forbid
> hardlinks between different "quota trees", otherwise it just won't fly...

Yes, I know it. We know other things we'll have to disable, but this is
OK to live without them.

> Also by 2-level, you mean it won't be possible to nest such subtrees?

As I see it - nesting can be done on top of it. I mean - once we have
a tree id of an inode and if we say "id A is a sub-id of id B" we're done.

As far as containers are concerned - we'll have to map container id to
quota tree id, since changing a container id is fast and simple, but
it's not so for tree id. That said, this treeid is just a way do distinguish
inodes from one sub-tree from the others.

> I.e. have a quota on directories a/, b/, a/b, a/c?
> 
>> The main usage of this is containers. When two or more of them are
>> located on one disk their roots will be marked with a unique tree id
>> and thus the disk consumption of each container will be limited. While
>> achieving this goal having an id of what tree an inode belongs to is
>> a key requirement.
>>
>> So first we would like to ask to reserve a place on ext3 and ext4 inodes
>> for that ID.
>   Do you really need to store tree ID on disk? I'd think that it should
> be enough to keep some id / pointer in memory and initialize it when we
> load inode into memory (from an id / pointer of parent directory). Then
> it would be enough to store a fact that some directory is a root of
> "quota tree" somewhere - either in extended attributes, as a flag in
> the inode, or together with quota data.

We can't do it inside ext4_nfs_get_inode unfortunately :(

> 								Honza

