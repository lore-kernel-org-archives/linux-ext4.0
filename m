From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize2fs: radically reduce memory utilization by using
 rbtree bitmaps
Date: Fri, 25 Jul 2014 13:11:42 -0500
Message-ID: <53D29DDE.805@redhat.com>
References: <1406310671-10784-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbaGYSLq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 14:11:46 -0400
In-Reply-To: <1406310671-10784-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/25/14, 12:51 PM, Theodore Ts'o wrote:
> When resizing an empty 21T file system to 28T, resize2fs was using
> this much CPU time and memory:
> 
> 216.98user 19.77system 4:02.92elapsed 97%CPU (0avgtext+0avgdata 4485664maxresident)k
> 8inputs+1068680outputs (0major+800745minor)pagefaults 0swaps
> 
> After this one-line change:
> 
> 222.29user 0.49system 3:48.79elapsed 97%CPU (0avgtext+0avgdata 30080maxresident)k
> 8inputs+1068552outputs (0major+2497minor)pagefaults 0swaps
> 
> An extra 14 seconds (+6%) of elapsed time to reduce the memory
> utilization from 4.2GB to 29MB seems like a fair trade.  :-)

especially when it actually looks like 14 *fewer* seconds (-6%) ?

-Eric

