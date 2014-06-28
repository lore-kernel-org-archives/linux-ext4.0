From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] msync: fix incorrect fstart calculation
Date: Sat, 28 Jun 2014 15:14:25 -0400
Message-ID: <20140628191425.GA2162@thunk.org>
References: <006a01cf91fc$5d225170$1766f450$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	'Matthew Wilcox' <matthew.r.wilcox@intel.com>,
	'Eric Whitney' <enwlinux@gmail.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <006a01cf91fc$5d225170$1766f450$@samsung.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 27, 2014 at 08:38:49PM +0900, Namjae Jeon wrote:
> Fix a regression caused by Commit 7fc34a62ca mm/msync.c: sync only
> the requested range in msync().
> xfstests generic/075 fail occured on ext4 data=3Djournal mode because
> the intended range was not syncing due to wrong fstart calculation.
>=20
> Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Cc: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> Reported-by: Eric Whitney <enwlinux@gmail.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

Andrew, do you want to take this in the mm tree, or shall I take it in
the ext4 tree?  I would prefer if we could get this pushed to Linus as
soon as possible, since it fixes a regression.

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
