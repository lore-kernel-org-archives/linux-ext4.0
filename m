From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Tue, 13 Jan 2009 23:24:02 -0500
Message-ID: <20090114042402.GH14730@mit.edu>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081218231707.GB20092@atrey.karlin.mff.cuni.cz> <496D1233.2060905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35337 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZANEYJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2009 23:24:09 -0500
Content-Disposition: inline
In-Reply-To: <496D1233.2060905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 13, 2009 at 04:14:11PM -0600, Eric Sandeen wrote:
> 
> This looks sane to me, and it does fix the below testcase.
> 
> Care to formally propose it?

Can we confirm what is being proposed?  From following this thread, I
think what folks are suggesting is:

1)  Revert the current "ext3/4: wait on all pending ocmmits in ext3/4_sync_fs"

2)  Apply Jan's patch "jbd[2]: Fix return value of journal_start_commit()"

3)  Also apply Jan's patch "jbd2: Skip commit of a transaction without
any buffers" since it appears to be a good optimization (although it's
not clear it would happen once we revert (1), above.

    	     	   	       	  	      - Ted
