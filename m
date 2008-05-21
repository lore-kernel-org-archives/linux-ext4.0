From: Theodore Tso <tytso@mit.edu>
Subject: Re: Theodore Ts'o: please consider dis-ambiguity
Date: Wed, 21 May 2008 11:54:07 -0400
Message-ID: <20080521155407.GI8581@mit.edu>
References: <91b13c310805202023n8c47ebfqef3206a55ead551e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: rae l <crquan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55896 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755222AbYEUPyP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 11:54:15 -0400
Content-Disposition: inline
In-Reply-To: <91b13c310805202023n8c47ebfqef3206a55ead551e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2008 at 11:23:11AM +0800, rae l wrote:
> Theodore:
> please consider delete that tag "origin" in the ext4.git repo:
> 
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git
> 
> as a common case, I cloned a local repo from torvalds/linux-2.6.git
> and fetched from tytso/ext4.git,

Oopts, sorry about that.  Yeah, I should make sure that origin is
properly set up as a branch, not as a tag.

	     	     	     	 - Ted
