From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sat, 04 Feb 2012 14:17:30 -0600
Message-ID: <4F2D925A.1070702@redhat.com>
References: <4F2D8F30.3090802@redhat.com> <4F2D90B6.4070008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2BDURd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Feb 2012 15:17:33 -0500
In-Reply-To: <4F2D90B6.4070008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/4/12 2:10 PM, Eric Sandeen wrote:

> Hm but something is weird, right after the punch-out xfs says
> it uses 84K:
> 
> [root@inode sparsify]# du -hc fsfile
> 84K	fsfile
> 84K	total
> 
> but then after an xfs_repair it looks saner:
> # du -hc fsfile
> 4.8M	fsfile
> 4.8M	total
> 
> something to look into I guess... weird.

nvm that's just xfs_repair zeroing the log & reinstating the blocks.
Sorry for the noise - Ok, back to my Saturday.

-Eric

