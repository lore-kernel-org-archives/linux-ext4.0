From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Tue, 24 Oct 2006 09:52:20 -0500
Message-ID: <453E28A4.5020107@redhat.com>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061024135928.GB11034@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

David Chinner wrote:
> The allocation interface, OTOH, is anything but simple and is really
> a filesystem specific interface. Seems logical to me to separate
> the two. 

And ext[234] preallocation would be a very nice feature in its own right.

-Eric
