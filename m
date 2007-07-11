From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [EXT4 set 4][PATCH 5/5] i_version: noversion mount option to disable inode version updates
Date: Wed, 11 Jul 2007 13:03:46 +0100
Message-ID: <20070711120346.GB26370@infradead.org>
References: <1183275474.4010.132.camel@localhost.localdomain> <20070710163144.21b739f9.akpm@linux-foundation.org> <20070711115716.GU6417@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070711115716.GU6417@schatzie.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2007 at 05:57:17AM -0600, Andreas Dilger wrote:
> Ah, this is the patch to disable i_version updates for Lustre.  I don't
> think any normal user would use this mount option, so I don't know if
> there is a need to document it.

This is a reason to not merge it at all.  If the only user of this is
the out of tree lustre code there is no need to put this in.  I should
rather stay in clusterfs' patchkit.

