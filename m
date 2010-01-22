From: tytso@mit.edu
Subject: Re: 2.6.32.4 - still getting ext4 related crashes
Date: Fri, 22 Jan 2010 16:38:27 -0500
Message-ID: <20100122213827.GH21263@thunk.org>
References: <20100122085035.GA5020@nik-nb2.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 maillist <linux-ext4@vger.kernel.org>,
	nikola.ciprich@linuxbox.cz
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37687 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab0AVVie (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2010 16:38:34 -0500
Content-Disposition: inline
In-Reply-To: <20100122085035.GA5020@nik-nb2.linuxbox.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 22, 2010 at 09:50:36AM +0100, Nikola Ciprich wrote:
> Hi,
> after upgrading to 2.6.32, I'm still getting crashes on one of my boxes. It usually happens
> under some load, ie copying larger amount of data...

I think this problem has been solved in 2.6.33-rc3+, but it's a bunch
of patches that need to be backported into the stable branch.  Can you
reproduce this failure reliably?  Would you be willing to try
2.6.33-rc5 and letting me know if you can reproduce it?

Many thanks,

					- Ted
