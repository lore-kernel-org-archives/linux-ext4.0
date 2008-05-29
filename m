From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck: unknown feature flag in journal superblock
Date: Thu, 29 May 2008 16:03:05 -0400
Message-ID: <20080529200305.GG8065@mit.edu>
References: <483EC202.8070408@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42770 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755125AbYE2UDk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 May 2008 16:03:40 -0400
Content-Disposition: inline
In-Reply-To: <483EC202.8070408@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 29, 2008 at 04:47:30PM +0200, Valerie Clement wrote:
> Hi Ted,
>
> I don't know if you are aware of this, when running e2fsck on an ext4 
> filesystem which was mounted with "journal_async_commit" option, the 
> following error is reported:
>
> e2fsck 1.41-WIP (27-Apr-2008)
> Ext3 journal superblock has an unknown incompatible feature flag set.
> Abort<y>?
>
> Seen with e2fsck from the latest next branch (1.41-WIP)

Support for the async journal flag is in the pu branch.  See recent
discussions on the linux-ext4 list.  There is some disagreement about
what is the right way to handle checksum failures, and what is
currently in the kernel is definitely buggy.

						- Ted
