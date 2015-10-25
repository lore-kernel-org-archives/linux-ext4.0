From: Dave Chinner <david@fromorbit.com>
Subject: Re: Test ext4/001
Date: Mon, 26 Oct 2015 07:41:01 +1100
Message-ID: <20151025204101.GH19199@dastard>
References: <20151022091017.GC14445@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151022091017.GC14445@quack.suse.cz>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 22, 2015 at 11:10:17AM +0200, Jan Kara wrote:
> Hi,
> 
> I've checked why test ext4/001 fails for me with DAX and after some
> investigation I've realized that the test assumes that
> extent_max_zeroout_kb is 32 KB and thus unwritten extent will get converted
> to written as a whole and not split. With DAX that doesn't happen (because
> of difference between EXT4_GET_BLOCKS_ flags passed in writeback path and
> DAX write path) and so the result differs.
> 
> So I was wondering how to best fix this. Either we could switch
> extent_max_zeroout_kb to 0 to make the result same (but that has a slight
> disadvantage that we would lose testing of the zeroout logic) or we could
> increase file size so that zeroout doesn't trigger or something else?
> Anyone has some idea?

Generic tests that have this problem with ext4 turn set zeroout to
0. You could always just filter the mount options to remove DAX from
this test - filtering mount options is not uncommon in XFS specific
tests that are designed to test specific functionality that may be
incompatible with the provided mount options.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
