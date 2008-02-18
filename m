From: Theodore Tso <tytso@mit.edu>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Mon, 18 Feb 2008 10:11:19 -0500
Message-ID: <20080218151119.GC25098@mit.edu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218131209.GB21080@cs181133002.pp.htv.fi> <20080218133140.GA21635@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian Bunk <bunk@kernel.org>, Andreas Dilger <adilger@sun.com>,
	sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57737 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752937AbYBRPLw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 10:11:52 -0500
Content-Disposition: inline
In-Reply-To: <20080218133140.GA21635@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2008 at 02:31:40PM +0100, Ingo Molnar wrote:
> i guess this explains what static code metrics already suggest:

Am I right in assuming that code-quality is just a program which runs
checkpatch.pl and measures the number of warnings and calls them
errors?

					- Ted
