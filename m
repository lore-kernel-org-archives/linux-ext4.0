From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3: kernel BUG at fs/jbd/journal.c:412!
Date: Thu, 6 Nov 2008 12:32:36 -0500
Message-ID: <20081106173236.GE18939@mit.edu>
References: <20081106155025.GE25194@skywalker> <20081106161227.GA9254@ajones-laptop.nbttech.com> <20081106171322.GD18939@mit.edu> <20081106171639.GH25194@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arthur Jones <ajones@riverbed.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50217 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751762AbYKFRck (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 12:32:40 -0500
Content-Disposition: inline
In-Reply-To: <20081106171639.GH25194@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 06, 2008 at 10:46:39PM +0530, Aneesh Kumar K.V wrote:
> 
> you would need the same patch for jbd2

I know, already done, and checked into the ext4 patch queue.

  		      	  	       - Ted
