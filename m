From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 13:02:24 -0400
Message-ID: <20061025170224.GB19513@havoc.gtf.org>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com> <20061024194416.GB16087@thunk.org> <20061024230020.GZ3509@schatzie.adilger.int> <20061025145450.GF21082@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@clusterfs.com, Theodore Tso <tytso@mit.edu>,
	David Chinner <dgc@sgi.com>, Alex Tomas <alex@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061025145450.GF21082@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 04:54:50PM +0200, Jan Kara wrote:
>   Yes, this sounds feasible. We could split the defrag ioctl into two
> pieces (addition of given extent to a file and swapping of extents), which
> can have generic interface... 

An ioctl is UGLY.

This was discussed years ago.  Google for 'Alexander Viro' and
'ext2meta'.  That's a clean, flexible, extensible way to access metadata
online.  No need for ioctl binary translation across 32bit<->64bit, or
any other ioctl issue.

	Jeff



