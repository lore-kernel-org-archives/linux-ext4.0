From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/3] libext2fs: ext2fs_node_split
Date: Sat, 17 May 2008 18:21:14 -0500
Message-ID: <482F686A.5030806@redhat.com>
References: <1210875464-25552-1-git-send-email-sandeen@redhat.com> <1210875464-25552-2-git-send-email-sandeen@redhat.com> <20080517225243.GC16496@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754514AbYEQXVQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 May 2008 19:21:16 -0400
In-Reply-To: <20080517225243.GC16496@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, May 15, 2008 at 01:17:42PM -0500, Eric Sandeen wrote:
>> When called for a given handle, this function  will split the
>> current node such that half of the node's entries will be moved
>> to a new tree block.  The parent will then be updated to point
>> to the (now smaller) original node as well as the new node.
> 
> This patch looks good.  One minor nit; if you're going to define new
> functions which are intended to be exported, then they need to be
> defined in the ext2fs.h header file --- otherwise, it should be
> declared static, to prevent function leakage.  Should
> ext2fs_node_split() be exported?  There doesn't seem to be any reason
> *not* to export it, but at the same time, there doesn't seem to be a
> good reason to export, either.
> 
> I'd tend to keep it static for now; what do other people think?

I'd say static until needed otherwise...

an  _extent_split might be more useful for a public interface;
_node_split is getting awfully low level IMHO.

-Eric
