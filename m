From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Fri, 27 Jul 2007 08:33:56 -0400
Message-ID: <46A9E634.1090409@garzik.org>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com> <46A9A41C.7080104@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Chinner <dgc@sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57065 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306AbXG0MeP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jul 2007 08:34:15 -0400
In-Reply-To: <46A9A41C.7080104@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
>> So without the ability to attach specific I/O completions to bios
>> or support for unwritten extents directly in __mpage_writepage,
>> there is no way XFS can use this "generic" delayed allocation code.
> 
> I didn't say "generic", see Subject: :)

Well, it shouldn't even be in the VFS layer if it's only usable by one 
filesystem.

	Jeff
