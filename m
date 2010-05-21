From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Prevent creation of files larger than
 RLIMIT_FSIZE using fallocate
Date: Thu, 20 May 2010 21:11:22 -0400
Message-ID: <20100521011122.GB11651@thunk.org>
References: <201004281854.49730.knikanth@suse.de>
 <201005030953.45157.knikanth@suse.de>
 <20100503065945.GA13756@amitarora.in.ibm.com>
 <201005041115.04400.knikanth@suse.de>
 <20100504062815.GA8091@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-ext4@vger.kernel.org
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43032 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab0EUBL3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 21:11:29 -0400
Content-Disposition: inline
In-Reply-To: <20100504062815.GA8091@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 04, 2010 at 11:58:16AM +0530, Amit K. Arora wrote:
> On Tue, May 04, 2010 at 11:15:04AM +0530, Nikanth Karthikesan wrote:
> > I assumed that Amit would send a patch with s-o-b, if not, please take
> > this patch.
> Have added my sign-off below. Thanks!

Added to the ext4 patch queue.

							- Ted

