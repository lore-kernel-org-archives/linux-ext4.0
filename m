From: Mark Tinguely <tinguely@sgi.com>
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
Date: Tue, 18 Sep 2012 09:43:36 -0500
Message-ID: <50588898.6050802@sgi.com>
References: <nsxa9wojdcd.fsf@closure.thunk.org> <20120918064039.GS11511@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120918064039.GS11511@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 09/18/12 01:40, Dave Chinner wrote:
> On Mon, Sep 17, 2012 at 10:04:34PM -0400, Theodore Ts'o wrote:
>>
>> Does anyone have test cases for SEEK_HOLE/SEEK_DATA handy?  As near as I
>> can tell xfstests doesn't have any tests for SEEK_HOLE/SEEK_DATA
>> functionality, and I was hoping someone had some test programs and test
>> sets already written.
>
> Perhaps a cc to xfs@oss.sgi.com so the xfstests maintainers see the
> question would be a sensible idea?
>
> As it is, there are tests pending check-in that test
> seek-data/seek-hole functionality - they were used to verify the
> unwritten extent aware XFS implementation that recently went into
> the kernel....
>
> Cheers,
>
> Dave.

xfstest 285 and 286 (I believe these tests were only in the OSS version 
and not in the kernel.org developers version of xfstests).

There is rough version of another test that I got directly from Jeff 
Lui, the person who wrote the SEEK_HOLE/SEEK_DATA feature in XFS. This 
version tests the advance features of SEEK_HOLE/SEEK_DATA.

Ben asked me about this advanced test when he committed the advance 
features of SEEK_HOLE/SEEK_DATA to the XFS OSS tree. To the best of my 
knowledge, this test has not been submitted as an xfstest so we could 
not add it then.

--Mark Tinguely.
