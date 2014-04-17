From: Robert Yang <liezhi.yang@windriver.com>
Subject: e2fsprogs: mke2fs -d: copy the Extended Attributes
Date: Thu, 17 Apr 2014 15:14:34 +0800
Message-ID: <534F7F5A.3070805@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:62104 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaDQHQf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 03:16:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted,

The "mke2fs -d" doesn't copy the file's extended attributes into the
device currently, I'd like to make it work and submit a patch for it
if it is acceptable by e2fsprogs. Maybe we can add a "[-x xattr]"
option for "mke2fs -d" to make it copy the extended attributes.

What's your opinion, please ?

-- 
Thanks

Robert
