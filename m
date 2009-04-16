From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Concise description of disk layout?
Date: Wed, 15 Apr 2009 19:49:57 -0500
Message-ID: <49E680B5.4050603@redhat.com>
References: <1239838392.12688.4.camel@bobble.smo.corp.google.com> <20090416002809.GG21586@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Frank Mayhar <fmayhar@google.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35077 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbZDPAuF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 20:50:05 -0400
In-Reply-To: <20090416002809.GG21586@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Apr 15, 2009 at 04:33:12PM -0700, Frank Mayhar wrote:
>> Does such a thing exist anywhere?  I.e. "inodes are here, data blocks
>> are here, etc., etc."  I need to come up with something like this but if
>> one already exists that would save a lot of time.
> 
> At what level?  You mean something like this:
> 
>    http://e2fsprogs.sourceforge.net/ext2intro.html
> 
> but updated for ext4?

Or do you mean like some XML DTD for a generic description?   That's the
first thing that came to mind when I read it.

or ... an e2image actually *captures* all of that information about a
filesystem... depends what you're looking for I suppose?

-Eric
