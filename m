From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: RCU locking issues in jbd2_dev_to_name
Date: Wed, 27 Jul 2011 07:28:27 -0400
Message-ID: <7A69E96B-0763-4440-BE10-A39B808C44FA@mit.edu>
References: <20110727174104.65fb9c1c@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:64102 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848Ab1G0L2d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2011 07:28:33 -0400
In-Reply-To: <20110727174104.65fb9c1c@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 27, 2011, at 3:41 AM, NeilBrown wrote:

> 
> 
> Hi Ted and all,
> 
> I've been exploring RCU usage in the kernel looking for strange things, and
> jbd2_dev_to_name looks particularly strange.  The following patch explains
> and addresses the issues that I found.  Comments welcome.

Yeah its broken.  But I have patches pending for the merge window that solve
it by nuking the function altogether; the problem is calling a function from
TP_PRINTK causes perf to die on the spot, terminating its tracing.  :-(

- Ted

