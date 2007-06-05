From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH ext3/ext4] orphan list check on destroy_inode
Date: Mon, 04 Jun 2007 22:04:38 -0500
Message-ID: <4664D2C6.4040804@redhat.com>
References: <4663A0BF.9010008@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
	linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
	adilger@clusterfs.com
To: Vasily Averin <vvs@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbXFEDFa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jun 2007 23:05:30 -0400
In-Reply-To: <4663A0BF.9010008@sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Vasily Averin wrote:
> Customers claims to ext3-related errors, investigation showed that ext3 orphan list has been corrupted and have the reference to non-ext3 inode. The following debug helps to understand the reasons of this issue.

Vasily, does your customer have this patch in place?

http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg00889.html

If not, perhaps it could be leading to the same error, because the inode 
will not be properly removed from the orphan inode list when it is 
freed, and could then be recycled...

-Eric
