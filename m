From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: Announce re-factor all current xfstests patches request
Date: Wed, 27 Mar 2013 11:42:35 -0500
Message-ID: <5153217B.5070909@sgi.com>
References: <5152F2BB.4000709@sgi.com> <20130327134606.GJ5861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>, <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20130327134606.GJ5861@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/27/2013 08:46 AM, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 08:23:07AM -0500, Rich Johnston wrote:
>> All xfstest developers,
>>
>> Thanks again for all your time in submitting and reviewing patches
>> for xfstests.  The latest patchset posted here:
>>
>> http://oss.sgi.com/archives/xfs/2013-03/msg00467.html
>>
>> requires all current patches to be re-factored.
>
> Given that we are now segregating patches into subdirectories, is it
> correct in the future tests should be named descriptively, instead of
> using 3 digit NNN numbers (which has been a major pain from a central
> assignment perspective)?
Yes
>
> If so, is there a suggested naming convention that is being recommended?
>
> Thanks for getting this change merged in!!
>
> 					- Ted
>

I suggest:

1. They should also be descriptive of the test rather than a number.
2. All lowercase letters separated by _

i.e.
something like
tests/$FSTYP/break_my_filesystem

Thanks
--Rich


