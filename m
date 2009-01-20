From: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Subject: Re: [PATCH]ext4: online defrag: Enable to reuse blocks by multiple
Date: Tue, 20 Jan 2009 08:43:47 +0530
Message-ID: <37d33d830901191913y3e511ba8m44a7aa646e3cd1fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>,
	"Greg Freemyer" <greg.freemyer@gmail.com>,
	"Manish Katiyar" <mkatiyar@gmail.com>,
	"Peter Teoh" <htmldeveloper@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:33853 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZATDNs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2009 22:13:48 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2909648rvb.1
        for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 19:13:47 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

I recently came across one of your mails mentioning the pnas of the
new ABI's that will be supported by ext4.

Just to give you a context first, we are working on Online
Hierarchical Storage Manager for linux. Initially we planned to keep
the implementation to ourself as its really difficult to get an ioctl
based interface to the block allocator.

We work exactly like any other HSM would, like using allocation and
relocation policies to relocate files across tiers (placement
classes).
Tiers are nothing but a set of disks or rather devices.

If the users set the ohsm to a mount point, through an ioctl we fecth
the mapping of the tiers in terms of Block groups.
And then depending upon the allocation policies, files (data blocks)
are allocated on the respective teirs.
Then, in the inode struct we set the home_tier_id to its respective
tier. This is used if the file needs to allocate more data blocks in
the future.

We have added two new members in the struct inode. Namely,
home_tier_id and dest_tier_id.

Now, when uses enforces relocation, we do a FS Scan and check the
policies to qualify some of the inodes for relocation. If any, we set
its dest_tier_id to the destination as mentioned in the policy, and
then reallocate all its data block from the new teir (BG ranges). Then
set its home_tier_id to the dest_tier_id.

Two things, if at the time of allocation a file doesn't qualify any
policy, we allow it to be allocated across the FS.
Secondly, during relocation, if the destination tier ID has not space,
we accpet a FLAG, if FLAG=0 ( means, anywhere in the FS), if FLAG=1 (
ENOSPC).

So, coming to the point. I would like to know more about the Second
ABI below that you have mentioned.

>(1) An (ioctl-based) interface which allows a privileged program to
>specify one or more range of blocks which the filesystem's block
>allocator must NOT allocate from.  (We may want to have a flag for
>each block range which either makes the block lockout advisory, such
>that if the block allocator can't find blocks anywhere else, it may
>invade the reserved block area --- or mandatory, where if there are no
>other blocks, the filesystem returns ENOSPC).  This allows the
>defragmenter to work on an area of the disk without worrying about
>concurrent allocations by other processes from getting in the way.

>(2) An (ioctl-based) interface which associates with an inode
>preferred range(s) of blocks which the block allocator will try using
>first; if those blocks are not available, or the block range(s) is
>exhausted, the block allocator use its normal algorithms to pick the
>best available block.  The set of preferred blocks is only guaranteed
>to persist while the inode is in memory.

We can just make a slight change with a FLAG where the user can
specify, how strict he is about his allocation.
This mechanism will allow us to think of extending our work to ext4.
We already have a working prototype for ext2.

If we get such an interface, that would really be great.

>(3) An (ioctl-based) interface which takes two inode numbers, and
>allows a privileged program to "defrag" an inode by using blocks from
>a donor inode and using them as the new blocks for the destination
>inode, preserving the contents of the destination inode.

>One other thing that comes to mind.  If it turns out that these
i>nterfaces have multiple users, and in some cases the reservations or
>lock allocation restrictions are expected to last for longer than a
>process lifetime, it may be useful to tag them with a short (8-16
>character) name, so that it is possible to list the current set of
>reservations, and so they can be removed by a privileged user.  This
>could be overdesigning the interface; but the whole *point* of
>thinking about the interfaces from a more generic point of view (as
>opposed for use by a specific program for which the kernel interfaces
>are custom-designed) is that hopefully they will have multiple use
>cases and multiple users, in which case we need to worry about how
>multiple users can co-exist.

You can count us too, in the list of users.

Where can we get more information on this ?

-- 
Regards,
Sandeep.





 	
"To learn is to change. Education is a process that changes the learner."
