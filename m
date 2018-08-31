From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Fri, 31 Aug 2018 11:33:48 +0530
Message-ID: <CAFqt6zZckYhLJuJr9TSw2KOZrt6qD25xDctuvbKfm0jyBoPycA@mail.gmail.com>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC> <20180830163352.5a96cc721ce069bed95fdbe8@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
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
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830163352.5a96cc721ce069bed95fdbe8@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 31, 2018 at 5:03 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 30 Aug 2018 22:55:47 +0530 Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> > Return type for fault handlers  in ext4 and nilfs are
> > changed to use vm_fault_t.
> >
> > Return type of block_page_mkwrite() is changed from
> > int to vm_fault_t. The function signature of
> > block_page_mkwrite() is changed to add one new parameter
> > int *err. This will provide a way for caller functions
> > to get error value along with return value and use it
> > further.
> >
> > Return type of block_page_mkwrite_return() is also changed
> > to use new vm_fault_t type.
> > --- a/fs/nilfs2/file.c
> > +++ b/fs/nilfs2/file.c
> > @@ -51,13 +51,14 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >       return err;
> >  }
> >
> > -static int nilfs_page_mkwrite(struct vm_fault *vmf)
> > +static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
>
> nilfs_page_mkwrite() already has return type vm_fault_t in Linus's
> kernel, due to the now-merged
> fs-nilfs2-adding-new-return-type-vm_fault_t.patch.  Looks like a simple
> fix.
>
> I'm beginning to feel vm_fault_t exhaustion.  Please remind me what
> benefit we're going to get out of all this churn?

The problem and benefit of these changes was discussed under this mail
thread when the first vm_fault_t patch was posted.

https://marc.info/?l=linux-mm&m=152054772413234&w=4
