From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: config: silence printf format warnings
Date: Tue, 8 Jan 2013 21:06:22 -0500
Message-ID: <20130109020621.GA26635@thunk.org>
References: <20130104202711.GA22365@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42434 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab3AICGX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jan 2013 21:06:23 -0500
Content-Disposition: inline
In-Reply-To: <20130104202711.GA22365@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 04, 2013 at 10:27:12AM -0000, Eric Whitney wrote:
> The printfs in the asm_types.c code contained within parse-types.sh
> expect sizeof to return an int.  Fix this for architectures where
> this isn't true (x86_64, etc.) so we don't see warning messages while
> running the configure script.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

					- Ted
