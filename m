From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] ext4: Convert int to vm_fault_t type
Date: Wed, 1 Aug 2018 06:13:30 -0700
Message-ID: <20180801131330.GA4734@bombadil.infradead.org>
References: <20180728085000.GA9136@jordon-HP-15-Notebook-PC>
 <20180801125512.GA10761@thunk.org>
 <CAFqt6zbxpj5DS=ONUGTJ9zaeH5k=qZpQYy-J+08tr9y0gOsCAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
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
In-Reply-To: <CAFqt6zbxpj5DS=ONUGTJ9zaeH5k=qZpQYy-J+08tr9y0gOsCAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 01, 2018 at 06:34:45PM +0530, Souptick Joarder wrote:
> > The fact that ext4_page_mkwrite() returns a vm_fault_t, while
> > block_page_mkwrite() returns an int which then has to get translated
> > into a vm_fault_t via block_page_mkwrite_return() is I suspect going
> > to confuse an awful lot of callers.
> 
> We have also changed block_page_mkwrite() to return vm_fault_t, but in
> a different patch. Hopefully that patch will be in linux-next tree soon.

I didn't sign off on that, so that's not "we", but "I".  And this is
completely against everything I've been telling you for this whole effort.
Patches should each make sense individually.  You can't make this patch
dependent on another patch without putting that in writing.

Leave block_page_mkwrite() alone for now.  Eventually it should return
a vm_fault_t, probably.  But that patch needs to be delayed at least
one kernel cycle.
