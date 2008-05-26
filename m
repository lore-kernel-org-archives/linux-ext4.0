From: Jan Kara <jack@suse.cz>
Subject: ext4 lock ordering patch
Date: Mon, 26 May 2008 19:34:52 +0200
Message-ID: <20080526173452.GL32407@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45387 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754523AbYEZRex (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2008 13:34:53 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Mingming,

  I've noticed you removed the patch reversing locking order of page lock
and transaction start from ext4 patch queue. Was this because of that
reported performance problem or for some other reason? As far as I've
understood that problem has been just in the patch fixing the delalloc mode
part so just removing that patch would be enough AFAICT.
  Anyway, the problem is I have now ordered mode rewrite for JBD2/ext4
which depends on this patch so the question is how to proceed... Should we
first fix that delalloc problem (are you looking into that?) or do we merge
all the changes and then fixup the delalloc code?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
