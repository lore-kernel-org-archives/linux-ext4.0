From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 4/4] ext4: replace __FUNCTION__ occurrences
Date: Sun, 13 Jul 2008 21:08:28 -0400
Message-ID: <20080714010828.GD7938@mit.edu>
References: <200807130626.m6D6QMvj007916@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org, stoyboyker@gmail.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46987 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753841AbYGNBIl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jul 2008 21:08:41 -0400
Content-Disposition: inline
In-Reply-To: <200807130626.m6D6QMvj007916@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 12, 2008 at 11:26:21PM -0700, akpm@linux-foundation.org wrote:
> From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
> 
> __FUNCTION__ is gcc-specific, use __func__ instead
> 

Thanks, applied.

						- Ted
