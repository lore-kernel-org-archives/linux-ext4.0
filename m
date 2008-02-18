From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Mon, 18 Feb 2008 14:55:09 +0100
Message-ID: <20080218135509.GC28851@elte.hu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218125702.GB15044@elte.hu> <20080218133127.GB12568@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:39940 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYBRNzt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 08:55:49 -0500
Content-Disposition: inline
In-Reply-To: <20080218133127.GB12568@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Theodore Tso <tytso@mit.edu> wrote:

> > So please deal with it like most other subsystem maintainers do and 
> > stop complaining about "code churn" - nobody but you changes the 
> > ext3 codebase, it's one of the codebases least affected by general 
> > kernel flux, it's an ultimate "leaf" subsystem.
> 
> Right, sorry.  I misread the filename; I thought this was against 
> fs/jbd2, instead of fs/jbd.

Btw., if people have problems with rejects from trivial patches, the 
'mpatch' tool does wonders in resolving the easy ones:

  http://oss.oracle.com/~mason/mpatch/

when you get a .rej file, first check whether mpatch can resolve it 
conflict-free:

  mpatch -d kernel/somefile.c.rej

if there are no conflicts then:

  mpatch -a kernel/somefile.c.rej

quilt refresh, review the result and it's done in the majority of cases.

	Ingo
