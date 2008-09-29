From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Mon, 29 Sep 2008 18:10:50 -0400
Message-ID: <20080929221050.GJ10831@mit.edu>
References: <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu> <20080914134859.GB21746@infradead.org> <20080914175810.GB13074@mit.edu> <20080915144948.GB16491@infradead.org> <20080915175305.GS4563@wotan.suse.de> <20080916213106.GA10562@mit.edu> <20080920164759.GY27404@josefsipek.net> <20080929010720.GH8711@mit.edu> <20080929211340.GF4563@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Anton Altaparmakov <aia21@cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080929211340.GF4563@wotan.suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 29, 2008 at 02:13:40PM -0700, Mark Fasheh wrote:
> Why not let this sit in -mm for a cycle? I know how that sounds, considering
> how long it's taken everyone to decide what color to paint the bicycle shed,
> but at the least it'd give other file systems a chance to write their own
> support patches. There's also the benefit of a little extra time for
> ext4/ocfs2 to debug their own support patches. Do we lose any momentum if
> the patches are 'complete' and in -mm with a target for 2.6.29?

Quite frankly, the reason why I'd rather not is because I'd rather not
have someone else showing up asking what color to paint the bicycle
shed.  We don't have to have all filesystems with support patches
before we merge the core patches; in fact I don't think there's any
real benefit in holding back until other filesystems are ready.  At
least the ext4 patches has been ready for quite some time --- and
getting it merged would help us with our online defrag patches.

      	       	       	   	      	  - Ted
