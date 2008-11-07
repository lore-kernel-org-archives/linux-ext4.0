From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH -V3 1/9] ext4: sparse fixes
Date: Fri, 7 Nov 2008 09:45:19 -0500
Message-ID: <20081107144519.GF9543@mit.edu>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081106220954.GM18939@mit.edu> <20081107142022.GK25194@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43684 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbYKGOpY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 09:45:24 -0500
Content-Disposition: inline
In-Reply-To: <20081107142022.GK25194@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 07:50:22PM +0530, Aneesh Kumar K.V wrote:
> I did it that way first But found the error path needing conversion.
> But i guess it is ok since it happen in the error path printk.

If there is an error path that needs conversion (I assume you mean the
fs/ext4/super.c unknown feature printk?) we can just open code it
instead of using the cpp macro --- as I see you've already done.

	   	     	       	      - Ted
