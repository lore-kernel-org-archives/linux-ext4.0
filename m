From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Wed, 23 Apr 2008 13:02:31 +0530
Message-ID: <20080423073231.GC10003@skywalker>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu> <20080407171230.GE11997@mit.edu> <20080418184329.GB25797@mit.edu> <20080421164144.GG9700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41317 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYDWHe3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 03:34:29 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m3N7ZD3U022339
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 17:35:13 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3N7X7Y04710430
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 17:33:07 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3N7XC4f015724
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 17:33:12 +1000
Content-Disposition: inline
In-Reply-To: <20080421164144.GG9700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 12:41:44PM -0400, Theodore Tso wrote:
> 
> * ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
>  - Add test cases for undoe2fs: u_undoe2fs_mke2fs and
>    u_undoe2fs_tune2fs
>  - Fix the resize inode test case
>  - tune2fs: Support for large inode migration.
>  - mke2fs: Add support for the undo I/O manager.
>  - Add undoe2fs command
>  - libext2fs: Add undo I/O manager
> 
> 	These patches have been *significantly* rototilled.
> 
> 	* The test cases weren't correctly setting and deleting the
> 	  test_name.ok and test_name.failed files
> 
> 	* mke2fs would bomb out with an incomprehensible error message
> 	  if run twice in a row, or if the user didn't have write access
> 	  to /var/lib/e2fsprogs (some users run mke2fs as a non-root
> 	  user!)
> 
> 	* the undoe2fs program was calling com_err and passing
> 	  in uninitialized retval values, and was otherwise confused
> 	  about how to do proper error handling, resulting in garbage
> 	  getting printed if the file passed in didn't exist
> 
> 	* there was a terrible performance problem because in the
> 	  mke2fs case, the undo manager was using a tdb_data_size of
> 	  512.
> 
> 	* I added the ability to configure the location of the scratch
>           dirctory via mke2fs.conf for mk2efs.  What we should do for
>           tune2fs is less clear, and still needs to be addressed.  It
>           is also possible to force an undo file to be always created,
>           and not just when doing a lazy inode table initialization.
>           By using a 4k instead of 512 tdb_data_size, the time to
>           speed up an mke2fs was cut in half, while still using an
>           undo file.  I suspect if we force the tdb_data_size to be
>           even larger, say 32k or 64k the overhead would shrink even
>           more.
> 
> 	Unfortunately, there appears to be some kind of data
> 	corruption bug if I force a tdb_data_size of 32768, so I'm not
> 	entirely sure I trust the undo manager to be working
> 	correctly.  The undo_manager code itself needs a pretty
> 	serious auditing and checking to make sure it's doing the
> 	right thing with large tdb_data_sizes.
> 

undo-mgr is using the first blocks size used to write. This was done as
per the discussion at

http://thread.gmane.org/gmane.comp.file-systems.ext4/1942
http://thread.gmane.org/gmane.comp.file-systems.ext4/2056

I am not sure how you are forcing larger tdb_data_size. Can you send me
the changes so that I can test it and see what is wrong.

-aneesh

