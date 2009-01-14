From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Wed, 14 Jan 2009 11:26:49 -0600
Message-ID: <496E2059.8010904@redhat.com>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081218231707.GB20092@atrey.karlin.mff.cuni.cz> <496D1233.2060905@redhat.com> <20090114042402.GH14730@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vg
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55400 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761024AbZANR1S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 12:27:18 -0500
In-Reply-To: <20090114042402.GH14730@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Jan 13, 2009 at 04:14:11PM -0600, Eric Sandeen wrote:
>> This looks sane to me, and it does fix the below testcase.
>>
>> Care to formally propose it?
> 
> Can we confirm what is being proposed?  From following this thread, I
> think what folks are suggesting is:
> 
> 1)  Revert the current "ext3/4: wait on all pending ocmmits in ext3/4_sync_fs"
> 
> 2)  Apply Jan's patch "jbd[2]: Fix return value of journal_start_commit()"

The above seems like the right plan to me.  It should address the
kernel.org bug about IO on idle partitions.

> 3)  Also apply Jan's patch "jbd2: Skip commit of a transaction without
> any buffers" since it appears to be a good optimization (although it's
> not clear it would happen once we revert (1), above.

Maybe not yet, it could probably use more testing/review/soak.

-Eric

>     	     	   	       	  	      - Ted
