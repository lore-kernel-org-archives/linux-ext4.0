From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are no dirty pages.
Date: Wed, 30 Jun 2010 13:05:16 -0600
Message-ID: <3763478A-2A1C-4F41-8464-41B1249E55DC@dilger.ca>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <20100504154553.GA22777@infradead.org> <20100630124832.GA1333@thunk.org> <4C2B44C0.3090002@redhat.com> <20100630134429.GE1333@thunk.org> <4C2B4C98.80208@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55366 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab0F3TFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2010 15:05:18 -0400
In-Reply-To: <4C2B4C98.80208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-06-30, at 07:54, Ric Wheeler wrote:
> On 06/30/2010 09:44 AM, tytso@mit.edu wrote:
>> We track whether or not there is any metadata updates associated with
>> the inode already; if it does, we force a journal commit, and this
>> implies a barrier operation.
>> 
>> The case we're talking about here is one where either (a) there is no
>> journal, or (b) there have been no metadata updates (I'm simplifying a
>> little here; in fact we track whether there have been fdatasync()- vs
>> fsync()- worthy metadata updates), and so there hasn't been a journal
>> commit to do the cache flush.
>> 
>> In this case, we want to track when is the last time an fsync() has
>> been issued, versus when was the last time data blocks for a
>> particular inode have been pushed out to disk.
> 
> I think that the state that we want to track is the last time the write cache on the target device has been flushed. If the last fsync() did do a full barrier, that would be equivalent :-)

We had a similar problem in Lustre, where we want to ensure the integrity of some data on disk, but don't want to force an extra journal commit/barrier if there was already one since the time the write was submitted and before we need it to be on disk.

We fixed this in a similar manner but it is optimized somewhat.  In your case there is a flag on the inode in question, but you should also registered a journal commit callback after the IO has been submitted that clears the flag when the journal commits (which also implies a barrier).  This avoids a gratuitous barrier if fsync() is called on this (or any other similarly marked) inode after the journal has already issued the barrier.

The best part is that this gives "POSIXly correct" semantics for applications that are issuing the f{,data}sync() on the modified files, without penalizing them again if the journal happened to do this already in the background in aggregate.

Cheers, Andreas





