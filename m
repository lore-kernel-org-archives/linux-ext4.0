From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 tracepoints documentation
Date: Fri, 16 Oct 2009 10:13:25 -0400
Message-ID: <20091016141325.GB8196@mit.edu>
References: <20091016135503.GA2806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jason Baron <jbaron@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54435 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZJPOOH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Oct 2009 10:14:07 -0400
Content-Disposition: inline
In-Reply-To: <20091016135503.GA2806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 16, 2009 at 09:55:03AM -0400, Jason Baron wrote:
> 
> I'm trying to improve the documentation around kernel tracepoints. I
> started a docbook for tracepoints, see:
> http://www.kernel.org/doc/htmldocs/tracepoint/
> 
> The initial lkml postings were:
> 
> 1) http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02647.html
> 2) http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02650.html
> 3) http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02648.html
> 4) http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02651.html
> 
> I was hoping you could add an ext4 chapter to the book and docbook style
> comments as in patch #4 referenced above.

I'll add it to be todo list and I'm certainly supportative, but at the
moment I'm pretty overwhelmed with other tasks, such as a
filesystem/data corruption regression bug that _has_ to be higher
priority (kernel BZ 14354).  Then there are bugs filed where a
corrupted filesystem can cause a crash (BZ 14286 and BZ 14287).  I
don't think personally they are that much of a big deal, but the Red
Hat security team has a tendency to hyperventilate and call these
things DoS bugs, even though if you can insert a USB stick with a
corrupted file system image, you usually can reach the power switch.  :-)

Anyway, documentation is important, but unfortunately it has a
tendency to take a back seat to other issues which we have stacked on
our plate.

Maybe some other ext4 developer may be interested in tackling this.
I've cc'ed the linux-ext4 list.  If someone is willing to take a crack
at creating a patch with the documentation, I'll commit to finding the
time somehow to verify and fix up the documentation patch.

Best regards,

					- Ted
