From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 10:50:32 -0500
Message-ID: <20101119155032.GB7145@infradead.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <20101119154119.GF10039@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0KSPud (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 10:50:33 -0500
Content-Disposition: inline
In-Reply-To: <20101119154119.GF10039@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 10:41:19AM -0500, Ted Ts'o wrote:
> What do people think?  Should I try to push these two patches to Linus
> now, to make it easier for other file systems who might be interested
> in implementing FITRIM functionality?

Yes, please.

