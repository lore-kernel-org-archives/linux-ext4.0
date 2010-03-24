From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix up flex groups used_dirs manipulation
Date: Wed, 24 Mar 2010 08:57:41 -0500
Message-ID: <4BAA1A55.1040406@redhat.com>
References: <20100323002123.GQ29604@tux1.beaverton.ibm.com> <4BA836C9.1050104@redhat.com> <20100324003717.GE2159@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: djwong@us.ibm.com, linux-ext4 <linux-ext4@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab0CXN5u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Mar 2010 09:57:50 -0400
In-Reply-To: <20100324003717.GE2159@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> I've added this to the ext4 patch queue.

thanks.  probably a -stable candidate too, whenever that's ready
to go ...

-Eric

> Yeah, I screwed up when I implemented the new flex_bg based allocator
> last year.   Thanks for catching this!
> 
> 						- Ted

