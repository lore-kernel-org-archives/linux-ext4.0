From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
Date: Thu, 5 Nov 2015 13:54:19 -0700
Message-ID: <563BC1FB.60004@kernel.dk>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
 <20151030035533.GU19199@dastard> <20151030183938.GC24643@linux.intel.com>
 <20151101232948.GF10656@dastard>
 <x49vb9kqy5k.fsf@segfault.boston.devel.redhat.com>
 <20151102201029.GI10656@dastard>
 <x49twp4p11j.fsf@segfault.boston.devel.redhat.com>
 <20151105083309.GJ19199@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 "J. Bruce Fields" <bfields@fieldses.org>, Theodore Ts'o <tytso@mit.edu>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>,
 Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>,
 Matthew Wilcox <willy@linux.intel.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@ml01.01.org,
 x86@kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <matthew.r.wilcox@intel.com>
To: Dave Chinner <david@fromorbit.com>, Jeff Moyer <jmoyer@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151105083309.GJ19199@dastard>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On 11/05/2015 01:33 AM, Dave Chinner wrote:
>> Des xfs rely on this model for correctness?  If so, I'd say we've got a
>> problem
>
> No, it doesn't. The XFS integrity model doesn't trust the IO layers
> to tell the truth about IO ordering and completion or for it's
> developers to fully understand how IO layer ordering works. :P

That's good, because the storage developers simplified the model so that 
fs developers would be able to get and use it.

> i.e. we wait for full completions of all dependent IO before issuing
> flushes or log writes that use REQ_FLUSH|REQ_FUA semantics to ensure
> the dependent IOs are fully caught by the cache flushes...

... which is what you are supposed to do, that's how it works.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
