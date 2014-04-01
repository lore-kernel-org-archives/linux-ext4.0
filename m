From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs: ext4: Sign-extend tv_sec after ORing in epoch bits
Date: Mon, 31 Mar 2014 22:56:10 -0400
Message-ID: <20140401025610.GG4911@thunk.org>
References: <1396191514-19081-1-git-send-email-cse.cem@gmail.com>
 <38140D27-E451-4BF1-9445-D319652E1BCF@dilger.ca>
 <CAG6CVpX57PFG7wUofHW4BPR_FY-ewv8+7P5baXgF9jd-gMOwmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Conrad Meyer <cemeyer@uw.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Conrad Meyer <cse.cem@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG6CVpX57PFG7wUofHW4BPR_FY-ewv8+7P5baXgF9jd-gMOwmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 31, 2014 at 08:42:06AM -0700, Conrad Meyer wrote:
> The problem exists in mainline (v3.14) and linux-next (20140328), so
> it looks like it didn't land. Unless it's queued in an ext4 tree and
> didn't get selected for Linus for some reason?

There were some proposals for a different encoding that would be
better, that would have required some e2fsprogs changes.  Since this
is a long range problem (that doesn't hit until 2038) it's not been
high priority to deal with, but I haven't forgotten it.  I've just had
higher priority items on my todo list.

The huge long thread can be found here:

    http://thread.gmane.org/gmane.comp.file-systems.ext4/40978

What this is blocked on is I wanted to have some better ways of
setting times using the old and the proposed new encoding convention,
so we could have proper regression tests for the changes in e2fsck.
That way we can make sure the right thing really happens with 32-bit
kernels, 64-bit kernels, 32-bit e2fsprogs, 64-bit e2fsprogs, etc.,
with file systems using both the old and the newer encoding.

(Yes, I'm paranoid that way.  Regression tests are _important_.)

      	  	   	      		       	   - Ted
