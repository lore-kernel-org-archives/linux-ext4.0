From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] ext4: Convert int to vm_fault_t type
Date: Wed, 1 Aug 2018 09:13:19 -0700
Message-ID: <20180801161319.GC4039@bombadil.infradead.org>
References: <20180728085000.GA9136@jordon-HP-15-Notebook-PC>
 <20180801125512.GA10761@thunk.org>
 <CAFqt6zbxpj5DS=ONUGTJ9zaeH5k=qZpQYy-J+08tr9y0gOsCAg@mail.gmail.com>
 <20180801131330.GA4734@bombadil.infradead.org>
 <CAFqt6zYJv7SdkntY7KOBvNyfk-9MRaXBMmkbsc4J7P-tq616DA@mail.gmail.com>
 <20180801143830.GB10761@thunk.org>
 <20180801160618.GE10761@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        adilger.kernel@dilger.ca,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Greg KH <gregkh@linuxfoundation.org>, kemi.wang@intel.com,
        Sabyasachi Gupta <sabyasachi.linux@gmail.com>,
        Brajeswar Ghosh <brajeswar.linux@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180801160618.GE10761@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 01, 2018 at 12:06:18PM -0400, Theodore Y. Ts'o wrote:
> On Wed, Aug 01, 2018 at 10:38:30AM -0400, Theodore Y. Ts'o wrote:
> > I'm going to drop the whole ext4 changes for vm_fault_t for this
> > cycle, and I'll let you try to fix it up properly for the next cycle.
> 
> Here's the fixed up commit that I'm going to drop since you plan to be
> making changes in block_page_mkpage(), and I don't want us to get out
> of sync.

This looks sane to me.
