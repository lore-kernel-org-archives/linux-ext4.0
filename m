From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Mon, 3 Sep 2018 19:13:55 -0700
Message-ID: <20180904021355.GA17153@bombadil.infradead.org>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
 <20180830163352.5a96cc721ce069bed95fdbe8@linux-foundation.org>
 <CAFqt6zZckYhLJuJr9TSw2KOZrt6qD25xDctuvbKfm0jyBoPycA@mail.gmail.com>
 <20180903172843.9bf312c738ce8a434dd9c242@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Souptick Joarder <jrdr.linux@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, kemi.wang@intel.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nilfs <linux-nilfs@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903172843.9bf312c738ce8a434dd9c242@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 03, 2018 at 05:28:43PM -0700, Andrew Morton wrote:
> > > I'm beginning to feel vm_fault_t exhaustion.  Please remind me what
> > > benefit we're going to get out of all this churn?

Hi Andrew,

The primary benefit is to help driver writers.  At the moment, there
is nothing to stop them returning -ENOMEM instead of VM_FAULT_NOMEM.
There were one or two examples of this in the tree, but I think they're
all gone now.

Secondarily, there are a number of places which translate between error
codes and vm_fault codes.  Those places are reduced as a result of these
patches, if not entirely eliminated yet.  There was some pretty extreme
cargo-culting of errno to vm_fault switch statements, particularly in
the DRM drivers.

There were also several places which were just ignoring the return value
of vm_insert_foo(), and as a result of this audit, those have been fixed.
Those errors are going to be rare, but can cause inappropriate decisions
to be made by the OOM killer.

Now that I think about it, vmf_insert_foo() should probably get marked
with __must_check to prevent those kinds of errors from being introduced
again.
