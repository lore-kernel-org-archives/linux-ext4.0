From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: unlock the new inode before iput
Date: Tue, 25 Aug 2009 22:32:19 -0400
Message-ID: <20090826023219.GB32712@mit.edu>
References: <1251194595-457-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60415 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbZHZCcU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 22:32:20 -0400
Content-Disposition: inline
In-Reply-To: <1251194595-457-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 25, 2009 at 03:33:15PM +0530, Aneesh Kumar K.V wrote:
> We need to unlock the new inode before iput. This patch fix the
> below warning.

Applied, thanks.

						- Ted
