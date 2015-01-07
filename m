From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v7 9/11] xfstests: generic/043: Test multiple fallocate
	insert/collapse range calls
Date: Wed, 07 Jan 2015 14:50:13 +0900
Message-ID: <001a01d02a3d$ce7462d0$6b5d2870$@samsung.com>
References: <004701d02670$73dcb0a0$5b9611e0$@samsung.com>
	<20150106191010.GJ5874@bfoster.bfoster>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>,
	linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>
To: 'Brian Foster' <bfoster@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-reply-to: <20150106191010.GJ5874@bfoster.bfoster>
Content-language: ko
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

> > +
> > +for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
> > +
> > +	length=$(($BLOCKS * $BSIZE))
> > +	case $FSTYP in
> > +	xfs)
> > +	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
> > +	;;
> > +	ext4)
> > +	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
> > +	;;
> > +	esac
> 
> I think we typically try to define things like blocksize in the test
> configuration. The MKFS_OPTIONS env. var. can be defined with the
> correct options for the associated fs being tested. That eliminates the
> need to loop and for the fs-specific _scratch_mkfs calls above.
Okay, I will change.
> 
> > +	_scratch_mount >> $seqres.full 2>&1
> > +
> > +	# Write file
> > +	$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
> > +
> > +
> > +	# Insert alternate blocks
> 
> Trailing space in the above comment.
> 
> > +	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +		offset=$((($j*$BSIZE)*2))
> > +		$XFS_IO_PROG -c "finsert $offset $BSIZE" $testfile > /dev/null
> > +	done
> > +
> > +	# Check if 100 extents are present
> > +	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
> > +
> > +	_check_scratch_fs
> > +	if [ $? -ne 0 ]; then
> > +		status=1
> > +		exit
> > +	fi
> > +
> > +	# Collapse alternate blocks
> 
> ... and here as well.
Okay, I wil fix both points.
> 
> > +	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> > +		offset=$((($j*$BSIZE)))
> > +		$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
> > +	done
> > +
> > +	# Check if 1 extents are present
> > +	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
> > +
> > +	_check_scratch_fs
> > +	if [ $? -ne 0 ]; then
> > +		status=1
> > +		exit
> > +	fi
> > +
> 
> Maybe create a copy of the original file before we run through the
> insert and collapse sequence and cmp the files here as a last step?
Good idea. I will add your point.

Thanks for your review!
> 
> Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
