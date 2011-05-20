From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix possible use-after-free
 ext4_remove_li_request()
Date: Fri, 20 May 2011 13:42:41 -0400
Message-ID: <20110520174241.GC29282@thunk.org>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
 <1304956630-20384-4-git-send-email-lczerner@redhat.com>
 <4DD57827.9060104@redhat.com>
 <alpine.LFD.2.00.1105201122510.5226@dhcp-27-109.brq.redhat.com>
 <20110520160313.GA29282@thunk.org>
 <alpine.LFD.2.00.1105201809320.5226@dhcp-27-109.brq.redhat.com>
 <20110520173946.GB29282@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58019 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab1ETRmt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 13:42:49 -0400
Content-Disposition: inline
In-Reply-To: <20110520173946.GB29282@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 20, 2011 at 01:39:46PM -0400, Ted Ts'o wrote:
> On Fri, May 20, 2011 at 06:16:34PM +0200, Lukas Czerner wrote:
> > 
> > I already did send it as a separate patch series with the version
> > description.
> 
> What, you mean the -v2 patch series?
> 
> 
> So let me rephrase the question:  Is -v2 your final answer?

Ah, never mind.  I got confused when with the other patch series where
half the patches where -v3, and the other half were -v2.  It makes
what shows up in patchwork hard to follow.  In the future, please bump
the version number on the entire series, not just on individual
patches, as it makes it a lot easier for me to track what is going
on....

						- Ted
