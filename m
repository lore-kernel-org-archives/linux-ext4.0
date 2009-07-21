From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Using O_DIRECT in ext4
Date: Tue, 21 Jul 2009 14:08:05 -0700
Message-ID: <1248210485.18500.2.camel@bobble.smo.corp.google.com>
References: <d5ca277e0907201841i18b83bb6uea757e83d177bc9b@mail.gmail.com>
	 <4A6538DB.5050202@redhat.com>
	 <6601abe90907210745k3730f74dq62f1fe6539722b4d@mail.gmail.com>
	 <4A65EEF3.9090507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Curt Wohlgemuth <curtw@google.com>, Xiang Wang <xiangw@google.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:21572 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZGUVI3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 17:08:29 -0400
In-Reply-To: <4A65EEF3.9090507@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-07-21 at 11:38 -0500, Eric Sandeen wrote:
> Curt Wohlgemuth wrote:
> > On Mon, Jul 20, 2009 at 8:41 PM, Eric Sandeen<sandeen@redhat.com> wrote:
> >> Xiang Wang wrote:
> 
> >>> For comparison, I did the same experiment on an ext2 partition,
> >>> resulting in each file having only 1 extent.
> >> Interestinng, not sure I would have expected that.
> > 
> > Same with us; we're looking into more variables to understand it.
> 
> To be more clear, I would not have expected ext2 to deal well with it
> either, is more what I meant ;)  I'm not terribly surprised that ext4
> gets fragmented.

Ext2 deals with it via the block reservation code added some time ago.
It turns out it works pretty well for this case.  Ext4, of course,
doesn't use the block reservation code.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

