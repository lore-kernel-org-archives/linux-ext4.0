From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Mon, 20 Jul 2009 10:26:40 -0400
Message-ID: <20090720142639.GA20642@infradead.org>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com> <20090717143637.GM8508@mit.edu> <1247842479.4524.11.camel@quest> <20090717150207.GA29705@mit.edu> <1247843694.4524.13.camel@quest> <20090719115617.GF2416@mit.edu> <20090719212714.GA6886@nb.net.home> <20090720142337.GH2416@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak@redhat.com>,
	Scott James Remnant <scott@ubuntu.com>,
	linux-ext4@vger.kernel.org, util-linux-ng@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZGTO0l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2009 10:26:41 -0400
Content-Disposition: inline
In-Reply-To: <20090720142337.GH2416@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 20, 2009 at 10:23:37AM -0400, Theodore Tso wrote:
> There are some commercial programs that might use libuuid --- minor
> ones, like SAP R/3.  So they might want to create programs that work
> on both RHEL 5 and RHEL 6.  The only way I can think of doing this is
> to build the link libraries without the map file, and the shared
> library with the map file.

If you want one binary to run on multiple distributions you'll always
have to build on the older one anyway.

