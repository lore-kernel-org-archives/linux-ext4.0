From: CaT <cat@zip.com.au>
Subject: Re: 2.6.33.1: ext4 disk free weirdness
Date: Tue, 30 Mar 2010 12:44:09 +1100
Message-ID: <20100330014409.GS2657@zip.com.au>
References: <20100329045748.GR2657@zip.com.au> <4BB0BDD2.3080100@redhat.com> <20100329145311.GA4671@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nessie.weebeastie.net ([220.233.7.36]:34711 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754447Ab0C3BoS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 21:44:18 -0400
Content-Disposition: inline
In-Reply-To: <20100329145311.GA4671@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 29, 2010 at 10:53:11AM -0400, tytso@mit.edu wrote:
> This is fixed in commit d330a5bef, which which got merged post
> 2.6.34-rc2, and which we need to get into 2.6.33 stable.  If you
> cherry-pick that commit, I think you'll see that it fixes this
> problem.

As it turns out, that USB drive died soon after so, as soon as I
get a warranty replacement I'll either cherry-pick this or install
the 33 point release with it in. It's kinda wild and wooly with its
speculation. All else fails, I'll use the mount option.

Thanks to both you and Eric for your replies. :)

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
