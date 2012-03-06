From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] ext4: Remove empty index blocks when punching holes
Date: Tue, 6 Mar 2012 11:44:12 -0500
Message-ID: <20120306164412.GD32282@thunk.org>
References: <1330501048-14109-1-git-send-email-achender@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1202290841310.4926@dhcp-27-109.brq.redhat.com>
 <4F4DDE8D.6020203@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1202290916590.4926@dhcp-27-109.brq.redhat.com>
 <20120305235430.GA12796@thunk.org>
 <alpine.LFD.2.00.1203060810430.5085@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48239 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab2CFQoR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 11:44:17 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1203060810430.5085@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 06, 2012 at 08:11:37AM +0100, Lukas Czerner wrote:
> 
> you're right my patches solves this problem (as I wrote in the commit
> description) just because we now use a different code paths, which do
> not have this problem.

Ok, thanks.  I'll look at them before the end of this week.

Just to be clear, have the problematic code paths been removed in your
patches, or are they not just being used in the problem scenario?
Basically, is there any other time where we might need the additional
logic which Allison added?

					- Ted
