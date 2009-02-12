From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 12579] ext4 filesystem hang
Date: Thu, 12 Feb 2009 12:49:08 -0500
Message-ID: <20090212174908.GA6922@mini-me.lan>
References: <bug-12579-13602@http.bugzilla.kernel.org/> <20090212152406.C59BC108041@picon.linux-foundation.org> <20090212163610.GA10351@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53764 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbZBLSsu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 13:48:50 -0500
Content-Disposition: inline
In-Reply-To: <20090212163610.GA10351@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>> Finally had some time, and I've tracked this down to the
>> page-writeback.c changes since .28 - backing them all out the
>> testcase runs overnight.  Still working out which one and why.  I
>> suppose it's still possible it's an ext4 bug but if so the
>> page-writeback.c changes exposed it.
>> 
>> It's a classic deadlock; I usually have 2 threads stuck, pdflush
>> vs. the livecd creator doing an fsync.  Each is waiting for a page
>> the other has locked.
>
> Two commits which are already in the mainline which fixed some changes
> after .28 are
> 
> 89e1219004b3657cc014521663eeef0744f1c99d
> dcf6a79dda5cc2a2bec183e50d829030c0972aaa
> 

I read Eric's email as saying he tracked it down to the
page-writeback.c changes *after* 2.6.28.  Eric, is that what you
meant?

	    	      	       	    	     - Ted
