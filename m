From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 14:41:18 -0400
Message-ID: <20061025184118.GG19513@havoc.gtf.org>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <20061023151447.GL3509@schatzie.adilger.int> <20061023160310.GB11353@atrey.karlin.mff.cuni.cz> <20061023172906.GO3509@schatzie.adilger.int> <20061025183656.GD9940@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@clusterfs.com, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061025183656.GD9940@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 08:36:56PM +0200, Jan Kara wrote:
>   Yes, but there's a question of the interface to this operation. How to
> specify which indirect block I mean? Obviously we could introduce
> separate call for remapping indirect blocks but I find this solution
> kind of clumsy...

Agreed...  that gets nasty real quick.

	Jeff



