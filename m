From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Date: Thu, 5 Aug 2010 16:39:28 -0400
Message-ID: <20100805203928.GM2901@thunk.org>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <20100504154553.GA22777@infradead.org>
 <20100630124832.GA1333@thunk.org>
 <4C5818A1.9070102@redhat.com>
 <20100804233206.GA2901@thunk.org>
 <4C5A1FDC.3010700@redhat.com>
 <20100805161745.GG2901@thunk.org>
 <x49pqxwc1p3.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49pqxwc1p3.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 05, 2010 at 03:13:44PM -0400, Jeff Moyer wrote:
> > IO_CMD_FSYNC doesn't exist right now, but sure, it means we don't have
> 
> Well, there's IOCB_CMD_FSYNC.  But still, this isn't the same thing as
> what's requested.  If I understand correctly, what is requested is a
> mechanism to flush out all data for multiple file descriptors and follow
> that with a single barrier/flush (and yes, Ted did give a summary of the
> commands that would be required to accomplish that).
> 
> There still remains the question of why this should be tied to the AIO
> submission interface.

I don't think it should, personally.  The only excuse might be if
someone wanted to do an asynchronous fsync(), but I don't think that
makes sense in most cases.

					- Ted
