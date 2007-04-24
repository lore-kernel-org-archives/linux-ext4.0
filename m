From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (April 23, 2007)
Date: Tue, 24 Apr 2007 10:00:09 +0400
Message-ID: <462D9CE9.1040402@clusterfs.com>
References: <462D42CA.50509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:51061 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161659AbXDXG2L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2007 02:28:11 -0400
In-Reply-To: <462D42CA.50509@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Avantika Mathur wrote:
> TESTING
> - extents testing
>    - Discussed methods for testing extents on highly fragmented 
> filesystems.
>    - Jose will look into possible tests, including perhaps using the 
> 'aged' option in FFSB
>    - Ted suggested creating a mountoption that creates a bad block 
> allocator which it jumps to a new block group every 8 blocks.  This 
> would force a very large number of extents, and may be a good test for 
> extents.

there is AGGRESSIVE_TEST define which limits number of entries in index/leaf.

> - Large file deletion
>    - Valerie had recently tested large file deletion on ext3/4, but did 
> not see the expected performance gain with ext4 due to compact metadata 
> when using extents.

any details?

thanks, Alex
