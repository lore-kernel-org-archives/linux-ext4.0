From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests-bld: add exclude file for ext3 tests
Date: Sun, 21 Feb 2016 11:34:11 +1100
Message-ID: <20160221003411.GZ14668@dastard>
References: <20160220155157.GA19420@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:22808 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337AbcBUAe0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Feb 2016 19:34:26 -0500
Content-Disposition: inline
In-Reply-To: <20160220155157.GA19420@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 20, 2016 at 10:51:57AM -0500, Eric Whitney wrote:
> Add an exclude file for the ext3 test case to prevent failure reports
> from tests that exercise unsupported online defrag functionality.

ext3 should not run these tests because of the _requires_defrag
check in these tests results in a _notrun command being run
when FSTYP=ext3.

> Two online defrag tests - ext4/307 and /308 - are not included because
> they contain explicit requirements for fallocate support that prevents
> them from running on an emulated ext3 file system.

Same here.

> It may be possible to modify the excluded tests at a future date so they
> will not run unless the test file system is extent mapped.  For now, this
> patch is an expedient measure to reduce testing noise.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  kvm-xfstests/test-appliance/files/root/conf/ext3.exclude | 6 ++++++
>  1 file changed, 6 insertions(+)
>  create mode 100644 kvm-xfstests/test-appliance/files/root/conf/ext3.exclude
> 
> diff --git a/kvm-xfstests/test-appliance/files/root/conf/ext3.exclude b/kvm-xfstests/test-appliance/files/root/conf/ext3.exclude
> new file mode 100644
> index 0000000..c46c79b
> --- /dev/null
> +++ b/kvm-xfstests/test-appliance/files/root/conf/ext3.exclude
> @@ -0,0 +1,6 @@
> +# ext4's ext3 emulation does not support on-line
> +# defrag, which requires extent-based files
> +ext4/301
> +ext4/302
> +ext4/303
> +ext4/304

So what we really need to understand is why _require_defrag is not
preventing these tests beign run on an ext3 filesystem?

Eric, what is the output of these tests when it is run on an ext3
filesytsem? What is the fstyp you are testing?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
