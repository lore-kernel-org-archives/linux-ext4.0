From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Mon, 18 Feb 2008 14:31:40 +0100
Message-ID: <20080218133140.GA21635@elte.hu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218131209.GB21080@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:53082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760872AbYBRNcY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 08:32:24 -0500
Content-Disposition: inline
In-Reply-To: <20080218131209.GB21080@cs181133002.pp.htv.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Adrian Bunk <bunk@kernel.org> wrote:

> The following was meant 100% seriously:
> 
> This patch has been sent on:
> - 16 May 2006
> - 1 May 2006
> - 23 Apr 2006

ouch ...

i guess this explains what static code metrics already suggest:

   $ code-quality fs/ext3/ fs/ext4/
                                errors   lines of code   errors/KLOC
   fs/ext3/                        408           16055          25.4
   fs/ext4/                        394           25169          15.6

compared to:

   $ code-quality kernel/
                                errors   lines of code   errors/KLOC
   kernel/                         739           98759           7.4

and i guess our hope is now in:

   $ code-quality fs/btrfs/
                                errors   lines of code   errors/KLOC
   fs/btrfs/                       240           20556          11.6

(which hopefully will be a project done in a much more Linux-ish manner: 
open participation, the easy taking of patches, an inclusive, 
newbie-friendly contribution atmosphere, etc.)

	Ingo

ps. http://redhat.com/~mingo/x86.git/code-quality
