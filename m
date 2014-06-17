From: "Joseph D. Wagner" <joe@josephdwagner.info>
Subject: Metadata Checksums Include =?UTF-8?Q?fs=5Fuuid=3F?=
Date: Tue, 17 Jun 2014 09:38:35 -0700
Message-ID: <e54129c593d975dcd28431a2c9b29438@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from josephdwagner.info ([72.4.161.242]:45212 "EHLO
	josephdwagner.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965381AbaFQQgA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2014 12:36:00 -0400
Received: from josephdwagner.info (josephdwagner.info [72.4.161.242])
	(authenticated bits=0)
	by josephdwagner.info (8.14.4/8.14.4) with ESMTP id s5HGcZOW010242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2014 12:38:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm sorry that I'm a little late to the party on this one.  I was 
reading this article.  http://lwn.net/Articles/457304/

It appears to describe the file system UUID as part of the checksum.  Is 
that correct?

I am a little concerned, because the UUID can be changed manually using 
tune2fs.  Does changing the UUID invalidate the checksums?  Does tune2fs 
update the checksums based upon the new UUID?

Why does the file system UUID even need to be part of the checksum?

I'm concerned that someone with too little knowledge could hose their 
own file system.

If I'm way off, I'm sorry.  I'm just trying to learn.

Joseph D. Wagner
