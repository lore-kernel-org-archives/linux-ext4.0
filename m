From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v1 5/10] ext4: Add DX_HASH_SIPHASH24 support
Date: 23 Sep 2014 23:08:28 -0400
Message-ID: <20140924030828.18454.qmail@ns.horizon.com>
References: <20140924014744.GJ17784@thunk.org>
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:44429 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754381AbaIXDIb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 23:08:31 -0400
In-Reply-To: <20140924014744.GJ17784@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> You're right, but it would probably be safer to have a hole in the
> on-disk numbering.  That's because changing the numbering of
> EXT2_HASH_*_UNSIGNED will change the ABI of ext2fs_dirhash().

Ah!  I missed that one!  I was thinking it would be uglier to
have a hole in the on-disk numbering, so I tried for the cleanest
possible method to move them.

> While we don't officially support a mismatch between the version of
> e2fsck and libext2fs, and it's unlikely that other programs would be
> trying to use ext2fs_dirhash.

debugfs uses it too, but same idea.  Mismatched e2fsprogs and libext2fs
seems really rare, but it can happen.

> Still, it would probably simpler to not try to assign
> DX_HASH_SIPHASH24 to be 6, and to leave better comments about how the
> hash values are used.

Is that "not try" supposed to be in there?

You're in charge of the number assignment.  The only other issue relevant
to hash_version assignment is the comment before struct ext2_dx_root_info.


BTW, initial benchmarking isn't showing much.  I created a 4 GB file
syste, on a RAM disk with -i 1024, and tried the following:

#!/bin/bash

set -e

DEV=/tmp/FS
MNT=/mnt

for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo performance > $i
done

for k in {1..10}; do
  for hash in legacy half_md4 tea siphash; do
     echo "=== Timing $hash (#$k) ==="
     misc/tune2fs -E hash_alg=$hash $DEV
     mount $DEV $MNT
     mkdir $MNT/dir
     time ( cd $MNT/dir &&
            for i in {00..99}; do
              touch ${i}{0000..9999} &
            done ;
            wait )
     umount $MNT; mount $DEV $MNT
     time ( cd $MNT/dir &&
            for i in {00..99}; do
              rm ${i}{0000..9999} &
            done ;
            wait )
     rmdir $MNT/dir
     umount $MNT
  done
done

for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo ondemand > $i
done


The results, after a little reformatting, are:

Creation:
Legacy              Half_MD4            TEA                 SipHash
real  user  sys     real  user  sys     real  user  sys     real  user  sys
8.767 2.600 20.303  9.137 2.567 20.483  9.088 2.537 20.690  8.802 2.523 20.693
8.568 2.540 19.633  9.635 2.627 20.830  8.844 2.493 20.223  9.032 2.620 19.947
8.829 2.687 19.710  9.233 2.627 20.633  9.011 2.570 20.583  9.050 2.577 20.307
8.991 2.627 20.553  9.433 2.493 21.190  9.304 2.560 20.773  8.956 2.540 20.547
8.694 2.600 19.577  9.451 2.647 21.147  8.787 2.577 20.143  9.407 2.600 20.293
8.755 2.543 20.120  8.596 2.603 19.193  8.961 2.520 19.857  9.593 2.617 21.150
8.675 2.537 19.650  8.952 2.540 20.253 10.269 2.590 22.013  9.911 2.493 21.887  
9.000 2.547 20.163  8.957 2.487 20.980  9.700 2.577 20.947  8.985 2.563 19.983
9.683 2.563 21.237  8.798 2.497 19.897  8.975 2.473 20.657  8.856 2.517 20.627
8.763 2.457 19.643  9.060 2.583 20.083  9.044 2.577 20.507  8.933 2.553 20.737

8.872 2.570 20.059  9.125 2.567 20.469  9.198 2.547 20.639  9.152 2.560 20.617
0.314 0.062  0.536  0.320 0.060  0.628  0.457 0.040  0.583  0.363 0.043  0.575

Last two lines are mean and (sample) standard deviation.


Removal:
Legacy              Half_MD4            TEA                 SipHash
real  user  sys     real  user  sys     real  user  sys     real  user  sys
6.108 2.610 31.603  6.472 2.620 32.157  6.904 2.650 34.963  6.338 2.617 33.370
6.190 2.697 30.747  6.469 2.560 33.423  6.448 2.733 32.050  6.609 2.720 32.047
6.140 2.703 30.110  6.807 2.517 35.587  6.933 2.663 36.240  6.596 2.563 34.923
6.117 2.653 31.033  6.427 2.677 32.700  6.359 2.647 32.060  6.387 2.687 32.733
6.161 2.767 30.207  6.503 2.790 33.017  6.403 2.683 31.297  6.389 2.730 33.173 
6.743 2.637 35.857  6.338 2.683 31.677  6.611 2.600 34.847  6.422 2.690 31.990
6.087 2.687 31.883  6.377 2.697 31.833  6.490 2.727 32.133  6.379 2.657 31.930
6.044 2.553 29.807  6.534 2.747 34.163  6.569 2.653 32.750  6.500 2.630 32.460
6.380 2.653 31.587  6.412 2.687 33.523  6.932 2.600 35.563  6.347 2.613 31.697
6.185 2.687 30.910  6.470 2.667 31.750  6.925 2.730 35.670  6.347 2.653 33.093

6.216 2.665 31.374  6.481 2.664 32.983  6.657 2.669 33.757  6.431 2.656 32.742
0.206 0.058  1.719  0.129 0.081  1.246  0.240 0.049  1.863  0.102 0.052  0.963

Last two lines are mean and (sample) standard deviation.

Anyway, real and system times seem to vary in the expected directions
(legacy is consistently fastest) but the differences are less tha 1
standard deviation, so I'd need to take a lot more data to prove anything.
