From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
Date: Mon, 02 Nov 2015 09:22:15 -0500
Message-ID: <x49vb9kqy5k.fsf@segfault.boston.devel.redhat.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151030035533.GU19199@dastard>
	<20151030183938.GC24643@linux.intel.com>
	<20151101232948.GF10656@dastard>
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
        Matthew Wilcox <matthew.r.wilcox@intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20151101232948.GF10656@dastard> (Dave Chinner's message of "Mon,
	2 Nov 2015 10:29:48 +1100")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> Further, REQ_FLUSH/REQ_FUA are more than just "put the data on stable
> storage" commands. They are also IO barriers that affect scheduling
> of IOs in progress and in the request queues.  A REQ_FLUSH/REQ_FUA
> IO cannot be dispatched before all prior IO has been dispatched and
> drained from the request queue, and IO submitted after a queued
> REQ_FLUSH/REQ_FUA cannot be scheduled ahead of the queued
> REQ_FLUSH/REQ_FUA operation.
>
> IOWs, REQ_FUA/REQ_FLUSH not only guarantee data is on stable
> storage, they also guarantee the order of IO dispatch and
> completion when concurrent IO is in progress.

This hasn't been the case for several years, now.  It used to work that
way, and that was deemed a big performance problem.  Since file systems
already issued and waited for all I/O before sending down a barrier, we
decided to get rid of the I/O ordering pieces of barriers (and stop
calling them barriers).

See commit 28e7d184521 (block: drop barrier ordering by queue draining).

Cheers,
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
