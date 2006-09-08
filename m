From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC:PATCH 000/002] EXT3: cleanups in preparation for ext4
 clone
Date: Fri, 8 Sep 2006 14:56:17 -0700
Message-ID: <20060908145617.f0d0a32a.akpm@osdl.org>
References: <20060908213914.11498.3272.sendpatchset@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:18638 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751195AbWIHV4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Sep 2006 17:56:21 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <20060908213914.11498.3272.sendpatchset@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 8 Sep 2006 17:39:17 -0400
Dave Kleikamp <shaggy@austin.ibm.com> wrote:

> I'm working on rebasing Mingming's ext4 patches on the -mm tree, and have
> noticed a couple cleanups that would be nice to have in ext3 before the
> code diverges.

Good idea, thanks.

I'll try to get all pending ext3/jbd stuff flushed out for 2.6.19-rc1 and
then we can put a plug in it for a while, get the ext4 copy-n-paste sorted
out.  I'd suggest we aim to do this on the day after 2.6.19-rc1 is tagged. 

Or maybe -rc2.  The road to 2.6.19-rc1 is going to be rough - there's an
unusually large amount of work pending, and there is an unusual (although
still small) amount of overlap between the subsystem trees which people
will need to sort out.  Because of this I expect it will take us more than
the nominal two weeks to reach -rc1.

