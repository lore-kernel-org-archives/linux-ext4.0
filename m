From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Mon, 3 Sep 2018 17:28:43 -0700
Message-ID: <20180903172843.9bf312c738ce8a434dd9c242@linux-foundation.org>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
        <20180830163352.5a96cc721ce069bed95fdbe8@linux-foundation.org>
        <CAFqt6zZckYhLJuJr9TSw2KOZrt6qD25xDctuvbKfm0jyBoPycA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, kemi.wang@intel.com,
        Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nilfs <linux-nilfs@vger.kernel.org>
To: Souptick Joarder <jrdr.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFqt6zZckYhLJuJr9TSw2KOZrt6qD25xDctuvbKfm0jyBoPycA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 31 Aug 2018 11:33:48 +0530 Souptick Joarder <jrdr.linux@gmail.com> wrote:

> > > Return type of block_page_mkwrite_return() is also changed
> > > to use new vm_fault_t type.
> > > --- a/fs/nilfs2/file.c
> > > +++ b/fs/nilfs2/file.c
> > > @@ -51,13 +51,14 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> > >       return err;
> > >  }
> > >
> > > -static int nilfs_page_mkwrite(struct vm_fault *vmf)
> > > +static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
> >
> > nilfs_page_mkwrite() already has return type vm_fault_t in Linus's
> > kernel, due to the now-merged
> > fs-nilfs2-adding-new-return-type-vm_fault_t.patch.  Looks like a simple
> > fix.
> >
> > I'm beginning to feel vm_fault_t exhaustion.  Please remind me what
> > benefit we're going to get out of all this churn?
> 
> The problem and benefit of these changes was discussed under this mail
> thread when the first vm_fault_t patch was posted.
> 
> https://marc.info/?l=linux-mm&m=152054772413234&w=4

That tells us about the merging plans.  But not much about what actual
benefit anyone gets from this.

This?

: There's some interesting patterns and commonalities between drivers
: (not to mention a few outright bugs) that we've noticed, and this'll be
: a good time to clean them up.

That is terribly vague.
