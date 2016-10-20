From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Thu, 20 Oct 2016 08:22:00 -0600
Message-ID: <1fb60e7c-a558-80df-09da-d3c36863a461@fb.com>
References: <20150618233430.GK20262@dastard>
 <20160929043722.ypf3tnxsl6ovt653@thunk.org> <20161012211407.GL23194@dastard>
 <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
 <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
 <ffc283a7-58ef-66b9-3c5b-75703d24ea0d@fb.com>
 <20161013231923.j2fidfbtzdp66x3t@thunk.org>
 <20161018180107.fscbfm66yidwhey4@thunk.org>
 <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
 <30fef8cd-67cc-da49-77d9-9d1a833f8a48@fb.com>
 <20161019203233.mbbmskpn5ekgl7og@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, <linux-ext4@vger.kernel.org>,
        <fstests@vger.kernel.org>, <tarasov@vasily.name>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20161019203233.mbbmskpn5ekgl7og@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/19/2016 02:32 PM, Theodore Ts'o wrote:
> On Wed, Oct 19, 2016 at 11:49:12AM -0600, Jens Axboe wrote:
>>
>> Number of cores/nodes?
>> Memory size?
>
> I'm using a gce n1-standard-2 VM.  So that's two CPU's and 7680M.
>
> Each CPU is a virtual CPU is implemented as a single hardware
> hyper-thread on a 2.3 GHz Intel Xeon E5 v3 (Haswell).  (I was using a
> GCE zone that has Haswell processors; different GCE zones may have
> different processors.  See [1] and [2] for more details.)
>
> [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__cloud.google.com_compute_docs_machine-2Dtypes&d=DQIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=cK1a7KivzZRh1fKQMjSm2A&m=itmAtbDNAiup3d6EW5J8mxTc5VKZZo4z-TaIkfeBJ8o&s=JGVEfRvtOlOiYH_c8NLKuy3FFH8Ap3EGLrhsLV_UdiM&e=
> [2] https://urldefense.proofpoint.com/v2/url?u=https-3A__cloud.google.com_compute_docs_regions-2Dzones_regions-2Dzones&d=DQIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=cK1a7KivzZRh1fKQMjSm2A&m=itmAtbDNAiup3d6EW5J8mxTc5VKZZo4z-TaIkfeBJ8o&s=nMlkYsjMNWYhpWmDmQmSFH_bQ6am_PeCfQzhWwFbbag&e=
>
>> Rough speed and size of the device?
>
> I'm using a GCE PD backed by a SSD.  To a first approximation, you can
> think of it as a KVM qcow file stored on a fast flash device.  I'm
> running LVM on the disk, and the fio is running on a 5 gig LVM volume.
>
>> Any special mkfs options?
>
> No.  This particular error will trigger on 4k block file systems, 1k
> block file systems, 4k file system swith journals disabled, etc.  It's
> fairly insensitive to the file system configuration.
>
>> And whatever else might be relevant.
>
> Note that the generic/299 test is running fio in an an ENOSPC hitter
> configuration, where there is an antangonist thread which is
> constantly allocating all of the disk space available and then freeing
> it all:
>
> # FSQA Test No. 299
> #
> # AIO/DIO stress test
> # Run random AIO/DIO activity and fallocate/truncate simultaneously
> # Test will operate on huge sparsed files so ENOSPC is expected.
>
>
> So some of the AIO/DIO operations will be failing with an error, and
> and I suspect that's very likely relevant to reproducing the failure.
>
> The actual guts of the test from generic/299[1]:
>
> [1] https://git.kernel.org/cgit/fs/xfs/xfstests-dev.git/tree/tests/generic/299
>
> _workout()
> {
> 	echo ""
> 	echo "Run fio with random aio-dio pattern"
> 	echo ""
> 	cat $fio_config >>  $seqres.full
> 	run_check $FIO_PROG $fio_config &
> 	pid=$!
> 	echo "Start fallocate/truncate loop"
>
> 	for ((i=0; ; i++))
> 	do
> 	    for ((k=1; k <= NUM_JOBS; k++))
> 	    do
> 		$XFS_IO_PROG -f -c "falloc 0 $FILE_SIZE" \
> 			$SCRATCH_MNT/direct_aio.$k.0 >> $seqres.full 2>&1
> 	    done
> 	    for ((k=1; k <= NUM_JOBS; k++))
> 	    do
> 		$XFS_IO_PROG -c "truncate  0" \
> 			$SCRATCH_MNT/direct_aio.$k.0 >> $seqres.full 2>&1
> 	    done
> 	    # Following like will check that pid is still run.
> 	    # Once fio exit we can stop fallocate/truncate loop
> 	    pgrep -f "$FIO_PROG" > /dev/null 2>&1 || break
> 	done
> 	wait $pid
> }
>
> So what's happening is that generic/299 is looping in the
> fallocate/truncate loop until fio exits, but since fio never exits, so
> it ends up looping forever.

I'm setting up the GCE now, I've had the tests running for about 24h now
on another test box and haven't been able to trigger any hangs. I'll
match your setup as closely as I can, hopefully that'll work.

-- 
Jens Axboe
