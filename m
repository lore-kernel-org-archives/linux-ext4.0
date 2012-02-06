From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Mon, 06 Feb 2012 10:40:11 -0800
Message-ID: <4F301E8B.7050909@oracle.com>
References: <4F2D8F30.3090802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, ocfs2-devel@oss.oracle.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34795 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab2BFSl2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Feb 2012 13:41:28 -0500
In-Reply-To: <4F2D8F30.3090802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/04/2012 12:04 PM, Eric Sandeen wrote:
> Now that ext4, xfs,&  ocfs2 can support punch hole, a tool to
> "re-sparsify" a file by punching out ranges of 0s might be in order.
>
> I whipped this up fast, it probably has bugs&  off-by-ones but thought
> I'd send it out.  It's not terribly efficient doing 4k reads by default
> I suppose.
>
> I'll see if util-linux wants it after it gets beat into shape.
> (or did a tool like this already exist and I missed it?)
>
> (Another mode which does a file copy, possibly from stdin
> might be good, like e2fsprogs/contrib/make-sparse.c ?  Although
> that can be hacked up with cp already).
>
> It works like this:
>
> [root@inode sparsify]# ./sparsify  -h
> Usage: sparsify [-m min hole size] [-o offset] [-l length] filename


So I have a similar tool queued up in ocfs2-tools. Named puncher.
http://oss.oracle.com/git/?p=ocfs2-tools.git;a=shortlog;h=puncher

I'll pull it out if we get something in util-linux. But maybe you can 
extract something useful from it.

Like.... maybe doing dry-run as default. It is an inplace modification
after all. Also using a large hole size as default (1MB). Over using 
hole punching will negatively affect read performance. We should make 
the sane choice for the user.

On a related note, it may make sense for ext4 to populate the cluster 
size (bigalloc) in stat.st_blksize.

2 cents...
