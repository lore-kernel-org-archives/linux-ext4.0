From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Date: Wed, 6 May 2009 13:12:43 +0200
Message-ID: <20090506111243.GI25203@elte.hu>
References: <20090506104436.GA24047@lst.de> <20090506110354.GG25203@elte.hu> <20090506110746.GA25088@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Fr?d?ric Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:38205 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935AbZEFLMu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2009 07:12:50 -0400
Content-Disposition: inline
In-Reply-To: <20090506110746.GA25088@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Christoph Hellwig <hch@lst.de> wrote:

> On Wed, May 06, 2009 at 01:03:54PM +0200, Ingo Molnar wrote:
> > i think these markers are still in active use,
> 
> It's trivially proveable by grep that there is real no user.
> (modulo ad-hoc out of tree modules, which we've never cared about
> retaining stuff)

Well, i'll defer to Ted about whether those out of tree uses are 
relevant to ext4. It's not a problem to do this all in a polite way, 
without destroying functionality.

	Ingo
