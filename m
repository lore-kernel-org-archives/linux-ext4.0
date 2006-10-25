From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 00:48:44 -0400
Message-ID: <20061025044844.GB32486@havoc.gtf.org>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Barry Naujok <bnaujok@melbourne.sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, "'Jan Kara'" <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061025042753.GV8394166@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 02:27:53PM +1000, David Chinner wrote:
> But it a race that is _easily_ handled, and applications only need to
> implement one interface, not a different method for every
> filesystem that requires deeep filesystem knowledge.
> 
> Besides, you still have to handle the case where the block you want
> has already been allocated because reading the metadata from
> userspace doesn't prevent the kernel from allocating the block you
> want before you ask for it...

The race is easily handled either way, by having the block move fail
when you tell the kernel the destination blocks.

The difference is that you don't unnecessarily bloat the kernel.

Every major filesystem has a libfoofs library that makes it trivial to
read the metadata, so all you need to do is use an existing lib.

	Jeff



