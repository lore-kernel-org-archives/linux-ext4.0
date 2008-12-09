From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Checking link targets are NULL-terminated
Date: Tue, 9 Dec 2008 12:18:14 -0500
Message-ID: <20081209171814.GA8667@infradead.org>
References: <20081205144810.GA25585@dastardly.home.dghda.com> <20081208143003.9449bc77.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Duane Griffin <duaneg@dghda.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYLIRSQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Dec 2008 12:18:16 -0500
Content-Disposition: inline
In-Reply-To: <20081208143003.9449bc77.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 08, 2008 at 02:30:03PM -0800, Andrew Morton wrote:
> Perhaps nd_set_link() is a suitable place?  Change that function so
> that it is passed a third argument (max_len) and then check that within
> nd_set_link().  Change nd_set_link() to return a __must_check-marked
> errno, change callers to handle errors appropriately.
> 
> Or something totally different ;)  But along those lines?

Note that XFS and possibly other filesystem don't store the NULL
termination on disk.  So having a follow_link interface that uses a
counted string would be a nice little optimization for the XFS
follow_link / readlink implementation.   But I'm not really sure it's
worth complicating the VFS for that little gem.

