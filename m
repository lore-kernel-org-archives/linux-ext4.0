From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] ext4: Allow writeback IO without io_end
Date: Wed, 10 May 2017 09:41:43 +0200
Message-ID: <20170510074147.26743-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45369 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752253AbdEJHro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 May 2017 03:47:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

this patch series allows ext4 to do page writeback without having io_end
allocated for the cases when block allocation is not required (it is the part
of my writepages improvements that didn't get merged in the first round). In
such cases io_end is not really necessary (it is really required only when
extent conversion has to happen after IO has finished) so just tweak the IO
completion code to allow IO submission without io_end allocated. It saves us
memory allocation on writeback path - it is not a big deal for performance but
it is nice in close-to-ENOMEM situations.

The patches have passed xfstests for ext4 and ext3 configurations,
specifically I have taken care to verify IO error handling still works.

								Honza
