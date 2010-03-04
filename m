From: tytso@mit.edu
Subject: Re: dumpe2fs/dump/restore not working correctly for ext4?
Date: Thu, 4 Mar 2010 17:17:28 -0500
Message-ID: <20100304221728.GH15028@thunk.org>
References: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40827 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab0CDWRc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Mar 2010 17:17:32 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 04, 2010 at 10:19:57AM -0500, Justin Piszcz wrote:
> Hi,
> 
> I need to look into this more obviously and try other dumps etc, but
> I even tried extracting a single (smaller) directory and it also
> segfaulted, has dump been tested properly with ext4?

Was dump/restore statically or dynamically linked?  And with which
version of libext2fs from e2fsprogs?

						- Ted
