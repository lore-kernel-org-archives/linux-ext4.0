From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Wed, 6 Jul 2016 21:47:28 -0500
Message-ID: <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
References: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
 <20160706233533.GK27480@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	sihara@ddn.com, lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Dave Chinner <david@fromorbit.com>,
	Wang Shilong <wangshilong1991@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20160706233533.GK27480@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 7/6/16 6:35 PM, Dave Chinner wrote:

...

>> +_require_scratch
>> +_require_chattr
>> +_require_test_lsattr
>> +_require_quota
> 
> needs  _require_prjquota, and that function needs to be modified to
> detect for both XFS and ext4 support.

I think that if there is desire to test both xfs and non-xfs userspace
with project quota, then we need to differentiate between "e2fsprogs
and linux-quota and the kernel all support it" and "xfsprogs and
the kernel both support it" don't we?

IOWs if the test uses setquota/repquota, chattr, mkfs, and fsck to
work with project quota, then that's a different set of requirements
from a test using xfs_io, xfs_quota, etc.

-Eric
