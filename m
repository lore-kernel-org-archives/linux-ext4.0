From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: booked-page-flag.patch
Date: Fri, 16 Feb 2007 10:02:37 -0600
Message-ID: <1171641757.8468.9.camel@kleikamp.austin.ibm.com>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
	 <45D495EA.3060200@redhat.com> <m3k5yj49bw.fsf@bzzz.home.net>
	 <20070215125654.b0f18ab3.akpm@linux-foundation.org>
	 <m3fy973z9w.fsf@bzzz.home.net>
	 <20070215152352.6ddcfa92.akpm@linux-foundation.org>
	 <m3sld636g0.fsf@bzzz.home.net>
	 <20070215234640.d52e5908.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44348 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426AbXBPQC5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Feb 2007 11:02:57 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1GG2uBo028809
	for <linux-ext4@vger.kernel.org>; Fri, 16 Feb 2007 11:02:56 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1GG2eVv302350
	for <linux-ext4@vger.kernel.org>; Fri, 16 Feb 2007 11:02:40 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1GG2d1H023918
	for <linux-ext4@vger.kernel.org>; Fri, 16 Feb 2007 11:02:39 -0500
In-Reply-To: <20070215234640.d52e5908.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-02-15 at 23:46 -0800, Andrew Morton wrote:
> On Fri, 16 Feb 2007 10:30:39 +0300 Alex Tomas <alex@clusterfs.com> wrote:
> > hmm. I thought it has to call get_block() at least to know whether
> > the block is already allocated. and I was going to reserve space
> > in prepare_write for which some fs-specific method is needed becase
> > only fs knows how much metadata it'd need.
> 
> Well, one could just assume that the page has no disk mapping and go and
> make the space reservation.  Things will work out OK when we come to do
> writepage().
> 
> Or one could do both: call get_block() only if the page was inside i_size.

Or call get_block() with create = 0.  Or replace the create argument
with a flags field that can take either GET_BLOCK_CREATE or
GET_BLOCK_RESERVE.
-- 
David Kleikamp
IBM Linux Technology Center
