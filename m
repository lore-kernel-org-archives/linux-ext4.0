From: Ming Lei <Ming.Lei@riverbed.com>
Subject: ext4 corruption on 17TB file system during power cycle test
Date: Wed, 13 Jun 2012 13:49:29 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA392828AAC@SFO1EXC-MBXP06.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.riverbed.com ([208.70.196.44]:32206 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2FMNtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 09:49:31 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I  have raid0 on 12 Seagate new 3TB sas drives and kernel version is 2.6.32SL6.1 version. The ext4 is mounted with barrier on, delalloc on/off has almost the same result.

I ran fs_mark -F -t 10 -D 1000 -N 1000 -n 1000000 -s 40 -S 2 into 4 iterations(reported count of 40000000) and then power cycled the box. After the box came up, I ran fsck -f to check inconsistency. On ext4 FS 7.5TB and 16TB, I got no fsck error; but on 17TB, 21TB and 33TB, I got big chunk of fsck errors.

My question is: is this known issue and any fix?
Thanks
M-
