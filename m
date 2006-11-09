From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/3] Extent base online defrag
Date: Thu, 09 Nov 2006 08:11:43 -0600
Message-ID: <1163081503.10671.9.camel@kleikamp.austin.ibm.com>
References: <20061109200950sho@rifu.tnes.nec.co.jp>
	 <45532328.70302@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sho@tnes.nec.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
In-Reply-To: <45532328.70302@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2006-11-09 at 07:46 -0500, Jeff Garzik wrote:
> sho@tnes.nec.co.jp wrote:

> > I have written the patches of ioctl for extent base online defragment
> > and the command which call it.
> > These patches are at the experimental stage so they need many
> > improvements.  But they work well so far as basic defragmenter,
> > which means they are worth enough to examine my trial.
> > 
> > - Specify the target area in a file using the following structure:
> >   struct ext3_ext_defrag_data {
> > 	  loff_t start_offset; /* start offset to defrag in bytes */
> > 	  loff_t defrag_size;  /* size of defrag in bytes */
> >   }
> >   It uses loff_t so that the size of the structure is identical on
> >   both 32 bits and 64 bits architecture.
> >   Block allocation, including searching for the free contiguous
> >   blocks, is implemented in kernel.
> 
> NAK the ioctl approach.

I agree it shouldn't go into mainline this way, but while the details of
the proper interface are debated, this implementation at least allows
the core function to be tested & reviewed.

> People who like ioctls are just holdovers from non-Linux OS's.
> 
> 	Jeff

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

