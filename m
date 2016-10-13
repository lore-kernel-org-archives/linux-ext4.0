From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] jbd2: fix incorrect unlock on j_list_lock
Date: Wed, 12 Oct 2016 23:21:13 -0400
Message-ID: <20161013032112.iy4hohrqplsajtye@thunk.org>
References: <1426644518-29680-1-git-send-email-tsgatesv@gmail.com>
 <FB6D02AD-62D8-4D29-81DF-B8BF81BD5FAC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Taesoo Kim <tsgatesv@gmail.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, taesoo@gatech.edu,
        changwoo@gatech.edu, sanidhya@gatech.edu, blee@gatech.edu,
        csong84@gatech.edu, stable@vger.kernel.org,
        "Faccini, Bruno" <bruno.faccini@intel.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56262 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933767AbcJMDXQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Oct 2016 23:23:16 -0400
Content-Disposition: inline
In-Reply-To: <FB6D02AD-62D8-4D29-81DF-B8BF81BD5FAC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 12, 2016 at 04:58:35PM -0600, Andreas Dilger wrote:
> On Mar 17, 2015, at 8:08 PM, Taesoo Kim <tsgatesv@gmail.com> wrote:
> > 
> > When 'jh->b_transaction == transaction' (asserted by below)
> > 
> >         J_ASSERT_JH(jh, (jh->b_transaction == transaction || ...
> > 
> > 'journal->j_list_lock' will be incorrectly unlocked, since
> > spin_lock() is called only in the 'if' and 'else-if' blocks but
> > not in the missing 'else' case, which results in a hang or an oops....
> > 
> > Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>
> 
> We've hit this repeatedly on kernels with commit v3.14-rc2-30-g6e4862a
> "jbd2: minimize region locked by j_list_lock in journal_get_create_access"
> under heavy load and this patch has fixed the problem.
> 
> It should also be considered for stable kernels after 3.14.
> 
> [I've updated the above commit message slightly to give more details.]
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

Apologies, this got lost which is why I hadn't handled it earlier.

	   	    	       	      - Ted
