From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Ext3 online defrag
Date: Tue, 24 Oct 2006 22:42:57 -0400
Message-ID: <20061025024257.GA23769@havoc.gtf.org>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "'David Chinner'" <dgc@sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, "'Jan Kara'" <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Content-Disposition: inline
In-Reply-To: <200610250225.MAA23029@larry.melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 12:30:02PM +1000, Barry Naujok wrote:
> Could we have a more abstract method for asking the filesystem where the 
> free blocks are and then using the same block addressing to tell the
> fs where to allocate/move the file's data to?

That's fundamentally racy, so you might as well just read the
filesystem metadata from userspace.  No need to go through the kernel
for that.

	Jeff



