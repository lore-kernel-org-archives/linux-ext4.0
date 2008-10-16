From: Theodore Tso <tytso@mit.edu>
Subject: Re: panic on boot at ext4_mb_poll_new_transaction
Date: Thu, 16 Oct 2008 10:30:35 -0400
Message-ID: <20081016143035.GA10825@mit.edu>
References: <20081016070735.GA28486@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Michael Spang <mspang@csclub.uwaterloo.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33846 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755624AbYJPOai (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 10:30:38 -0400
Content-Disposition: inline
In-Reply-To: <20081016070735.GA28486@csclub.uwaterloo.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 16, 2008 at 03:07:35AM -0400, Michael Spang wrote:
> I switched my laptop over to ext4 yesterday. Then I used tune2fs to
> enable the features from mke2fs.conf's defaults for ext4 (some failed).
> 
> It worked fine initially but today I am getting a panic when the machine
> boots: http://csclub.uwaterloo.ca/~mspang/panic.jpg .
> 
> Let me know if there's anything I can do to rescue it. Otherwise I'll
> just reinstall.

What version of the kernel are you using, and what patches (if any)
have you installed?  Are you using a distribution kernel?

							- Ted
