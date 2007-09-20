From: Jan Kara <jack@suse.cz>
Subject: Ext3 not marking filesystems as with errors
Date: Thu, 20 Sep 2007 14:50:35 +0200
Message-ID: <20070920125035.GG2689@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:55881 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751540AbXITM3n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 08:29:43 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

  one friend has just pointed me to a following misbehaviour of ext3. If we
stumble on some error in JBD (e.g. in commit code), we call
__journal_abort_hard(). It just marks the journal as aborted but does
nothing else. Later ext3 comes, finds journal aborted, calls ext3_abort()
which remounts fs read-only and stops (it does not mark filesystem as
having errors). It calls journal_abort(.., -EIO) but that does nothing
because the journal is already aborted. If you then unmount the filesystem
and mount it again, everything goes on happily as if there was no error -
no suggestion for running fsck, nothing.
  I guess this is a bug but please correct me if you don't think so. There
are two possibilities how to fix it - either we mark the filesystem as with
errors in ext3_abort() or we could call some less lowlevel function from
JBD to abort journal (as soon as j_errno is set, we are safe). Any feeling
what is less hacky?

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
