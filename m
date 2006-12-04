From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Tue, 5 Dec 2006 10:50:42 +1100
Message-ID: <20061204235042.GS33919298@melbourne.sgi.com>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Nikolai Joukov <kolya@cs.sunysb.edu>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.53.0612041256180.15321@compserv1>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 04, 2006 at 01:33:55PM -0500, Nikolai Joukov wrote:
> As we promised on the linux-ext4 list on October 31, here is the patch
> that adds secure deletion via a trash-bin functionality for ext4.  It is a
> compromise solution that combines secure deletion with the trash-bin support
> (the latter had been requested by even more people than the former :-).

Given that almost all of the code for this uses vfs interfaces and
only a couple of simple filesystem hooks, is there any reason for
this being ext4 specific?  i.e. why aren't you hooking the vfs layer
so we get a single undelete/secure delete implementation for all
filesystems?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
