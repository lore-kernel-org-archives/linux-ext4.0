From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: Filesystem benchmarks on reasonably fast hardware
Date: Mon, 18 Jul 2011 14:42:29 +0200
Message-ID: <20110718124229.GG1437@logfs.org>
References: <20110717160501.GA1437@logfs.org> <20110718120751.GH14869@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="TD8GDToEDw0WLGOL"
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110718120751.GH14869@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, 18 July 2011 08:07:51 -0400, Ted Ts'o wrote:
> 
> Can you send me your script and the lockstat for ext4?

Attached.  The first script generates a bunch of files, the second
condenses them into the tabular form.  Will need some massaging to
work on anything other than my particular setup, sorry.

> (Please cc the linux-ext4@vger.kernel.org list if you don't mind.
> Thanks!!)

Sure.  Lockstat will come later today.  The machine is currently busy
regenerating xfs seqrd numbers.

Jörn

-- 
I've never met a human being who would want to read 17,000 pages of
documentation, and if there was, I'd kill him to get him out of the
gene pool.
-- Joseph Costello

--TD8GDToEDw0WLGOL
Content-Type: application/x-sh
Content-Disposition: attachment; filename="sysbench.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0Aset -u=0A#set -x=0Aset -e=0A=0ASIZE=3D20G=0AFILES=3D128=0AALL_M=
ODES=3D"seqrd rndrd seqwr rndwr rndrw"=0AALL_BLOCKSIZES=3D"16384 8192 4096 =
2048 1024 512"=0AALL_BLOCKSIZES=3D"512 1024 2048 4096 8192 16384"=0AALL_THR=
EADS=3D"001 002 004 008 016 032 064 128"=0AODIRECT=3D""=0AODIRECT=3D--file-=
extra-flags=3Ddirect=0APOWERSOCKET=3D1=0A=0AMKFS=3D"mkfs.xfs -s size=3D512"=
=0AFSTYPE=3Dxfs=0A#MKFS=3D"mkfs.ext4 -b 1024"=0A#FSTYPE=3Dext4=0A#MKFS=3D"m=
kfs.btrfs"=0A#FSTYPE=3Dbtrfs=0A=0Afor BLOCKSIZE in 512 1024 2048 4096 8192 =
16384 ; do=0A	for MODE in seqwr rndwr rndrd seqrd ; do=0A		ARG1=3D"--test=
=3Dfileio --file-num=3D$FILES --file-total-size=3D$SIZE"=0A		for THREADS in=
 128 064 032 016 008 004 002 001 ; do=0A			LOGFILE=3Dsysbench-$SIZE-$MODE-b=
-$BLOCKSIZE-t-$THREADS=0A			SSH=3D"ssh -- root@sandy"=0A=0A			strom -o $POW=
ERSOCKET=0A			echo "Size      $SIZE" | tee $LOGFILE=0A			echo "Mode      $M=
ODE" | tee -a $LOGFILE=0A			echo "Threads   $THREADS" | tee -a $LOGFILE=0A	=
		echo "Blocksize $BLOCKSIZE" | tee -a $LOGFILE=0A			while ! `nc -zw1 sandy=
 22`; do true; done=0A			$SSH "echo 8 > /proc/sys/kernel/printk"=0A			$SSH =
"$MKFS drais"=0A			$SSH "mount drais /mnt/ -t $FSTYPE"=0A			$SSH "cd /mnt/ =
&& sysbench $ARG1 \=0A				prepare" | tee -a $LOGFILE=0A			$SSH "cd /mnt/ &&=
 sysbench $ARG1 \=0A				--file-test-mode=3D$MODE \=0A				--max-time=3D120 \=
=0A				--max-requests=3D100000000 \=0A				--num-threads=3D$THREADS \=0A				=
--init-rng=3Don \=0A				--file-fsync-freq=3D0 \=0A				--file-block-size=3D$=
BLOCKSIZE \=0A				$ODIRECT \=0A				run" | tee -a $LOGFILE 2>&1=0A			#$SSH "=
cd /mnt/ && sysbench $ARG1 cleanup"=0A			#$SSH "cat /proc/lock_stat" > $LOG=
FILE.lock_stat=0A			strom -f $POWERSOCKET=0A			sleep 1=0A		done=0A	done=0Ad=
one=0A
--TD8GDToEDw0WLGOL
Content-Type: application/x-sh
Content-Disposition: attachment; filename="sysbench_result.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A#set -u=0A#set -x=0A#set -e=0A=0AALL_BLOCKSIZES=3D"16384 8192 4=
096 2048 1024 512"=0AALL_THREADS=3D"001 002 004 008 016 032 064 128"=0AALL_=
MODES=3D"seqrd rndrd seqwr rndwr"=0ASIZE=3D20G=0A=0A# 95% Latency=0AGREP=3D=
'percentile'=0ASED1=3D's/.*://'=0A=0A# min Latency=0AGREP=3D'min:'=0ASED1=
=3D's/.*://'=0A=0A# average Latency=0AGREP=3D'avg:'=0ASED1=3D's/.*://'=0A=
=0A# max Latency=0AGREP=3D'max:'=0ASED1=3D's/.*://'=0A=0A# IO/s=0AGREP=3D'R=
equests/sec'=0ASED1=3D's/\..*//'=0A=0Afor MODE in $ALL_MODES; do=0A	echo=0A=
	echo -n "$MODE"=0A	echo "	1	2	4	8	16	32	64	128"=0A	for BLOCKSIZE in $ALL_B=
LOCKSIZES; do=0A		echo -n "$BLOCKSIZE	"=0A		for THREADS in $ALL_THREADS; do=
=0A			LOGFILE=3Dsysbench-$SIZE-$MODE-b-$BLOCKSIZE-t-$THREADS=0A			echo -n `=
grep $GREP $LOGFILE 2>/dev/null| \=0A				sed $SED1 | \=0A				sed 's/ *//' |=
 \=0A				sed 's/\n//'`=0A			echo -n "	"=0A		done=0A		echo=0A	done=0Adone=0A
--TD8GDToEDw0WLGOL--
