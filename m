From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3] fs: Fix remaining filesystems to wait for stable
 page writeback
Date: Thu, 1 Nov 2012 15:23:54 -0700
Message-ID: <5092F67A.2060203@panasas.com>
References: <20121101075805.16153.64714.stgit@blackbox.djwong.org> <20121101075829.16153.92036.stgit@blackbox.djwong.org> <5092C2CE.7070209@panasas.com> <20121101162254.03dbbd9a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, <axboe@kernel.dk>,
        <lucho@ionkov.net>, <tytso@mit.edu>, <sage@inktank.com>,
        <ericvh@gmail.com>, <mfasheh@suse.com>, <dedekind1@gmail.com>,
        <adrian.hunter@intel.com>, <dhowells@redhat.com>, <sfrench@samba.org>,
        <jlbec@evilplan.org>, <rminnich@sandia.gov>,
        <linux-cifs@vger.kernel.org>, <jack@suse.cz>,
        <martin.petersen@oracle.com>, <neilb@suse.de>, <david@fromorbit.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-mtd@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <v9fs-developer@lists.sourceforge.net>, <ceph-devel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <linux-afs@lists.infradead.org>,
        <ocfs2-devel@oss.oracle.com>
To: Jeff Layton <jlayton@samba.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20121101162254.03dbbd9a@tlielax.poochiereds.net>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On 11/01/2012 01:22 PM, Jeff Layton wrote:
> Hmm...I don't know...
> 
> I've never been crazy about using the page lock for this, but in the
> absence of a better way to guarantee stable pages, it was what I ended
> up with at the time. cifs_writepages will hold the page lock until
> kernel_sendmsg returns. At that point the TCP layer will have copied
> off the page data so it's safe to release it.
> 
> With this change though, we're going to end up blocking until the
> writeback flag clears, right? And I think that will happen when the
> reply comes in? So, we'll end up blocking for much longer than is
> really necessary in page_mkwrite with this change.
> 

Hmm OK, that is a very good point. In that case it is just a simple
nack on Darrick's hunk to cifs. cifs is fine and should not be touched

Boaz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
