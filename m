From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Properly mark the extent uninitialized during
	truncate
Date: Wed, 10 Jun 2009 14:24:51 -0400
Message-ID: <20090610182451.GB6953@mit.edu>
References: <1244638557-13492-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54759 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431AbZFJVLc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2009 17:11:32 -0400
Content-Disposition: inline
In-Reply-To: <1244638557-13492-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2009 at 06:25:57PM +0530, Aneesh Kumar K.V wrote:
> We should make sure we don't mark the non uninit extent as
> uninit during truncate

Good catch!  I've applied it to the ext4 patch queue.

Thanks,

					- Ted
