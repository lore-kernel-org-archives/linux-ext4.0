From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Mon, 3 Sep 2018 17:28:46 +0530
Message-ID: <CAFqt6zY41OnT6F8F7vyUEJcc_RPoF3mALAOS7CUMUvQv8GdG0w@mail.gmail.com>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
 <20180830163352.5a96cc721ce069bed95fdbe8@linux-foundation.org> <20180903.111310.853324894545237861.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180903.111310.853324894545237861.konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 3, 2018 at 7:43 AM Ryusuke Konishi
<konishi.ryusuke@lab.ntt.co.jp> wrote:
>
> Hi Souptick,
>
> On Thu, 30 Aug 2018 16:33:52 -0700, Andrew Morton wrote:
> > On Thu, 30 Aug 2018 22:55:47 +0530 Souptick Joarder wrote:
> >
> >> Return type for fault handlers  in ext4 and nilfs are
> >> changed to use vm_fault_t.
> >>
> >> Return type of block_page_mkwrite() is changed from
> >> int to vm_fault_t. The function signature of
> >> block_page_mkwrite() is changed to add one new parameter
> >> int *err. This will provide a way for caller functions
> >> to get error value along with return value and use it
> >> further.
> >>
> >> Return type of block_page_mkwrite_return() is also changed
> >> to use new vm_fault_t type.
> >> --- a/fs/nilfs2/file.c
> >> +++ b/fs/nilfs2/file.c
> >> @@ -51,13 +51,14 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >>      return err;
> >>  }
> >>
> >> -static int nilfs_page_mkwrite(struct vm_fault *vmf)
> >> +static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
> >
> > nilfs_page_mkwrite() already has return type vm_fault_t in Linus's
> > kernel, due to the now-merged
> > fs-nilfs2-adding-new-return-type-vm_fault_t.patch.  Looks like a simple
> > fix.
>
> In the first patch in this thread, this return type change was
> excluded correctly for nilfs_page_mkwrite() though the changelog was
> inaccurate in that sense.
>
> Please confirm your base point of the revised patch.
>

Ryusuku,
Base point of revised patch is to address your comment by
removing err = 0. Nothing else was suppose to there in v2.

But unfortunately I mixed up my local branches and created v2 against
old branch which leads to confusion of v1 -> v2 delta changes.
Sorry for creating more confusions.

>
> >
> > I'm beginning to feel vm_fault_t exhaustion.  Please remind me what
> > benefit we're going to get out of all this churn?
> >
> >>
> >> ...
> >>
