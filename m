From: Theodore Tso <tytso@mit.edu>
Subject: Re: Zero length files - an alternative approach?
Date: Mon, 30 Mar 2009 10:06:59 -0400
Message-ID: <20090330140659.GH13356@mit.edu>
References: <87bprka9sg.fsf@newton.gmurray.org.uk> <yw1xab744lqi.fsf@thrashbarg.mansr.com> <1238416886.30488.6.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57019 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZC3OHH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Mar 2009 10:07:07 -0400
Content-Disposition: inline
In-Reply-To: <1238416886.30488.6.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 30, 2009 at 08:41:26AM -0400, Chris Mason wrote:
> > 
> > Consider this scenario:
> > 
> > 1. Create/write/close newfile
> > 2. Rename newfile to oldfile
> 
> 2a. create oldfile again
> 2b. fsync oldfile
> 
> > 3. Open/read oldfile.  This must return the new contents.
> > 4. System crash and reboot before delayed allocation/flush complete
> > 5. Open/read oldfile.  Old contents now returned.
> > 
> 
> What happens to the new generation of oldfile?  We could insert
> dependency tracking so that we know the fsync of oldfile is supposed to
> also fsync the rename'd new file.  But then picture a loop of operations
> doing renames and creating files in the place of the old one...that
> dependency tracking gets ugly in a hurry.

If there are any calls to link(2) to create hard links to oldfile or
newfile intermingled in this sequence, life also gets very
entertaining.

> Databases know how to do all of this, but filesystems don't implement
> most of the database transactional features.

Yep, we'd have to implement a rollback log to get this right, which
would also impact performance.  My guess is that just aggressively
forcing out the data write before the rename() is going to cost less
in performance, and is certainly much easier to implement.

   		       		      	     - Ted
