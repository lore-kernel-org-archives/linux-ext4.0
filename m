From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4-lazy (SMR-optimizations) landing to kernel?
Date: Mon, 10 Apr 2017 20:23:34 -0700
Message-ID: <20170411032334.GA5066@birch.djwong.org>
References: <6B0F0C59-6930-41B3-8EE4-EA5BEECEB9F9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ts'o Theodore" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38111 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdDKDXp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Apr 2017 23:23:45 -0400
Content-Disposition: inline
In-Reply-To: <6B0F0C59-6930-41B3-8EE4-EA5BEECEB9F9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 10, 2017 at 09:06:23PM -0600, Andreas Dilger wrote:
> Hi Ted,
> now that FAST'17 is behind us, is there any plan to land the ext4-lazy code
> (SMR optimizations) to the upstream kernel?  This looks like it improves
> some workloads even without SMR disks, and doesn't have any noticeable
> overhead for other workloads.
> 
> I'd guess the one thing that we might want to do is still allow the journal
> to optionally checkpoint the metadata to the filesystem in the background,
> when the filesystem is otherwise idle, so that in case of journal loss for
> some reason the whole filesystem is not lost?

Don't forget to fix jbd2_bh_submit_read to behave when JBD2_FLAG_ESCAPE
is set on a journal data block.

--D

> 
> Cheers, Andreas
> 
> 
> 
> 
> 
