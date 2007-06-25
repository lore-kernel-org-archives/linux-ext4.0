From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Add undo I/O manager [ Was Re: E2fsprogs 1.40 release imminent! ]
Date: Mon, 25 Jun 2007 15:03:30 -0400
Message-ID: <20070625190330.GA23064@thunk.org>
References: <E1I2aKE-0008RV-KP@tinytim.thunk.org> <467FE166.10003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48716 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbXFYTDg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2007 15:03:36 -0400
Content-Disposition: inline
In-Reply-To: <467FE166.10003@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 25, 2007 at 09:08:14PM +0530, Aneesh Kumar K.V wrote:
> What about undo I/O manager ? 

That and many other queued patches will be merged after 1.40 releases.
I didn't want to include anything that would be high risk or wouldn't
be useful as standalone.  The undo manager by itself isn't going to be
useful until it's integrated into other e2fsprogs programs, and I
didn't want to put off the 1.40 release.  So for the past couple of
weeks I've only been merging bug fixes so we could do a stable release.

Regards,

					- Ted
