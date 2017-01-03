From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 3/6] ubifs: Use 64bit readdir cookies
Date: Tue, 3 Jan 2017 14:52:45 -0500
Message-ID: <20170103195245.GB5712@fieldses.org>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
 <1480629741-18375-4-git-send-email-richard@nod.at>
 <20161229025835.GC21325@fieldses.org>
 <bf60916c-e0f2-387c-ce21-325ad8977539@nod.at>
 <20161229153407.GA29149@fieldses.org>
 <fe46ea3c-ef8f-40ba-f4ab-8dfe8faafb0b@nod.at>
 <20161229161534.GA29261@fieldses.org>
 <224abf2f-c820-5df1-6292-42c1e2d47933@nod.at>
 <20161229165920.GA29744@fieldses.org>
 <6ba02247-cb0e-e925-207e-4ea3fc37b9b7@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mtd@lists.infradead.org, david@sigma-star.at, tytso@mit.edu,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:51890 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760953AbdACTwt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 3 Jan 2017 14:52:49 -0500
Content-Disposition: inline
In-Reply-To: <6ba02247-cb0e-e925-207e-4ea3fc37b9b7@nod.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 29, 2016 at 06:05:54PM +0100, Richard Weinberger wrote:
> On 29.12.2016 17:59, J. Bruce Fields wrote:
> > OK, good.  So the random nonce is stored with the entry, and the hash
> > you can always recalculate from the filename, so if you return entries
> > in nonce+hash order, then you can keep that order stable even across
> > deletes and renames.
> 
> Yes.

Thanks, feel free to add a

	Reviewed-by: J. Bruce Fields <bfields@redhat.com>

to this and 6/6.

--b.
