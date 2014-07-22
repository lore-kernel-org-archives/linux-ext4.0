From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfstests: add data integtiry test for e4defrag
 ext4/307
Date: Wed, 23 Jul 2014 07:05:33 +1000
Message-ID: <20140722210533.GK20518@dastard>
References: <1406061455-731-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32801 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbaGVVFp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 17:05:45 -0400
Content-Disposition: inline
In-Reply-To: <1406061455-731-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 23, 2014 at 12:37:34AM +0400, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Needs a proper commit message.

Also, what makes this ext4 specific? Why can't it run on any
filesystem with a defrag operation?

> +_need_to_be_root
> +_require_scratch
> +_require_defrag
> +
> +rm -f $seqres.full
> +
> +_workout()
> +{
> +    	nr=$1
> +	echo "Defragment file with $nr * 2 fragments"
> +	# Create sparse file
> +    	for ((i=0;i<nr;i++))
> +	do
> +	    fallocate -l 4k -o $((409600*i)) $SCRATCH_MNT/test.$nr
> +	done

please use $XFS_IO_PROG -c "falloc" ... for these operations to minimise
the number of external dependencies...


> +	# Fill holes for half of range , as result file will contain nr*1.5 fragments
> +	fallocate -l $((204800*nr)) $SCRATCH_MNT/test.$nr
> +	# Data wrilte will convert extetns to inialized ones
> +    	for ((i=0;i<nr;i++))

whitespace

> +	do
> +	    dd if=/dev/urandom bs=1234 seek=$((100*i)) of=$SCRATCH_MNT/test.$nr \
> +		conv=notrunc count=3 >> $seqres.full 2>&1
> +	done

again, $XFS_IO_PROG -c "pwrite .." rather than dd. And use a fixed
pattern, so that the hash of the file is predictable.


> +	filefrag -v $SCRATCH_MNT/test.$nr >> $seqres.full

$XFS_IO_PROG -c "fiemap" ....

> +	sha1sum $SCRATCH_MNT/test.$nr > $SCRATCH_MNT/test.$nr.sha1sum

md5sum is sufficient and faster for this sort of testing, and used
everywhere else in xfstests for this purpose. And with predictable
file contents, the output can be dumped into the output file like:

	md5sum $SCRATCH_MNT/test.$nr | _filter_scratch

And so we get file contents integrity checking from both the initial
write and the defrag command...

> +	$DEFRAG_PROG $SCRATCH_MNT $SCRATCH_DEV >> $seqres.full 2>&1
> +	filefrag -v $SCRATCH_MNT/test.$nr >> $seqres.full
> +	run_check sha1sum -c $SCRATCH_MNT/test.$nr.sha1sum

And this run_check can go away - just dump the md5sum again.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
