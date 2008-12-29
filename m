From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: [dm-devel] Re: jbd2 inside a device mapper module
Date: Mon, 29 Dec 2008 19:05:37 -0200
Message-ID: <20081229210537.GN4127@blitiri.com.ar>
References: <20081225143535.GA4127@blitiri.com.ar> <20081227200127.GX5000@webber.adilger.int> <46A00B48CC54E4468EF6911F877AC4CA01DDBB66@blrx3m10.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com, Alex.Zhuravlev@sun.com,
	linux-ext4@vger.kernel.org, tytso@MIT.EDU,
	linux-kernel@vger.kernel.org
To: Shyam_Iyer@Dell.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:1064 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYL2VIn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Dec 2008 16:08:43 -0500
Content-Disposition: inline
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CA01DDBB66@blrx3m10.blr.amer.dell.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 29, 2008 at 11:50:14AM +0530, Shyam_Iyer@Dell.com wrote:
> Andreas Dilger wrote:
> > On Dec 25, 2008  12:35 -0200, Alberto Bertogli wrote:
> > > On Wed, Dec 24, 2008 at 06:49:15PM -0500, Theodore Tso wrote:
> > > > I have no idea why you would need to do manual __breads().  No
> doubt
> > > > I'm missing some context here.  
> > >
> > > I'm writing (just for fun and learning purposes) a device mapper
> > > module that stores checksums on writes and verifies them on reads.
> The
> > > integrity metadata (currently just the checksum) is interleaved in
> the
> > > backing device: one sector holding the integrity metadata for the
> > > following 64 data sectors.
> 
> > Alex and I discussed implementing checksums for ext4 using an external
> device like this, and he might have some more design information for
> you.
> 
> 
> That external device could possibly be a TPM chip that can store
> checksums.

Thanks for the suggestion. The code I have at the moment (without the
journal stuff) already has the capability of storing checksums in a
different device. It's one of the reasons why I would prefer to avoid
using jbd.

I think I'll go with the "two metadatas" approach and see how it goes.
Worst case scenario is that I have to drop that code, which means to be
back where I am now, only with one less option.

Thanks,
		Alberto

