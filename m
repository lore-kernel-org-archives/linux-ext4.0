From: Andreas Dilger <adilger@sun.com>
Subject: Re: Problems with the max value for create directory
Date: Tue, 23 Dec 2008 00:49:44 -0700
Message-ID: <20081223074944.GH5000@webber.adilger.int>
References: <495054DE.9030405@cn.fujitsu.com> <495062D1.6010805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54106 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYLWHtt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2008 02:49:49 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mBN7nkaS010141
	for <linux-ext4@vger.kernel.org>; Mon, 22 Dec 2008 23:49:46 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KCB00101K752F00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 22 Dec 2008 23:49:46 -0800 (PST)
In-reply-to: <495062D1.6010805@jp.fujitsu.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 23, 2008  13:02 +0900, Toshiyuki Okajima wrote:
> Zhang Xiliang wrote:
>> Hi,
>>
>> I creat 65537 long directories and failed when the block size is 1024.
>>
>> # mkfs.ext4dev -b 1024 -I 256 /dev/hda3
>> # tune2fs -E test_fs -O extents /dev/hda3
>> # mount -t ext4dev /dev/hda3 /mnt
>> # ./create_long_dirs 65537 /mnt
>>
>> The code of create_long_dirs.c:
>
> ext4 filesystem cannot make over 65000 links toward a file.
> (ext3 filesystem cannot make over 32000 links toward a file.)
> This test makes over 65000 links toward /mnt-directory.
> (Creating 65000 sub-directories makes 65000 links toward /mnt-directory.)

Note that there is a specific reason why it was implemented this way:
- a directory with > 65000 subdirectories can be checked if empty even
  if the link count is wrong (in fact link count was ignored even in ext3)
- a file needs to keep accurate link counts or it is impossible to know
  when the file needs to be deleted.

We thought about adding a "i_links_count_hi" but it wasn't thought that
many (any) real applications would create so many hard links on the same
file.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

