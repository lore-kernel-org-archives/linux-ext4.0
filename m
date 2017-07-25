From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 1/5] mm: add vm_insert_mixed_mkwrite()
Date: Tue, 25 Jul 2017 10:01:58 +0200
Message-ID: <20170725080158.GA5374@lst.de>
References: <20170724170616.25810-1-ross.zwisler@linux.intel.com> <20170724170616.25810-2-ross.zwisler@linux.intel.com> <20170724221400.pcq5zvke7w2yfkxi@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724221400.pcq5zvke7w2yfkxi@node.shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 25, 2017 at 01:14:00AM +0300, Kirill A. Shutemov wrote:
> I guess it's up to filesystem if it wants to reuse the same spot to write
> data or not. I think your assumptions works for ext4 and xfs. I wouldn't
> be that sure for btrfs or other filesystems with CoW support.

Or XFS with reflinks for that matter.  Which currently can't be
combined with DAX, but I had a somewhat working version a few month
ago.
