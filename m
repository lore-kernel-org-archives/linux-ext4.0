From: "Jayson R. King" <dev@jaysonking.com>
Subject: Re: [10/24] vfs: Add no_nrwrite_index_update writeback control flag
Date: Tue, 25 May 2010 12:00:58 -0500
Message-ID: <4BFC024A.9090600@jaysonking.com>
References: <20100524223544.GA13721@kroah.com> <20100524223016.208581966@clark.site> <20100525111208.GA8779@infradead.org> <20100525165230.GA9154@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	"Jayson R. King" <dev@jaysonking.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout12.eigbox.net ([66.96.186.12]:33551 "EHLO
	bosmailout12.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab0EYRdR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 13:33:17 -0400
In-Reply-To: <20100525165230.GA9154@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/25/2010 11:52 AM, Greg KH wrote:
> On Tue, May 25, 2010 at 07:12:08AM -0400, Christoph Hellwig wrote:
>> On Mon, May 24, 2010 at 03:28:06PM -0700, Greg KH wrote:
>>> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
>>
>> NACK.  This has been shown to cause severe writeback regression for
>> other filesystems and is beeing reverted in mianline.
> 
> Ok, if I drop this one, I think I need to drop an ext4 patch as well,
> I'll go figure that out and respin a -rc2 with this change in it.

You'd have to drop the next two ext4 -stable patches to get a buildable
kernel if you drop this one. The last of those ext4 patches is the one
which fixes the deadlock from kernel bugzilla #12579.

Jayson
