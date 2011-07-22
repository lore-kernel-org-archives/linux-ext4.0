From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Date: Fri, 22 Jul 2011 17:30:48 -0500
Message-ID: <1311373848.2771.164.camel@doink>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
	 <1311292237-4155-2-git-send-email-tytso@mit.edu>
	 <20110722141753.GA19681@infradead.org> <20110722183048.GC25092@thunk.org>
	 <20110722183830.GA21744@infradead.org>
Reply-To: <aelder@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	<xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:54800 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751212Ab1GYNKU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jul 2011 09:10:20 -0400
In-Reply-To: <20110722183830.GA21744@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2011-07-22 at 14:38 -0400, Christoph Hellwig wrote:
> On Fri, Jul 22, 2011 at 02:30:48PM -0400, Ted Ts'o wrote:

. . .

> A typical V=1 compile line looks like:
> 
> /bin/bash ../libtool --quiet --tag=CC --mode=compile gcc -I. -g -O2
> -DNDEBUG -DVERSION=\"3.1.5\" -DLOCALEDIR=\"/usr/share/locale\"
> -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE
> -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char
> -fno-strict-aliasing -Wall    -c xfs_dir2_sf.c

FWIW, I get a compile line for xfs_dir2_sf.c identical to
what Christoph supplied.

> for me.  The biggest thing is that you have another directory in your
> include path.  How did you add that one? Did you add anything else
> special to the ./configure or make command lines?

