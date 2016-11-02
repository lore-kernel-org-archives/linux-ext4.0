From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv3 15/41] filemap: handle huge pages in
 do_generic_file_read()
Date: Wed, 2 Nov 2016 07:37:49 -0700
Message-ID: <20161102143749.GB4790@infradead.org>
References: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
 <20160915115523.29737-16-kirill.shutemov@linux.intel.com>
 <20161013093313.GB26241@quack2.suse.cz>
 <20161031181035.GA7007@node.shutemov.name>
 <20161101163940.GA5459@quack2.suse.cz>
 <20161102083204.GB13949@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-block@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161102083204.GB13949@node.shutemov.name>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 02, 2016 at 11:32:04AM +0300, Kirill A. Shutemov wrote:
> Yes, buffer_head list doesn't scale. That's the main reason (along with 4)
> why syscall-based IO sucks. We spend a lot of time looking for desired
> block.
> 
> We need to switch to some other data structure for storing buffer_heads.
> Is there a reason why we have list there in first place?
> Why not just array?
> 
> I will look into it, but this sounds like a separate infrastructure change
> project.

We're working on it with the iomap code.  And yes, it's really something
that needs to be done before we can consider the THP patches.  Same for
the biovec thing were we really need the > PAGE_SIZE bio_vecs first.
