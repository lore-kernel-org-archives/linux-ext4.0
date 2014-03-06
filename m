From: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Subject: Re: [PATCH, RFC] jbd2: don't write non-commit blocks synchronously
Date: Thu, 6 Mar 2014 19:37:49 +0100
Message-ID: <20140306183749.GA15122@xanadu.blop.info>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140306135642.GA22136@thunk.org>
 <20140306172801.GA12751@xanadu.blop.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xanadu.blop.info ([178.79.145.134]:36212 "EHLO xanadu.blop.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaCFSjc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 13:39:32 -0500
Content-Disposition: inline
In-Reply-To: <20140306172801.GA12751@xanadu.blop.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/03/14 at 18:28 +0100, Lucas Nussbaum wrote:
> On 06/03/14 at 08:56 -0500, Theodore Ts'o wrote:
> > On Wed, Mar 05, 2014 at 03:13:43PM +0100, Lucas Nussbaum wrote:
> > > TL;DR: we experience long temporary hangs when doing multiple mount -o
> > > remount at the same time as other I/O on an ext4 filesystem.
> > 
> > Hi Lukas,
> > 
> > Thanks for this report.  Are you willing to try a kernel patch?  If
> > so, could you try and see if this fixes your issue.  From looking at
> > your block trace, I saw a large number of suspicious 4k writes from
> > the jbd2 layer.
> 
> Hi Ted,
> 
> This patch doesn't solve the problem. It seems that on average, it makes
> the situation worse, but I'm not sure if this is just anecdotical
> evidence or statistically valid.
> 
> Anything else I could try to gather more information?

Two other data points:
- same problem with a 2.6.29-2-amd64 kernel from Debian
- with that 2.6.29-2-amd64, disabling the journal on the ext4 filesytem
  using 'tune2fs -O ^has_journal /dev/sda5' makes the problem go away
-- 
| Lucas Nussbaum      Assistant professor @ Univ. de Lorraine |
| lucas.nussbaum@loria.fr                   LORIA / AlGorille |
| http://www.loria.fr/~lnussbau/            +33 3 54 95 86 19 |
