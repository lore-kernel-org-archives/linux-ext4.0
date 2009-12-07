From: tytso@mit.edu
Subject: Re: [PATCH] Ext4: wait for log to commit when putting super
Date: Mon, 7 Dec 2009 15:41:50 -0500
Message-ID: <20091207204150.GK27692@thunk.org>
References: <20091207200924.GB8558@localhost.localdomain>
 <4B1D64ED.5060403@redhat.com>
 <20091207203156.GC8558@localhost.localdomain>
 <4B1D6810.40204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53662 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934896AbZLGUlp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2009 15:41:45 -0500
Content-Disposition: inline
In-Reply-To: <4B1D6810.40204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 07, 2009 at 02:39:44PM -0600, Eric Sandeen wrote:
> 
> I guess it doesn't matter much to me, I just preferred rearranging
> teardown order to adding more logic that I think is already taken care
> of in the jbd2_journal_destroy call ..

Agreed.

> Thanks for finding this! :)

... and seconded!  :-)

					- Ted
