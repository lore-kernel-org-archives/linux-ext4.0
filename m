From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] add defragmentation stress test for ext4
Date: Thu, 27 Sep 2012 11:15:22 +1000
Message-ID: <20120927011522.GH15236@dastard>
References: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
 <1348496601-32637-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@lst.de, xfs@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1348496601-32637-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 24, 2012 at 06:23:21PM +0400, Dmitry Monakhov wrote:
> Perform various regression tests for ext4defrag  subsystem
> 
>  Test1: Defragment file while other task does direct AIO
>  Test2: Perform defragmentation on file under buffered AIO
>  	while third task does direct AIO to donor file
>  Test3: Two defrag tasks use common donor file.
>  Test4: Stress defragmentation. Several threads pefrorm
>  	fragmentation at random position use inplace=1 will
> 	allocate and free blocks inside defrag event improve
> 	load pressure.

Please do these as 4 separate tests so that it is easy to
isolate/reproduce failures caused by a specific test that is being
run.

Same comments as previous two patches, as well.

> +_workout()
> +{
> +	echo ""
> +	echo " Start defragment activity "
> +	echo ""
> +	cat $tmp-$seq.fio >>  $seq.full
> +	run_check $FIO_PROG $tmp-$seq.fio >>  $seq.full
> +}
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_supported_fs ext4
> +_need_to_be_root
> +_require_scratch
> +_require_fio $tmp-$seq.fio

Even though e4defrag is not used, it's probably still a good idea to
call _require_defrag to check for systems that have a recent enough
ext4 to run defrag on. e.g. a recent fio on an old distro might
result in fio saying "I understand this job file" but then not be
able to run defrag...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
