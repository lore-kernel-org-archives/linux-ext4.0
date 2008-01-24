From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 41/49] ext4: Add multi block allocator for ext4
Date: Thu, 24 Jan 2008 20:23:00 +0530
Message-ID: <20080124145300.GD14348@skywalker>
References: <1200970948-17903-35-git-send-email-tytso@mit.edu> <1200970948-17903-36-git-send-email-tytso@mit.edu> <1200970948-17903-37-git-send-email-tytso@mit.edu> <1200970948-17903-38-git-send-email-tytso@mit.edu> <1200970948-17903-39-git-send-email-tytso@mit.edu> <1200970948-17903-40-git-send-email-tytso@mit.edu> <1200970948-17903-41-git-send-email-tytso@mit.edu> <1200970948-17903-42-git-send-email-tytso@mit.edu> <20080123140727.f47e9c9d.akpm@linux-foundation.org> <20080124075614.GA14348@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	alex@clusterfs.com, adilger@clusterfs.com, sandeen@redhat.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:57175 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYAXOxG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 09:53:06 -0500
Content-Disposition: inline
In-Reply-To: <20080124075614.GA14348@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 24, 2008 at 01:26:14PM +0530, Aneesh Kumar K.V wrote:
> 
> > 
> > > +/* find most significant bit */
> > > +static int fmsb(unsigned short word)
> > > +{
> > > +	int order;
> > > +
> > > +	if (word > 255) {
> > > +		order = 7;
> > > +		word >>= 8;
> > > +	} else {
> > > +		order = -1;
> > > +	}
> > > +
> > > +	do {
> > > +		order++;
> > > +		word >>= 1;
> > > +	} while (word != 0);
> > > +
> > > +	return order;
> > > +}
> > 
> > Did we just reinvent fls()?
> 
> replaced by fls.
> 
> > 

That should be fls() - 1;

The full patch is at

http://www.radian.org/~kvaneesh/ext4/jan-24-2008/mballoc-core.patch

The patch is too big to inline.

-aneesh
