From: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Subject: Re: [PATCH, RFC] jbd2: don't write non-commit blocks synchronously
Date: Thu, 6 Mar 2014 18:28:01 +0100
Message-ID: <20140306172801.GA12751@xanadu.blop.info>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140306135642.GA22136@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xanadu.blop.info ([178.79.145.134]:35116 "EHLO xanadu.blop.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaCFR2M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 12:28:12 -0500
Content-Disposition: inline
In-Reply-To: <20140306135642.GA22136@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/03/14 at 08:56 -0500, Theodore Ts'o wrote:
> On Wed, Mar 05, 2014 at 03:13:43PM +0100, Lucas Nussbaum wrote:
> > TL;DR: we experience long temporary hangs when doing multiple mount -o
> > remount at the same time as other I/O on an ext4 filesystem.
> 
> Hi Lukas,
> 
> Thanks for this report.  Are you willing to try a kernel patch?  If
> so, could you try and see if this fixes your issue.  From looking at
> your block trace, I saw a large number of suspicious 4k writes from
> the jbd2 layer.

Hi Ted,

This patch doesn't solve the problem. It seems that on average, it makes
the situation worse, but I'm not sure if this is just anecdotical
evidence or statistically valid.

Anything else I could try to gather more information?

Lucas
