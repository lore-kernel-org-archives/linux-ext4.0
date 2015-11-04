From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
Date: Wed, 04 Nov 2015 13:34:58 -0500
Message-ID: <x49a8qtpq99.fsf@segfault.boston.devel.redhat.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151030035533.GU19199@dastard>
	<20151030183938.GC24643@linux.intel.com>
	<20151101232948.GF10656@dastard>
	<x49vb9kqy5k.fsf@segfault.boston.devel.redhat.com>
	<20151102201029.GI10656@dastard>
	<x49twp4p11j.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-nvdimm@ml01.01.org, "J. Bruce Fields" <bfields@fieldses.org>,
        linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeff Layton <jlayton@poochiereds.net>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <x49twp4p11j.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Mon, 02 Nov 2015 16:02:48 -0500")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

>> Hence once the filesystem has waited on the REQ_WRITE|REQ_FLUSH IO
>> to complete, we know that all the earlier REQ_WRITE IOs are on
>> stable storage, too. Hence there's no need for the elevator to drain
>> the queue to guarantee completion ordering - the dispatch ordering
>> and flush/fua write semantics guarantee that when the flush/fua
>> completes, all the IOs dispatch prior to that flush/fua write are
>> also on stable storage...
>
> Des xfs rely on this model for correctness?  If so, I'd say we've got a
> problem.

Dave?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
