From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Date: Thu, 5 Aug 2010 12:17:45 -0400
Message-ID: <20100805161745.GG2901@thunk.org>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <20100504154553.GA22777@infradead.org>
 <20100630124832.GA1333@thunk.org>
 <4C5818A1.9070102@redhat.com>
 <20100804233206.GA2901@thunk.org>
 <4C5A1FDC.3010700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33598 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886Ab0HEQRy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 12:17:54 -0400
Content-Disposition: inline
In-Reply-To: <4C5A1FDC.3010700@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 05, 2010 at 05:20:12AM +0300, Avi Kivity wrote:
> 
> Why not?  To be clear, I'm talking about an io_submit() with
> multiple IO_CMD_FSYNC requests, with a kernel implementation that is
> able to batch these requests.

IO_CMD_FSYNC doesn't exist right now, but sure, it means we don't have
to add a new syscall.  I find the aio interface to be horribly
complicated, and it would mean that programs would have to link
against libaio, which again isn't my favorite set of interfaces.  

All of that being said, I do agree that adding a new IO_CMD_FSYNC,
IO_CMD_FSYNCDATA, IO_CMD_FSYNC_NOBARRIER, and
IOCMD_FSYNC_DATA_NOBARRIER would be the simplist thing to do from a
kernel implementation perspective.

						- Ted
