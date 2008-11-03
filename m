From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 5/6] ext4: Call journal commit callback without holding
	j_list_lock
Date: Sun, 2 Nov 2008 21:42:02 -0500
Message-ID: <20081103024202.GS8134@mit.edu>
References: <1225471859-19718-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225471859-19718-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225471859-19718-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225471859-19718-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225471859-19718-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, frederic.bohe@bull.net,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36947 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754095AbYKCCmQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 21:42:16 -0500
Content-Disposition: inline
In-Reply-To: <1225471859-19718-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justification for this patch, please?  Is there a lockdep violation
that you're trying to avoid? 

Also, given that __jbd2_journal_drop_transaction() is called exactly
twice, instead of passing in an extra free, it might be simpler just
to transfer the responsibility of calling kfree() to the caller.

   	    		       	  	  - Ted
