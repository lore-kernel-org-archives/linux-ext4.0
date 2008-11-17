From: Kelly Kane <kelly@hq.newdream.net>
Subject: Re: Call traces on console from a test machine
Date: Mon, 17 Nov 2008 10:58:42 -0800
Message-ID: <4921BEE2.1090700@hq.newdream.net>
References: <491CC6E3.7070808@hq.newdream.net> <491CDF90.8070802@hq.newdream.net> <20081114170930.GI25117@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.hq.newdream.net ([66.33.206.127]:54858 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbYKQS6n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 13:58:43 -0500
In-Reply-To: <20081114170930.GI25117@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> e2image -r /dev/sdXX -  | bzip2 > /tmp/sdXX.e2i.bz2
> 
> ... and send it to me?

http://ext4dev.dreamhosters.com/sdb1.e2i.bz2

The above is the e2image requested, though it has been fsck'd a handful of 
times as detailed in the other post. The main change is I got fsck.ext4 to 
correct the block group checksum error. The pass 2 errors still make fsck 
exit early claiming to be aborted.

Kelly
