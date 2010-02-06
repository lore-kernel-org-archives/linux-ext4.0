From: tytso@mit.edu
Subject: Re: [PATCH] libss: add newer libreadline to dlopen path
Date: Sat, 6 Feb 2010 08:01:56 -0500
Message-ID: <20100206130156.GC321@thunk.org>
References: <4B5E6D5A.9000900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44606 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab0BFNB5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Feb 2010 08:01:57 -0500
Content-Disposition: inline
In-Reply-To: <4B5E6D5A.9000900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 25, 2010 at 10:19:38PM -0600, Eric Sandeen wrote:
> Rawhide now has libreadline.so.6 ... add it to the ever-expanding
> list of libs to look for.
> 
> Unfortunately without commit 06ef971be505678ee462ae1844204ed24f14aedc
> this fails in a rather cryptic way.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
