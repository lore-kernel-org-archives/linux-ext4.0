From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: birth time of a file
Date: Thu, 25 Sep 2014 02:40:56 -0700 (PDT)
Message-ID: <alpine.DEB.2.19.4.1409250223520.9897@trent.utfs.org>
References: <alpine.DEB.2.19.4.1409242257430.9897@trent.utfs.org> <3C36B392-FF09-46D1-B7DA-ADF893A56C42@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:41965 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaIYJlI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Sep 2014 05:41:08 -0400
In-Reply-To: <3C36B392-FF09-46D1-B7DA-ADF893A56C42@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 25 Sep 2014 at 09:08, Andreas Dilger wrote:
> It looks like your filesystem is formatted with 128-byte inodes
> (i.e. ext3) instead of 256-byte inodes (i.e. ext4). The i_crtime is stored
> in this extended space of the inode.  You could verify this with

Bingo! Thanks, that was the problem. I used a small (less than 512MB) test 
filesystem and inode size was indeed 128 byte. When I ran mkfs.ext4 on a 
512 MB (and larger) device, 256 byte inodes were created and then crtime 
was indeed visible with debugfs. Or I could have used -I to force larger 
inodes.

Thanks for the hint!
Christian. 

>    dumpe2fs -h /dev/loop0
> 
> and look for the "Inode size" field. 
> 
> This is a format time option. What is strange is that you have specified mkfs.ext4, so
> this should be selected automatically. It may be that with very small 
> devices (e.g. floppy size) it defaults to 128-byte inodes. 

-- 
BOFH excuse #124:

user to computer ration too low.
