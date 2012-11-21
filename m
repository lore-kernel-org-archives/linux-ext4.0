From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/9] vfs: Handle O_SYNC AIO DIO in generic code properly
Date: Wed, 21 Nov 2012 13:38:55 -0500
Message-ID: <x49y5huu7gg.fsf@segfault.boston.devel.redhat.com>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074123.24645.41965.stgit@blackbox.djwong.org>
	<20121121100809.GE23339@infradead.org>
	<x497gpevqoy.fsf@segfault.boston.devel.redhat.com>
	<20121121182901.GA4519@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
	tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
	viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121121182901.GA4519@infradead.org> (Christoph Hellwig's
	message of "Wed, 21 Nov 2012 13:29:01 -0500")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Nov 21, 2012 at 11:58:05AM -0500, Jeff Moyer wrote:
>> > I'd like to use this as a vehicle to revisit how dio completions work.
>> 
>> I don't like the sound of that.  ;-)  It sounds like this bugfix may get
>> further delayed by the desire for unrelated code cleanup.
>
> I've got a prototype that isn't much more invasive than the current
> series.  I'll finish it up and run it through QA and will post it
> tomorrow.

Works for me.  Thanks!

-Jeff
