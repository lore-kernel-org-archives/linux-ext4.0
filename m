From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Thu, 26 Jul 2007 06:32:56 -0400
Message-ID: <46A87858.40005@garzik.org>
References: <46A8628D.6070103@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <46A8628D.6070103@clusterfs.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
> Good day,
> 
> please review ...
> 
> thanks, Alex
> 
> 
> basic delayed allocation in VFS:
> 
>  * block_prepare_write() can be passed special ->get_block() which
>    doesn't allocate blocks, but reserve them and mark bh delayed
>  * a filesystem can use mpage_da_writepages() with other ->get_block()
>    which doesn't defer allocation. mpage_da_writepages() finds all
>    non-allocated blocks and try to allocate them with minimal calls
>    to ->get_block(), then submit IO using __mpage_writepage()
> 
> 
> Signed-off-by: Alex Tomas <alex@clusterfs.com>

Is this based on Christoph's work?

Christoph, or some other XFS hacker, already did generic delalloc, 
modeled on the XFS delalloc code.

	Jeff


