From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4 ENOSPC Bug
Date: Sat, 29 Nov 2008 16:15:33 -0500
Message-ID: <20081129211533.GG3372@mit.edu>
References: <200811291418.24672.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andres Freund <andres@anarazel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41398 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752501AbYK2VPg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Nov 2008 16:15:36 -0500
Content-Disposition: inline
In-Reply-To: <200811291418.24672.andres@anarazel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 29, 2008 at 02:18:19PM +0100, Andres Freund wrote:
> Hi Ted, Hi Andreas, hi all,
> 
> On a testsystem (spare laptop) with ext4 as root filesystem sometimes the 
> system starts to return ENOSPC to all write/create syscalls.
> Sometimes the system runs without problems, at other times it starts having 
> problems soon after boot.

Hmm.... Is there anything interesting log messages relating to ext4 or
jbd2 showing up in /var/log/messages or in dmesg?

     	     	   		     	   - Ted
