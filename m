From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: jbd/2: eliminate code duplication and gracefully handle cache
	initialisation failure
Date: Wed, 12 Mar 2008 02:46:44 +0000
Message-ID: <20080312024644.GA3567@dastardly.plus.com>
References: <1205001459-5291-1-git-send-email-duaneg@dghda.com> <20080310124628.44a62466.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, hch@infradead.org, tytso@mit.edu,
	sct@redhat.com, adilger@clusterfs.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2119 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYCLCqs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2008 22:46:48 -0400
Content-Disposition: inline
In-Reply-To: <20080310124628.44a62466.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2008 at 12:46:28PM -0700, Andrew Morton wrote:
> > This is version 2 of the jdb/2 patches to eliminate code duplication and
> > gracefully handle cace initialisation failure.
> > 
> 
> I couldn't get these to apply and I didn't understand the relationship
> between these new patches and your earlier
> jbd[2]-replace-potentially-false-assertion-with-if-block.patch and
> jbd[2]-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch
> so I just dropped everything.
> 
> Please redo and resend against next -mm or
> http://userweb.kernel.org/~akpm/mmotm/, thanks.

Will do, sorry for the inconvenience.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
