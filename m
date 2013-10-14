From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [RFC 01/10] mke2fs.c: add an option: -d root-directory
Date: Mon, 14 Oct 2013 09:26:26 -0700
Message-ID: <1381767986.9489.74.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
	 <1377667560-20089-2-git-send-email-liezhi.yang@windriver.com>
	 <20131014024126.GA24871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Robert Yang <liezhi.yang@windriver.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17273 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748Ab3JNQ00 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Oct 2013 12:26:26 -0400
In-Reply-To: <20131014024126.GA24871@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2013-10-13 at 22:41 -0400, Theodore Ts'o wrote:
> On Wed, Aug 28, 2013 at 01:25:51PM +0800, Robert Yang wrote:
> > @@ -2773,7 +2776,6 @@ no_journal:
> >  		       "filesystem accounting information: "));
> >  	checkinterval = fs->super->s_checkinterval;
> >  	max_mnt_count = fs->super->s_max_mnt_count;
> > -	retval = ext2fs_close(fs);
> >  	if (retval) {
> >  		fprintf(stderr,
> >  			_("\nWarning, had trouble writing out superblocks."));
> 
> You can't just move the call to ext2fs_close().  You also need to move
> 
> 	if (!quiet)
> 		printf(_("Writing superblocks and "
> 		       "filesystem accounting information: "));
> 
> before the call to ext2fs_close() since this is used to print the
> message for the progress information that will be emitted by
> ext2fs_close(), and you also have to move the error checking:
> 
>   	if (retval) {
>   		fprintf(stderr,
>   			_("\nWarning, had trouble writing out superblocks."));
> 	...
> 
> after the call to ext2fs_close().
> 
> 
> This would have been ***painfully*** obvious if you had run the
> regression test suite.  ("make -j8 ; make -j8 check"), since the
> inconsistent move of ext2fs_close() without the preceeding printf
> would cause all of the mke2fs tests (the m_* tests) to fail.
> 
> This is why regression test suites are so important.  :-)
> 
>      	    	       	    	       - Ted

Robert,

Can you please take Ted's feedback into account (this and his response
to patch 10/10) and prepare another version of the patches.

As Ted suggests here, please run the regression test suite prior to any
future patch submissions. Looks like we missed some critical bits by not
doing that.

Ted, thank you for the response and taking the time to point out the
test suite. Robert, could you check the README and see if anything needs
to get updated there to make sure other developers are aware of the
regressions suite and how to run it?

Thanks,


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


