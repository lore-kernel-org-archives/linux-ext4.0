From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] print unsigned RAM usage statistics
Date: Tue, 7 Apr 2009 13:24:34 -0400
Message-ID: <20090407172433.GC29759@mit.edu>
References: <20081028204420.GA3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42606 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZDGRYj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2009 13:24:39 -0400
Content-Disposition: inline
In-Reply-To: <20081028204420.GA3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 28, 2008 at 02:44:21PM -0600, Andreas Dilger wrote:
> Running e2fsck against a 14.5TB filesystem with -tt it reported
> -200904kB for RAM usage in pass3 instead of the correct 2300773kB.
> The RAM usage statistics were being printed with %d instead of %u.

Thanks, applied.

						- Ted
