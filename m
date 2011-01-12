From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: Oops while going into hibernate
Date: Wed, 12 Jan 2011 17:56:37 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:36623 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1ALQ4n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jan 2011 11:56:43 -0500
In-Reply-To: <20110112162655.GA13496@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Wed, 12 Jan 2011, Ted Ts'o wrote:
> On Wed, Jan 12, 2011 at 02:48:58PM +0100, Sebastian Ott wrote:
> > Hi,
> > 
> > while goning into hibernation right after resuming with
> > 2.6.37-05668-g4162cf6 on S390 I get this one:
> 
> Hmm... what are you hibernating to?  A swap device?  A file-backed
> swap device?
swap device.

Regards,
Sebastian
