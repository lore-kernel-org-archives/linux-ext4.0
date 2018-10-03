Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38606 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeJCXpe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2018 19:45:34 -0400
Received: by mail-oi1-f193.google.com with SMTP id u197-v6so5114554oif.5
        for <linux-ext4@vger.kernel.org>; Wed, 03 Oct 2018 09:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20180824154542.26872-1-jack@suse.cz> <20181003163557.GA18434@thunk.org>
In-Reply-To: <20181003163557.GA18434@thunk.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Oct 2018 09:56:09 -0700
Message-ID: <CAPcyv4hxxcC6dkeN80MXaHx9A-kw1fn=Yjqi5uGRdFueVRFXbg@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix warning in insert_pfn()
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 3, 2018 at 9:40 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Fri, Aug 24, 2018 at 05:45:42PM +0200, Jan Kara wrote:
> > In DAX mode a write pagefault can race with write(2) in the following
> > way:
> >
> > CPU0                            CPU1
> >                                 write fault for mapped zero page (hole)
> > dax_iomap_rw()
> >   iomap_apply()
> >     xfs_file_iomap_begin()
> >       - allocates blocks
> >     dax_iomap_actor()
> >       invalidate_inode_pages2_range()
> >         - invalidates radix tree entries in given range
> >                                 dax_iomap_pte_fault()
> >                                   grab_mapping_entry()
> >                                     - no entry found, creates empty
> >                                   ...
> >                                   xfs_file_iomap_begin()
> >                                     - finds already allocated block
> >                                   ...
> >                                   vmf_insert_mixed_mkwrite()
> >                                     - WARNs and does nothing because there
> >                                       is still zero page mapped in PTE
> >         unmap_mapping_pages()
> >
> > This race results in WARN_ON from insert_pfn() and is occasionally
> > triggered by fstest generic/344. Note that the race is otherwise
> > harmless as before write(2) on CPU0 is finished, we will invalidate page
> > tables properly and thus user of mmap will see modified data from
> > write(2) from that point on. So just restrict the warning only to the
> > case when the PFN in PTE is not zero page.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
>
> I don't see this in linux-next.  What's the status of this patch?
>

It's in Andrew's tree. I believe we are awaiting the next -next
release to rebase on latest mmotm.
