From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/064 test failures on ext4 (4.2-rc*)
Date: Tue, 28 Jul 2015 07:51:29 +1000
Message-ID: <20150727215129.GH3902@dastard>
References: <20150727190957.GA1606@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: namjae.jeon@samsung.com, a.sangwan@samsung.com,
	linux-ext4@vger.kernel.org, fstests@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150727190957.GA1606@localhost.localdomain>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[cc fstests@vger.kernel.org. Please cc this list for questions
about fstests behaviour, especially for generic tests that all
filesystem run. ]

On Mon, Jul 27, 2015 at 03:10:03PM -0400, Eric Whitney wrote:
> Hi Namjae:
> 
> I'm seeing generic/064 fail consistently when testing ext4 on 4.2-rc kernels
> with Ted's kvm-xfstests test appliance.
> 
> The two kvm-xfstests test cases that fail are ext3conv and data_journal. Both
> of them force disablement of delayed allocation.  The nodelalloc mount option
> is used explicitly in the ext3conv case, and it's set implicitly in the kernel
> when the data_journal mount option is used.  The size of the scratch device
> used also matters.  The failure occurs when the device is 5 GB in size, but
> does not when 20 GB in size.
> 
> What's happening is that when nodelalloc is set, ext4 produces a testfile.dest
> containing 101 extents when generic/064 inserts 100 block ranges, and this does
> not match the test's expected output of 100 extents.
> 
> Ted Ts'o says that ext4 does not guarantee a specific extent layout when
> delayed allocation is disabled in these circumstances.
> 
> The header comment for generic/064 states that insert range is to be called
> until 100 extents are created.  Would the intent of your test be preserved if
> it was modified to verify that 100 holes were inserted rather than 100
> extents created?

The block layout outside the insert range should not be modified at
all, so if inserting 100 holes results in more data extents that the
expected 100, then there's something wrong before we start inserting
holes.  e.g. maybe the source file had two extents rather than 1.
Can you confirm that this is occurring?

> This would seem to be a more direct way to verify that
> insert range was functioning correctly without assuming anything about other
> test filesystem behavior.  ext4 does create 100 holes for generic/064 with
> nodelalloc set.

Really, the number of extents or holes at the intermediate stage
doesn't matter. What matters is that after collapsing the holes back
out of the file, then number of extents is identical to the original
file (i.e. that fcollapse() undoes finsert() exactly).

So changing this code to use _within_tolerance to say that 100 >=
num_extents >= 105 is ok would probably be better:

	_within_tolerance "Extent count" $nextents 100 0 5%

This will output a standard pass/fail message rather than an exact
count.  This allows some wiggle room for filesystem configurations
that have unexpected non-contiguous baseline allocation behaviour to
pass the test.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
