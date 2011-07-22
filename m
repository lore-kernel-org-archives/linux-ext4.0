From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Date: Fri, 22 Jul 2011 14:30:48 -0400
Message-ID: <20110722183048.GC25092@thunk.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
 <1311292237-4155-2-git-send-email-tytso@mit.edu>
 <20110722141753.GA19681@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44130 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab1GVSaw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 14:30:52 -0400
Content-Disposition: inline
In-Reply-To: <20110722141753.GA19681@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 22, 2011 at 10:17:53AM -0400, Christoph Hellwig wrote:
> On Thu, Jul 21, 2011 at 07:50:36PM -0400, Theodore Ts'o wrote:
> > The tree currently will blow out with a build failure if -DDEBUG is
> > specified.
> 
> This still doesn't make sense to me.  libxfs explicily overrides
> DEBUG in the makefile:
> 
> # don't try linking xfs_repair with a debug libxfs.
> DEBUG = -DNDEBUG

I added some debugging statements in libxfs/Makefile, and found this
(see below).

It looks like the problem is that GNU make 3.81 is doing an immediate
expansion of this line in builddefs:

CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)

							- Ted

LTCOMPILE is /bin/sh ../libtool --quiet --tag=CC --mode=compile gcc -I/kbuild/xfstests/bld/include -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -I. -g -O2 -DNDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall
FCFLAGS is -I.
GCFLAGS is -g -O2 -DNDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I../include -DENABLE_GETTEXT
PCFLAGS is -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall
CFLAGS is -I/kbuild/xfstests/bld/include -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -I. -g -O2 -DNDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall
CCF is gcc -I/kbuild/xfstests/bld/include -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -I. -g -O2 -DNDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall
