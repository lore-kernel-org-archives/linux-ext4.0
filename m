From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] Make block_page_mkwrite() handle frozen fs (V2)
Date: Wed, 18 May 2011 17:17:59 +0200
Message-ID: <1305731882-8334-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	tytso@mit.edu, Christoph Hellwig <hch@infradead.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933164Ab1ERPTE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 11:19:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  this is a second version of my patches which rewrite ext4_page_mkwrite() to
use generic helper. When we are already changing this code, I also added proper
handling of frozen filesystem there in patch 2/3. I've incorporated suggestions
from Christoph in the patches which resulted in some patch reorg. I'd like to
get these patches reviewed and then get them merged possibly via ext4-tree
(although the first two patches might go via Al but that would complicate
merging of ext4 part where I expect more conflicts with ongoing work).

                                                                        Honza

