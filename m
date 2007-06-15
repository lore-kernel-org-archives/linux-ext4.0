From: Theodore Tso <tytso@mit.edu>
Subject: Re: close /dev/urandom fd (e2fsprogs 1.40-WIP (7-Apr-2007))
Date: Fri, 15 Jun 2007 18:08:54 -0400
Message-ID: <20070615220853.GI14911@thunk.org>
References: <878xalc687.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43405 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbXFOWJF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jun 2007 18:09:05 -0400
Content-Disposition: inline
In-Reply-To: <878xalc687.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 15, 2007 at 10:28:40PM +0200, Jim Meyering wrote:
> The file descriptor opened on /dev/urandom can be closed sooner:

Is there a reason why the caching of the open file descriptor for
/dev/random is causing you problems?  Keeping it open was deliberate.

Regards,

						- Ted
