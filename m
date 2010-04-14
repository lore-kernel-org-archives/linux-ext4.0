From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext34_free_inode's mess
Date: Wed, 14 Apr 2010 11:03:50 -0500
Message-ID: <4BC5E766.3030801@redhat.com>
References: <87pr2246y4.fsf@openvz.org> <20100414133440.GD3616@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab0DNQD6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 12:03:58 -0400
In-Reply-To: <20100414133440.GD3616@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
> On Wed 14-04-10 15:19:47, Dmitry Monakhov wrote:
>> I've finally automated my favorite testcase (see attachment), 
>> before i've run it by hand.
>> And sometimes i've saw following complain from fsck:
>> fsck.ext4 -f -n /dev/sdb2
>> ...
>> Pass 5: Checking group summary information
>> Inode bitmap differences:  -93582
>> Fix? no
>>
>> Free inodes count wrong for group #12 (4634, counted=4633).
>> Fix? no
>>
>> Free inodes count wrong (35610, counted=35609).
>> Fix? no
>> ...
>   Interesting. So some inode is marked as free although it is in
> use, right? That sounds like a nasty bug - if you reproduce this
> again, could you use debugfs to find out what file type is that
> inode? It could help looking for the bug.

running fsstress in verbose mode, and disabling link/unlink/symlink,
you can sometimes narrow it down to a sequence of operations on that file, too.
(keep track of the seed nr...)

Of course if it's a random-ish race that probably won't be of much use.  :)

-Eric
