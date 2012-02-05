From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 5 Feb 2012 09:55:54 -0700
Message-ID: <9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca>
References: <4F2D8F30.3090802@redhat.com> <201202050933.q159XQpB026380@helium.internal.tigress.co.uk> <4F2EB017.5090006@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ron Yorston <rmy@tigress.co.uk>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:37596 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2BEQzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Feb 2012 11:55:31 -0500
In-Reply-To: <4F2EB017.5090006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-05, at 9:36, Eric Sandeen <sandeen@redhat.com> wrote:
> On 2/5/12 3:33 AM, Ron Yorston wrote:
>> Eric Sandeen wrote:
>>> Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>>> "re-sparsify" a file by punching out ranges of 0s might be in order.
>>> 
>>> I'll see if util-linux wants it after it gets beat into shape.
>>> (or did a tool like this already exist and I missed it?)
> 
> Matthias' suggestion of adding SEEK_HOLE/SEEK_DATA makes very good sense too.

I thought about this, but if SEEK_HOLE/SEEK_DATA (or FIEMAP) worked, then the file would already be sparse, so I don't think that will help in this case...

> I should also untie the read/zero buffer size from the minimum hole size,
> we should do optimal IO sizes regardless of the minimum hole size desired...

Definitely. 4kB IO is a killer for large files.

Cheers, Andreas