From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
 flex_bg filesystems
Date: Tue, 24 Feb 2009 18:58:38 -0600
Message-ID: <49A497BE.1030700@redhat.com>
References: <20090218154310.GH3600@mini-me.lan> <20090224085931.GA25657@skywalker> <20090224224108.GQ3199@webber.adilger.int> <49A49785.10000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45169 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbZBYA7Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 19:59:25 -0500
In-Reply-To: <49A49785.10000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Andreas Dilger wrote:
>> Ted Ts'o wrote something like the following (didnt' get original email):
>>> @@ -122,6 +122,9 @@ struct ext4_inode_info {
>>>  	struct list_head i_prealloc_list;
>>>  	spinlock_t i_prealloc_lock;
>>>
>>> +	/* ialloc */
>>> +	ext4_group_t	i_last_alloc_group;
>> Even better would be to store i_last_alloc_inode.  In the past Eric
>> has demonstrated workloads that are allocating lots of inodes exhibit
>> O(n^2) behaviour because the entire group bitmap is searched from the
>> start each time, and that can cumulatively be very slow.  Having the
>> directory start searching from the most recently allocated inode would
>> make this O(n), and would not significantly alter behaviour.
> 
> A very hacky benchmark I had to demonstrate this is at

Er, URL please, maestro...

http://people.redhat.com/esandeen/benchmarks/seq_mkdirs.c

> It just creates a directory tree starting at 000/ under the dir it's run
> in, and times iterations of creates.
> 
> The tree is created in order, like:
> 
> 000/000/000/000/000/000
> 000/000/000/000/000/001
> 000/000/000/000/000/002
> ...
> 000/000/000/000/000/fff
> 000/000/000/000/001/000
> ....
> 
> On ext3:
> 
> # ./seq_mkdirs
> iter 0: 6.191491 sec
> iter 1: 8.455782 sec
> iter 2: 9.435375 sec
> iter 3: 10.198069 sec
> iter 4: 10.922969 sec
> iter 5: 10.800908 sec
> iter 6: 12.940676 sec
> iter 7: 15.513261 sec
> ...
> 
> On upstream ext4:
> 
> # ./seq_mkdirs
> iter 0: 5.628331 sec
> iter 1: 6.581043 sec
> iter 2: 6.723445 sec
> iter 3: 6.567891 sec
> iter 4: 5.862526 sec
> iter 5: 6.462064 sec
> iter 6: 7.208110 sec
> iter 7: 6.549735 sec
> ...
> 
> 
> I did play with saving the last-allocated position but if that's just
> in-memory then it's a little odd that the first allocation will be
> potentially much slower, but that's probably acceptable.  It also
> wouldn't fill in gaps when inodes are deleted if you don't re-search
> from the parent.  ISTR that the constant create/delete didn't cause a
> problem, will need to remind myself why ...
> 
> -Eric
> 

