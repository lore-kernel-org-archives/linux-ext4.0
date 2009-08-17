From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]Show unwritten extent flag in ext4_ext_show_leaf()
Date: Mon, 17 Aug 2009 08:37:11 -0400
Message-ID: <20090817123711.GB20106@mit.edu>
References: <1250091501.18329.16.camel@mingming-laptop> <1250093510.18329.35.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39567 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZHQMhN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2009 08:37:13 -0400
Content-Disposition: inline
In-Reply-To: <1250093510.18329.35.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 12, 2009 at 09:11:50AM -0700, Mingming wrote:
> 
> Updated patch, changes to print out the unwritten flag should moved to
> this patch instead of the compile warning fix patch.

Thanks, added to the ext4 patch queue.

					- Ted
