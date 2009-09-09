From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filessystem corruptions while using rsnapshot
Date: Wed, 09 Sep 2009 09:40:41 -0500
Message-ID: <4AA7BE69.7070406@redhat.com>
References: <20090909133026.GA1965@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZIIOlL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 10:41:11 -0400
In-Reply-To: <20090909133026.GA1965@phenom2.trippelsdorf.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Markus Trippelsdorf wrote:
> I'm using rsnapshot (http://rsnapshot.org/) to automatically backup my
> root filesystem (btrfs) to a second harddrive running ext4. Rsnapshot
> uses rsync and a massive amount of hard links to keep multiple backups
> instantly available. 
> It seems that the sheer number of hard links overwhelms ext4 and results
> in problems that require manual fsck.ext4 runs to bring the fs back to
> normal.
> 
> For example this is output from fsck.ext4:
> 
> Problem in HTREE directory inode <some number> 
> ... node <increasing number> has invalid depth (2)
> ... node <increasing number> has bad mxhash
> ... node <increasing number> not referenced
> 
> This output is repeated ad nauseam while <increasing number> increases
> at each round.
> 
> The bug is very simple to reproduce here. Just run rsnapshot several
> times per day and you will eventually hit the problem.

Could you provide a bzip2'd e2image -r of a corrupted filesystem for 
analysis?

Thanks,
-Eric
