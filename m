From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Handle -EDQUOT error on write
Date: Fri, 22 Jan 2010 17:24:31 -0500
Message-ID: <20100122222431.GI21263@thunk.org>
References: <1264147063-18795-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52182 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab0AVWYv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2010 17:24:51 -0500
Content-Disposition: inline
In-Reply-To: <1264147063-18795-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 22, 2010 at 01:27:43PM +0530, Aneesh Kumar K.V wrote:
> We need to release the journal before we do a write_inode. Otherwise
> we could deadlock.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks, applied with some minor adjustments (mostly comment
reformatting/rewording).

						- Ted
