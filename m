From: Theodore Tso <tytso@mit.edu>
Subject: Re: BUG# ext4: getting call trace when copying large data to ext4
	filesystem
Date: Thu, 21 Aug 2008 09:25:36 -0400
Message-ID: <20080821132536.GF16634@mit.edu>
References: <OF64A349C6.9E7DE19A-ON652574AC.00353D74-652574AC.0035590F@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Rishikesh K Rajak <risrajak@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57787 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752053AbYHUNZl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 09:25:41 -0400
Content-Disposition: inline
In-Reply-To: <OF64A349C6.9E7DE19A-ON652574AC.00353D74-652574AC.0035590F@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 21, 2008 at 03:12:52PM +0530, Rishikesh K Rajak wrote:
> 
> Wanted to know if anyone is getting the same problem too.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11389

Yes, this was fixed quite a while ago; the patch is on the ext4 patch
queue.  Please note that if you are going to be doing extensive ext4
testing, you probably want to be using the latest ext4 patch sets.
The problem was first reported last week, and was fixed on the
linux-ext4 mailing list within two days, and we had a warning about
the problem on the Ext4 Wiki, on the Ext4 Howto page documenting the
problem, and telling people how to avoid it, or how to download the
specific patches from the ext4 patch queue.

Yesterday, I released the latest 2.6.26-ext4-7 patchset, which has
these problems fixed, and I updated the Ext4 Howto.

Regards,

						- Ted
