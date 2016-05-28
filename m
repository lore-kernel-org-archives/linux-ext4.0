From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] Apply LDFLAGS when building tests in lib/e2p
Date: Sat, 28 May 2016 19:34:52 -0400
Message-ID: <20160528233452.GE5730@thunk.org>
References: <1462578003-25315-1-git-send-email-filbranden@google.com>
 <CADU+-uBOXVHUUX4f3xjJmzdDpLwUGNao2R9pKSunMsUKoaqfxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Christopher <echristo@google.com>,
	Michael Forney <forney@google.com>
To: Filipe Brandenburger <filbranden@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43418 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbcE1Xe4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 May 2016 19:34:56 -0400
Content-Disposition: inline
In-Reply-To: <CADU+-uBOXVHUUX4f3xjJmzdDpLwUGNao2R9pKSunMsUKoaqfxw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 26, 2016 at 10:47:54AM -0700, Filipe Brandenburger wrote:
> Hi Ted,
> 
> Can you please include this patch in upstream e2fsprogs git repo?
> 
> This is a complement for 53904ae543591a which added LDFLAGS to the
> test cases but seemed to miss these two...

Applied, thanks.

					- Ted
