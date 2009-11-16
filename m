From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: directory blocks must be treated as metadata by
	ext4_forget()
Date: Mon, 16 Nov 2009 08:56:05 -0500
Message-ID: <20091116135605.GS4323@mit.edu>
References: <20091114232912.GF4221@mit.edu> <1258245059-17687-1-git-send-email-tytso@mit.edu> <20091115070447.GA26614@skywalker.linux.vnet.ibm.com> <20091115204346.GE4323@mit.edu> <20091116070146.GA8600@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55650 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZKPN4G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2009 08:56:06 -0500
Content-Disposition: inline
In-Reply-To: <20091116070146.GA8600@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 16, 2009 at 12:31:46PM +0530, Aneesh Kumar K.V wrote:
> May be you want to merge the ext4_remove_blocks changes also. That make
> sure anybody reading code doesn't have to spent time in figuring out
> why ext4_forget is called with metadata = 0 and ext4_free_blocks is called
> with metadata = 1.

Yeah, I suppose so.  The reason why I didn't was because currently
ext4_forget() doesn't get called with metadata = 1 on the
direct/indirect-mapped path for directories and symlinks, and I
figured why not keep things consistent between those two callers of
ext4_forget().

Long term we should probably clean up the indirect path as well, I
suppose, and then remove the safety checks in ext4_free_blocks() and
ext4_forget().  That will save a tiny amount of CPU, which I doubt
anyone except Google will be able to measure or notice.  :-)

              	      	     	     	  - Ted
