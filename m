From: Andreas Schlick <schlick@lavabit.com>
Subject: [PATCH 0/2] Fix wrong name_len and file_type in intermediate htree nodes
Date: Sun, 30 Aug 2009 16:56:40 +0200
Message-ID: <200908301656.40866.schlick@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:57036 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZH3PNC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Aug 2009 11:13:02 -0400
Received: from e.earth.lavabit.com (e.earth.lavabit.com [192.168.111.14])
	by karen.lavabit.com (Postfix) with ESMTP id 5C3F911B8AF
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2009 10:13:04 -0500 (CDT)
Received: from 78.52.134.207 (78.52.134.207)
	by lavabit.com with ESMTP id BJGQUN0NUV50
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2009 10:13:04 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

while testing the dirshrink patch, I found that sometimes intermediate htree 
nodes end up with their fake_dirent's name_len and file_type not being zero. 
e2fsck will then consider the htree to be corrupted as it doesn't recognise 
that these blocks contain dx_nodes. 

As far as I understand it, this happens sometimes when ext4_dx_add_entry() has 
to create a new index node and calls ext4_append(). In the end ext4_getblk() 
is called and it might get a buffer that has BH_Uptodate set, causing 
ext4_getblk() to not zero it out and leave the old content intact. 

I can reproduce this with plain linux-2.6.30.5. To produce this I use a nearly 
full filesystem and continuously create new files in one directory while 
removing other directories/files at the same time. 

Do I understand it correctly, that it happens when the newly allocated block 
(for the new index node) was very recently used by another file/directory, so 
that it is still in the buffer cache? But it surprises me that it doesn't 
happen more often.

Andreas Schlick

