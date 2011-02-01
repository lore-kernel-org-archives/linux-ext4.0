From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: ext4: Fix clear_buffer_dirty() call for mblk_io_submit writepages path
Date: Tue, 1 Feb 2011 02:37:22 -0500
Message-ID: <3DDF4CC0-B456-425D-A132-A082B27379F2@mit.edu>
References: <AANLkTi=Mzjqoo_QWNLSjhS5CKt9JdTQB6iHEWp_NPuw_@mail.gmail.com> <AANLkTikk-ngjGfWDwryPtMdQ6+660YC3ScpXTHLkKx_A@mail.gmail.com> <4D478A64.7070108@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:56875 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab1BAHh1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Feb 2011 02:37:27 -0500
In-Reply-To: <4D478A64.7070108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jan 31, 2011, at 11:21 PM, Eric Sandeen wrote:

> On 1/31/11 6:15 PM, Curt Wohlgemuth wrote:
>> Sorry:  I forgot to mention that I tested this on 2.6.37 under KVM
>> with the postgresql script specified by Ted in
>> 1449032be17abb69116dbc393f67ceb8bd034f92 -- without this commit, and
>> hence by default using the multiblock writepages submittal code.
>> 
>> Without the patch, I'd hit the corruption problem about 50-70% of the
>> time.  With the patch, I executed the script > 100 times with no
>> corruption seen.
> 
> Can you resubmit with a changelog that indicates it's actually a corruption
> fix?  Maybe even in the summary.  That is important information to have
> for the commit...

Agreed, although I'd also point out that the corruption fix was for code that
was disabled by default before 2.6.37 shipped, precisely because of the
reported corruption bug, and that  this code should make it safe to use
the mblk_io_submit mount option, which will become the default in
2.6.39.

Normally I add such clarifications in the commit description (I'm used to
editing descriptions to correct English and to make things clearer, so for
me this is no big deal), but if you want resubmit with an updated description
and save me some work, I won't complain.  :-)

-- Ted

