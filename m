From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Concise description of disk layout?
Date: Fri, 17 Apr 2009 18:30:44 +0000 (UTC)
Message-ID: <gsahsj$8tk$1@ger.gmane.org>
References: <1239838392.12688.4.camel@bobble.smo.corp.google.com>
	<20090416002809.GG21586@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:37785 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484AbZDQSfH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 14:35:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Lusty-0003ng-Ol
	for linux-ext4@vger.kernel.org; Fri, 17 Apr 2009 18:35:02 +0000
Received: from 207.47.98.129.static.nextweb.net ([207.47.98.129])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 18:35:02 +0000
Received: from fmayhar by 207.47.98.129.static.nextweb.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 18:35:02 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for the late reply.

On Wed, 15 Apr 2009 20:28:09 -0400, Theodore Tso wrote:
> On Wed, Apr 15, 2009 at 04:33:12PM -0700, Frank Mayhar wrote:
>> Does such a thing exist anywhere?  I.e. "inodes are here, data blocks
>> are here, etc., etc."  I need to come up with something like this but
>> if one already exists that would save a lot of time.
> 
> At what level?  You mean something like this:
> 
>    http://e2fsprogs.sourceforge.net/ext2intro.html
> 
> but updated for ext4?

Yeah, the "Physical Structure" section.

> Hmm, not really.  Fragments of what's there can be found in various
> slide decks and papers, here:
> 
>       http://ext4.wiki.kernel.org/index.php/Publications

Sigh.  Okay, I'll dig through those.

> If you'd like to write up something comprehensive for the ext4 wiki,
> that would be great.  :-)

I'm going to have to come up with something, although it probably won't 
be comprehensive.  With luck I'll have time to make it suitable for 
public consumption. :-)
-- 
Frank Mayhar
fmayhar@google.com

