From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] ext3: Fix ext3_dx_readdir hash collision handling
Date: Wed, 17 Sep 2008 12:19:43 -0700
Message-ID: <20080917121943.904b66b6.akpm@linux-foundation.org>
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, tytso@MIT.EDU, eugene@ibrix.com,
	msnitzer@ibrix.com, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbYIQTUl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Sep 2008 15:20:41 -0400
In-Reply-To: <1221319971-29879-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 13 Sep 2008 11:32:48 -0400
"Theodore Ts'o" <tytso@MIT.EDU> wrote:

> This fixes a bug where readdir() would return a directory entry twice
> if there was a hash collision in an hash tree indexed directory.

That sounds like a serious problem, but given the amount of time it
took to turn up, I guess it's pretty rare.

What are your thoughts regarding a 2.6.27 merge for this?  2.6.26.x? 
2.6.25.x?  ...

