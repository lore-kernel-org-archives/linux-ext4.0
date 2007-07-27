From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Fri, 27 Jul 2007 16:42:57 +0400
Message-ID: <46A9E851.2000705@clusterfs.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com> <46A9A41C.7080104@clusterfs.com> <46A9E634.1090409@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Chinner <dgc@sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:62474 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbXG0MnU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jul 2007 08:43:20 -0400
In-Reply-To: <46A9E634.1090409@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jeff Garzik wrote:
> Alex Tomas wrote:
>>> So without the ability to attach specific I/O completions to bios
>>> or support for unwritten extents directly in __mpage_writepage,
>>> there is no way XFS can use this "generic" delayed allocation code.
>>
>> I didn't say "generic", see Subject: :)
> 
> Well, it shouldn't even be in the VFS layer if it's only usable by one 
> filesystem.

sorry, but it seems I can say the same about iomap/ioend. I think
mpage_da_writepages() is simple enough to be adopted by other
filesystem, ext2 for example.

thanks, Alex
