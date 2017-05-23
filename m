From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] ubifs: Implement export_operations
Date: Tue, 23 May 2017 01:48:18 -0700
Message-ID: <20170523084818.GA26514@infradead.org>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
 <1495398051-4604-6-git-send-email-richard@nod.at>
 <20170523083932.GC4107@infradead.org>
 <04af5127-e8f3-a2e9-4d2f-af5ef9fc1531@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-mtd@lists.infradead.org, david@sigma-star.at,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, bfields@redhat.com,
        marcus.folkesson@gmail.com, hyc.lee@gmail.com,
        rockdotlee@gmail.com, leon.pollak@gmail.com
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <04af5127-e8f3-a2e9-4d2f-af5ef9fc1531@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 23, 2017 at 10:41:16AM +0200, Richard Weinberger wrote:
> UBIFS has no inode generations, inodes simply can't wrap around.
> We "handle" it like JFF2 does, we assumes that the NAND is long dead
> before we reach the maximum inode number.

So you never ever reuse an inode number once it's been unlinked and
the last opener went away?

If that is the case please add a comment explaining this next to
the get_inode helper.
