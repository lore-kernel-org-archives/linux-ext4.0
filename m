From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
Date: Thu, 05 Nov 2015 14:49:21 -0500
Message-ID: <x498u6crzum.fsf@segfault.boston.devel.redhat.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151030035533.GU19199@dastard>
	<20151030183938.GC24643@linux.intel.com>
	<20151101232948.GF10656@dastard>
	<x49vb9kqy5k.fsf@segfault.boston.devel.redhat.com>
	<20151102201029.GI10656@dastard>
	<x49twp4p11j.fsf@segfault.boston.devel.redhat.com>
	<20151105083309.GJ19199@dastard>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.com>,
        Jeff Layton <jlayton@poochiereds.net>,
        Matthew Wilcox <willy@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-nvdimm@ml01.01.org, x86@kernel.org, xfs@oss.sgi.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>, axboe@kernel.dk
To: Dave Chinner <david@fromorbit.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151105083309.GJ19199@dastard> (Dave Chinner's message of "Thu,
	5 Nov 2015 19:33:09 +1100")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> But this part is not.  It is up to the I/O scheduler to decide when to
>> dispatch requests.  It can hold on to them for a variety of reasons.
>> Flush requests, however, do not go through the I/O scheduler.  At the
>
> That's pure REQ_FLUSH bios, right? Aren't data IOs with
> REQ_FLUSH|REQ_FUA sorted like any other IO?

No, they also go through the flush machinery, and so short-circuit the
I/O scheduler.

>> Des xfs rely on this model for correctness?  If so, I'd say we've got a
>> problem
>
> No, it doesn't. The XFS integrity model doesn't trust the IO layers
> to tell the truth about IO ordering and completion or for it's
> developers to fully understand how IO layer ordering works. :P
>
> i.e. we wait for full completions of all dependent IO before issuing
> flushes or log writes that use REQ_FLUSH|REQ_FUA semantics to ensure
> the dependent IOs are fully caught by the cache flushes...

OK, phew!  ;-)

-Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
