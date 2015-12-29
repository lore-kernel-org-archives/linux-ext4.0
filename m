From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 Statistics
Date: Tue, 29 Dec 2015 10:23:01 -0500
Message-ID: <20151229152301.GD3248@thunk.org>
References: <5681b67a.44de8c0a.82c37.3f52@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: funky.shelf@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58052 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbbL2PXD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Dec 2015 10:23:03 -0500
Content-Disposition: inline
In-Reply-To: <5681b67a.44de8c0a.82c37.3f52@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 28, 2015 at 02:23:54PM -0800, funky.shelf@gmail.com wrote:
> Would it be possible to store the number of successful read and
> write operations that a regular file witnesses during its lifetime?
> I'm sorry if this question has been asked before. If the information
> is already available, where may one find it?

Ext4 doesn't currently do this; if it did it would be a performance
disaster, so it's not likely that it's something we would add.

Why would you want such a thing?  What are you trying to do?

						- Ted
