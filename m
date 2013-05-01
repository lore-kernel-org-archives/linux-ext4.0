From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fsck memory usage
Date: Wed, 1 May 2013 00:09:19 -0400
Message-ID: <20130501040919.GA22839@thunk.org>
References: <CAEUQceh3Wm6LZpGQnXNjh0c9WbO8S70D5-KYjY8anup80WbLHQ@mail.gmail.com>
 <20130417230745.GC5401@thunk.org>
 <CAEUQceh8oX9TsOR-rtn44QtegGSGH_+QHm9GPcoVPqHGJMhWHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45645 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3EAEJW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 May 2013 00:09:22 -0400
Content-Disposition: inline
In-Reply-To: <CAEUQceh8oX9TsOR-rtn44QtegGSGH_+QHm9GPcoVPqHGJMhWHw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 01, 2013 at 08:12:14AM +0530, Subranshu Patel wrote:
> 
> I used the sar command for tracking memory usage. The total memory
> usage reported by sar command is around 8GB, but it includes the
> buffer and cache memory.
> 
> memused = 8GB
> 
> buffer = 6.7GB
> 
> cache = negligible (some MBs)
> 
> So I think the effective memory usage will be 1.3GB (8 - 6.7). So the
> memory reported under buffer and cache is available for use (if any
> other process requires it). Please correct my understanding.

Yes, in general this is true.  I'm curious why you are you don't just
use /usr/bin/time, though.

						- Ted
