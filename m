From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH 2/3] ext4 directory index: read-ahead blocks v2
Date: Tue, 19 Jul 2011 16:22:13 +0200
Message-ID: <4E259315.6070004@itwm.fraunhofer.de>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain> <20110620202854.2473133.32514.stgit@localhost.localdomain> <20110716235950.GC2717@thunk.org> <4E22348E.5060707@fastmail.fm> <31F2FDF7-1CED-4831-87E1-861752A6899A@mit.edu> <20110718002314.GD2717@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	linux-ext4@vger.kernel.org, adilger@whamcloud.com, colyli@gmail.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:36545 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1GSOWh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 10:22:37 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p6JEMOpb018492
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jul 2011 16:22:27 +0200
In-Reply-To: <20110718002314.GD2717@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

sorry for my late reply and thanks a lot for your help!

On 07/18/2011 02:23 AM, Ted Ts'o wrote:
>> On Jul 16, 2011, at 9:02 PM, Bernd Schubert wrote:
>>
>>> I don't understand it either yet why we have so many, but each directory
>>> has about 20 to 30 index blocks
>
> OK, I think I know what's goign on.  Those are 20-30 index blocks;
> those are 20-30 leaf blocks.  Your directories are approximately
> 80-120k, each, right?

Yes, you are right. For example:

drwxr-xr-x 2 root root 102400 Jul 18 13:39 FFB


I also uploaded the debugfs htree output to
> http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/ext4/htree_dump.bz2

>
> So what your patch is doing is constantly doing readahead to bring the
> *entire* directory into the buffer cache any time you do a dx_probe.
> That's definitely not what we would want to enable by default, but I
> really don't like the idea of adding Yet Another Mount option.  It
> expands our testing effort, and the reality is very few people will
> take advantage of the mount option.
>
> How about this?  What if we don't actually perform readahead, but
> instead try to look up all of the blocks to see if they are in the
> buffer cache using sb_find_get_block().  If it is in the the buffer

In principle that should be mostly fine. We could read all directories 
on starting up our application and those pages would be kept in cache 
then. While our main concern right now is the meta data server, where 
that patch would help and where we will also change the on-disk-layout 
to entirely workaround that issue, the issue also effects storage 
servers. On those we are not sure, if the patch would help, as real data 
pages might drop those directory pages out of the cache.
Also interesting is that the hole issue might easily explain meta data 
issues I experienced in the past with Lustre and systems with lots of 
files per OST - Lustre and FhGFS have a rather similar on-disk layout 
for data files and so should suffer from similar underlying storage 
issues. We are already discussing here for some time if we could change 
that layout for FhGFS, but that would bring up other even more critical 
problems...

> cache, it will get touched, so it will be less likely to be evicted
> from the page cache.  So for a workload like yours, it should do what
> you want.  But if won't cause all of the pages to get pulled in after
> the first reference of the directory in question.

I think we would still need to map the ext4 block to the real block for 
sb_find_get_block(). So what about to keep most of the existing patch, 
but update ext4_bread_ra() to:

+/*
+ * Read-ahead blocks
+ */
+int ext4_bread_ra(struct inode *inode, ext4_lblk_t block)
+{
+       struct buffer_head *bh;
+       int err;
+
+       bh = ext4_getblk(NULL, inode, block, 0, &err);
+       if (!bh)
+               return -1;
+
+       if (buffer_uptodate(bh))
+		touch_buffer(bh); /* patch update here */
+
+       brelse(bh);
+       return 0;
+}
+


>
> I'm still worried about the case of a very large directory (say an
> unreaped tmp directory that has grown to be tens of megabytes).  If a
> program does a sequential scan through the directory doing a
> "readdir+stat" (i.e., for example a tmp cleaner or someone running the
> command ls -sF"), we probably shouldn't be trying to keep all of those
> directory blocks in memory.  So if a sequential scan is detected, that
> should probably suppress the calls to sb_find_get_block(0.

Do you have a suggestion how to detect that? Set a flag in the dir inode 
on during a readdir and if that flag is set we won't do the 
touch_buffer(bh)? So add flags in struct file i_private and struct inode 
private about the readdir and remove those on close of the file?
Better would be if there would exist a readdirplus syscall, which ls 
would use and which would set its intent itself... But even if we would 
add that, it would take ages until all user space programs would use it.



Thanks,
Bernd
