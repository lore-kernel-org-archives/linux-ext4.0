From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCHv3 15/41] filemap: handle huge pages in
 do_generic_file_read()
Date: Mon, 7 Nov 2016 19:03:17 +0300
Message-ID: <20161107160317.jwdbqopivo7g2j2i@black.fi.intel.com>
References: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
 <20160915115523.29737-16-kirill.shutemov@linux.intel.com>
 <20161013093313.GB26241@quack2.suse.cz>
 <20161031181035.GA7007@node.shutemov.name>
 <20161101163940.GA5459@quack2.suse.cz>
 <20161102143612.GA4790@infradead.org>
 <20161107111305.GB13280@node.shutemov.name>
 <20161107150103.GA17451@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
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
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:31990 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932380AbcKGQDY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Nov 2016 11:03:24 -0500
Content-Disposition: inline
In-Reply-To: <20161107150103.GA17451@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 07, 2016 at 07:01:03AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 07, 2016 at 02:13:05PM +0300, Kirill A. Shutemov wrote:
> > It looks like a huge limitation to me.
> 
> The DAX PMD fault code can live just fine with it.

There's no way out for DAX as we map backing storage directly into
userspace. There's no such limitation for page-cache. And I don't see a
point to introduce such limitation artificially.

Backing storage fragmentation can be a weight on decision whether we want
to allocate huge page, but it shouldn't be show-stopper.

> And without it performance would suck anyway.

It depends on workload, obviously.

-- 
 Kirill A. Shutemov
