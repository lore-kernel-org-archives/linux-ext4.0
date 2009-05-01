From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2 for 2.6.31] ext4: Use -1 as the fake block number
	for delayed new buffer_head
Date: Fri, 1 May 2009 14:58:41 -0400
Message-ID: <20090501185841.GG7681@mit.edu>
References: <1241003611-3652-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57337 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZEAS7E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2009 14:59:04 -0400
Content-Disposition: inline
In-Reply-To: <1241003611-3652-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

You mean "for 2.6.30", right?

						- Ted
