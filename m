From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: defragmentation of boot related files
Date: Thu, 26 Aug 2010 18:47:52 -0600
Message-ID: <2076374F-7C3C-4A4A-831C-3BD698A90E69@dilger.ca>
References: <4C7505C3.1070509@rid-net.de> <4C762AF3.8020303@sx.jp.nec.com> <AANLkTi=zdx6QjsB+EJrOtmpr9BY-j24TGTJaeisAcqu7@mail.gmail.com> <4C76CB9C.2060207@rid-net.de>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Greg Freemyer <greg.freemyer@gmail.com>, k-mio@sx.jp.nec.com,
	linux-ext4@vger.kernel.org
To: andreas@rid-net.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55611 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0H0Ary convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 20:47:54 -0400
In-Reply-To: <4C76CB9C.2060207@rid-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-26, at 14:16, andreas@rid-net.de wrote:
>>> Usage: e4defrag -r directory...| device...
>>>       e4defrag -r base_file move_file...<--- new
>>> 
> 
> The new interface looks nice. As I see it's easy to implement cause only the main-function must be modified. If you have no objections, I will do it myself and send you the patch to review it.
> 
>> I suspect the original idea would work better because it is more
>> likely to pack the libs / files into perfectly contiguous block
>> ranges.
> 
> I don't know if it makes a difference for the block allocator. Even though you know the size of all files to be moved.
> 
> For a better result, may it be possible to create a base_file whose inode is part of an empty block group?

There is a /proc/fs/ext4/*/inode_goal that will cause new inodes allocated in the filesystem to be after the specified goal inode.

I suppose it would also be possible to have e4defrag simply take an inode number in the form "<inode_number>" in place of "base_file", as debugfs does.

Cheers, Andreas





