From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Wed, 14 Jan 2009 02:48:13 +0000
Message-ID: <496D526D.1010402@linux.intel.com>
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org> <20090114014434.GE14730@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	linux-kerne
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:9672 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751393AbZANCs3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jan 2009 21:48:29 -0500
In-Reply-To: <20090114014434.GE14730@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Jan 13, 2009 at 04:48:42PM -0800, Andrew Morton wrote:
>> Well that's not good.  I don't recall us making any changes which
>> affect the orphan list handling.  Perhaps "filesystem freeze: add error
>> handling of write_super_lockfs/unlockfs", but only indirectly.
>>
>> Does Arjan's new async stuff play with filesystems at umount/shutdown
>> time?  Don't think so.
> 
> Well, Arjan's commit, efaee192: "async: make the final inode deletion
> an asynchronous event", does change how inodes get deleted, and this
> looks like a race where an inode is getting deleted during the umount.
> 
> So I would try reverting commit efaee192 and see if it fixes things
> before starting a full bisect...

the commit is already reverted before rc1

