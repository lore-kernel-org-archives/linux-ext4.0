From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 12/17] vfs: pagecache usage optimization for
 pagesize!=blocksize
Date: Mon, 28 Jul 2008 16:09:04 -0700
Message-ID: <20080728160904.f644fb85.akpm@linux-foundation.org>
References: <200807282246.m6SMkaHT032267@imap1.linux-foundation.org>
	<20080728230031.GA22218@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, hifumi.hisashi@oss.ntt.co.jp,
	hch@infradead.org, jack@ucw.cz, linux-ext4@vger.kernel.org,
	nickpiggin@yahoo.com.au
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbYG1XJK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2008 19:09:10 -0400
In-Reply-To: <20080728230031.GA22218@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 28 Jul 2008 19:00:32 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jul 28, 2008 at 03:46:36PM -0700, akpm@linux-foundation.org wrote:
> > From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> > 
> > When we read some part of a file through pagecache, if there is a
> > pagecache of corresponding index but this page is not uptodate, read IO is
> > issued and this page will be uptodate.
> 
> I was under the impression we wanted to do this in a nicer way than 
> the hacky method?

The only description I've seen of "a nicer way" is vague two-word
descriptions of "changing readpage".  Or something.  No indication of
what those changes are, nor who will implement them nor when.

That just isn't solid enough to block a change which has significant
performance benefits.

