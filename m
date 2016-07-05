From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests, ext4: add project quota attribute tests
Date: Tue, 5 Jul 2016 09:59:22 -0500
Message-ID: <972db66f-b7a9-2fad-f158-fa84c4499d6e@sandeen.net>
References: <1467701791-14626-1-git-send-email-wangshilong1991@gmail.com>
 <20160705094304.GA30163@infradead.org> <20160705143515.GF15193@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Wang Shilong <wangshilong1991@gmail.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, sihara@ddn.com, lixi@ddn.com,
	wshilong@ddn.com
To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20160705143515.GF15193@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 7/5/16 9:35 AM, Theodore Ts'o wrote:
> On Tue, Jul 05, 2016 at 02:43:04AM -0700, Christoph Hellwig wrote:
>> On Tue, Jul 05, 2016 at 03:56:31PM +0900, Wang Shilong wrote:
>>> From: Wang Shilong <wshilong@ddn.com>
>>>
>>> Some basic project quota inferface tests.
>>>
>>> 1. ioctl with/without project.
>>> 2. project inherit attribute.
>>> 3. Link accross project should fail
>>> 4. change project ignores quota
>>
>> These looks pretty generic.  Aren't there any XFS tests that can be made
>> generic now that ext4 supports project quotas?  Even if not these new
>> test should be made generic and added to the generic group.
> 
> Last I checked there were some patches which I thought either Eric or
> you were working on to change xfsprogs so it would be willing to try
> to manipulate project quotas on non-xfs file systems?

Dave had sent them, but they still need some work.  I asked Bill O'Donnell
to take a look at getting them up to snuff.

However, we also agreed long ago (I think) that we need to test both
paths at this point - using the xfs as well as the vfs interfaces.

So making xfs_quota work on non-xfs filesystems tests one path, and
dedicated tests invoking generic quota tools will test the other path.

> I had some *extremely* hacky patches which were just enough to test
> project quotas, but then I gave up on them after quotatools learned
> how to work with project quotas.  I believe the presumption though was
> that it would be easier to teach xfsprogs to work with ext4 than to
> change xfstests to use quotatools?

We need to do both to get full coverage, sadly.

(I'm glad to see movement on this again; it seems that even this much
has led to some bug disccovery and fixing already.  Without tests we
had no idea whether the merged common code really worked.)

> Does anyone know what the status of the "real" patches to xfsprogs
> that were (hopefuly) going to be clean enough to try to push them
> upstream?

They're being resurrected now.

-Eric

> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
