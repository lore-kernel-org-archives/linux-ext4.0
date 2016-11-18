From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: use more strict checks for inodes_per_block on
 mount
Date: Fri, 18 Nov 2016 16:56:30 -0500
Message-ID: <20161118215630.ubdxrgo2rmtapoap@thunk.org>
References: <20161118183842.25682-1-tytso@mit.edu>
 <20161118183842.25682-3-tytso@mit.edu>
 <20161118203046.GB100623@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kernel@kyup.com,
        bp@alien8.de, stable@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161118203046.GB100623@google.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 18, 2016 at 12:30:46PM -0800, Eric Biggers wrote:
> On Fri, Nov 18, 2016 at 01:38:41PM -0500, Theodore Ts'o wrote:
> > Centralize the checks for inodes_per_block and be more strict to make
> > sure the inodes_per_block_group can't end up being zero.
> 
> Nit: this should say 's_inodes_per_group', not 'inodes_per_block_group'.
> > 
> > +	    sbi->s_inodes_per_group > blocksize * 8) {
> > +		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
> > +			 sbi->s_blocks_per_group);
> > +		goto failed_mount;
> > +	}
> 
> Should print out s_inodes_per_group, not s_blocks_per_group.

Thanks, good catch.  I'll fix both of these.

					- Ted
