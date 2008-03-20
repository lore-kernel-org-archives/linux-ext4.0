From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Thu, 20 Mar 2008 16:49:50 -0400
Message-ID: <20080320204950.GA7991@mit.edu>
References: <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com> <20080318022053.GL8368@mit.edu> <47DF35CC.7020604@redhat.com> <20080318042339.GO8368@mit.edu> <47DF5045.1000108@redhat.com> <20080318110145.GQ8368@mit.edu> <47DFBF84.5070207@redhat.com> <20080318135254.GA27000@mit.edu> <47E2B850.2080801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39110 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbYCTUvX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 16:51:23 -0400
Content-Disposition: inline
In-Reply-To: <47E2B850.2080801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2008 at 02:17:36PM -0500, Eric Sandeen wrote:
> Rather than *looking* for extN and size type in the magic first and
> second slots, what if we fill them in there internally, but they will be
> overridden by any other -T options specified.
> 
> Internally, first an extN type is picked up from mkfs.FOO first, or
> defaults fs type if not specified.  Seond, also internally, a size type
> is chosen next from the default size breakpoints.

Yes, this works, as long as we make sure every single filesystem and
size stanza in /etc/mke2fs.conf overrides each other completely.

Hmm.... Actually, as it's currently specified, it's not completely
true that a later parameter completely overrides a later one.  The one
it's not true for is the "features" profile knob, where each specific
filesystem called e2p_edit_features(), so that one particular features
knob is cumulative.

Given that I think my previous proposal of overriding -t is probably
the better one, and concuptally simpler to understand and document.

    	   	    			   	      - Ted
