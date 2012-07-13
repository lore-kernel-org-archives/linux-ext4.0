From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
Date: Fri, 13 Jul 2012 13:42:09 -0400
Message-ID: <20120713174209.GC17109@thunk.org>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
 <1342185555-21146-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	achender@linux.vnet.ibm.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1342185555-21146-2-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Lukas,

This patch set has changes to the VFS, XFS, and ext4, and there are
cross dependencies between them.  Is there any way you can disentagle
the dependencies between the patches so we don't need to worry about
how these get pulled in during the merge window?

I suppose could try to get the XFS folks to sign off with my carrying
this patch in the ext4 tree, since the bulk of the changes are
ext4-related, but it is a bit of a complication.

	      	     	      	 - Ted
