From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add more tracepoints and change to use
 MAJOR/MINOR dev macros
Date: Mon, 21 Mar 2011 21:50:27 -0400
Message-ID: <20110322015027.GB3907@thunk.org>
References: <20110318021325.85D814206C@ruihe.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53556 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab1CVBua (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2011 21:50:30 -0400
Content-Disposition: inline
In-Reply-To: <20110318021325.85D814206C@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added to the ext4 patch queue.  After running pahole, though, I'm
still noticing a lot of holes in the ftrace structures:

struct ftrace_raw_ext4_load_inode {
        struct trace_entry         ent;                  /*     0    12 */

        /* XXX 4 bytes hole, try to pack */

        ino_t                      ino;                  /*    16     8 */
        dev_t                      dev;                  /*    24     4 */
        char                       __data[0];            /*    28     0 */

        /* size: 32, cachelines: 1 */
        /* sum members: 24, holes: 1, sum holes: 4 */
        /* padding: 4 */
        /* last cacheline: 32 bytes */
};      /* definitions: 1 */

Simply by swapping the ino and dev fields means that we'll save 4
bytes for this event.

						- Ted

On Thu, Mar 17, 2011 at 07:13:25PM -0700, Jiaying Zhang wrote:
> ext4: add more tracepoints and change to use MAJOR/MINOR dev macros
> 
> - Add more ext4 tracepoints.
> - Change ext4 tracepoints to use dev_t field with MAJOR/MINOR macros
> so that we can save 4 bytes on certain platforms.
> - Add sync_mode to ext4_da_writepages, ext4_da_write_pages, and
> ext4_da_writepages_result tracepoints. Also remove for_reclaim
> field from ext4_da_writepages since it is usually not very useful.
> 
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>


