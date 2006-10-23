From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Mon, 23 Oct 2006 18:31:40 +0400
Message-ID: <m3vembnlwz.fsf@bzzz.home.net>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz>
	<20061023141641.GA29649@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061023141641.GA29649@thunk.org> (Theodore Tso's message of "Mon, 23 Oct 2006 10:16:41 -0400")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Theodore Tso (TT) writes:

 TT> On Mon, Oct 23, 2006 at 02:27:10PM +0200, Jan Kara wrote:
 >> Hello,
 >> 
 >> I've written a simple patch implementing ext3 ioctl for file
 >> relocation. Basically you call ioctl on a file, give it list of blocks
 >> and it relocates the file into given blocks (provided they are still
 >> free). The idea is to use it as a kernel part of ext3 online
 >> defragmenter (or generally disk access optimizer). 

isn't that a kernel responsbility to find/allocate target blocks?
wouldn't it better to specify desirable target group and minimal
acceptable chunk of free blocks?

thanks, Alex
