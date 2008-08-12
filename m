From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: tracepoints in ext4 (and/or ext3?)
Date: Tue, 12 Aug 2008 15:33:02 +0900
Message-ID: <20080812152113.9470.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <48A09E7F.7060605@redhat.com> <20080812032335.GC21194@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: kosaki.motohiro@jp.fujitsu.com, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55895 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYHLGd6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Aug 2008 02:33:58 -0400
In-Reply-To: <20080812032335.GC21194@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, Aug 11, 2008 at 03:18:07PM -0500, Eric Sandeen wrote:
> > As just an initial inquiry, I'm wondering how people would feel about
> > putting some tracepoints (trace_mark()) into ext[34] for monitoring the
> > fs behavior.
> 
> I think it's a great idea!  Do you have some specific tracepoints in
> mind?

I think two viewpoint exist. An administrator want to
  - performance mesurement
  - which IO aborted it, if any error happend.

In addition, OS vendor want to
  - split out fs problem and device problem

So, candidate of tracepints are
  - jbd activity
  - boundary activity between fs and block layer 


I don't fs expert, it is just idea.


