From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Convert int to vm_fault_t type
Date: Wed, 1 Aug 2018 10:38:30 -0400
Message-ID: <20180801143830.GB10761@thunk.org>
References: <20180728085000.GA9136@jordon-HP-15-Notebook-PC>
 <20180801125512.GA10761@thunk.org>
 <CAFqt6zbxpj5DS=ONUGTJ9zaeH5k=qZpQYy-J+08tr9y0gOsCAg@mail.gmail.com>
 <20180801131330.GA4734@bombadil.infradead.org>
 <CAFqt6zYJv7SdkntY7KOBvNyfk-9MRaXBMmkbsc4J7P-tq616DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@infradead.org>, adilger.kernel@dilger.ca,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Greg KH <gregkh@linuxfoundation.org>, kemi.wang@intel.com,
        Sabyasachi Gupta <sabyasachi.linux@gmail.com>,
        Brajeswar Ghosh <brajeswar.linux@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFqt6zYJv7SdkntY7KOBvNyfk-9MRaXBMmkbsc4J7P-tq616DA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 01, 2018 at 06:56:39PM +0530, Souptick Joarder wrote:
> As caller of block_page_mkwrite() are -
> fs/ext4/inode.c
> fs/nilfs2/file.c
> 
> I will merge both changes in a single patch and send it.

Note that it's *important* for ext4 that we know what kind of error
was returned by the helper function passed into block_page_write() and
called by it.  In particular, whether the error was ENOSPC or not.

That's why this change should have raised all sorts of alarums:

 	ext4_journal_stop(handle);
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (ret == VM_FAULT_SIGBUS &&
+		ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry_alloc;

Note the ret == -ENOSPC --- you blindly changed it to return
VM_FAULT_SIGBUS!!!

You need to understand *why* the code does what it does, and not just
make blind mechanical replacements.

In this particular case, it probably means that if you insist on
making block_page_mkwrite() return vmfault_t, it will probably need to
take an optional "int *err" parameter, so the error can be returned to
the caller if the caller needs it.

I'm going to drop the whole ext4 changes for vm_fault_t for this
cycle, and I'll let you try to fix it up properly for the next cycle.

Regards,

						- Ted
