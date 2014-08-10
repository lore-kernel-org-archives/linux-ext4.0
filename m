From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sun, 10 Aug 2014 17:49:43 -0400
Message-ID: <20140810214943.GL15431@thunk.org>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
 <20140808223335.GQ25145@thunk.org>
 <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
 <20140809172427.GF15431@thunk.org>
 <1407703644.8477.1.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407703644.8477.1.camel@jarvis.lan>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 10, 2014 at 01:47:24PM -0700, James Bottomley wrote:
> 
> Actually, I don't believe that's entirely accurate.  The performance
> problem with shared filesystem roots for containers has meant OpenVZ has
> been using a block root for a while.  However, we still support the old
> shared filesystem root, but for quota's within the chroot, we use a subtree
> quota system (not a project quota) for which Dmitry Monakhov
> posted the patches several times a couple of years ago.

The XFS-compatible project quota is effectively a subtree quota
system.  My argument is that if we're going to try to get something
like this upstream, it should have the same properties as the XFS
project quota system; and that should be semantically compatible with
the patches you are using.

(If we end up using the same ioctl's as xfs_quota uses, which in
theory I'm in favor of, but which I haven't studied yet, then it might
not be ABI compatible with Dmitry's patches, but it should simplify
the patches that OpenVZ would need to carry.)

					- Ted
