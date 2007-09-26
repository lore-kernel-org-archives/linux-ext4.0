From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] JBD/ext34 cleanups: convert to kzalloc
Date: Wed, 26 Sep 2007 14:05:51 -0700
Message-ID: <1190840751.4517.14.camel@localhost.localdomain>
References: <1189796027.3841.6.camel@localhost.localdomain>
	 <1190057391.3845.22.camel@localhost.localdomain>
	 <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
	 <1190069851.6725.6.camel@localhost.localdomain>
	 <20070918090407.GA671@infradead.org>
	 <1190133347.3819.6.camel@localhost.localdomain>
	 <1190138690.6528.23.camel@norville.austin.ibm.com>
	 <1190163601.3819.15.camel@localhost.localdomain>
	 <20070918191920.a2130a3c.akpm@linux-foundation.org>
	 <1190229352.4318.12.camel@localhost.localdomain>
	 <20070919194813.GT32520@schatzie.adilger.int>
	 <1190239431.4318.34.camel@localhost.localdomain>
	 <1190416436.11349.13.camel@localhost.localdomain>
	 <20070926125440.36c3cb5b.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762937AbXIZVGk@vger.kernel.org>
In-Reply-To: <20070926125440.36c3cb5b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-09-26 at 12:54 -0700, Andrew Morton wrote:
> On Fri, 21 Sep 2007 16:13:56 -0700
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Convert kmalloc to kzalloc() and get rid of the memset().
> 
> I split this into separate ext3/jbd and ext4/jbd2 patches.  It's generally
> better to raise separate patches, please - the ext3 patches I'll merge
> directly but the ext4 patches should go through (and be against) the ext4
> devel tree.
> 
Sure. The patches(including ext3/jbd and ext4/jbd2) were merged into
ext4 devel tree already, I will remove the ext3/jbd part out of the ext4
devel tree.

> I fixed lots of rejects against the already-pending changes to these
> filesystems.
> 
> You forgot to remove the memsets in both start_this_handle()s.
> 
Thanks for catching this.

Mingming
