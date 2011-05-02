From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Need of revoke mechanism in JBD
Date: Mon, 2 May 2011 10:43:55 -0400
Message-ID: <20110502144355.GF2819@thunk.org>
References: <4DB68257.4070407@gmail.com>
 <BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
 <BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
 <20110426122558.GF9486@thunk.org>
 <BANLkTin35yOg+ndy3i4vTT7RHxtFso+HCA@mail.gmail.com>
 <20110501222813.GD2819@thunk.org>
 <BANLkTimaR0n-YmtBe6xWKCkOc+PoBNa72w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ding Dinghua <dingdinghua85@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Niraj Kulkarni <kulkarniniraj14@gmail.com>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36355 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909Ab1EBOn4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 10:43:56 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTimaR0n-YmtBe6xWKCkOc+PoBNa72w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 01:42:48PM +0300, Amir Goldstein wrote:
> 
> Clearly, at the time of this talk, revoke code was still on the design table
> and committed_data is not mentioned, so either it was not introduced yet
> or just wasn't in the scope of the talk.

No, the revoke code was already implemented when he gave the talk.

   "The way we're doing that in EXT3 is that deleting metadata can
   cause a revoke record to be written into the journal. And when you
   do the replay of the journal, the very first pass of the journal
   recovery, we look for all of the revoke records and make sure that
   any data that's been revoked is never, ever replayed. And so that
   deals with that particular case."

Stephen gave the talk in July, 2000.  Journal support was first
supported in e2fsprogs 1.20 (released May 2000), and we fixed a bug in
the revoke handling in e2fsprogs 1.21 (released June 2000).  Data
journalling mode (only) came first, and was working by late 1999;
indeed we couldn't do ordered or writeback journaling at all until we
had support for the revoke handling, for reasons which he explained in
his talk.

						- Ted
