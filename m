From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Tue, 19 Apr 2011 09:05:24 -0500
Message-ID: <4DAD96A4.40008@sandeen.net>
References: <20110415000940.GL21395@dastard>	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>	<20110416005040.GP21395@dastard>	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>	<20110418004040.GS21395@dastard>	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>	<20110419034455.GB23985@dastard>	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>	<20110419074538.GG23985@dastard> <BANLkTinozFL1Q5BmWr=7=Pua+0g_BciVvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigbrady.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52629 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1DSOFL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 10:05:11 -0400
In-Reply-To: <BANLkTinozFL1Q5BmWr=7=Pua+0g_BciVvA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/19/11 3:11 AM, Yongqiang Yang wrote:
> On Tue, Apr 19, 2011 at 3:45 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Tue, Apr 19, 2011 at 02:53:20PM +0800, Yongqiang Yang wrote:


...

>>> I think there are 2 ways to provide a definite definition for FIEMAP
>>> for all filesystems:
>>>
>>> 1. FIEMAP returns extent state on disk.
>>> 2. FIEMAP returns extent both in memory and on disk.
>>
>> You are *not listening*. There is no #2. FIEMAP returns the extent
>> state _on disk_ at the time of the call. If you want it to reflect
>> the in-memory state at the time of the call (for data or metadata),
>> you *must* use the the SYNC flag to convert that in-memory state to
>> on-disk state, which FIEMAP then reports just fine.
> 
> Sorry for being dense.
> 
> I think delayed extent is an exception. because it is not on the disk.
> 
> Yongqiang.

I don't think you're being dense, I think that the interface specification is just messed up.

By including flags for both unwritten and delalloc in the interface, we have hopelessly intertwined on-disk and in-memory state.

If you preallocate 1M and then do a buffered IO to that same range without a sync, and then a fiemap, what on earth should the interface return?

Writing the first part of that testcase is simple but I have no idea what the correct behavior is.

(FIEMAP_EXTENT_UNWRITTEN|FIEMAP_EXTENT_DELALLOC) ? that makes no sense.  But no other combination of flags makes sense to me either, unless we get into tortured redefinitions of what "delalloc" means.

And if we can't say what it -should- return.... well, too bad for coreutils.  :(

-Eric
