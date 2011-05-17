From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during
 writeback for various fses
Date: Tue, 17 May 2011 10:01:50 -0400
Message-ID: <20110517140150.GA7030@infradead.org>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
 <20110516190427.GN20579@tux1.beaverton.ibm.com>
 <20110516202710.GA32630@infradead.org>
 <20110516205535.GP20579@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jeff Layton <jlayton@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
	Chris Mason <chris.mason@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1EQOCT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 10:02:19 -0400
Content-Disposition: inline
In-Reply-To: <20110516205535.GP20579@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2011 at 01:55:35PM -0700, Darrick J. Wong wrote:
> As for Al Viro, he's still listed as the VFS maintainer; isn't he resting?
> I guess he did nominate you for the holding off of morons (like me). :)

Al is back in action.  Anyway, the point stands, this is VFS material
and you should formally submit the bits to the maintainer.  Note that
there is very little fs specific material left, with Hirofumi beeing
at least not overly exited by fat patches for now, and the only real
ext4 patch going away with Jan's series to make it use the generic
page_mkwrite code.

