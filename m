From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Thu, 7 Jul 2016 22:19:27 -0500
Message-ID: <77863b4a-95e6-4100-79c2-5cbcaf0872e7@sandeen.net>
References: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
 <20160706233533.GK27480@dastard>
 <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
 <20160708005127.GK12670@dastard> <20160708024654.GE19871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Wang Shilong <wangshilong1991@gmail.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, sihara@ddn.com, lixi@ddn.com,
	Wang Shilong <wshilong@ddn.com>
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20160708024654.GE19871@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 7/7/16 9:46 PM, Theodore Ts'o wrote:
> On Fri, Jul 08, 2016 at 10:51:27AM +1000, Dave Chinner wrote:
>> On Wed, Jul 06, 2016 at 09:47:28PM -0500, Eric Sandeen wrote:
>>> On 7/6/16 6:35 PM, Dave Chinner wrote:
>>>
>>> ...
>>>
>>>>> +_require_scratch
>>>>> +_require_chattr
>>>>> +_require_test_lsattr
>>>>> +_require_quota
>>>>
>>>> needs  _require_prjquota, and that function needs to be modified to
>>>> detect for both XFS and ext4 support.
>>>
>>> I think that if there is desire to test both xfs and non-xfs userspace
>>> with project quota, then we need to differentiate between "e2fsprogs
>>> and linux-quota and the kernel all support it" and "xfsprogs and
>>> the kernel both support it" don't we?
>>
>> Well, it should be just "linux-quota and kernel". ext4 needs to
>> have the same mount option behaviour for project quota as it does
>> for all other types of quota, not be dependent on mkfs....
> 
> Project quota for ext4 is an optional thing, and if nothing else, we
> need to have a separate feature flag for legacy file systems that were
> created before we started supporting project quota.  So if you want to
> support project quota you *will* need to have a version of e2fsck that
> understands project quota, and a version of mke2fs that knows how to
> request that project quota be enabled, etc., etc.
> 
> So while it might be *nice* if ext4 could support project quota
> without being dependent on having a specific version of mke2fs and
> e2fsck installed, it's just simply not possible....
> 
>>> IOWs if the test uses setquota/repquota, chattr, mkfs, and fsck to
>>> work with project quota, then that's a different set of requirements
>>> from a test using xfs_io, xfs_quota, etc.
>>
>> _require_linux_prjquota
>> _require_xfs_prjquota
>>
>> But that said, both ext4 and xfs need to work for both
>> configurations, and they should all be using the common xfstests
>> quota infrastructure....
> 
> Agreed, but we want xfstests to be able to support systems where
> linux-quota (aka quotatools) and/or e2fsprogs and/or the kernel
> haven't been upgraded to support project quota, don't we?  If for no
> other reason than to be kind to the poor souls who have to support
> RHEL 6.  :-)

It's unlikely that ext4 project quota will find its way to RHEL6. ;)

But the point I keep trying to make - and failing, apparently - 
is that we will / should have two sets of tests for userspace
functionality at least; one using standard quota tools, and one
using xfs_quota.  Both should test the same kernel paths, but
if we want to know that userspace is working we need to test both.

And to test one or the other, we need to know that *it* supports
project quota before proceeding.

I don't know how we got to the point where we have 2 parallel
quota infrastructures, it's an unfortunate mess IMHO.  :(

But if we want to test xfs_quota tests on ext4, we still
need to know that e2fsprogs is pquota-capable.

If we want to test standard quota tools on ext4, we need to know
that *those* binaries are capable, as well as e2fsprogs.  etc...

-Eric

> 						- Ted
> 
