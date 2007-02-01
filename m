From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [Resubmit][PATCH 5/5] Secure Deletion and Trash-Bin Support
	for Ext4
Date: Thu, 01 Feb 2007 07:19:58 -0600
Message-ID: <1170335998.12263.4.camel@kleikamp.austin.ibm.com>
References: <Pine.GSO.4.53.0701310955130.28263@compserv1>
	 <1170263470.12392.23.camel@kleikamp.austin.ibm.com>
	 <Pine.GSO.4.53.0701311951100.4753@compserv1>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ezk@cs.sunysb.edu, kolya@cs.sunysb.edu
To: Harry Papaxenopoulos <harry@cs.sunysb.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:41582 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422864AbXBANUC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 08:20:02 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l11DK1vL021287
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 08:20:01 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l11DK1ij492626
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 06:20:01 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l11DK0cs029061
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 06:20:01 -0700
In-Reply-To: <Pine.GSO.4.53.0701311951100.4753@compserv1>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-02-01 at 06:05 -0500, Harry Papaxenopoulos wrote:
> 
> On Wed, 31 Jan 2007, Dave Kleikamp wrote:

> > why not unconditionally goto out here?  if vfs_trash_entry() was
> > successful, the file was successfully moved to the trashbin directory.
> > There is nothing left to be done, right?  Then there's no need for the
> > trashed flag.
> >
> > In fact, the ifdef'ed code should precede the call to get_UCSname(),
> > since we don't need to allocate dname if we move the file to the
> > trashbin, and we leak the allocation if we jump to out:.
> >
> 
> Well the main reason I don't jump to out is to update the inode's
> change time, otherwise I would have unconditionally jumped.

the rename already updates the change time.
> 
> You're right, I used the incorrect label to jump. Should have been "out1"
> instead of "out" so the allocation is freed. Sorry about that.

I'd rather do the allocation after the new code anyway.  It's not needed
at all if we're moving the file to the trashbin.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
