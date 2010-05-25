From: "Jayson R. King" <dev@jaysonking.com>
Subject: Re: [10/24] vfs: Add no_nrwrite_index_update writeback control flag
Date: Tue, 25 May 2010 11:53:04 -0500
Message-ID: <4BFC0070.9010408@jaysonking.com>
References: <20100524223544.GA13721@kroah.com> <20100524223016.208581966@clark.site> <20100525111208.GA8779@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	"Jayson R. King" <dev@jaysonking.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout11.eigbox.net ([66.96.190.11]:46558 "EHLO
	bosmailout11.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab0EYRZ3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 13:25:29 -0400
In-Reply-To: <20100525111208.GA8779@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/25/2010 06:12 AM, Christoph Hellwig wrote:
> On Mon, May 24, 2010 at 03:28:06PM -0700, Greg KH wrote:
>> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> NACK.  This has been shown to cause severe writeback regression for
> other filesystems and is beeing reverted in mianline.

It can't be reverted directly (you'll get a build failure) since the
next ext4 patch in this -stable series depends on it.

There's a commit from Ted Ts'o in the ext4 git, "ext4: Use our own
write_cache_pages()", which removes the dependency, but that patch is
not yet in mainline so isn't a -stable candidate. When/if that patch
hits mainline, it can be added to -stable and this patch dropped/reverted.

Jayson
