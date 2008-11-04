From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH -v2 6/9] ext4: Call journal commit callback without
	holding j_list_lock
Date: Tue, 4 Nov 2008 12:37:07 -0500
Message-ID: <20081104173707.GM30291@mit.edu>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:53603 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754888AbYKDRhS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 12:37:18 -0500
Content-Disposition: inline
In-Reply-To: <1225733769-23734-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I suggest adding the following description and to change the prefix to
be jbd2, not ext4, since the change applies 100% to jbd2 code (and so
it could potentially apply to ocfs2 if they decide to use this
callback, for example).

jbd2: Call journal commit callback without holding j_list_lock

Avoid freeing the transaction in __jbd2_journal_drop_transaction() so
the journal commit callback can run without holding j_list_lock, to
avoid lock contention on this spinlock.

						- Ted
