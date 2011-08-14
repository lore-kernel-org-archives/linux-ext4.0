From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests #62 broken on ext4
Date: Sun, 14 Aug 2011 12:09:25 -0400
Message-ID: <20110814160925.GA29428@infradead.org>
References: <E1QsFMR-0001iq-Vt@tytso-glaptop>
 <20110813201419.GA6442@infradead.org>
 <20110814004417.GA3524@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
	Stefan Behrens <sbehrens@giantdisaster.de>, xfs@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35774
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350Ab1HNQJ3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:29 -0400
Content-Disposition: inline
In-Reply-To: <20110814004417.GA3524@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 13, 2011 at 08:44:17PM -0400, Ted Ts'o wrote:
> I see there's an sort command at the very end of _extend_test_bed(), I
> presume we should also add a similar "LC_COLLATE=POSIX sort" to the
> other "find" command pipelines, and it's easy enough to filter out the
> lost+found directory by adding a "! -name lost+found".

A patch from you or Stefan would be very welcome.  Note that at least
for btrfs I see problems with the user.name2 attribute in that test too,
so it might be a bit of effort to sort out what actually is going on.

