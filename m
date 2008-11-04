From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH -v2 5/9] ext4: sparse annotate the group info
	semaphore
Date: Tue, 4 Nov 2008 12:43:57 -0500
Message-ID: <20081104174357.GN30291@mit.edu>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43036 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751184AbYKDRoK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 12:44:10 -0500
Content-Disposition: inline
In-Reply-To: <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I changed the description of this patch to be more grammatically
correct:

ext4: Add sparse annotations for the group info semaphore

Hmm...  Why not merge this with patch #3, "ext4: Use
EXT4_GROUP_INFO_NEED_INIT_BIT during resize" where alloc_semp is newly
defined?

      	  	 	     	     	   	- Ted
