From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Htree concept
Date: Wed, 13 May 2015 11:29:43 -0500
Message-ID: <55537BF7.8000602@redhat.com>
References: <mivr40$2lj$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
To: "U.Mutlu" <for-gmane@mutluit.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbbEMQ3q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2015 12:29:46 -0400
In-Reply-To: <mivr40$2lj$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/13/15 10:37 AM, U.Mutlu wrote:
> Hi,
> I'm writing a toy-fs, and discover a major shortcoming
> (finding a given child (dir/file) as fast as possible),
> which other developers (ie. ext3/4) had encountered long ago too.
> They introduced HTree. The info on HTree on the web is scarce
> or I couldn't find the right texts/papers yet.
> I wonder how HTree works on a conceptual basis.
> Could a kind soul enligten me pls. TIA.

Regarding htree details, did you look at:

http://en.wikipedia.org/wiki/HTree

which points to:

http://ext2.sourceforge.net/2005-ols/paper-html/node3.html
and more specifically,
http://web.archive.org/web/20131203105316/http://www.linuxshowcase.org/2001/full_papers/phillips/phillips_html/index.html

?

-Eric

