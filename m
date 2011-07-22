From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Date: Fri, 22 Jul 2011 18:34:58 -0400
Message-ID: <20110722223458.GD25092@thunk.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
 <1311292237-4155-2-git-send-email-tytso@mit.edu>
 <20110722141753.GA19681@infradead.org>
 <20110722183048.GC25092@thunk.org>
 <20110722183830.GA21744@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36840 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1GVWfC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 18:35:02 -0400
Content-Disposition: inline
In-Reply-To: <20110722183830.GA21744@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 22, 2011 at 02:38:30PM -0400, Christoph Hellwig wrote:
> 
> You can get most of this by simply using make V=1, not just in xfsprogs,
> but in most projects using silent make output (including those using
> automake)

Yeah, I know about V=1 (and I have been using it), but I wanted to
know which of the many Makefile variables which finally make up
$(CFLAGS) was getting set to which value, and V=1 doesn't do this.

> for me.  The biggest thing is that you have another directory in your
> include path.  How did you add that one? Did you add anything else
> special to the ./configure or make command lines?

Yes I needed it because I wanted to do a hermetic build; that is, I
didn't want to depend on the version of the acl, attr, dmapi, etc.,
shipped by the distribution.  (This is actually more important when
building xfstests, since I wanted to make sure we used the version of
the xfsprogs headers shipped by the very tip of xfsprogs-dev, since in
the past I've had problems because the distro-shipped header files
were too old.)

The way I did that was by setting the environment CFLAGS to
-I/kbuild/xfstests/bld/include.  And that seems to be the problem.  If
CFLAGS is set as an environment variable, then it's set as a :=, which
means that CFLAGS is set right away, the first time buildmacros is
included.

How about this instead?  A patch like this so that CFLAGS can be
remembered at configure time:

diff --git a/include/builddefs.in b/include/builddefs.in
index 4c8ec64..81ebfcd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -25,6 +25,7 @@ OPTIMIZER = @opt_build@
 MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
+CFLAGS = @CFLAGS@
 
 LIBRT = @librt@
 LIBUUID = @libuuid@

Then I don't have to set an environment variable when running make; I
just have to pass it to configure.

							- Ted
