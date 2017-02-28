From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 new shutdown ioctl fails generic/04{4,5,6}
Date: Tue, 28 Feb 2017 00:13:37 -0500
Message-ID: <20170228051337.lxmiiz7jzhojmagz@thunk.org>
References: <20170228032556.dc5d26cldwku4puw@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fstests@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170228032556.dc5d26cldwku4puw@XZHOUW.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 28, 2017 at 11:25:56AM +0800, Xiong Zhou wrote:
> 
> On latest Linus tree, xfstests generic/04{4,5,6} fails.

Yes, that's known issue.  generic/04[456] were originally XFS specific
tests, and they have have assumptions about the implementation of the
underlying file system.

We have a few of those at the moment in kvm-xfstests/gce-xfstests's
exclude file:

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/test-appliance/files/root/fs/ext4/exclude

# generic/042 and generic/392 are failing because ext4 forces the
# resolution of all delayed allocation writes before allowing the
# punch operation to proceed.  We probably want to see if we can avoid
# this for the future, but what ext4 is doing is legal, so just skip
# the test for now
generic/042
generic/392

# generic/04[456] tests how truncate and delayed allocation works
# ext4 uses the data=ordered to avoid exposing stale data, and
# so it uses a different mechanism than xfs.  So these tests will fail
generic/044
generic/045
generic/046

# generic/223 tests file alignment, which works on ext4 only by
# accident because we're not RAID stripe aware yet, and works at all
# because we have bias towards aligning on power-of-two block numbers.
# It is a flaky test for some configurations, so skip it.
generic/223

# ext4/304 fails for all configurations, and this appears to be at
# test or fio bug.
#
ext4/304

Cheers,

						- Ted
