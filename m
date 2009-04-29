From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: add --disable-libblkid (v2)
Date: Wed, 29 Apr 2009 13:17:00 -0400
Message-ID: <20090429171700.GE14264@mit.edu>
References: <20090224084434.GF6020@nb.net.home> <20090324121147.GA22386@zelda.netsplit.com> <20090416102241.GA3290@nb.net.home> <1239976118.11603.109.camel@quest> <20090422133304.GP15541@mit.edu> <1241013552.16780.20.camel@quest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak@redhat.com>, linux-ext4@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
To: Scott James Remnant <scott@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46596 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZD2RRG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 13:17:06 -0400
Content-Disposition: inline
In-Reply-To: <1241013552.16780.20.camel@quest>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 29, 2009 at 02:59:12PM +0100, Scott James Remnant wrote:
> On Wed, 2009-04-22 at 09:33 -0400, Theodore Tso wrote:
> 
> > The changes have been pushed out to the e2fsprogs git repository if
> > you want to try it out with the latest changes, which will be in the
> > very-soon-to-be-released e2fsprogs 1.41.5.
> > 
> I couldn't find these in the git repository - the tag has been pushed,
> but not the branch.

Try it now.  The changes for --disable-blkid were in the git
repository, but the last set of changes for 1.41.5 hadn't gotten
pushed out to master.kernel.org for some reason.

       	      			    - Ted
