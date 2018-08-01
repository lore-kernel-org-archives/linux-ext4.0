From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Convert int to vm_fault_t type
Date: Wed, 1 Aug 2018 12:22:59 -0400
Message-ID: <20180801162259.GF10761@thunk.org>
References: <20180728085000.GA9136@jordon-HP-15-Notebook-PC>
 <20180801125512.GA10761@thunk.org>
 <CAFqt6zbxpj5DS=ONUGTJ9zaeH5k=qZpQYy-J+08tr9y0gOsCAg@mail.gmail.com>
 <20180801131330.GA4734@bombadil.infradead.org>
 <CAFqt6zYJv7SdkntY7KOBvNyfk-9MRaXBMmkbsc4J7P-tq616DA@mail.gmail.com>
 <20180801143830.GB10761@thunk.org>
 <20180801160618.GE10761@thunk.org>
 <20180801161319.GC4039@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Souptick Joarder <jrdr.linux@gmail.com>, adilger.kernel@dilger.ca,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Greg KH <gregkh@linuxfoundation.org>, kemi.wang@intel.com,
        Sabyasachi Gupta <sabyasachi.linux@gmail.com>,
        Brajeswar Ghosh <brajeswar.linux@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180801161319.GC4039@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 01, 2018 at 09:13:19AM -0700, Matthew Wilcox wrote:
> On Wed, Aug 01, 2018 at 12:06:18PM -0400, Theodore Y. Ts'o wrote:
> > On Wed, Aug 01, 2018 at 10:38:30AM -0400, Theodore Y. Ts'o wrote:
> > > I'm going to drop the whole ext4 changes for vm_fault_t for this
> > > cycle, and I'll let you try to fix it up properly for the next cycle.
> > 
> > Here's the fixed up commit that I'm going to drop since you plan to be
> > making changes in block_page_mkwrite(), and I don't want us to get out
> > of sync.
> 
> This looks sane to me.

Yeah, it's fine except for the cognitive load to the file system
programmer where block_page_mkwrite() returns an int, and not a
vm_fault_t, and you have use block_page_mkwrite_return() in order to
convert from the negative error code convention to a vm_fault_t.

Souptick has a separate patch out which changes block_page_mkpage() to
return a vm_fault_t.  It's broken in that it clobbers the error return
and doesn't provide a way for the caller to get the error return.  So
Souptick, please consider that other patch to have received a NACK
from me, as it *will* break ext4.

Souptick, perhaps you could change block_page_mkwrite() so that its
function signature looks like this instead:

vm_fault_t block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
	   		      get_block_t get_block, int *err)

...that's sane.  Or you can maybe simply change the *name* of the
function so it's clear it's differnt from all other xxx_page_mkwrite()
functions in that it returns an int.

I'll let you decide what you want to do --- since part of your
development to be a sophisticated programmer is to get experience
making these sorts of decisions that involve having good programming
"taste".

Regards,

						- Ted
