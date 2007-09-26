From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] JBD/ext34 cleanups: convert to kzalloc
Date: Wed, 26 Sep 2007 12:54:40 -0700
Message-ID: <20070926125440.36c3cb5b.akpm@linux-foundation.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbXIZTyn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2007 15:54:43 -0400
In-Reply-To: <1190416436.11349.13.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 21 Sep 2007 16:13:56 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> Convert kmalloc to kzalloc() and get rid of the memset().

I split this into separate ext3/jbd and ext4/jbd2 patches.  It's generally
better to raise separate patches, please - the ext3 patches I'll merge
directly but the ext4 patches should go through (and be against) the ext4
devel tree.

I fixed lots of rejects against the already-pending changes to these
filesystems.

You forgot to remove the memsets in both start_this_handle()s.
