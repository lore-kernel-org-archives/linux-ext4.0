From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: fix delalloc retry loop logic v2
Date: Thu, 4 Feb 2010 14:45:59 -0500
Message-ID: <20100204194559.GL25885@thunk.org>
References: <87zl3qrwnx.fsf@openvz.org>
 <87sk9irve0.fsf@openvz.org>
 <87y6j9qlwq.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45608 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572Ab0BDTqG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Feb 2010 14:46:06 -0500
Content-Disposition: inline
In-Reply-To: <87y6j9qlwq.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry, what version were you testing when you ran into the problem
that you reported?  Annesh's patch hit mainline just before 2.6.33-rc6.

     	 	    	     	       - Ted
