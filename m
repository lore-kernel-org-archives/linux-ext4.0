From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] msync: fix incorrect fstart calculation
Date: Sat, 28 Jun 2014 15:57:48 -0400
Message-ID: <20140628195748.GC2162@thunk.org>
References: <006a01cf91fc$5d225170$1766f450$@samsung.com>
 <20140628191425.GA2162@thunk.org>
 <20140628124421.c499b001.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <namjae.jeon@samsung.com>, linux-mm@kvack.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	'Matthew Wilcox' <matthew.r.wilcox@intel.com>,
	'Eric Whitney' <enwlinux@gmail.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140628124421.c499b001.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 28, 2014 at 12:44:21PM -0700, Andrew Morton wrote:
> On Sat, 28 Jun 2014 15:14:25 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
> > On Fri, Jun 27, 2014 at 08:38:49PM +0900, Namjae Jeon wrote:
> > > Fix a regression caused by Commit 7fc34a62ca mm/msync.c: sync only
> > > the requested range in msync().
> > > xfstests generic/075 fail occured on ext4 data=journal mode because
> > > the intended range was not syncing due to wrong fstart calculation.
> > > 
> > > Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
> > > Cc: Luk____ Czerner <lczerner@redhat.com>
> > > Reported-by: Eric Whitney <enwlinux@gmail.com>
> > > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > 
> > Reviewed-by: Theodore Ts'o <tytso@mit.edu>
> > 
> > Andrew, do you want to take this in the mm tree,
> 
> I have done so.

Great, thanks!!

						- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
