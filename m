From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 2 Jun 2011 20:43:00 -0400
Message-ID: <20110603004300.GE16306@thunk.org>
References: <20110601215049.GC17449@redhat.com>
 <20110602012209.GQ561@dastard>
 <20110602141716.GD18712@redhat.com>
 <20110602143633.GE18712@redhat.com>
 <20110602155610.GF18712@redhat.com>
 <20110602235153.GV561@dastard>
 <20110603002714.GA27129@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60608 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab1FCAnC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 20:43:02 -0400
Content-Disposition: inline
In-Reply-To: <20110603002714.GA27129@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 08:27:14PM -0400, Vivek Goyal wrote:
> 
> In this case only a single thread is doing IO continuously. I am assuming
> if there is a database using XFS, it is not unreasonable to have prolonged
> periods of continuous IO activity. In that case I think by above design
> sync will not finish until and unless there is a momentary pause in IO. This
> does not sound like the best design choice.

Sure, but under what circumstances would a database be blasting data
using AIO/DIO in one thread, and calling fsync() in another thread?
In practice I don't think this situation should ever arise.  If it
did, the question of which writes could be considered safely on stable
store and which would not would be undefined.  In fact, for most
enterpise databases, they are using preallocated files, so there's no
need at all to use fsync() and AIO/DIO at the same time.

     	       	   	       	       	  - Ted
