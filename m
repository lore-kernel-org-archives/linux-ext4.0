From: Theodore Tso <tytso@mit.edu>
Subject: Re: A tree to pull into linux-next
Date: Thu, 16 Jul 2009 07:47:51 -0400
Message-ID: <20090716114751.GE21267@mit.edu>
References: <20090715193742.GA18583@duck.suse.cz> <20090716164826.f4edbd42.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53923 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZGPLsT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 07:48:19 -0400
Content-Disposition: inline
In-Reply-To: <20090716164826.f4edbd42.sfr@canb.auug.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 16, 2009 at 04:48:26PM +1000, Stephen Rothwell wrote:
> 
> I am happy to include this, but (no offense) I would like to hear from
> the ext3 and jbd maintainers (cc'd) about it.
> 

The main isssue would be that akpm often has ext3 changes stashed in
-mm.  Having a separate ext3 tree makes sense, and if Jan wants to
maintain it, that makes good sense to me, but we should get Andrew's
sign off, and Jan should make sure he has any ext3/jbd patches that
might be in -mm, to avoid any potential patch conflicts.

      	    	    	      - Ted
