From: Theodore Tso <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Tue, 13 Jan 2009 23:40:59 -0500
Message-ID: <20090114044059.GA6222@mit.edu>
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org> <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Arjan van de Ven <arjan@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49066 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZANElE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2009 23:41:04 -0500
Content-Disposition: inline
In-Reply-To: <496D526D.1010402@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 14, 2009 at 02:48:13AM +0000, Arjan van de Ven wrote:
>> Well, Arjan's commit, efaee192: "async: make the final inode deletion
>> an asynchronous event", does change how inodes get deleted, and this
>> looks like a race where an inode is getting deleted during the umount.
>>
>> So I would try reverting commit efaee192 and see if it fixes things
>> before starting a full bisect...
>
> the commit is already reverted before rc1
>

Ah, right.  I see, the async infrastructure is still in fs/super.c,
but the actual code to insert deleted inodes onto the s_async_list was
removed in commit b32714b.  Sorry, that confused me.

OK, so assuming that Venkatesh was using something post-rc1, I can't
suggest anything other than a full bisect.  Sorry....

						- Ted
