From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: How to fix up mballoc
Date: Thu, 23 Jul 2009 10:51:58 -0700
Message-ID: <4A68A33E.4050103@us.ibm.com>
References: <20090721001750.GD4231@webber.adilger.int> <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com> <20090723134538.GC8040@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:49680 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbZGWRwA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 13:52:00 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n6NHmP9n029646
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 11:48:25 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6NHq0Xh244392
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 11:52:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6NHpxel015613
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 11:52:00 -0600
In-Reply-To: <20090723134538.GC8040@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> So I started looking to see how we might be able to improve mballoc to
> avoid freespace fragmentation, and I came up with the following high
> level design.  Does this look sane?   Have I overlooked anything?
>
> 1) In ext4_mb_normalize_request(), if the inode that we are allocating
> does not have any open file descriptors for write (i.e., it's already
> closed and we're allocating via delalloc) _and_ the inode was
> previously opened with O_CREAT and without O_APPEND (checked via a
> flag in EXT4_I(inode)), then do not normalize the size to a power of
> two, but rather to the filesystem blocksize.
>
> The idea here is that we should be trying to find an exact fit, since
> most of the time (except for log files, which get appended; hence the
> O_CREAT && !O_APPEND test) once a file is written, that is probably
> the final size for the file.  So normalizing the size for the
> preallocation area to a power of two will be counterproductive for
> most files.
>
>   
I am trying to understand what user cases prefer normalize allocation 
request size? If they are uncommon cases, perhaps
we should disable the normalize the allocation size disabled by default, 
unless the apps opens the files with O_APPEND?
> 2) If the there has been less than X files opened in Y jiffies the
> parent directory (using the dentry path used to open the file), then
> do not set EXT4_MB_HINT_GROUP_ALLOC in ext4_mb_group_or_file().  We
> can simulate this for without creating this patch to test #1 by
> setting mb_stream_request to 0 (which should completely disable group
> preallocation).
>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


