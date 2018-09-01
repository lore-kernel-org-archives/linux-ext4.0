From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Sat, 1 Sep 2018 21:51:28 +0530
Message-ID: <CAFqt6zY=-fEDR606Ae-Opg3Dn+jyZ9NdAKAshuF0PmmgimhHRQ@mail.gmail.com>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
 <20180830163521.728f3ff2fd3cc93b52a5dcc0@linux-foundation.org> <20180831165844.GB3303@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, adilger.kernel@dilger.ca,
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180831165844.GB3303@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Also, the fact that the patch series involves multiple file system is
> a massive pain.  It means I'm going to have to do a separate
> regression test --- or preferably, I would ask *you* to run a file
> system regression test[1] --- to make sure what is *not* a trivial
> patch doesn't break things.  Also, it means that this patch series is
> going to get more complicated to get into kernel, and we may have to
> deal with patch conflicts if this goes in via some third party tree
> (such as Andrew's tree).
>
> [1] https:/thunk.org/gce-xfstests

Sure, I will run the regression.

>
> One way to make life easier is to add the new function with the new
> interface first, and then wait a release cycle, and then move file
> systems over in independant patches.

In last review, you left it to me either to add new function or modify the
input parameters of block_page_mkwrite() to return err to caller.
As block_page_mkwrite() is getting called from 2 places in ext4 & nilfs,
I choose to add new input argument in block_page_mkwrite() rather than
introducing new function and put everything in a single commit.
