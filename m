From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] set_page_buffer_dirty should skip unmapped buffers
Date: Wed, 6 Sep 2006 17:34:49 +0200
Message-ID: <20060906153449.GC18281@atrey.karlin.mff.cuni.cz>
References: <1157125829.30578.6.camel@dyn9047017100.beaverton.ibm.com> <Pine.LNX.4.64.0609011652420.24650@hermes-2.csi.cam.ac.uk> <1157128342.30578.14.camel@dyn9047017100.beaverton.ibm.com> <20060901101801.7845bca2.akpm@osdl.org> <1157472702.23501.12.camel@dyn9047017100.beaverton.ibm.com> <20060906124719.GA11868@atrey.karlin.mff.cuni.cz> <1157555559.23501.25.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>,
	Anton Altaparmakov <aia21@cam.ac.uk>, sct@redhat.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <1157555559.23501.25.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, 2006-09-06 at 14:47 +0200, Jan Kara wrote:
> 
> > > Andrew, what should we do ? Do you suggest handling this in jbd
> > > itself (like this patch) ?
> >   Actually that part of commit code needs rewrite anyway (and after that
> > rewrite you get rid of ll_rw_block()) because of other problems - the
> > code assumes that whenever buffer is locked, it is being written to disk
> > which is not true... I have some preliminary patches for that but they
> > are not very nice and so far I didn't have enough time to find a nice
> > solution.
> 
> Are you okay with current not-so-elegant fix ? 
  Actually I don't quite understand how it can happen what you describe
(so probably I missed something). How it can happen that some buffers
are unmapped while we are committing them?  journal_unmap_buffers()
checks whether we are not committing truncated buffers and if so, it
does not do anything to such buffers...
							Bye
								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
