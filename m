From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Date: Tue, 20 May 2008 10:52:38 -0500
Message-ID: <4832F3C6.1050601@redhat.com>
References: <482DDA56.6000301@redhat.com> <482DDC04.7020706@redhat.com> <20080520023454.GM15035@mit.edu> <20080520154313.GI16676@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbYETPxD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 11:53:03 -0400
In-Reply-To: <20080520154313.GI16676@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jamie Lokier wrote:
> Theodore Tso wrote:
>> On Fri, May 16, 2008 at 02:09:56PM -0500, Eric Sandeen wrote:
>>> To ensure that bits are truly on-disk after an fsync,
>>> we should call blkdev_issue_flush if barriers are supported.
>> This patch isn't necessary, and in fact will cause a double flush.
>> When you call fsync(), it calls ext4_force_commit(), and we do a the
>> equivalent of a blkdev_issue_flush() today (which is what happenes
>> when you do a submit_bh(WRITE_BARRIER, bh), which is what setting
>> set_ordered_mode(bh) ends up causing.
> 
> ISTR fsync() on ext3 did not always force a commit, if in-place data
> writes did not change any metadata.

I think that might still be true, but I'm still looking through it (in
the background...)

I tried blktrace to see what was going on but I'm not sure what an "NB"
in the RWBS field means, anyone know?

-Eric

