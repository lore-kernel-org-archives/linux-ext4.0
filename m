From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests, ext4: add project quota attribute tests
Date: Tue, 5 Jul 2016 10:35:15 -0400
Message-ID: <20160705143515.GF15193@thunk.org>
References: <1467701791-14626-1-git-send-email-wangshilong1991@gmail.com>
 <20160705094304.GA30163@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Shilong <wangshilong1991@gmail.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, sihara@ddn.com, lixi@ddn.com,
	wshilong@ddn.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160705094304.GA30163@infradead.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 05, 2016 at 02:43:04AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 05, 2016 at 03:56:31PM +0900, Wang Shilong wrote:
> > From: Wang Shilong <wshilong@ddn.com>
> > 
> > Some basic project quota inferface tests.
> > 
> > 1. ioctl with/without project.
> > 2. project inherit attribute.
> > 3. Link accross project should fail
> > 4. change project ignores quota
> 
> These looks pretty generic.  Aren't there any XFS tests that can be made
> generic now that ext4 supports project quotas?  Even if not these new
> test should be made generic and added to the generic group.

Last I checked there were some patches which I thought either Eric or
you were working on to change xfsprogs so it would be willing to try
to manipulate project quotas on non-xfs file systems?

I had some *extremely* hacky patches which were just enough to test
project quotas, but then I gave up on them after quotatools learned
how to work with project quotas.  I believe the presumption though was
that it would be easier to teach xfsprogs to work with ext4 than to
change xfstests to use quotatools?

Does anyone know what the status of the "real" patches to xfsprogs
that were (hopefuly) going to be clean enough to try to push them
upstream?

					- Ted
