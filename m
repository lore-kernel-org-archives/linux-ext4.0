From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 19:31:40 -0500
Message-ID: <20110226003140.GB2924@thunk.org>
References: <E1PsnrK-0005r5-JH@tytso-glaptop>
 <20110225215924.GA28214@noexit>
 <20110225234002.GA2924@thunk.org>
 <20110226000304.GC28214@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39396 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab1BZAbn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Feb 2011 19:31:43 -0500
Content-Disposition: inline
In-Reply-To: <20110226000304.GC28214@noexit>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 25, 2011 at 04:03:04PM -0800, Joel Becker wrote:
> > We could add complexity to do suballocations for directories, but KISS
> > seems to be a much better idea for now.
> 
> 	Oh dear God no.

What are you saying no to?  KISS or suballocations?  :-)

							- Ted
