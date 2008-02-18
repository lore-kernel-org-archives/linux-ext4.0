From: Theodore Tso <tytso@mit.edu>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Mon, 18 Feb 2008 08:31:28 -0500
Message-ID: <20080218133127.GB12568@mit.edu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218125702.GB15044@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Adrian Bunk <bunk@kernel.org>,
	sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37058 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760471AbYBRNbu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 08:31:50 -0500
Content-Disposition: inline
In-Reply-To: <20080218125702.GB15044@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> So please deal with it like most other subsystem maintainers do and stop 
> complaining about "code churn" - nobody but you changes the ext3 
> codebase, it's one of the codebases least affected by general kernel 
> flux, it's an ultimate "leaf" subsystem.

Right, sorry.  I misread the filename; I thought this was against
fs/jbd2, instead of fs/jbd.

						- Ted
