From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Oops while going into hibernate
Date: Wed, 12 Jan 2011 11:26:55 -0500
Message-ID: <20110112162655.GA13496@thunk.org>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48533 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1ALQ06 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jan 2011 11:26:58 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 12, 2011 at 02:48:58PM +0100, Sebastian Ott wrote:
> Hi,
> 
> while goning into hibernation right after resuming with
> 2.6.37-05668-g4162cf6 on S390 I get this one:

Hmm... what are you hibernating to?  A swap device?  A file-backed
swap device?

Thanks,

						- Ted
