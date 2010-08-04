From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Date: Wed, 4 Aug 2010 19:32:06 -0400
Message-ID: <20100804233206.GA2901@thunk.org>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <20100504154553.GA22777@infradead.org>
 <20100630124832.GA1333@thunk.org>
 <4C5818A1.9070102@redhat.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C5818A1.9070102@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 03, 2010 at 04:24:49PM +0300, Avi Kivity wrote:
>  On 06/30/2010 03:48 PM, tytso@mit.edu wrote:
> >
> >I wonder if it's worthwhile to think about a new system call which
> >allows users to provide an array of fd's which are collectively should
> >be fsync'ed out at the same time.  Otherwise, we end up issuing
> >multiple barrier operations in cases where the application needs to
> >do:
> >
> >	fsync(control_fd);
> >	fsync(data_fd);
> >
> 
> The system call exists, it's called io_submit().

Um, not the same thing at all.

						- Ted
