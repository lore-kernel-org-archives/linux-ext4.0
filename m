From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: for mktemp the exes must be the final characters
 of the name
Date: Wed, 4 Jun 2014 23:28:11 -0400
Message-ID: <20140605032811.GC21061@thunk.org>
References: <1401884926-31722-1-git-send-email-bensberg@justemail.net>
 <850D72EC-599B-458C-BBE1-22E6A0F74E92@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Benno Schulenberg <bensberg@justemail.net>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51507 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaFED2O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2014 23:28:14 -0400
Content-Disposition: inline
In-Reply-To: <850D72EC-599B-458C-BBE1-22E6A0F74E92@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2014 at 04:31:21PM -0600, Andreas Dilger wrote:
> On Jun 4, 2014, at 6:28 AM, Benno Schulenberg <bensberg@justemail.net> wrote:
> > Signed-off-by: Benno Schulenberg <bensberg@justemail.net>
> > ---
> > tests/scripts/resize_test |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tests/scripts/resize_test b/tests/scripts/resize_test
> > index c9a7a1c..1e5756c 100755
> > --- a/tests/scripts/resize_test
> > +++ b/tests/scripts/resize_test
> > @@ -21,7 +21,7 @@ if truncate -s $SIZE_2 $TMPFILE 2> /dev/null; then
> > 	echo "using $TMPFILE" >> $LOG
> > else
> > 	rm $TMPFILE
> > -	export TMPFILE=$(TMPDIR=. mktemp -t $test_name.XXXXXX.tmp)
> > +	export TMPFILE=$(TMPDIR=. mktemp -t $test_name.tmp.XXXXXX)
> 
> The goal was that the temporary file ended with ".tmp" so that it would
> be removed by "make clean" in case the test fails or is interrupted, so
> it would be good to update the "make clean" rules to find these files.

The problem is that using a template where the XXXXXX is in the middle
of the file name is a GNU coreutils extension.  It's not supported by
Mac OSX, *BSD's, and Ubuntu 10.04 and before (and presumably similar
vintage enterprise distros).

With older coreutils, "mktemp /tmp/foo.XXXXXX.bar" will out and out
fail.  That's what Benno noticed.  On OSX, "mktemp
/tmp/foo.XXXXXX.bar" will return /tmp/foo.XXXXXX.bar, unless that file
already exists, in which case it will bomb out.

If the goal is to make sure we remove temporary files, what we can do
is to use a template of "/tmp/e2fs-$test_name-tmp.XXXXXX", and then
include "rm /tmp/e2fs-*-tmp.???????" in the "make clean" rule.

Cheers,

						- Ted

