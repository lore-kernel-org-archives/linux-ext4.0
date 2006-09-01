From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC][PATCH] set_page_buffer_dirty should skip unmapped buffers
Date: Fri, 1 Sep 2006 10:18:01 -0700
Message-ID: <20060901101801.7845bca2.akpm@osdl.org>
References: <1157125829.30578.6.camel@dyn9047017100.beaverton.ibm.com>
	<Pine.LNX.4.64.0609011652420.24650@hermes-2.csi.cam.ac.uk>
	<1157128342.30578.14.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, sct@redhat.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
In-Reply-To: <1157128342.30578.14.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 01 Sep 2006 09:32:22 -0700
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> > > Kernel BUG at fs/buffer.c:2791
> > > invalid opcode: 0000 [1] SMP
> > > 
> > > Its complaining about BUG_ON(!buffer_mapped(bh)).

I need to have a little think about this, remember what _should_ be
happening in this situation.

We (mainly I) used to do a huge amount of fsx-linux testing on 1k blocksize
filesystems.  We've done something to make this start happening.  Part of
resolving this bug will be working out what that was.

