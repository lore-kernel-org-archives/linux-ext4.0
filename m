From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/2] fs: ext4: use BUG_ON if writepage call comes from
 direct reclaim
Date: Tue, 3 Jul 2018 19:43:31 -0400
Message-ID: <20180703234331.GA5104@thunk.org>
References: <1530591079-33813-1-git-send-email-yang.shi@linux.alibaba.com>
 <20180703103948.GB27426@thunk.org>
 <6c305241-d502-b8ea-a187-54c33e4ca692@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mgorman@techsingularity.net, adilger.kernel@dilger.ca,
        darrick.wong@oracle.com, dchinner@redhat.com,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
To: Yang Shi <yang.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c305241-d502-b8ea-a187-54c33e4ca692@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 03, 2018 at 10:05:04AM -0700, Yang Shi wrote:
> I'm not sure if it is a good choice to let filesystem handle such vital VM
> regression. IMHO, writing out filesystem page from direct reclaim context is
> a vital VM bug. It means something is definitely wrong in VM. It should
> never happen.

If it does happen, it should happen reliably; this isn't the sort of
thing where some linked list had gotten corrupted.  This would be a
structural problem in the VM code.

So presumably, if the WARN_ON triggered, it should be be noticed by VM
developers, and they should fix it.

In general, though, BUG_ON's should be avoided unless there really is
no way to recover.

> It sounds ok to have filesystem throw out warning and handle it, but I'm not
> sure if someone will just ignore the warning, but it should *never* be
> ignored.

If a kernel develper (a VM developer in this case) ignores a warning,
that's just simply professional malpractice.  In general WARN_ON's
should only be used as a sign of a kernel bug.  So they should never
be ignored.

						- Ted
