From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 12/17] vfs: pagecache usage optimization for pagesize!=blocksize
Date: Tue, 29 Jul 2008 11:11:42 +1000
Message-ID: <200807291111.42941.nickpiggin@yahoo.com.au>
References: <200807282246.m6SMkaHT032267@imap1.linux-foundation.org> <20080728230031.GA22218@infradead.org> <20080728160904.f644fb85.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	torvalds@linux-foundation.org, hifumi.hisashi@oss.ntt.co.jp,
	jack@ucw.cz, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:27129 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750819AbYG2BLz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2008 21:11:55 -0400
In-Reply-To: <20080728160904.f644fb85.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 29 July 2008 09:09, Andrew Morton wrote:
> On Mon, 28 Jul 2008 19:00:32 -0400
>
> Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, Jul 28, 2008 at 03:46:36PM -0700, akpm@linux-foundation.org wrote:
> > > From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
> > >
> > > When we read some part of a file through pagecache, if there is a
> > > pagecache of corresponding index but this page is not uptodate, read IO
> > > is issued and this page will be uptodate.
> >
> > I was under the impression we wanted to do this in a nicer way than
> > the hacky method?
>
> The only description I've seen of "a nicer way" is vague two-word
> descriptions of "changing readpage".  Or something.  No indication of
> what those changes are, nor who will implement them nor when.
>
> That just isn't solid enough to block a change which has significant
> performance benefits.

Yes I thought it would be nicer to do it by changing readpage, but I
said I'm happy to try to consolidate them myself down the track. It
is fairly low impact on core code.
