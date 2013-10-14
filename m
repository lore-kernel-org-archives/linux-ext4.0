From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 01/10] mke2fs.c: add an option: -d root-directory
Date: Sun, 13 Oct 2013 22:41:26 -0400
Message-ID: <20131014024126.GA24871@thunk.org>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
 <1377667560-20089-2-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dvhart@linux.intel.com
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45657 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520Ab3JNClb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Oct 2013 22:41:31 -0400
Content-Disposition: inline
In-Reply-To: <1377667560-20089-2-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 28, 2013 at 01:25:51PM +0800, Robert Yang wrote:
> @@ -2773,7 +2776,6 @@ no_journal:
>  		       "filesystem accounting information: "));
>  	checkinterval = fs->super->s_checkinterval;
>  	max_mnt_count = fs->super->s_max_mnt_count;
> -	retval = ext2fs_close(fs);
>  	if (retval) {
>  		fprintf(stderr,
>  			_("\nWarning, had trouble writing out superblocks."));

You can't just move the call to ext2fs_close().  You also need to move

	if (!quiet)
		printf(_("Writing superblocks and "
		       "filesystem accounting information: "));

before the call to ext2fs_close() since this is used to print the
message for the progress information that will be emitted by
ext2fs_close(), and you also have to move the error checking:

  	if (retval) {
  		fprintf(stderr,
  			_("\nWarning, had trouble writing out superblocks."));
	...

after the call to ext2fs_close().


This would have been ***painfully*** obvious if you had run the
regression test suite.  ("make -j8 ; make -j8 check"), since the
inconsistent move of ext2fs_close() without the preceeding printf
would cause all of the mke2fs tests (the m_* tests) to fail.

This is why regression test suites are so important.  :-)

     	    	       	    	       - Ted
