From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] jbd: ordered data integrity fix (rebased)
Date: Mon, 19 May 2008 05:11:51 +0200
Message-ID: <20080519031151.GB10233@duck.suse.cz>
References: <482A6E00.6080303@hitachi.com> <482A6F2B.3020605@hitachi.com> <20080514131007.GD24363@duck.suse.cz> <482D6128.6060200@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Josef Bacik <jbacik@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41074 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752772AbYESDLx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 May 2008 23:11:53 -0400
Content-Disposition: inline
In-Reply-To: <482D6128.6060200@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 16-05-08 19:25:44, Hidehiro Kawai wrote:
> Jan Kara wrote:
> 
> > On Wed 14-05-08 13:48:43, Hidehiro Kawai wrote:
> > 
> >>Subject: [PATCH 2/4] jbd: ordered data integrity fix
> >>
> >>In ordered mode, if a buffer being dirtied exists in the committing
> >>transaction, we write the buffer to the disk, move it from the
> >>committing transaction to the running transaction, then dirty it.
> >>But we don't have to remove the buffer from the committing
> >>transaction when the buffer couldn't be written out, otherwise it
> >>breaks the ordered mode rule.
> > 
> >   Hmm, could you elaborate a bit more what exactly is broken and how does
> > this help to fix it? Because even if we find EIO happened on data buffer,
> > we currently don't do anything else than just remove the buffer from the
> > transaction and abort the journal. And even if we later managed to write
> > the data buffer from other process before the journal is aborted, ordered
> > mode guarantees are satisfied - we only guarantee that too old data cannot
> > be seen, newer can be seen easily... Thanks.
> 
> In the case where I stated the above, error checking is postponed to
> the next (currently running) transaction because the buffer is removed
> from the committing transaction before checked for an error.  This can
> happen repeatedly, then the error won't be detected "for a long time".
> However, finally the error is detected by, for example,
> journal_commit_transaction(), we can abort the journal.  So this
> problem is not so serious than the other patches which I sent.
  OK, I see. So I agree with the change but please add this explanation
(like: cannot remove buffer with io error from the committing transaction
because otherwise it would miss the error and commit would not abort) to
the comment in journal_dirty_data(). Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
