From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC][PATCH] set_page_buffer_dirty should skip unmapped buffers
Date: Wed, 13 Sep 2006 20:38:17 -0700
Message-ID: <20060913203817.b6711381.akpm@osdl.org>
References: <20060901101801.7845bca2.akpm@osdl.org>
	<1157472702.23501.12.camel@dyn9047017100.beaverton.ibm.com>
	<20060906124719.GA11868@atrey.karlin.mff.cuni.cz>
	<1157555559.23501.25.camel@dyn9047017100.beaverton.ibm.com>
	<20060906153449.GC18281@atrey.karlin.mff.cuni.cz>
	<1157559545.23501.30.camel@dyn9047017100.beaverton.ibm.com>
	<20060906162723.GA14345@atrey.karlin.mff.cuni.cz>
	<1157563016.23501.39.camel@dyn9047017100.beaverton.ibm.com>
	<20060906172733.GC14345@atrey.karlin.mff.cuni.cz>
	<1157641877.7725.13.camel@dyn9047017100.beaverton.ibm.com>
	<20060907223048.GD22549@atrey.karlin.mff.cuni.cz>
	<1158179120.11112.2.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Badari Pulavarty <pbadari@us.ibm.com>,
	Anton Altaparmakov <aia21@cam.ac.uk>, sct@redhat.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1158179120.11112.2.camel@kleikamp.austin.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 13 Sep 2006 15:25:19 -0500
Dave Kleikamp <shaggy@austin.ibm.com> wrote:

> > +void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
> 
> Is there any reason this couldn't be static?

Nope.

> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < bufs; i++) {
> > +               wbuf[i]->b_end_io = end_buffer_write_sync;
> > +               /* We use-up our safety reference in submit_bh() */
> > +               submit_bh(WRITE, wbuf[i]);
> > +       }
> > +} 
> 
> I'm rebasing the ext4 work on the latest -mm tree and would like to
> avoid renaming this function in the jbd2 clone.

<edits the diff>
