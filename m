From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Date: Wed, 6 May 2009 13:07:46 +0200
Message-ID: <20090506110746.GA25088@lst.de>
References: <20090506104436.GA24047@lst.de> <20090506110354.GG25203@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	Fr?d?ric Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:48801 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759265AbZEFLIB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2009 07:08:01 -0400
Content-Disposition: inline
In-Reply-To: <20090506110354.GG25203@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 06, 2009 at 01:03:54PM +0200, Ingo Molnar wrote:
> i think these markers are still in active use,

It's trivially proveable by grep that there is real no user.
(modulo ad-hoc out of tree modules, which we've never cared about
retaining stuff)

The workflow question is the real one, that's why I can only do it if
Ted is okay with it.
