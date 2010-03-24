From: tytso@mit.edu
Subject: Re: [PATCH] fix up flex groups used_dirs manipulation
Date: Tue, 23 Mar 2010 20:37:17 -0400
Message-ID: <20100324003717.GE2159@thunk.org>
References: <20100323002123.GQ29604@tux1.beaverton.ibm.com>
 <4BA836C9.1050104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, linux-ext4 <linux-ext4@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54188 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab0CXBbx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Mar 2010 21:31:53 -0400
Content-Disposition: inline
In-Reply-To: <4BA836C9.1050104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've added this to the ext4 patch queue.

Yeah, I screwed up when I implemented the new flex_bg based allocator
last year.   Thanks for catching this!

						- Ted
