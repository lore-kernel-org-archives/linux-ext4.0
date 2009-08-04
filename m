From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: Fix device too big bug in mainline?
Date: Tue, 4 Aug 2009 14:28:11 -0400
Message-ID: <20090804182811.GG9324@shell>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137AbZHDS2M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 14:28:12 -0400
Content-Disposition: inline
In-Reply-To: <20090802022209.GC8680@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 01, 2009 at 10:22:09PM -0400, Theodore Tso wrote:
> In case people are wondering why it's taking so long to merge the
> 64-bit patch series, let me show one patch as exhibit 'A' about how
> not to submit patches to me (or Linus, or any other upstream
> maintainer):

Oh, geez, those are an old patch set!  I did go back and fix the
temporary commits and dangly semi-colons, plus reimplemented progress
meters the way you wanted:

http://osdir.com/ml/linux-ext4/2009-02/msg00591.html

I just forgot because I sent it back in February. :( I hope you can
merge those changes without a lot of trouble.

-VAL
