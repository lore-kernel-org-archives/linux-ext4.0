From: Theodore Tso <tytso@mit.edu>
Subject: Re: Performance of ext4
Date: Fri, 20 Jun 2008 04:59:22 -0400
Message-ID: <20080620085922.GH9119@mit.edu>
References: <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de> <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de> <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <20080619155645.GA8582@mit.edu> <485A8C2D.1090806@redhat.com> <20080619174211.GB9119@mit.edu> <Pine.LNX.4.64.0806200812340.3383@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41267 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751292AbYFTJAm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jun 2008 05:00:42 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806200812340.3383@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 20, 2008 at 08:32:52AM +0000, Holger Kiehl wrote:
>> It sounds like i_size is actually dropping in
>> size at some pointer long after the file was written.  If I had to

sorry, "at some point"...
            
>> guess the value in the inode cache is correct; and perhaps so is the
>> value on the journal.  But somehow, the wrong value is getting written
>> to disk 

Or, "the right value is never getting written to disk".  (Which as I
think about it is more likely; it's likely that an update to i_size is
getting *lost*, perhaps because the delalloc code is possibly
modifying i_size without starting a transaction first.  Again this is
just a guess.)

> What I find strange is that the missing parts of the file are not for
> example exactly 512 or 1024 or 4096 bytes it is mostly some odd number
> of bytes.

Is there any chance the truncation point is related to how the program
is writing its output file?  i.e., if it is a text file, is the
truncation happening after a new-line or when the stdio library might
have done an explicit or implicit fflush()?

							- Ted
