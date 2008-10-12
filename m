From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't reuse released data blocks untill
	transaction commits
Date: Sun, 12 Oct 2008 16:33:27 -0400
Message-ID: <20081012203327.GG12662@mit.edu>
References: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1223566329-29434-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53640 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753374AbYJLUeH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Oct 2008 16:34:07 -0400
Content-Disposition: inline
In-Reply-To: <1223566329-29434-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2008 at 09:02:08PM +0530, Aneesh Kumar K.V wrote:
> We need to make sure we don't reuse the data blocks released
> during the transaction untill the transaction commits. We force
> this mode only for ordered and journalled mode. Writeback mode
> already don't provided data consistency.

It might be a good idea in ext4_free_mb_metadata() to add a comment
that the name of the function is a little bit of a misnomer...

BTW, you may want to check what I put in the patch queue, because
iirc, I fixed up a few spelling/grammar in the patch comments.

      	      	       			       - Ted
